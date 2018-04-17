import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewstate.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';


class OnboardingFirstPage extends StatefulWidget {
  final OnboardingFirstPageIntent intent;
  final OnboardingFirstPageViewModel model;

  OnboardingFirstPage._({
    Key key,
    @required this.intent,
    @required this.model}) : super(key: key);

  factory OnboardingFirstPage({Key key,
    OnboardingFirstPageIntent intent,
    OnboardingFirstPageViewModel model,}) {

    final _intent = intent ?? new OnboardingFirstPageIntent();
    final _model = model ?? new OnboardingFirstPageViewModel();

    return new OnboardingFirstPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<StatefulWidget> createState() => new _OnboardingFirstPageState(intent: intent, model: model);
}

class _OnboardingFirstPageState extends ViewState<OnboardingFirstPage, OnboardingFirstPageViewModel, OnboardingFirstPageIntent, OnboardingFirstPageState> {

  _OnboardingFirstPageState({
    @required OnboardingFirstPageIntent intent,
    @required OnboardingFirstPageViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<OnboardingFirstPageState> snapshot) {
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
    return new Center(
      child: new Text("Onboarding first page"),
    );
  }

}