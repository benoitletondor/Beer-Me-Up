import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewstate.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';


class OnboardingSecondPage extends StatefulWidget {
  final OnboardingSecondPageIntent intent;
  final OnboardingSecondPageViewModel model;

  OnboardingSecondPage._({
    Key key,
    @required this.intent,
    @required this.model}) : super(key: key);

  factory OnboardingSecondPage({Key key,
    OnboardingSecondPageIntent intent,
    OnboardingSecondPageViewModel model,}) {

    final _intent = intent ?? new OnboardingSecondPageIntent();
    final _model = model ?? new OnboardingSecondPageViewModel();

    return new OnboardingSecondPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<StatefulWidget> createState() => new _OnboardingSecondPageState(intent: intent, model: model);
}

class _OnboardingSecondPageState extends ViewState<OnboardingSecondPage, OnboardingSecondPageViewModel, OnboardingSecondPageIntent, OnboardingSecondPageState> {

  _OnboardingSecondPageState({
    @required OnboardingSecondPageIntent intent,
    @required OnboardingSecondPageViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<OnboardingSecondPageState> snapshot) {
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
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("Onboarding second page"),
        new Padding(padding: new EdgeInsets.only(top: 15.0)),
        new RaisedButton(
          onPressed: intent.finish,
          child: new Text("Start"),
        ),
      ],
    );
  }

}