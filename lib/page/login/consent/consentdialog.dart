import 'package:flutter/material.dart';
import 'dart:async';

import 'package:beer_me_up/common/widget/materialflatbutton.dart';

// FIXME this view would need some proper MVI
Future<bool> showConsentDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text(
        'Create your account',
        style: TextStyle(
          fontFamily: "Google Sans",
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: const Text(
                "By creating your account, you agree to the Terms of Service and Privacy Policy.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: const Text(
                "You also certify to be over legal drinking age (18 or 21 depending on your country), using this app is prohibited for underage people.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: const Text(
                "Finally, we remind you that alcohol is dangerous for you and other people: drink responsibly.",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 15.0)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MaterialFlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              text: "Cancel",
              textColor: Theme.of(context).textTheme.title.color,
            ),
            MaterialFlatButton.primary(
              context: context,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              text: "Create account",
            ),
            const Padding(padding: EdgeInsets.only(right: 8.0)),
          ],
        ),
      ],
    ),
  );
}