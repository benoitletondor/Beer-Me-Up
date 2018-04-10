import 'package:flutter/material.dart';
import 'dart:async';

// FIXME this view would need some proper MVI
Future<String> showLostPasswordDialog(BuildContext context) async {
  final emailController = new TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) => new SimpleDialog(
      title: const Text('Retrieve password'),
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      children: <Widget>[
        new Text("Enter your login email and we'll send you instructions to reset your password"),
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
        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("CANCEL"),
            ),
            new FlatButton(
              onPressed: () {
                if( emailController.value.text.trim().isEmpty ) {
                  _showEmptyEmailDialog(context);
                  return;
                }

                Navigator.of(context).pop(emailController.value.text);
              },
              textColor: Theme.of(context).accentColor,
              child: new Text("RESET PASSWORD")
            ),
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
      title: new Text("Empty email"),
      content: new Text("Please provide an email"),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: new Text("OK"),
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

