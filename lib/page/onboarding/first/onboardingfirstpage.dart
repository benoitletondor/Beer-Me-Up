import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/materialraisedbutton.dart';
import 'package:beer_me_up/localization/localization.dart';

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

    final _intent = intent ?? OnboardingFirstPageIntent();
    final _model = model ?? OnboardingFirstPageViewModel();

    return OnboardingFirstPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<StatefulWidget> createState() => _OnboardingFirstPageState(intent: intent, model: model);
}

class _OnboardingFirstPageState extends ViewState<OnboardingFirstPage, OnboardingFirstPageViewModel, OnboardingFirstPageIntent, OnboardingFirstPageState> {

  _OnboardingFirstPageState({
    @required OnboardingFirstPageIntent intent,
    @required OnboardingFirstPageViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<OnboardingFirstPageState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return snapshot.data.join(
          (onboarding) => _buildOnboardingScreen(context),
          () => Container(),
        );
      },
    );
  }

  Widget _buildOnboardingScreen(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
              child: Image.asset("images/round_logo.png"),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Localization.of(context).onboardingFirstTitle,
                          style: TextStyle(
                            fontFamily: 'Google Sans',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10.0)),
                        Text(
                          Localization.of(context).onboardingFirstSubText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 15.0)),
                  Image.asset(
                    "images/thinking_face.png",
                    width: 50.0,
                  ),
                ],
              ),
            ),
            Center(
              child: MaterialRaisedButton.accent(
                context: context,
                onPressed: intent.next,
                text: Localization.of(context).onboardingFirstCTA
              ),
            ),
          ],
        ),
      ),
    );
  }

}