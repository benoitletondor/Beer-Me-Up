import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

class MaterialFlatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color textColor;

  MaterialFlatButton({
    @required this.onPressed,
    @required this.text,
    @required this.textColor,
  });

  factory MaterialFlatButton.accent({
    @required BuildContext context,
    @required VoidCallback onPressed,
    @required String text}) {
    return MaterialFlatButton(
      onPressed: onPressed,
      text: text,
      textColor: Theme.of(context).accentColor,
    );
  }

  factory MaterialFlatButton.primary({
    @required BuildContext context,
    @required VoidCallback onPressed,
    @required String text}) {
    return MaterialFlatButton(
      onPressed: onPressed,
      text: text,
      textColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTapDown: (details) { HapticFeedback.lightImpact(); },
      child: new FlatButton(
        onPressed: onPressed,
        textColor: textColor,
        child: new Text(
          text,
          textAlign: TextAlign.center,
          style: new TextStyle(
            fontFamily: 'Google Sans',
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}