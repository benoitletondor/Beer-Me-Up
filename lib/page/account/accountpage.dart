import 'package:meta/meta.dart';

import 'package:flutter/material.dart';

import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/common/mvi/viewstate.dart';

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

    final _intent = intent ?? new AccountIntent();
    final _model = model ?? new AccountViewModel(
      userService ?? AuthenticationService.instance,
      _intent.logout,
    );

    return new AccountPage._(key: key, intent: _intent, model: _model);
  }

  @override
  State<StatefulWidget> createState() => new _AccountPageState(intent: intent, model: model);
}

class _AccountPageState extends ViewState<AccountPage, AccountViewModel, AccountIntent, AccountState> {

  _AccountPageState({
    @required AccountIntent intent,
    @required AccountViewModel model
  }) : super(intent, model);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<AccountState> snapshot) {
        if (!snapshot.hasData) {
          return new Container();
        }

        return snapshot.data.join(
          (account) => _buildAccountScreen(),
          () => new Container(),
        );
      },
    );
  }

  Widget _buildAccountScreen() {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Account"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              child: const Text('Logout'),
              onPressed: intent.logout,
            ),
          ],
        ),
      ),
    );
  }

}