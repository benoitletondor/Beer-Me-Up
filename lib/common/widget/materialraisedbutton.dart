import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:beer_me_up/common/hapticfeedback.dart';

class MaterialRaisedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final Color textColor;
  final Widget leading;

  MaterialRaisedButton({
    @required this.onPressed,
    @required this.text,
    @required this.color,
    @required this.textColor,
    this.leading,
  });

  factory MaterialRaisedButton.accent({
    @required BuildContext context,
    @required VoidCallback onPressed,
    @required String text,
    Widget leading,}) {
    return MaterialRaisedButton(
      onPressed: onPressed,
      text: text,
      textColor: Colors.white,
      color: Theme.of(context).accentColor,
      leading: leading,
    );
  }

  factory MaterialRaisedButton.primary({
    @required BuildContext context,
    @required VoidCallback onPressed,
    @required String text,
    Widget leading,}) {
    return MaterialRaisedButton(
      onPressed: onPressed,
      text: text,
      textColor: Colors.white,
      color: Theme.of(context).primaryColor,
      leading: leading,
    );
  }

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
      elevation: 1.0,
      padding: EdgeInsets.only(left: leading == null ? 24.0 : 18.0, right: 24.0, top: 10.0, bottom: 10.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
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
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}