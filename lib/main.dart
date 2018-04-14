import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:beer_me_up/page/home/homepage.dart';
import 'package:beer_me_up/page/onboarding/onboardingpage.dart';
import 'package:beer_me_up/page/login/loginpage.dart';
import 'package:beer_me_up/page/checkin/checkinpage.dart';
import 'package:beer_me_up/page/account/accountpage.dart';

void main() => runApp(new BeerMeUpApp());

class BeerMeUpApp extends StatelessWidget {
  static FirebaseAnalytics analytics = new FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Beer Me Up',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new HomePage(),
      routes: <String, WidgetBuilder> {
        ONBOARDING_PAGE_ROUTE: (BuildContext context) => new OnboardingPage(),
        LOGIN_PAGE_ROUTE: (BuildContext context) => new LoginPage(),
        CHECK_IN_PAGE_ROUTE: (BuildContext context) => new CheckInPage(),
        ACCOUNT_PAGE_ROUTE: (BuildContext context) => new AccountPage(),
      },
      navigatorObservers: [
        new FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}


