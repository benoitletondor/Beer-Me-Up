import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/materialraisedbutton.dart';
import 'package:beer_me_up/localization/localization.dart';

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

    final _intent = intent ?? OnboardingSecondPageIntent();
    final _model = model ?? OnboardingSecondPageViewModel();

    return OnboardingSecondPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<StatefulWidget> createState() => _OnboardingSecondPageState(intent: intent, model: model);
}

class _OnboardingSecondPageState extends ViewState<OnboardingSecondPage, OnboardingSecondPageViewModel, OnboardingSecondPageIntent, OnboardingSecondPageState> {

  _OnboardingSecondPageState({
    @required OnboardingSecondPageIntent intent,
    @required OnboardingSecondPageViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<OnboardingSecondPageState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return snapshot.data.join(
          (onboarding) => _buildOnboardingScreen(),
          () => Container(),
        );
      },
    );
  }

  Widget _buildOnboardingScreen() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 50.0),
        child: Column(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 3),
              child: Image.asset("images/large_logo.png"),
            ),
            const Padding(padding: EdgeInsets.only(top: 16.0)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      Localization.of(context).onboardingSecondTitle,
                      style: TextStyle(
                        fontFamily: 'Google Sans',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 25.0)),
                    RichText(
                      text: TextSpan(
                        text: "1. ",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: Localization.of(context).onboardingSecondFirstExplainFirst,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: Localization.of(context).onboardingSecondFirstExplainSecond,
                          )
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10.0)),
                    RichText(
                      text: TextSpan(
                        text: Localization.of(context).onboardingSecondSecondExplainFirst,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: Localization.of(context).onboardingSecondSecondExplainSecond,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: Localization.of(context).onboardingSecondSecondExplainThird,
                          )
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10.0)),
                    RichText(
                      text: TextSpan(
                        text: Localization.of(context).onboardingSecondThirdExplainFirst,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: Localization.of(context).onboardingSecondThirdExplainSecond,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: Localization.of(context).onboardingSecondThirdExplainThird,
                          ),
                          TextSpan(
                            text: Localization.of(context).onboardingSecondThirdExplainFourth,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: Localization.of(context).onboardingSecondThirdExplainFifth,
                          )
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 25.0)),
                    Text(
                      Localization.of(context).onboardingSecondSubText,
                      style: const TextStyle(
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
            const Padding(padding: EdgeInsets.only(top: 16.0)),
            Center(
              child: MaterialRaisedButton.accent(
                context: context,
                onPressed: intent.finish,
                text: Localization.of(context).onboardingSecondCTA
              ),
            ),
          ],
        ),
      ),
    );
  }

}