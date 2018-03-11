import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../common/widget/loadingwidget.dart';

const String LOGIN_PAGE_ROUTE = "/login";

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum _LoginPageStateStatus { SIGN_UP, SIGN_IN, AUTHENTICATING, SIGN_UP_ERROR, SIGN_IN_ERROR }

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _LoginPageStateStatus _status = _LoginPageStateStatus.SIGN_UP;
  String _error;

  @override
  Widget build(BuildContext context) {
    switch(_status) {
      case _LoginPageStateStatus.SIGN_UP:
        return _buildSignUpScreen(context);
      case _LoginPageStateStatus.SIGN_IN:
        return _buildLoginScreen(context);
      case _LoginPageStateStatus.AUTHENTICATING:
        return _buildAuthenticatingScreen(context);
      case _LoginPageStateStatus.SIGN_UP_ERROR:
        return _buildSignUpScreen(context, error: _error);
      case _LoginPageStateStatus.SIGN_IN_ERROR:
        return _buildLoginScreen(context, error: _error);
    }

    return null;
  }

  Widget _buildSignUpScreen(BuildContext context, {String error}) {
    final emailController = new TextEditingController();
    final passController = new TextEditingController();

    return new Scaffold(
      appBar: _buildAppBar(context),
      body: new SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Text(
                "Create your account",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              new TextField(
                decoration: new InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              new TextField(
                decoration: new InputDecoration(
                  icon: const Icon(Icons.vpn_key),
                  hintText: "Password",
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: passController,
              ),
              new Padding(padding: const EdgeInsets.only(top: 20.0)),
              new RaisedButton(
                onPressed: () { _handleCreateAccount(emailController, passController); },
                child: new Text("Sign-up"),
              ),
              new Padding(padding: const EdgeInsets.only(top: 20.0)),
              new Text(
                "Or",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              new Padding(padding: const EdgeInsets.only(top: 20.0)),
              new RaisedButton(
                onPressed: () { _signInWithGoogle(); },
                child: new Text("Sign-in with Google"),
              ),
              new Divider(height: 50.0),
              new FlatButton(
                onPressed: () { setState((){
                  _status = _LoginPageStateStatus.SIGN_IN;
                }); },
                child: new Text(
                  "ALREADY HAVE AN ACCOUNT ? SIGN-IN",
                  style: new TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginScreen(BuildContext context, {String error}) {
    final emailController = new TextEditingController();
    final passController = new TextEditingController();

    return new Scaffold(
      appBar: _buildAppBar(context),
      body: new SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Text(
                "Sign-in with your account",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              new TextField(
                decoration: new InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              new TextField(
                decoration: new InputDecoration(
                  icon: const Icon(Icons.vpn_key),
                  hintText: "Password",
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: passController,
              ),
              new Padding(padding: const EdgeInsets.only(top: 20.0)),
              new RaisedButton(
                onPressed: () { _handleLogin(emailController, passController); },
                child: new Text("Sign-in"),
              ),
              new Padding(padding: const EdgeInsets.only(top: 20.0)),
              new Text(
                "Or",
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              new Padding(padding: const EdgeInsets.only(top: 20.0)),
              new RaisedButton(
                onPressed: () { _signInWithGoogle(); },
                child: new Text("Sign-in with Google"),
              ),
              new Divider(height: 50.0),
              new FlatButton(
                onPressed: () { setState((){
                  _status = _LoginPageStateStatus.SIGN_UP;
                }); },
                child: new Text(
                  "DON'T HAVE AN ACCOUNT ? SIGN-UP",
                  style: new TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticatingScreen(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(context),
      body: new LoadingWidget(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('Beer Me Up - Sign in'),
    );
  }

  _handleCreateAccount(TextEditingController emailController,TextEditingController passController) async {
    final String email = emailController.text;
    final String pass = passController.text;

    if( email.isEmpty ) {
      showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text(
            "Email is mandatory",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: new Text("Please provide an email to sign-up."),
          actions: <Widget>[
            new FlatButton(
                child: const Text('OK'),
                onPressed: () { Navigator.pop(context); }
            ),
          ],
        ),
      );
      return;
    }

    if( pass.isEmpty ) {
      showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text(
            "Password is mandatory",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: new Text("Please provide a password to sign-up."),
          actions: <Widget>[
            new FlatButton(
                child: const Text('OK'),
                onPressed: () { Navigator.pop(context); }
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _status = _LoginPageStateStatus.AUTHENTICATING;
    });

    try {
      await _signUpWithAccount(email, pass);
      Navigator.of(context).pushReplacementNamed("/");
    } catch(e) {
      _error = e.toString();

      setState(() {
        _status = _LoginPageStateStatus.SIGN_UP_ERROR;
      });
    }
  }

  _handleLogin(TextEditingController emailController,TextEditingController passController) async {
    final String email = emailController.text;
    final String pass = passController.text;
    
    if( email.isEmpty ) {
      showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text(
            "Email is mandatory",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: new Text("Please provide an email to sign-in."),
          actions: <Widget>[
            new FlatButton(
              child: const Text('OK'),
              onPressed: () { Navigator.pop(context); }
            ),
          ],
        ),
      );
      return;
    }

    if( pass.isEmpty ) {
      showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text(
            "Password is mandatory",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: new Text("Please provide a password to sign-in."),
          actions: <Widget>[
            new FlatButton(
                child: const Text('OK'),
                onPressed: () { Navigator.pop(context); }
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _status = _LoginPageStateStatus.AUTHENTICATING;
    });

    try {
      await _loginWithAccount(email, pass);
      Navigator.of(context).pushReplacementNamed("/");
    } catch(e) {
      _error = e.toString();

      setState(() {
        _status = _LoginPageStateStatus.SIGN_IN_ERROR;
      });
    }
  }

  _signInWithGoogle() async {
    try {
      setState(() {
        _status = _LoginPageStateStatus.AUTHENTICATING;
      });

      GoogleSignInAccount googleUser = await _googleSignIn.signInSilently();
      if( googleUser == null ) {
        googleUser = await _googleSignIn.signIn();
      }

      if( googleUser == null ) {
        throw new Exception("No user found");
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

      Navigator.of(context).pushReplacementNamed("/");
    } catch (e) {
      _error = e.toString();
      setState(() {
        _status = _LoginPageStateStatus.SIGN_IN_ERROR;
      });
    }

  }

  Future<FirebaseUser> _loginWithAccount(String email, String pass) async {
    if( email == null || email.isEmpty ) {
      throw new Exception("Email is empty");
    }

    if( pass == null || pass.isEmpty ){
      throw new Exception("Password is empty");
    }

    final FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: pass);
    if( user == null ) {
      throw new Exception("Unable to login");
    }
    assert(user.email != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    return user;
  }

  Future<FirebaseUser> _signUpWithAccount(String email, String pass) async {
    if( email == null || email.isEmpty ) {
      throw new Exception("Email is empty");
    }

    if( pass == null || pass.isEmpty ){
      throw new Exception("Password is empty");
    }

    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
    if( user == null ) {
      throw new Exception("Unable to login");
    }

    assert(user.email != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    return user;
  }

}