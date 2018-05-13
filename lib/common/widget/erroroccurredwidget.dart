import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:beer_me_up/common/widget/materialflatbutton.dart';

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
            const Text(
              "An error occurred",
              style: TextStyle(
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
                    text: "Retry",
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