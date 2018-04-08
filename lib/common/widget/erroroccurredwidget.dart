import 'package:flutter/material.dart';

class ErrorOccurredWidget extends StatelessWidget {
  ErrorOccurredWidget(this._error, this._retryCallback, {Key key}) : super(key: key);

  final String _error;
  final VoidCallback _retryCallback;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "An error occurred",
            style: new TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          new Padding(padding: const EdgeInsets.only(top: 10.0)),
          new Text(_error),
          new Padding(padding: const EdgeInsets.only(top: 30.0)),
          new RaisedButton(
            onPressed: _retryCallback,
            child: new Text("Retry"),
          )
        ],
      ),
    );
  }
}