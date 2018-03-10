import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/beer.dart';
import '../onboarding/onboardingpage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

enum _HomePageStateStatus { AUTHENTICATING, AUTHENTICATED, ERROR_AUTHENTICATING, LOADING, LOAD, ERROR }

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  FirebaseUser _currentUser;
  List<Beer> _beers = new List();
  _HomePageStateStatus _status = _HomePageStateStatus.AUTHENTICATING;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool sawOnboarding = prefs.getBool(USER_SAW_ONBOARDING_KEY);
    if( sawOnboarding == null || !sawOnboarding ) {
      Navigator.of(context).pushReplacementNamed(ONBOARDING_PAGE_ROUTE);
      return;
    }

    _currentUser = await _ensureLoggedIn();
    if( _currentUser == null ) {
      setState(() {
        _status = _HomePageStateStatus.ERROR_AUTHENTICATING;
      });
      return;
    }

    debugPrint("User logged in $_currentUser");

    setState(() {
      _status = _HomePageStateStatus.LOADING;
    });

    _beers = await _getUserBeersCollection(_currentUser);
    if( _beers == null ) {
      setState(() {
        _status = _HomePageStateStatus.ERROR;
      });
      return;
    }

    setState(() {
      _status = _HomePageStateStatus.LOAD;
    });
  }

  Future<FirebaseUser> _ensureLoggedIn() async {
    setState(() {
      _status = _HomePageStateStatus.AUTHENTICATING;
    });

    GoogleSignInAccount googleUser = await _googleSignIn.signInSilently();
    if( googleUser == null ) {
      googleUser = await _googleSignIn.signIn();
    }

    if( googleUser == null ) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    return user;
  }

  Future<List<Beer>> _getUserBeersCollection(FirebaseUser user) async {
    try {
      DocumentSnapshot doc = await Firestore.instance.collection("users").document(user.uid).get();
      if( doc == null || !doc.exists ) {
        debugPrint("Creating document reference for id ${user.uid}");
        final DocumentReference ref = Firestore.instance.collection("users").document(user.uid);
        await ref.setData({"id" : user.uid});
        doc = await ref.get();
      }

      final beersCollection = await doc.reference.getCollection("beers").getDocuments();
      if( beersCollection.documents.isEmpty ) {
        debugPrint("No beers registered for that user");
        return new List(0);
      }

      final beersArray = beersCollection.documents;
      debugPrint("Found ${beersArray.length} beers");

      List<Beer> beers = new List();
      for(final beerDocument in beersArray) {
        beers.add(new Beer(beerDocument.data["id"] as String));
      }

      return beers;
    } catch (e) {
      debugPrint("Error querying the DB: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Beer Me Up'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Current status:',
            ),
            new Text(
              _getStatusText(),
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  String _getStatusText() {
    switch (_status) {
      case _HomePageStateStatus.AUTHENTICATING:
        return "Authenticating";
      case _HomePageStateStatus.AUTHENTICATED:
        return "Authenticated";
      case _HomePageStateStatus.ERROR_AUTHENTICATING:
        return "Error while authenticating";
      case _HomePageStateStatus.LOADING:
        return "Loading data...";
      case _HomePageStateStatus.LOAD:
        return "Found ${_beers.length} beers";
      case _HomePageStateStatus.ERROR:
        return "Error while loading data";
    }

    return "Unknown";
  }
}