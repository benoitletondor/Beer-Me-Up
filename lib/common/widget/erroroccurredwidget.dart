import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:beer_me_up/common/widget/materialflatbutton.dart';
import 'package:beer_me_up/localization/localization.dart';

class ErrorOccurredWidget extends StatelessWidget {

  ErrorOccurredWidget({
    Key key,
    @required this.error,
    this.onRetry,
    this.invertColors = false,
  }) : super(key: key);

  final String error;
  final VoidCallback onRetry;
  final bool invertColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Localization.of(context).errorOccurred,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Google Sans",
                fontSize: 18.0,
                color: invertColors ? Colors.white : Theme.of(context).textTheme.body1.color
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: invertColors ? Colors.white : Theme.of(context).textTheme.body1.color
              ),
            ),
            Offstage(
              offstage: onRetry == null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  MaterialFlatButton(
                    textColor: invertColors ? Colors.white : Theme.of(context).primaryColor,
                    onPressed: onRetry,
                    text: Localization.of(context).retry,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}