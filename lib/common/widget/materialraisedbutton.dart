import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

class MaterialRaisedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color textColor;

  MaterialRaisedButton({
    @required this.onPressed,
    @required this.text,
    @required this.color,
    @required this.textColor,
  });

  factory MaterialRaisedButton.accent(BuildContext context, VoidCallback onPressed, String text) {
    return MaterialRaisedButton(
      onPressed: onPressed,
      text: text,
      textColor: Colors.white,
      color: Theme.of(context).accentColor,
    );
  }

  factory MaterialRaisedButton.primary(BuildContext context, VoidCallback onPressed, String text) {
    return MaterialRaisedButton(
      onPressed: onPressed,
      text: text,
      textColor: Colors.white,
      color: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTapDown: (details) { HapticFeedback.lightImpact(); },
      onTapUp: (details) { HapticFeedback.lightImpact(); },
      child: new RaisedButton(
        onPressed: onPressed,
        color: color,
        textColor: textColor,
        elevation: 1.0,
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
        ),
        child: new Text(
          text,
          style: new TextStyle(
            fontFamily: 'Google Sans',
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}