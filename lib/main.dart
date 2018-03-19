import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'page/home/homepage.dart';
import 'page/onboarding/onboardingpage.dart';
import 'page/login/loginpage.dart';
import 'page/checkin/checkinpage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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
      },
      navigatorObservers: [
        new FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}


