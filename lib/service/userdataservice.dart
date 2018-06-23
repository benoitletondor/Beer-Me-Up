import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:tuple/tuple.dart';
export 'package:tuple/tuple.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:beer_me_up/main.dart';
import 'package:beer_me_up/common/exceptionprint.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/model/beercheckinsdata.dart';
import 'package:beer_me_up/service/beersearch/beersearchservice.dart';
import 'package:beer_me_up/service/beersearch/untappdservice.dart';
import 'package:beer_me_up/common/networkexception.dart';
import 'package:beer_me_up/common/datehelper.dart';

abstract class UserDataService {
  static final UserDataService instance = _UserDataServiceImpl(Firestore.instance, HttpClient(), UntappdService(BeerMeUpApp.config));

  Future<void> initDB(FirebaseUser currentUser);

  Future<CheckinFetchResponse> fetchCheckInHistory({CheckIn startAfter});
  Stream<CheckIn> listenForCheckIn();
  Future<CheckinDetails> getCheckinDetails(Beer beer, DateTime date);
  Future<void> saveBeerCheckIn(CheckIn checkIn);
  Future<List<Beer>> fetchLastCheckedInBeers();

  Future<List<BeerCheckInsData>> fetchBeerCheckInsData();
  Future<List<CheckIn>> fetchThisWeekCheckIns();
  Future<int> getTotalUserPoints();

  Future<List<Beer>> findBeersMatching(String pattern);

  Future<int> fetchRatingForBeer(Beer beer);
  Future<void> saveRatingForBeer(Beer beer, int rating);
  Stream<Tuple2<Beer, int>> listenForNewRatings();
}

class CheckinDetails {
  final List<CheckIn> weekCheckIns;
  final bool beerAlreadyCheckedIn;

  CheckinDetails(this.weekCheckIns, this.beerAlreadyCheckedIn);
}

class CheckinFetchResponse {
  final List<CheckIn> checkIns;
  final bool hasMore;

  CheckinFetchResponse(this.checkIns, this.hasMore);
}

const _NUMBER_OF_RESULTS_FOR_HISTORY = 20;
const _LIMIT_FOR_WEEKLY_CHECK_INS = 100;
const _LIMIT_FOR_LAST_CHECK_INS_BEERS = 5;
const _BEER_VERSION = 1;

const _DEFAULT_TIMEOUT = Duration(seconds: 10);

class _UserDataServiceImpl implements UserDataService {
  final HttpClient _httpClient;
  final BeerSearchService _beerSearchService;
  final Firestore _firestore;

  DocumentSnapshot _userDoc;

  _UserDataServiceImpl(this._firestore, this._httpClient, this._beerSearchService);

  @override
  Future<void> initDB(FirebaseUser currentUser) async {
    _userDoc = await _connectDB(currentUser).timeout(
      _DEFAULT_TIMEOUT,
      onTimeout: () => Future.error(NetworkException("Unable to connect to database. Please check your network connection."))
    );
  }

  Future<DocumentSnapshot> _connectDB(FirebaseUser user) async {
    DocumentSnapshot doc = await _firestore.collection("users").document(user.uid).get();

    if( doc == null || !doc.exists ) {
      debugPrint("Creating document reference for id ${user.uid}");

      final DocumentReference ref = _firestore.collection("users").document(user.uid);
      await ref.setData({
        "id" : user.uid,
        "mail" : user.email,
        "created_at": DateTime.now(),
      });

      doc = await ref.get();
      if( doc == null ) {
        throw Exception("Unable to create user document");
      }
    }

    return doc;
  }

  _assertDBInitialized() {
    if( _userDoc == null ) {
      throw Exception("DB is not initialized");
    }
  }

  @override
  Future<CheckinFetchResponse> fetchCheckInHistory({CheckIn startAfter}) async {
    _assertDBInitialized();

    var query = _userDoc
      .reference
      .collection("history")
      .orderBy("date", descending: true)
      .limit(_NUMBER_OF_RESULTS_FOR_HISTORY);

    if( startAfter != null ) {
      query = query.startAfter([startAfter.date]);
    }

    final checkinCollection = await query.getDocuments().timeout(
      _DEFAULT_TIMEOUT,
      onTimeout: () => Future.error(NetworkException("Unable to get your check-ins data. Please check your network connection."))
    );

    final checkinArray = checkinCollection.documents;
    if( checkinArray.isEmpty ) {
      return CheckinFetchResponse(List(0), false);
    }

    List<CheckIn> checkIns = checkinArray
      .map((checkinDocument) => _parseCheckinFromDocument(checkinDocument))
      .toList(growable: false);

    return CheckinFetchResponse(checkIns, checkIns.length >= _NUMBER_OF_RESULTS_FOR_HISTORY ? true : false);
  }

  @override
  Future<List<BeerCheckInsData>> fetchBeerCheckInsData() async {
    _assertDBInitialized();

    final beerDocsSnapshot = await _userDoc
        .reference
        .collection("beers")
        .getDocuments()
        .timeout(
        _DEFAULT_TIMEOUT,
        onTimeout: () => Future.error(NetworkException("Unable to retrieve your data. Please check your network connection."))
    );

    return beerDocsSnapshot.documents.map((beerSnapshot) =>
        BeerCheckInsData(
          _parseBeerFromValue(beerSnapshot.data["beer"], beerSnapshot.data["beer_version"]),
          beerSnapshot.data["checkin_counter"],
          beerSnapshot.data["last_checkin"],
          beerSnapshot.data["drank_quantity"],
          beerSnapshot.data["rating"],
        )
    ).toList(growable: false);
  }

  Stream<CheckIn> listenForCheckIn() {
    final StreamController<CheckIn> _controller = StreamController();

    final subscription = _userDoc
      .reference
      .collection("history")
      .where("creation_date", isGreaterThan: DateTime.now())
      .snapshots()
      .listen(
        (querySnapshot) {
          querySnapshot.documentChanges
            .where((documentChange) => documentChange.type == DocumentChangeType.added)
            .forEach((documentChange) {
              _controller.add(_parseCheckinFromDocument(documentChange.document));
            });
        },
        onDone: _controller.close,
        onError: (e, stackTrace) {
          printException(e, stackTrace, "Error listening for checkin");
          _controller.close();
        },
        cancelOnError: true,
      );

    _controller.onCancel = () {
      subscription.cancel();
      _controller.close();
    };

    return _controller.stream;
  }

  @override
  Future<CheckinDetails> getCheckinDetails(Beer beer, DateTime date) async {
    _assertDBInitialized();

    final List<CheckIn> checkins = await fetchWeekCheckIns(date);
    final beerDocument = _userDoc
        .reference
        .collection("beers")
        .document(beer.id);

    final beerDoc = await beerDocument.get().timeout(
      _DEFAULT_TIMEOUT,
      onTimeout: () => Future.error(NetworkException("Unable to get check-ins details. Please check your network connection."))
    );

    bool beerAlreadyCheckedIn = beerDoc != null && beerDoc.exists;

    return CheckinDetails(checkins, beerAlreadyCheckedIn);
  }

  @override
  Future<void> saveBeerCheckIn(CheckIn checkIn) async {
    _assertDBInitialized();

    final beerDocument = _userDoc
      .reference
      .collection("beers")
      .document(checkIn.beer.id);

    DocumentSnapshot beerDocumentValues = await beerDocument.get().timeout(
      const Duration(seconds: 30),
      onTimeout: () => Future.error(NetworkException("Unable save check-in. Please check your network connection."))
    );

    final numberOfCheckIns = beerDocumentValues != null && beerDocumentValues.exists ? beerDocumentValues.data["checkin_counter"] : 0;
    final drankQuantity = beerDocumentValues != null && beerDocumentValues.exists ? beerDocumentValues.data["drank_quantity"] : 0.0;
    final lastCheckinDate = beerDocumentValues != null && beerDocumentValues.exists ? beerDocumentValues.data["last_checkin"] : null;

    final lastCheckin = lastCheckinDate != null ? checkIn.date.isAfter(lastCheckinDate) ? checkIn.date : lastCheckinDate : checkIn.date;
    await beerDocument
      .setData(
        {
          "beer": _createValueForBeer(checkIn.beer),
          "beer_id": checkIn.beer.id,
          "beer_version": _BEER_VERSION,
          "last_checkin": lastCheckin,
          "checkin_counter": numberOfCheckIns + 1,
          "drank_quantity": drankQuantity + checkIn.quantity.value,
        },
        merge: true,
      );

    await beerDocument
      .collection("history")
      .add({
        "date": checkIn.date,
        "quantity": checkIn.quantity.value,
      });

    await _userDoc
        .reference
        .collection("history")
        .add({
          "creation_date": checkIn.creationDate,
          "date": checkIn.date,
          "beer": _createValueForBeer(checkIn.beer),
          "beer_id": checkIn.beer.id,
          "beer_version": _BEER_VERSION,
          "quantity": checkIn.quantity.value,
          "points": checkIn.points,
        });

    _userDoc = await _userDoc.reference.get();
    int currentPointsCounter = _userDoc.data.containsKey("points") ? _userDoc.data["points"] as int : 0;

    await _userDoc
      .reference
      .setData({
        "points": currentPointsCounter+checkIn.points,
      },
      merge: true);
  }

  Beer _parseBeerFromValue(Map<dynamic, dynamic> data, int version) {
    BeerStyle style;

    final Map<dynamic, dynamic> styleData = data["style"];
    if( styleData != null ) {
      style = BeerStyle(
        id: styleData["id"],
        name: styleData["name"],
      );
    }

    BeerLabel label;
    final Map<dynamic, dynamic> labelData = data["label"];
    if( labelData != null ) {
      label = BeerLabel(
        iconUrl: labelData["iconUrl"],
        mediumUrl: labelData["mediumUrl"],
        largeUrl: labelData["largeUrl"],
      );
    }

    return Beer(
      id: data["id"],
      name: data["name"],
      description: data["description"],
      abv: data["abv"],
      label: label,
      style: style,
    );
  }

  CheckIn _parseCheckinFromDocument(DocumentSnapshot doc) {
    return CheckIn(
      creationDate: doc["creation_date"],
      date: doc["date"],
      beer: _parseBeerFromValue(doc["beer"], doc["beer_version"]),
      quantity: _parseQuantityFromValue(doc["quantity"]),
      points: doc["points"],
    );
  }

  CheckInQuantity _parseQuantityFromValue(double value) {
    for(CheckInQuantity quantity in CheckInQuantity.values) {
      if( quantity.value == value ) {
        return quantity;
      }
    }

    throw Exception("Unknown quantity: $value");
  }

  Map<String, dynamic> _createValueForBeer(Beer beer) {
    Map<String, dynamic> style;
    Map<String, dynamic> label;

    if( beer.style != null ) {
      style = {
        "id": beer.style.id,
        "name": beer.style.name,
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
    };
  }

  @override
  Future<List<CheckIn>> fetchThisWeekCheckIns() async {
    return fetchWeekCheckIns(DateTime.now());
  }

  Future<List<CheckIn>> fetchWeekCheckIns(DateTime date) async {
    _assertDBInitialized();

    final weekDates = getWeekStartAndEndDate(date);

    final QuerySnapshot snapshots = await _userDoc
        .reference
        .collection("history")
        .where("date", isGreaterThanOrEqualTo: weekDates.item1)
        .where("date", isLessThanOrEqualTo: weekDates.item2)
        .orderBy("date", descending: true)
        .limit(_LIMIT_FOR_WEEKLY_CHECK_INS)
        .getDocuments()
        .timeout(
          _DEFAULT_TIMEOUT,
          onTimeout: () => Future.error(NetworkException("Unable to retrieve your data. Please check your network connection."))
        );

    return snapshots.documents
        .map((checkinDocument) => _parseCheckinFromDocument(checkinDocument))
        .toList(growable: false);
  }

  @override
  Future<int> getTotalUserPoints() async {
    final userDoc = await _userDoc.reference.get();
    final points = userDoc["points"];
    if( points == null ) {
      return 0;
    }

    return points as int;
  }

  @override
  Future<List<Beer>> findBeersMatching(String pattern) {
    return _beerSearchService.findBeersMatching(_httpClient, pattern);
  }

  @override
  Future<List<Beer>> fetchLastCheckedInBeers() async {
    final querySnapshot = await _userDoc
      .reference
      .collection("beers")
      .orderBy("last_checkin", descending: true)
      .limit(_LIMIT_FOR_LAST_CHECK_INS_BEERS)
      .getDocuments();
    
    return querySnapshot
      .documents
      .map((doc) => _parseBeerFromValue(doc["beer"], doc["beer_version"]))
      .toList(growable: false);
  }

  @override
  Future<int> fetchRatingForBeer(Beer beer) async {
    final documentSnapshot = await _userDoc
        .reference
        .collection("beers")
        .document(beer.id)
        .get();

    if( !documentSnapshot.exists ) {
      return null;
    }

    return documentSnapshot.data["rating"];
  }

  @override
  Future<void> saveRatingForBeer(Beer beer, int rating) async {
    if( rating < 1 || rating > 5 ) {
      throw Exception("Invalid rating: $rating");
    }

    final beerDocument = _userDoc
        .reference
        .collection("beers")
        .document(beer.id);

    await beerDocument.setData(
      {
        "rating": rating,
      },
      merge: true,
    );
  }

  @override
  Stream<Tuple2<Beer, int>> listenForNewRatings() {
    final StreamController<Tuple2<Beer, int>> _controller = StreamController();

    final subscription = _userDoc
      .reference
      .collection("beers")
      .snapshots()
      .listen((querySnapshot) {
        querySnapshot.documentChanges
          .where((documentChange) => documentChange.type == DocumentChangeType.modified)
          .forEach((documentChange) {
            final int rating = documentChange.document.data["rating"];
            if( rating != null ) {
              _controller.add(
                Tuple2(
                  _parseBeerFromValue(documentChange.document.data["beer"], documentChange.document.data["beer_version"]),
                  rating
                )
              );
            }
          });
      },
      onDone: _controller.close,
      onError: (e, stackTrace) {
        printException(e, stackTrace, "Error listening for checkin");
        _controller.close();
      },
      cancelOnError: true,
    );

    _controller.onCancel = () {
      subscription.cancel();
      _controller.close();
    };

    return _controller.stream;
  }
}