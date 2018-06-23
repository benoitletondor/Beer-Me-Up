import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({
    Key key,
    this.invertColors = false,
  }) : super(key: key);

  final bool invertColors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
        child: LinearProgressIndicator(
          backgroundColor: invertColors ? Colors.white : Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}