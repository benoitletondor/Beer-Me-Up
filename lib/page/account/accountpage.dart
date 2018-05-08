import 'package:meta/meta.dart';

import 'package:flutter/material.dart';

import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';
import 'package:beer_me_up/common/widget/loadingwidget.dart';

import 'model.dart';
import 'intent.dart';
import 'state.dart';

const String ACCOUNT_PAGE_ROUTE = "/account";

class AccountPage extends StatefulWidget {
  final AccountIntent intent;
  final AccountViewModel model;

  AccountPage._({
    Key key,
    @required this.intent,
    @required this.model}) : super(key: key);

  factory AccountPage({Key key,
    AccountIntent intent,
    AccountViewModel model,
    AuthenticationService userService}) {

    final _intent = intent ?? AccountIntent();
    final _model = model ?? AccountViewModel(
      userService ?? AuthenticationService.instance,
      _intent.logout,
    );

    return AccountPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<StatefulWidget> createState() => _AccountPageState(intent: intent, model: model);
}

class _AccountPageState extends ViewState<AccountPage, AccountViewModel, AccountIntent, AccountState> {

  _AccountPageState({
    @required AccountIntent intent,
    @required AccountViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<AccountState> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return snapshot.data.join(
          (loading) => _buildLoadingScreen(),
          (account) => _buildAccountScreen(account.email, account.name),
        );
      },
    );
  }

  Widget _buildAccountScreen(String email, String name) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Offstage(
              offstage: name == null,
              child: Column(
                children: <Widget>[
                  Text(name ?? ""),
                  Padding(padding: EdgeInsets.only(top: 15.0)),
                ],
              ),
            ),
            Text(email),
            Padding(padding: EdgeInsets.only(top: 15.0)),
            RaisedButton(
              child: Text('Logout'),
              onPressed: intent.logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: LoadingWidget(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        "Account",
        style: TextStyle(
          fontFamily: "Google Sans",
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

}