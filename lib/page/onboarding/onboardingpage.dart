import 'package:meta/meta.dart';

import 'package:flutter/material.dart';

import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

const String ONBOARDING_PAGE_ROUTE = "/onboarding";

class OnboardingPage extends StatefulWidget {
  final OnboardingIntent intent;
  final OnboardingViewModel model;

  OnboardingPage._({
    Key key,
    @required this.intent,
    @required this.model}) : super(key: key);

  factory OnboardingPage({Key key,
    OnboardingIntent intent,
    OnboardingViewModel model,
    AuthenticationService userService}) {

    final _intent = intent ?? new OnboardingIntent();
    final _model = model ?? new OnboardingViewModel(
      userService ?? AuthenticationService.instance,
      _intent.finish,
    );

    return new OnboardingPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<StatefulWidget> createState() => new _OnboardingPageState(intent: intent, model: model);
}

class _OnboardingPageState extends ViewState<OnboardingPage, OnboardingViewModel, OnboardingIntent, OnboardingState> {

  _OnboardingPageState({
    @required OnboardingIntent intent,
    @required OnboardingViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<OnboardingState> snapshot) {
        if (!snapshot.hasData) {
          return new Container();
        }

        return snapshot.data.join(
          (onboarding) => _buildOnboardingScreen(),
          () => new Container(),
        );
      },
    );
  }

  Widget _buildOnboardingScreen() {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Welcome"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              child: const Text('Continue'),
              onPressed: intent.finish,
            ),
          ],
        ),
      ),
    );
  }

}