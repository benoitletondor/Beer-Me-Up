import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:beer_me_up/common/hapticfeedback.dart';

class MaterialExtendedFAB extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  MaterialExtendedFAB({
    @required this.icon,
    @required this.text,
    @required this.color,
    @required this.textColor,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTapDown: (details) { performSelectionHaptic(context); },
      child: new RaisedButton(
        onPressed: onPressed,
        color: color,
        textColor: textColor,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        shape: const StadiumBorder(),
        child: new ConstrainedBox(
          constraints: BoxConstraints(minHeight: 45.0, maxHeight: 45.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 16.0),
              icon,
              const SizedBox(width: 8.0),
              new Text(
                text,
                style: new TextStyle(
                  fontFamily: "Google Sans",
                  color: textColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 20.0),
            ],
          ),
        ),
      ),
    );
  }

}