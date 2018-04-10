import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:beer_me_up/common/exceptionprint.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/model/beercheckinsdata.dart';
import 'package:beer_me_up/service/brewerydbservice.dart';

abstract class UserDataService {
  static final UserDataService instance = new _UserDataServiceImpl(Firestore.instance, new HttpClient());

  Future<void> initDB(FirebaseUser currentUser);

  Future<CheckinFetchResponse> fetchCheckinHistory({CheckIn startAfter});
  Stream<CheckIn> listenForCheckin();
  Future<void> saveBeerCheckIn(CheckIn checkIn);

  Future<List<BeerCheckInsData>> fetchBeerData();
  Future<List<CheckIn>> fetchThisWeekCheckIns();

  Future<List<Beer>> findBeersMatching(String pattern);
}

class CheckinFetchResponse {
  final List<CheckIn> checkIns;
  final bool hasMore;

  CheckinFetchResponse(this.checkIns, this.hasMore);
}

const _NUMBER_OF_RESULTS_FOR_HISTORY = 20;
const _LIMIT_FOR_WEEKLY_CHECKINS = 100;
const _BEER_VERSION = 1;

class _UserDataServiceImpl extends BreweryDBService implements UserDataService {
  DocumentSnapshot _userDoc;
  final HttpClient _httpClient;
  final Firestore _firestore;

  _UserDataServiceImpl(this._firestore, this._httpClient);

  @override
  Future<void> initDB(FirebaseUser currentUser) async {
    _userDoc = await _connectDB(currentUser);
  }

  Future<DocumentSnapshot> _connectDB(FirebaseUser user) async {
    DocumentSnapshot doc;
    try {
      doc = await _firestore.collection("users").document(user.uid).get();
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error in firestore while getting user collection");
      doc = null;
    }

    if( doc == null || !doc.exists ) {
      debugPrint("Creating document reference for id ${user.uid}");

      final DocumentReference ref = _firestore.collection("users").document(user.uid);
      await ref.setData({"id" : user.uid});

      doc = await ref.get();
      if( doc == null ) {
        throw new Exception("Unable to create user document");
      }
    }

    return doc;
  }

  _assertDBInitialized() {
    if( _userDoc == null ) {
      throw new Exception("DB is not initialized");
    }
  }

  @override
  Future<CheckinFetchResponse> fetchCheckinHistory({CheckIn startAfter}) async {
    _assertDBInitialized();

    var query = _userDoc
      .reference
      .getCollection("history")
      .orderBy("date", descending: true)
      .limit(_NUMBER_OF_RESULTS_FOR_HISTORY);

    if( startAfter != null ) {
      query = query.startAfter([startAfter.date]);
    }

    final checkinCollection = await query.getDocuments();

    final checkinArray = checkinCollection.documents;
    if( checkinArray.isEmpty ) {
      return new CheckinFetchResponse(new List(0), false);
    }

    List<CheckIn> checkIns = checkinArray
      .map((checkinDocument) => _parseCheckinFromDocument(checkinDocument))
      .toList(growable: false);

    return new CheckinFetchResponse(checkIns, checkIns.length >= _NUMBER_OF_RESULTS_FOR_HISTORY ? true : false);
  }

  Stream<CheckIn> listenForCheckin() {
    final StreamController<CheckIn> _controller = new StreamController();

    final subscription = _userDoc
      .reference
      .getCollection("history")
      .where("date", isGreaterThan: new DateTime.now())
      .snapshots
      .listen(
        (querySnapshot) {
          querySnapshot.documentChanges
            .where((documentChange) => documentChange.type == DocumentChangeType.added)
            .forEach((documentChange) {
              _controller.add(_parseCheckinFromDocument(documentChange.document));
            });
        },
        onDone: _controller.close,
        onError: (e) { _controller.close(); },
        cancelOnError: true,
      );

    _controller.onCancel = () {
      subscription.cancel();
      _controller.close();
    };

    return _controller.stream;
  }

  @override
  Future<void> saveBeerCheckIn(CheckIn checkIn) async {
    _assertDBInitialized();

    await _userDoc
      .reference
      .getCollection("history")
      .add({
        "date": checkIn.date,
        "beer": _createValueForBeer(checkIn.beer),
        "beer_id": checkIn.beer.id,
        "beer_style_id": checkIn.beer.style?.id,
        "beer_category_id": checkIn.beer.category?.id,
        "beer_version": _BEER_VERSION,
        "quantity": checkIn.quantity.value,
      });

    final beerDocument = _userDoc
      .reference
      .getCollection("beers")
      .document(checkIn.beer.id);

    DocumentSnapshot beerDocumentValues;
    try {
      beerDocumentValues = await beerDocument.get();
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error getting existing values for beer ${checkIn.beer.name}");
    }

    final numberOfCheckIns = beerDocumentValues != null && beerDocumentValues.exists ? beerDocumentValues.data["checkin_counter"] : 0;
    final drankQuantity = beerDocumentValues != null && beerDocumentValues.exists ? beerDocumentValues.data["drank_quantity"] : 0.0;

    await beerDocument
      .setData(
        {
          "beer": _createValueForBeer(checkIn.beer),
          "beer_id": checkIn.beer.id,
          "beer_style_id": checkIn.beer.style?.id,
          "beer_category_id": checkIn.beer.category?.id,
          "beer_version": _BEER_VERSION,
          "last_checkin": checkIn.date,
          "checkin_counter": numberOfCheckIns + 1,
          "drank_quantity": drankQuantity + checkIn.quantity.value,
        },
        SetOptions.merge
      );

    await beerDocument
      .getCollection("history")
      .add({
        "date": checkIn.date,
        "quantity": checkIn.quantity.value,
      });
  }

  Beer _parseBeerFromValue(Map<dynamic, dynamic> data, int version) {
    BeerStyle style;
    BeerCategory category;

    final Map<dynamic, dynamic> styleData = data["style"];
    if( styleData != null ) {
      style = new BeerStyle(
        id: styleData["id"],
        name: styleData["name"],
        description: styleData["description"],
        shortName: styleData["shortName"],
      );
    }

    final Map<dynamic, dynamic> categoryData = data["category"];
    if( categoryData != null ) {
      category = new BeerCategory(
        id: categoryData["id"],
        name: categoryData["name"],
      );
    }

    BeerLabel label;
    final Map<dynamic, dynamic> labelData = data["label"];
    if( labelData != null ) {
      label = new BeerLabel(
        iconUrl: labelData["iconUrl"],
        mediumUrl: labelData["mediumUrl"],
        largeUrl: labelData["largeUrl"],
      );
    }

    return new Beer(
      id: data["id"],
      name: data["name"],
      description: data["description"],
      abv: data["abv"],
      label: label,
      style: style,
      category: category,
    );
  }

  CheckIn _parseCheckinFromDocument(DocumentSnapshot doc) {
    return new CheckIn(
      date: doc["date"],
      beer: _parseBeerFromValue(doc["beer"], doc["beer_version"]),
      quantity: _parseQuantityFromValue(doc["quantity"]),
    );
  }

  CheckInQuantity _parseQuantityFromValue(double value) {
    for(CheckInQuantity quantity in CheckInQuantity.values) {
      if( quantity.value == value ) {
        return quantity;
      }
    }

    throw new Exception("Unknown quantity: $value");
  }

  Map<String, dynamic> _createValueForBeer(Beer beer) {
    Map<String, dynamic> style;
    Map<String, dynamic> category;
    Map<String, dynamic> label;

    if( beer.style != null ) {
      style = {
        "id": beer.style.id,
        "name": beer.style.name,
        "shortName": beer.style.shortName,
        "description": beer.style.description,
      };
    }

    if( beer.category != null ) {
      category = {
        "id": beer.category.id,
        "name": beer.category.name,
      };
    }

    if( beer.label != null ) {
      label = {
        "iconUrl": beer.label.iconUrl,
        "mediumUrl": beer.label.mediumUrl,
        "largeUrl": beer.label.largeUrl,
      };
    }

    return {
      "id": beer.id,
      "name": beer.name,
      "description": beer.description,
      "abv": beer.abv,
      "label": label,
      "style": style,
      "category": category,
    };
  }

  @override
  Future<List<Beer>> findBeersMatching(String pattern) async {
    if( pattern == null || pattern.trim().isEmpty ) {
      return new List(0);
    }

    var uri = buildBreweryDBServiceURI(path: "search", queryParameters: {'q': pattern, 'type': 'beer'});
    HttpClientRequest request = await _httpClient.getUrl(uri);
    HttpClientResponse response = await request.close();
    if( response.statusCode <200 || response.statusCode>299 ) {
      throw new Exception("Bad response: ${response.statusCode} (${response.reasonPhrase})");
    }

    String responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    int totalResults = data["totalResults"] ?? 0;
    if( totalResults == 0 ) {
      return new List(0);
    }

    return (data['data'] as List).map((beerJson) {
      BeerStyle style;
      BeerCategory category;

      final Map<dynamic, dynamic> styleData = beerJson["style"];
      if( styleData != null ) {
        style = new BeerStyle(
          id: styleData["id"],
          name: styleData["name"],
          description: styleData["description"],
          shortName: styleData["shortName"],
        );

        final Map<dynamic, dynamic> categoryData = styleData["category"];
        if( categoryData != null ) {
          category = new BeerCategory(
            id: categoryData["id"],
            name: categoryData["name"],
          );
        }
      }

      double abv;
      if( beerJson["abv"] != null ) {
        abv = double.parse(beerJson["abv"] as String);
      } else if( styleData != null ) {
        final String abvMin = styleData["abvMin"];
        final String abvMax = styleData["abvMax"];

        if( abvMax != null && abvMin != null ) {
          abv = (double.parse(abvMax) + double.parse(abvMin)) / 2.0;
        } else if( abvMin != null ) {
          abv = double.parse(abvMin);
        } else if( abvMax != null ) {
          abv = double.parse(abvMax);
        }
      }

      BeerLabel label;
      final labelJson = beerJson["labels"];
      if( labelJson != null && labelJson is Map ) {
        label = new BeerLabel(
          iconUrl: labelJson["icon"],
          mediumUrl: labelJson["medium"],
          largeUrl: labelJson["large"],
        );
      }

      return new Beer(
        id: beerJson["id"],
        name: beerJson["name"],
        description: beerJson["description"],
        abv: abv,
        label: label,
        style: style,
        category: category,
      );
    }).toList(growable: false);
  }

  @override
  Future<List<BeerCheckInsData>> fetchBeerData() async {
    _assertDBInitialized();

    final beerDocsSnapshot = await _userDoc
      .reference
      .getCollection("beers")
      .getDocuments();

    return beerDocsSnapshot.documents.map((beerSnapshot) =>
      new BeerCheckInsData(
        _parseBeerFromValue(beerSnapshot.data["beer"], beerSnapshot.data["beer_version"]),
        beerSnapshot.data["checkin_counter"],
        beerSnapshot.data["last_checkin"],
        beerSnapshot.data["drank_quantity"],
      )
    ).toList(growable: false);
  }

  @override
  Future<List<CheckIn>> fetchThisWeekCheckIns() async {
    _assertDBInitialized();

    final now = new DateTime.now();
    final today = new DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime thisWeekStartDate = today.add(
      new Duration(
        days: -(now.weekday - 1)
      )
    );

    final QuerySnapshot snapshots = await _userDoc
      .reference
      .getCollection("history")
      .where("date", isGreaterThanOrEqualTo: thisWeekStartDate)
      .orderBy("date", descending: true)
      .limit(_LIMIT_FOR_WEEKLY_CHECKINS)
      .getDocuments();

    return snapshots.documents
      .map((checkinDocument) => _parseCheckinFromDocument(checkinDocument))
      .toList(growable: false);
  }

}