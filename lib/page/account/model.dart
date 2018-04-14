import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/page/home/homepage.dart';

import 'state.dart';

class AccountViewModel extends BaseViewModel<AccountState> {
  final AuthenticationService _authService;

  AccountViewModel(
      this._authService,
      Stream<Null> onLogoutButtonPressed) {

    onLogoutButtonPressed.listen(_logout);
  }

  @override
  AccountState initialState() => new AccountState.account();

  _logout(Null event) async {
    await _authService.signOut();
    popUntil(ModalRoute.withName('/'));
    pushReplacement(
      new MaterialPageRoute(
        builder: (BuildContext context) => new HomePage(),
        settings: RouteSettings(
          name: "/",
          isInitialRoute: true
        ),
      )
    );
  }
}