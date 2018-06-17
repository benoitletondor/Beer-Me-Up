import 'package:flutter/material.dart';
import 'dart:async';

import 'package:beer_me_up/common/widget/materialflatbutton.dart';
import 'package:beer_me_up/localization/localization.dart';

// FIXME this view would need some proper MVI
Future<bool> showConsentDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(
        Localization.of(context).consentTitle,
        style: const TextStyle(
          fontFamily: "Google Sans",
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                Localization.of(context).consentTOSExplain,
                style: const TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                Localization.of(context).consentAgeExplain,
                style: const TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                Localization.of(context).consentWarningExplain,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 15.0)),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 4.0,
                children: <Widget>[
                  MaterialFlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    text: Localization.of(context).cancel,
                    textColor: Theme.of(context).textTheme.title.color,
                  ),
                  MaterialFlatButton.primary(
                    context: context,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    text: Localization.of(context).consentAcceptCTA,
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(right: 8.0)),
          ],
        ),
      ],
    ),
  );
}