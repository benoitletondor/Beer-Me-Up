import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/materialraisedbutton.dart';

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
          (onboarding) => _buildOnboardingScreen(context),
          () => new Container(),
        );
      },
    );
  }

  Widget _buildOnboardingScreen(BuildContext context) {
    return new SafeArea(
      child: new Container(
        padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 50.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Image.asset(
              "images/round_logo.png",
            ),
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Ever wondered...",
                          style: new TextStyle(
                            fontFamily: 'Google Sans',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        new Text(
                          "\"What was that beer I drank last time that tasted so good?\"",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Padding(padding: EdgeInsets.only(left: 15.0)),
                  new Image.asset(
                    "images/thinking_face.png",
                    width: 50.0,
                  ),
                ],
              ),
            ),
            new Center(
              child: new MaterialRaisedButton.accent(
                context,
                intent.next,
                "Yeah! Totally!"
              ),
            ),
          ],
        ),
      ),
    );
  }

}