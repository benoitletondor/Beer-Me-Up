import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:beer_me_up/page/home/homepage.dart';
import 'package:beer_me_up/page/onboarding/onboardingpage.dart';
import 'package:beer_me_up/page/login/loginpage.dart';
import 'package:beer_me_up/page/checkin/checkinpage.dart';
import 'package:beer_me_up/page/account/accountpage.dart';

void main() => runApp(BeerMeUpApp());

class BeerMeUpApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beer Me Up',
      theme: ThemeData(
        primaryColor: Colors.blueAccent[400],
        accentColor: Colors.amber[500],
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder> {
        ONBOARDING_PAGE_ROUTE: (BuildContext context) => OnboardingPage(),
        LOGIN_PAGE_ROUTE: (BuildContext context) => LoginPage(),
        CHECK_IN_PAGE_ROUTE: (BuildContext context) => CheckInPage(),
        ACCOUNT_PAGE_ROUTE: (BuildContext context) => AccountPage(),
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}


