import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:beer_me_up/service/config.dart';
import 'package:beer_me_up/page/home/homepage.dart';
import 'package:beer_me_up/page/onboarding/onboardingpage.dart';
import 'package:beer_me_up/page/login/loginpage.dart';
import 'package:beer_me_up/page/checkin/checkinpage.dart';
import 'package:beer_me_up/page/settings/settingspage.dart';
import 'package:beer_me_up/page/tos/tospage.dart';
import 'package:beer_me_up/service/analytics.dart';
import 'package:sentry/sentry.dart';
import 'package:beer_me_up/private.dart';
import 'package:beer_me_up/common/exceptionprint.dart';
import 'package:beer_me_up/localization/localization.dart';

void main() => runApp(BeerMeUpApp());

class BeerMeUpApp extends StatelessWidget {
  static OptOutAwareFirebaseAnalytics analytics = OptOutAwareFirebaseAnalytics(FirebaseAnalytics());
  static Config config = Config.create();
  static SentryClient sentry = new SentryClient(dsn: SENTRY_DSN);

  @override
  Widget build(BuildContext context) {
    config.toString(); // Access object to ensure creation at startup time

    // Set-up error reporting
    FlutterError.onError = (FlutterErrorDetails error) {
      printException(error.exception, error.stack, error.context);
    };

    return MaterialApp(
      title: 'Beer Me Up',
      theme: ThemeData(
        primaryColor: Colors.blueAccent[400],
        accentColor: Colors.amber[500],
        canvasColor: const Color(0xFFF8F8F8),
        textTheme: Typography(platform: defaultTargetPlatform).black.apply(
          bodyColor: Colors.blueGrey[900],
          displayColor: Colors.blueGrey[900],
        ),
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder> {
        ONBOARDING_PAGE_ROUTE: (BuildContext context) => OnboardingPage(),
        LOGIN_PAGE_ROUTE: (BuildContext context) => LoginPage(),
        CHECK_IN_PAGE_ROUTE: (BuildContext context) => CheckInPage(),
        SETTINGS_PAGE_ROUTE: (BuildContext context) => SettingsPage(),
        TOS_PAGE_ROUTE: (BuildContext context) => TOSPage(),
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      localizationsDelegates: [
        const BeerMeUpLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr'),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}


