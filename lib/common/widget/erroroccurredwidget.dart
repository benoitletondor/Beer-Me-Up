import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:beer_me_up/common/widget/materialraisedbutton.dart';

class ErrorOccurredWidget extends StatelessWidget {

  ErrorOccurredWidget({
    Key key,
    @required this.error,
    this.onRetryPressed,
  }) : super(key: key);

  final String error;
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "An error occurred",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          Text(error),
          const Padding(padding: EdgeInsets.only(top: 30.0)),
          MaterialRaisedButton.primary(
            context: context,
            onPressed: onRetryPressed,
            text: "Retry",
          )
        ],
      ),
    );
  }
}