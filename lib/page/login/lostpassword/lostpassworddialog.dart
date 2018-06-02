import 'package:flutter/material.dart';
import 'dart:async';

import 'package:beer_me_up/common/widget/materialflatbutton.dart';
import 'package:beer_me_up/localization/localization.dart';

// FIXME this view would need some proper MVI
Future<String> showLostPasswordDialog(BuildContext context) async {
  final emailController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(
        Localization.of(context).forgotPasswordTitle,
        style: const TextStyle(
          fontFamily: "Google Sans",
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: <Widget>[
              Text(
                Localization.of(context).forgotPasswordExplain,
                style: const TextStyle(
                  fontSize: 15.0,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 16.0)),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: Localization.of(context).email,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const Padding(padding: EdgeInsets.only(top: 25.0)),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MaterialFlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: Localization.of(context).cancel,
              textColor: Theme.of(context).textTheme.title.color,
            ),
            MaterialFlatButton.primary(
              context: context,
              onPressed: () {
                if( emailController.value.text.trim().isEmpty ) {
                  _showEmptyEmailDialog(context);
                  return;
                }

                Navigator.of(context).pop(emailController.value.text);
              },
              text: Localization.of(context).forgotPasswordResetCTA,
            ),
            const Padding(padding: EdgeInsets.only(right: 8.0)),
          ],
        ),
      ],
    ),
  );
}

_showEmptyEmailDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        Localization.of(context).forgotPasswordNoEmailTitle,
        style: const TextStyle(
          fontFamily: "Google Sans",
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        Localization.of(context).forgotPasswordNoEmailExplain,
        style: const TextStyle(
          fontSize: 15.0,
        ),
      ),
      actions: <Widget>[
        MaterialFlatButton.primary(
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
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      Localization.of(context).forgotPasswordSuccessMessage,
    ),
    duration: const Duration(seconds: 5),
  ));
}

showLostPasswordEmailErrorSendingSnackBar(BuildContext context, String error) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      "${Localization.of(context).forgotPasswordErrorMessage} ($error)",
      style: TextStyle(
        color: Colors.red[600],
      ),
    ),
    duration: const Duration(seconds: 5),
  ));
}

