import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:beer_me_up/common/widget/materialflatbutton.dart';
import 'package:beer_me_up/localization/localization.dart';

class ErrorOccurredWidget extends StatelessWidget {

  ErrorOccurredWidget({
    Key key,
    @required this.error,
    this.onRetry,
  }) : super(key: key);

  final String error;
  final VoidCallback onRetry;

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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Google Sans",
                fontSize: 18.0,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            Text(
              error,
              textAlign: TextAlign.center,
            ),
            Offstage(
              offstage: onRetry == null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 10.0)),
                  MaterialFlatButton.primary(
                    context: context,
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