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
  Stream<AccountState> bind(BuildContext context) {
    _loadData();

    return super.bind(context);
  }

  @override
  AccountState initialState() => AccountState.loading();

  _loadData() async {
    setState(AccountState.loading());

    final user = await _authService.getCurrentUser();

    setState(AccountState.account(user.email, user.displayName));
  }

  _logout(Null event) async {
    await _authService.signOut();
    await _authService.resetUserSawOnboarding(); // FIXME remove that later
    popUntil(ModalRoute.withName('/'));
    pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => HomePage(),
        settings: RouteSettings(
          name: "/",
          isInitialRoute: true
        ),
      )
    );
  }
}