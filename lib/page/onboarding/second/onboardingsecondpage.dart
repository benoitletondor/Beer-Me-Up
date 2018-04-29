import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/materialraisedbutton.dart';

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
    return new SafeArea(
      child: new Container(
        padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 50.0),
        child: new Column(
          children: <Widget>[
            new ConstrainedBox(
              constraints: new BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 3),
              child: new Image.asset("images/large_logo.png"),
            ),
            new Padding(padding: EdgeInsets.only(top: 16.0)),
            new Expanded(
              child: new SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    new Text(
                      "How does it work?",
                      style: new TextStyle(
                        fontFamily: 'Google Sans',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 25.0)),
                    new RichText(
                      text: new TextSpan(
                        text: "1. ",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                            text: "Create an account",
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          new TextSpan(
                            text: ", to save and retreive your beer check-ins at any time",
                          )
                        ],
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    new RichText(
                      text: new TextSpan(
                        text: "2. Every time you drink a beer, just ",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                            text: "check-in it",
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          new TextSpan(
                            text: " into the app",
                          )
                        ],
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    new RichText(
                      text: new TextSpan(
                        text: "3. Get a full ",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                            text: "history",
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          new TextSpan(
                            text: ", with ",
                          ),
                          new TextSpan(
                            text: "stats",
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          new TextSpan(
                            text: ", about your all the beers you drank",
                          )
                        ],
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 25.0)),
                    new Text(
                      "And that's it! That easy!",
                      style: new TextStyle(
                        fontFamily: 'Google Sans',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
            new Padding(padding: EdgeInsets.only(top: 16.0)),
            new Center(
              child: new MaterialRaisedButton.accent(
                context,
                intent.finish,
                "Let's go"
              ),
            ),
          ],
        ),
      ),
    );
  }

}