import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

const String ONBOARDING_PAGE_ROUTE = "/onboarding";
const String USER_SAW_ONBOARDING_KEY = "sawOnboarding";

class OnboardingPage extends StatelessWidget {
  OnboardingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Welcome"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              child: const Text('Continue'),
              onPressed: () { _setSawOnboardingAndGoBackToRoot(context); },
            ),
          ],
        ),
      ),
    );
  }

  _setSawOnboardingAndGoBackToRoot(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(USER_SAW_ONBOARDING_KEY, true);
    Navigator.of(context).pushReplacementNamed("/");
  }
}