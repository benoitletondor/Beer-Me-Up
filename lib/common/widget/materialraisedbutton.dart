import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:beer_me_up/common/hapticfeedback.dart';

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

  factory MaterialRaisedButton.accent({
    @required BuildContext context,
    @required VoidCallback onPressed,
    @required String text}) {
    return MaterialRaisedButton(
      onPressed: onPressed,
      text: text,
      textColor: Colors.white,
      color: Theme.of(context).accentColor,
    );
  }

  factory MaterialRaisedButton.primary({
    @required BuildContext context,
    VoidCallback onPressed,
    String text}) {
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
      onTapDown: (details) { performSelectionHaptic(context); },
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
          textAlign: TextAlign.center,
          style: new TextStyle(
            fontFamily: 'Google Sans',
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}