import 'package:flutter/material.dart';

class ErrorOccurredWidget extends StatelessWidget {
  ErrorOccurredWidget(this._error, this._retryCallback, {Key key}) : super(key: key);

  final String _error;
  final VoidCallback _retryCallback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "An error occurred",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          Text(_error),
          const Padding(padding: EdgeInsets.only(top: 30.0)),
          RaisedButton(
            onPressed: _retryCallback,
            child: const Text("Retry"),
          )
        ],
      ),
    );
  }
}