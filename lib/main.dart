import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/beer.dart';

void main() => runApp(new MyApp());

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = new FirebaseAnalytics();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Beer Me Up',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(title: 'Beer Me Up'),
      navigatorObservers: [
        new FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _content;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<FirebaseUser> _ensureLoggedIn() async {
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

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

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
      return new List(0);
    }
  }

  _loadData() async {
    final FirebaseUser user = await _ensureLoggedIn();
    if( user == null ) {
      setState(() {
        _content = "Error login";
      });
      return;
    } else {
      debugPrint("User logged in $user");
    }

    setState(() {
      _content = "Loading...";
    });

    List<Beer> beers = await _getUserBeersCollection(user);
    if( beers == null ) {
      setState(() {
        _content = "Error fetching beers";
      });
      return;
    }

    setState(() {
      _content = "$beers";
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            new Text(
              '$_content',
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
