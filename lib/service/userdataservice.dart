import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/service/brewerydbservice.dart';

abstract class UserDataService {
  static final UserDataService instance = new _UserDataServiceImpl(Firestore.instance, new HttpClient());

  Future<void> initDB(FirebaseUser currentUser);

  Future<CheckinFetchResponse> fetchCheckinHistory({CheckIn startAfter});
  Future<void> saveBeerCheckIn(Beer beer);

  Future<List<Beer>> findBeersMatching(String pattern);
}

class CheckinFetchResponse {
  final List<CheckIn> checkIns;
  final bool hasMore;

  CheckinFetchResponse(this.checkIns, this.hasMore);
}

const _NUMBER_OF_RESULTS_FOR_HISTORY = 20;
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
    } catch (e) { // This should be removed when a fix will be available
      debugPrint("Error in firestore while getting user collection: $e");
      doc = null;
    }

    if( doc == null ) {
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

    List<CheckIn> checkIns = checkinArray.map((checkinDocument) => new CheckIn(
      date: checkinDocument["date"],
      beer: _parseBeerFromValue(checkinDocument["beer"], checkinDocument["beer_version"])
    )).toList(growable: false);

    return new CheckinFetchResponse(checkIns, checkIns.length >= _NUMBER_OF_RESULTS_FOR_HISTORY ? true : false);
  }

  @override
  Future<void> saveBeerCheckIn(Beer beer) async {
    _assertDBInitialized();

    await _userDoc
      .reference
      .getCollection("history")
      .add({
        "date": new DateTime.now(),
        "beer": _createValueForBeer(beer),
        "beer_id": beer.id,
        "beer_version": _BEER_VERSION,
      });

    final beerDocument = _userDoc
      .reference
      .getCollection("beers")
      .document(beer.id);

    await beerDocument
      .setData(
        {
          "beer": _createValueForBeer(beer),
          "beer_id": beer.id,
          "beer_version": _BEER_VERSION,
          "last_checkin": new DateTime.now(),
        },
        SetOptions.merge
      );

    await beerDocument
      .getCollection("history")
      .add({
        "date": new DateTime.now(),
      });
  }

  Beer _parseBeerFromValue(Map<String, dynamic> data, int version) {
    return new Beer(
      id: data["id"],
      name: data["name"],
      description: data["description"],
      thumbnailUrl: data["thumbnail_url"],
    );
  }

  Map<String, dynamic> _createValueForBeer(Beer beer) {
    return {
      "id": beer.id,
      "name": beer.name,
      "description": beer.description,
      "thumbnail_url": beer.thumbnailUrl,
    };
  }

  @override
  Future<List<Beer>> findBeersMatching(String pattern) async {
    var uri = buildBreweryDBServiceURI(path: "search", queryParameters: {'q': pattern, 'type': 'beer'});
    HttpClientRequest request = await _httpClient.getUrl(uri);
    HttpClientResponse response = await request.close();
    if( response.statusCode <200 || response.statusCode>299 ) {
      throw new Exception("Bad response: ${response.statusCode}");
    }

    String responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    int totalResults = data["totalResults"] ?? 0;
    if( totalResults == 0 ) {
      return new List(0);
    }

    return (data['data'] as List).map((beerJson) => new Beer(
        id: beerJson["id"] as String,
        name: beerJson["name"] as String,
        description: beerJson["description"] as String,
        thumbnailUrl: _extractThumbnailUrl(beerJson))
    ).toList(growable: false);
  }

  String _extractThumbnailUrl(Map beerJson) {
    final labels = beerJson["labels"];
    if( labels == null || !(labels is Map) ) {
      return null;
    }

    return labels["icon"] as String;
  }

}