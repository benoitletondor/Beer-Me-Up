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
    return RaisedButton(
      onPressed: () {
        performSelectionHaptic(context);
        if( onPressed != null ) {
          onPressed();
        }
      },
      color: color,
      textColor: textColor,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: const StadiumBorder(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 45.0, maxHeight: 45.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 16.0),
            icon,
            const SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(
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
    );
  }

}