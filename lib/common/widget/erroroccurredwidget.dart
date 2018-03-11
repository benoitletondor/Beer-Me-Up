import 'package:flutter/material.dart';

class ErrorOccurredWidget extends StatelessWidget {
  ErrorOccurredWidget(this._error, this._retryCallback, {Key key}) : super(key: key);

  final String _error;
  final Function _retryCallback;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "An error occurred",
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          new Text(_error),
          new RaisedButton(
            onPressed: () {_retryCallback();},
            child: new Text("Retry"),
          )
        ],
      ),
    );
  }
}