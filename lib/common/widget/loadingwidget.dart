import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
        child: new LinearProgressIndicator(),
      ),
    );
  }
}