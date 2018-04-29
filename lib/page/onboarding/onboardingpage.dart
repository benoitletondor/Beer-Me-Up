import 'package:meta/meta.dart';
import 'dart:math';

import 'package:flutter_stream_friends/flutter_stream_friends.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';

import 'package:beer_me_up/page/onboarding/first/onboardingfirstpage.dart';
import 'package:beer_me_up/page/onboarding/first/intent.dart';
import 'package:beer_me_up/page/onboarding/second/onboardingsecondpage.dart';
import 'package:beer_me_up/page/onboarding/second/intent.dart';

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
  final PageController _controller = new PageController();

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
          (onboarding) => _buildOnboardingScreen(context),
          () => new Container(),
        );
      },
    );
  }

  Widget _buildOnboardingScreen(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: new Stack(
        children: <Widget>[
          new PageView(
            controller: _controller,
            children: <Widget>[
              new OnboardingFirstPage(
                intent: new OnboardingFirstPageIntent(
                  nextIntent: () {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.decelerate,
                    );
                  },
                ),
              ),
              new OnboardingSecondPage(
                intent: new OnboardingSecondPageIntent(
                  finishIntent: intent.finish,
                ),
              )
            ],
          ),
          new Positioned(
            bottom: 20.0,
            left: 0.0,
            right: 0.0,
            child: new Center(
              child: new _DotsIndicator(
                color: Colors.white,
                controller: _controller,
                itemCount: 2,
                onPageSelected: (int page) {
                  _controller.animateToPage(
                    page,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              ),
            )
          ),
        ],
      )
    );
  }

}

// https://gist.github.com/collinjackson/4fddbfa2830ea3ac033e34622f278824
class _DotsIndicator extends AnimatedWidget {
  _DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 6.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}