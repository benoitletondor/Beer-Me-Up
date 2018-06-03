import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:beer_me_up/common/hapticfeedback.dart';

class MaterialFlatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final Widget leading;

  MaterialFlatButton({
    @required this.onPressed,
    @required this.text,
    @required this.textColor,
    this.leading,
  });

  factory MaterialFlatButton.accent({
    @required BuildContext context,
    @required VoidCallback onPressed,
    @required String text,
    Widget leading,}) {
    return MaterialFlatButton(
      onPressed: onPressed,
      text: text,
      textColor: Theme.of(context).accentColor,
      leading: leading,
    );
  }

  factory MaterialFlatButton.primary({
    @required BuildContext context,
    @required VoidCallback onPressed,
    @required String text,
    Widget leading,}) {
    return MaterialFlatButton(
      onPressed: onPressed,
      text: text,
      textColor: Theme.of(context).primaryColor,
      leading: leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        performSelectionHaptic(context);
        if( onPressed != null ) {
          onPressed();
        }
      },
      textColor: textColor,
      child: FittedBox(
        child: Row(
          children: <Widget>[
            Offstage(
              offstage: leading == null,
              child: Row(
                children: <Widget>[
                  leading ?? Container(),
                  const Padding(padding: EdgeInsets.only(left: 10.0)),
                ],
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Google Sans',
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}