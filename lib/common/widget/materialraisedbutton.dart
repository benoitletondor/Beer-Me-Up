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
    return new GestureDetector(
      onTapDown: (details) { performSelectionHaptic(context); },
      child: new RaisedButton(
        onPressed: onPressed,
        color: color,
        textColor: textColor,
        elevation: 1.0,
        padding: new EdgeInsets.only(left: leading == null ? 24.0 : 18.0, right: 24.0, top: 10.0, bottom: 10.0),
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
        ),
        child: new FittedBox(
          child: new Row(
            children: <Widget>[
              new Offstage(
                offstage: leading == null,
                child: new Row(
                  children: <Widget>[
                    leading ?? new Container(),
                    new Padding(padding: EdgeInsets.only(left: 10.0)),
                  ],
                ),
              ),
              new Text(
                text,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontFamily: 'Google Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}