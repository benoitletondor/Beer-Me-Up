import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../onboarding/onboardingpage.dart';
import '../../common/widget/loadingwidget.dart';
import '../../common/widget/erroroccurredwidget.dart';
import 'profile/profilepage.dart';
import 'history/historypage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

enum _HomePageStateStatus { AUTHENTICATING, AUTHENTICATED, ERROR_AUTHENTICATING, LOADING, READY, ERROR }

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  FirebaseUser _currentUser;
  String _error;
  DocumentSnapshot _userDoc;
  _HomePageStateStatus _status = _HomePageStateStatus.AUTHENTICATING;

  int _index = 0;

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

    setState(() {
      _status = _HomePageStateStatus.AUTHENTICATING;
    });

    _currentUser = await _ensureLoggedIn();
    if( _currentUser == null ) {
      setState(() {
        _error = "Unable to authenticate you";
        _status = _HomePageStateStatus.ERROR_AUTHENTICATING;
      });
      return;
    }

    debugPrint("User logged in $_currentUser");

    setState(() {
      _status = _HomePageStateStatus.LOADING;
    });

    try {
      this._userDoc = await _connectDB(_currentUser);
      setState(() {
        _status = _HomePageStateStatus.READY;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _status = _HomePageStateStatus.ERROR;
      });
    }
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

  Future<DocumentSnapshot> _connectDB(FirebaseUser user) async {
      DocumentSnapshot doc = await Firestore.instance.collection("users").document(user.uid).get();
      if( doc == null || !doc.exists ) {
        debugPrint("Creating document reference for id ${user.uid}");
        final DocumentReference ref = Firestore.instance.collection("users").document(user.uid);
        await ref.setData({"id" : user.uid});
        doc = await ref.get();
      }

      return doc;
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _HomePageStateStatus.AUTHENTICATING:
        return _buildLoading();
      case _HomePageStateStatus.AUTHENTICATED:
        return _buildLoading();
      case _HomePageStateStatus.ERROR_AUTHENTICATING:
        return _buildError();
      case _HomePageStateStatus.LOADING:
        return _buildLoading();
      case _HomePageStateStatus.ERROR:
        return _buildError();
      case _HomePageStateStatus.READY:
        // Continue
        break;
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Beer Me Up'),
      ),
      body: new Center(
        child: new Stack(
          children: <Widget>[
            new Offstage(
              offstage: _index != 0,
              child: new TickerMode(
                enabled: _index == 0,
                child: new ProfilePage(_userDoc),
              ),
            ),
            new Offstage(
              offstage: _index != 1,
              child: new TickerMode(
                enabled: _index == 0,
                child: new HistoryPage(_userDoc),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _index,
        onTap: (int index) { setState((){ this._index = index; }); },
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text("Profile"),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.history),
            title: new Text("History"),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Beer Me Up'),
      ),
      body: new LoadingWidget(),
    );
  }

  Widget _buildError() {
    return new ErrorOccurredWidget(
      _error,
          () {_loadData(); },
    );
  }
}