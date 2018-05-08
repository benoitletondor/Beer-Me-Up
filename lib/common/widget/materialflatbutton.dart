import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:beer_me_up/common/hapticfeedback.dart';

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
    return GestureDetector(
      onTapDown: (details) { performSelectionHaptic(context); },
      child: FlatButton(
        onPressed: onPressed,
        textColor: textColor,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Google Sans',
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}