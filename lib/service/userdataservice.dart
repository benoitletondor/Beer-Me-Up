import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/service/brewerydbservice.dart';

abstract class UserDataService {
  static final UserDataService instance = new _UserDataServiceImpl();

  Future<void> initDB(FirebaseUser currentUser);

  Future<List<Beer>> fetchUserBeers();

  Future<List<Beer>> findBeersMatching(String pattern);
}

class _UserDataServiceImpl extends BreweryDBService implements UserDataService {
  DocumentSnapshot _userDoc;
  final _httpClient = new HttpClient();

  @override
  Future<void> initDB(FirebaseUser currentUser) async {
    _userDoc = await _connectDB(currentUser);
  }

  Future<DocumentSnapshot> _connectDB(FirebaseUser user) async {
    DocumentSnapshot doc = await Firestore.instance.collection("users").document(user.uid).get();
    if( doc == null || !doc.exists ) {
      debugPrint("Creating document reference for id ${user.uid}");

      final DocumentReference ref = Firestore.instance.collection("users").document(user.uid);
      await ref.setData({"id" : user.uid});

      doc = await ref.get();
      if( doc == null ) {
        throw new Exception("Unable to create user document");
      }
    }

    return doc;
  }

  @override
  Future<List<Beer>> fetchUserBeers() async {
    _assertDBInitialized();

    final beersCollection = await _userDoc.reference.getCollection("beers").getDocuments();
    if( beersCollection.documents.isEmpty ) {
      return new List(0);
    }

    final beersArray = beersCollection.documents;
    return beersArray.map((beerDocument) => new Beer(
        id: beerDocument["id"] as String,
        name: null,
        description: null
    )).toList(growable: false);
  }

  _assertDBInitialized() {
    if( _userDoc == null ) {
      throw new Exception("DB is not initialized");
    }
  }

  @override
  Future<List<Beer>> findBeersMatching(String pattern) async {
    var uri = buildBreweryDBServiceURI(path: "search", queryParameters: {'q': pattern, 'type': 'beer'});
    HttpClientRequest request = await _httpClient.getUrl(uri);
    HttpClientResponse response = await request.close();
    if( response.statusCode <200 || response.statusCode>299 ) {
      throw new Exception("Bad response: ${response.statusCode}");
    }

    String responseBody = await response.transform(UTF8.decoder).join();
    Map data = JSON.decode(responseBody);
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