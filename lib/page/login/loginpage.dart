import 'package:meta/meta.dart';

import 'package:flutter/material.dart';

import 'package:beer_me_up/common/widget/loadingwidget.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';

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
              new Offstage(
                offstage: error == null,
                child: new Column(
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.only(top: 15.0)),
                    new Text(
                      error ?? "",
                      style: new TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 15.0)),
                  ],
                ),
              ),
              new TextField(
                decoration: new InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                controller: signUpEmailController,
                onChanged: (val) { intent.signUpEmailInputChanged(); },
              ),
              new TextField(
                decoration: new InputDecoration(
                  icon: const Icon(Icons.vpn_key),
                  hintText: "Password",
                ),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: signUpPassController,
                onChanged: (val) { intent.signUpPasswordInputChanged(); },
              ),
              new Padding(padding: const EdgeInsets.only(top: 20.0)),
              new RaisedButton(
                onPressed: () => intent.signUp(new LoginFormData(signUpEmailController.text, signUpPassController.text)),
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
                onPressed: intent.signUpWithGoogle,
                child: new Text("Sign-in with Google"),
              ),
              new Padding(padding: const EdgeInsets.only(top: 10.0)),
              new RaisedButton(
                onPressed: intent.signUpWithFacebook,
                child: new Text("Sign-in with Facebook"),
              ),
              new Divider(height: 50.0),
              new FlatButton(
                onPressed: intent.showSignIn,
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
    return new Scaffold(
      appBar: _buildAppBar(context),
      body: new Builder(builder: (context) =>
        new SafeArea(
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
                new Offstage(
                  offstage: error == null,
                  child: new Column(
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.only(top: 15.0)),
                      new Text(
                        error ?? "",
                        style: new TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      new Padding(padding: EdgeInsets.only(top: 15.0)),
                    ],
                  ),
                ),
                new TextField(
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.email),
                    hintText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: signInEmailController,
                  onChanged: (val) { intent.signInEmailInputChanged(); },
                ),
                new TextField(
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.vpn_key),
                    hintText: "Password",
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  controller: signInPassController,
                  onChanged: (val) { intent.signInPasswordInputChanged(); },
                ),
                new Padding(padding: const EdgeInsets.only(top: 20.0)),
                new RaisedButton(
                  onPressed: () => intent.signIn(new LoginFormData(signInEmailController.text, signInPassController.text)),
                  child: new Text("Sign-in"),
                ),
                new Padding(padding: const EdgeInsets.only(top: 10.0)),
                new FlatButton(
                  onPressed: () { intent.forgotPassword(context); },
                  child: new Text("FORGOT PASSWORD?"),
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
                  onPressed: intent.signInWithGoogle,
                  child: new Text("Sign-in with Google"),
                ),
                new Padding(padding: const EdgeInsets.only(top: 10.0)),
                new RaisedButton(
                  onPressed: intent.signInWithFacebook,
                  child: new Text("Sign-in with Facebook"),
                ),
                new Divider(height: 50.0),
                new FlatButton(
                  onPressed: intent.showSignUp,
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
}