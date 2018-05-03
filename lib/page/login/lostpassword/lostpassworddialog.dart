import 'package:flutter/material.dart';
import 'dart:async';

import 'package:beer_me_up/common/widget/materialflatbutton.dart';

// FIXME this view would need some proper MVI
Future<String> showLostPasswordDialog(BuildContext context) async {
  final emailController = new TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) => new SimpleDialog(
      title: new Text(
        'Retrieve password',
        style: new TextStyle(
          color: Colors.blueGrey[900],
          fontFamily: "Google Sans",
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
      children: <Widget>[
        new Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: new Column(
            children: <Widget>[
              new Text(
                "Enter your login email and we'll send you instructions to reset your password",
                style: new TextStyle(
                  color: Colors.blueGrey[900],
                  fontSize: 15.0,
                ),
              ),
              new Padding(padding: EdgeInsets.only(top: 16.0)),
              new TextField(
                controller: emailController,
                decoration: new InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              new Padding(padding: EdgeInsets.only(top: 25.0)),
            ],
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new MaterialFlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: "Cancel",
              textColor: Colors.blueGrey[900],
            ),
            new MaterialFlatButton.primary(
              context: context,
              onPressed: () {
                if( emailController.value.text.trim().isEmpty ) {
                  _showEmptyEmailDialog(context);
                  return;
                }

                Navigator.of(context).pop(emailController.value.text);
              },
              text: "Reset password",
            ),
            new Padding(padding: EdgeInsets.only(right: 8.0)),
          ],
        ),
      ],
    ),
  );
}

_showEmptyEmailDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text(
        "Empty email",
        style: new TextStyle(
          color: Colors.blueGrey[900],
          fontFamily: "Google Sans",
          fontWeight: FontWeight.w500,
        ),
      ),
      content: new Text(
        "Please provide an email",
        style: new TextStyle(
          color: Colors.blueGrey[900],
          fontSize: 15.0,
        ),
      ),
      actions: <Widget>[
        new MaterialFlatButton.primary(
          context: context,
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: "OK",
        )
      ],
    ),
  );
}

showLostPasswordEmailSentSnackBar(BuildContext context) {
  Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text("Email with instructions has been send."),
    duration: Duration(seconds: 3),
  ));
}

showLostPasswordEmailErrorSendingSnackBar(BuildContext context, String error) {
  Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text(
      "An error occurred while sending en email with instructions ($error)",
      style: new TextStyle(
        color: Colors.red[600],
      ),
    ),
    duration: Duration(seconds: 5),
  ));
}

