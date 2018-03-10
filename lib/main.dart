import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

    String dataURL = "https://jsonplaceholder.typicode.com/posts/1";
    setState(() {
      _content = "Loading...";
    });

    http.Response response = await http.get(dataURL);
    setState(() {
      _content = response.body;
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
