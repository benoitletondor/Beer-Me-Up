import 'package:meta/meta.dart';

import 'package:flutter/material.dart';

import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/materialraisedbutton.dart';
import 'package:beer_me_up/common/widget/materialflatbutton.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

const String LOGIN_PAGE_ROUTE = "/login";

class LoginPage extends StatefulWidget {
  final LoginIntent intent;
  final LoginViewModel model;

  LoginPage._({
    Key key,
    @required this.intent,
    @required this.model}) : super(key: key);

  factory LoginPage({Key key,
    LoginIntent intent,
    LoginViewModel model,
    AuthenticationService userService}) {

    final _intent = intent ?? new LoginIntent();
    final _model = model ?? new LoginViewModel(
      userService ?? AuthenticationService.instance,
      _intent.showSignIn,
      _intent.showSignUp,
      _intent.signUp,
      _intent.signIn,
      _intent.signInWithGoogle,
      _intent.signUpWithGoogle,
      _intent.signInWithFacebook,
      _intent.signUpWithFacebook,
      _intent.forgotPassword,
      _intent.signUpEmailInputChanged,
      _intent.signUpPasswordInputChanged,
      _intent.signInEmailInputChanged,
      _intent.signInPasswordInputChanged,
    );

    return new LoginPage._(key: key, intent: _intent, model: _model);
  }

  @override
  _LoginPageState createState() => new _LoginPageState(intent: intent, model: model);
}

class _LoginPageState extends ViewState<LoginPage, LoginViewModel, LoginIntent, LoginState> {

  final signUpEmailController = new TextEditingController();
  final signUpPassController = new TextEditingController();
  final signInEmailController = new TextEditingController();
  final signInPassController = new TextEditingController();

  _LoginPageState({
    @required LoginIntent intent,
    @required LoginViewModel model
  }): super(intent, model);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<LoginState> snapshot) {
        if( !snapshot.hasData ) {
          return new Container();
        }

        return snapshot.data.join(
          (signUp) => _buildSignUpScreen(context),
          (signIn) => _buildLoginScreen(context),
          (authenticating) => _buildAuthenticatingScreen(context),
          (signUpError) => _buildSignUpScreen(context, error: signUpError.error),
          (signInError) => _buildLoginScreen(context, error: signInError.error),
        );
      },
    );
  }

  Widget _buildSignUpScreen(BuildContext context, {String error}) {
    return new Scaffold(
      appBar: _buildAppBar(context),
      body: new SafeArea(
        child: new SingleChildScrollView(
          child: new Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  "Create your account",
                  style: new TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    fontFamily: "Google Sans",
                    color: Colors.blueGrey[900],
                  ),
                ),
                new Offstage(
                  offstage: error == null,
                  child: new Column(
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.only(top: 16.0)),
                      new Text(
                        error ?? "",
                        style: new TextStyle(
                          color: Colors.red[600],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.only(top: 16.0)),
                new TextField(
                  decoration: new InputDecoration(
                    hintText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: signUpEmailController,
                  onChanged: (val) { intent.signUpEmailInputChanged(); },
                ),
                new Padding(padding: EdgeInsets.only(top: 16.0)),
                new TextField(
                  decoration: new InputDecoration(
                    hintText: "Password",
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  controller: signUpPassController,
                  onChanged: (val) { intent.signUpPasswordInputChanged(); },
                ),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new Center(
                  child: new MaterialRaisedButton.primary(
                    context: context,
                    onPressed: () { intent.signUp(new LoginFormData(signUpEmailController.text, signUpPassController.text)); },
                    text: "Sign-up"
                  ),
                ),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        height: 2.0,
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(left: 16.0)),
                    new Text(
                      "OR",
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Google Sans",
                        color: Colors.black38,
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(left: 16.0)),
                    new Expanded(
                      child: new Container(
                        height: 2.0,
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new Center(
                  child: new MaterialRaisedButton.primary(
                    context: context,
                    onPressed: intent.signUpWithGoogle,
                    text: "Sign-in with Google"),
                ),
                new Padding(padding: const EdgeInsets.only(top: 16.0)),
                new Center(
                  child: new MaterialRaisedButton.primary(
                    context: context,
                    onPressed: intent.signUpWithFacebook,
                    text: "Sign-in with Facebook"
                  ),
                ),
                new Padding(padding: EdgeInsets.only(top: 30.0)),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Icon(
                      Icons.lock,
                      color: Colors.blueGrey[900],
                    ),
                    new Padding(padding: EdgeInsets.only(left: 10.0)),
                    new Expanded(
                      child: new Text(
                        "Like privacy? We feel you. We don’t use or sell your data. It’s your personal beer logging, not ours ;)",
                        style: new TextStyle(
                          color: Colors.blueGrey[900],
                          fontSize: 14.0,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                new Padding(padding: EdgeInsets.only(top: 20.0)),
                new Center(
                  child: new MaterialFlatButton.primary(
                    context: context,
                    onPressed: intent.showSignIn,
                    text: "Already have an account? Sign-in",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginScreen(BuildContext context, {String error}) {
    return new Scaffold(
      appBar: _buildAppBar(context),
      body: new SafeArea(
        child: new SingleChildScrollView(
          child: new Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  "Sign-in with your account",
                  style: new TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    fontFamily: "Google Sans",
                    color: Colors.blueGrey[900],
                  ),
                ),
                new Offstage(
                  offstage: error == null,
                  child: new Column(
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.only(top: 16.0)),
                      new Text(
                        error ?? "",
                        style: new TextStyle(
                          color: Colors.red[600],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.only(top: 16.0)),
                new TextField(
                  decoration: new InputDecoration(
                    hintText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: signInEmailController,
                  onChanged: (val) { intent.signInEmailInputChanged(); },
                ),
                new Padding(padding: EdgeInsets.only(top: 16.0)),
                new TextField(
                  decoration: new InputDecoration(
                    hintText: "Password",
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  controller: signInPassController,
                  onChanged: (val) { intent.signInPasswordInputChanged(); },
                ),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new Center(
                  child: new MaterialRaisedButton.primary(
                    context: context,
                    onPressed: () { intent.signIn(new LoginFormData(signInEmailController.text, signInPassController.text)); },
                    text: "Sign-in"
                  ),
                ),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        height: 2.0,
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(left: 16.0)),
                    new Text(
                      "OR",
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Google Sans",
                        color: Colors.black38,
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(left: 16.0)),
                    new Expanded(
                      child: new Container(
                        height: 2.0,
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
                new Padding(padding: const EdgeInsets.only(top: 25.0)),
                new Center(
                  child: new MaterialRaisedButton.primary(
                    context: context,
                    onPressed: intent.signInWithGoogle,
                    text: "Sign-in with Google"
                  ),
                ),
                new Padding(padding: const EdgeInsets.only(top: 16.0)),
                new Center(
                  child: new MaterialRaisedButton.primary(
                    context: context,
                    onPressed: intent.signInWithFacebook,
                    text: "Sign-in with Facebook"
                  ),
                ),
                new Padding(padding: EdgeInsets.only(top: 30.0)),
                new Center(
                  child: new MaterialFlatButton.primary(
                    context: context,
                    onPressed: intent.showSignUp,
                    text: "Don't have an account yet? Sign-up",
                  ),
                )
              ],
            ),
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
      title: new Text(
        'Beer Me Up',
        style: new TextStyle(
          fontFamily: "Google Sans",
        ),
      ),
    );
  }
}