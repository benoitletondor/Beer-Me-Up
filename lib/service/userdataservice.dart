import 'dart:async';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/model/beer.dart';

abstract class UserDataService {
  static final UserDataService instance = new _UserDataServiceImpl();

  Future<void> initDB(FirebaseUser currentUser);

  Future<List<Beer>> fetchUserBeers();
}

class _UserDataServiceImpl extends UserDataService {
  DocumentSnapshot _userDoc;

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
    final beers = new List();

    for(final beerDocument in beersArray) {
      beers.add(new Beer(beerDocument.data["id"] as String));
    }

    return beers;
  }

  _assertDBInitialized() {
    if( _userDoc == null ) {
      throw new Exception("DB is not initialized");
    }
  }
}