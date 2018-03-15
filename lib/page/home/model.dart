import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'state.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/page/onboarding/onboardingpage.dart';
import 'package:beer_me_up/page/login/loginpage.dart';

class HomeViewModel extends BaseViewModel<HomeState> {
  final AuthenticationService _authService;
  final UserDataService _dataService;

  HomeViewModel(
      this._authService,
      this._dataService,
      Stream<Null> onProfileTabButtonPressed,
      Stream<Null> onHistoryTabButtonPressed,
      Stream<Null> onErrorRetryButtonPressed,
      Stream<Null> onBeerCheckInButtonPressed,) {

    onProfileTabButtonPressed.listen(_showProfileTab);
    onHistoryTabButtonPressed.listen(_showHistoryTab);
    onErrorRetryButtonPressed.listen(_retryLoading);
    onBeerCheckInButtonPressed.listen(_beerCheckIn);
  }

  @override
  HomeState initialState() => new HomeState.authenticating();

  @override
  Stream<HomeState> bind(BuildContext context) {
    _loadData();

    return super.bind(context);
  }

  _loadData() async {
    try {
      setState(new HomeState.authenticating());

      bool sawOnboarding = await _authService.hasUserSeenOnboarding();
      if( sawOnboarding == null || !sawOnboarding ) {
        pushReplacementNamed(ONBOARDING_PAGE_ROUTE);
        return;
      }

      final currentUser = await _authService.getCurrentUser();
      if( currentUser == null ) {
        pushReplacementNamed(LOGIN_PAGE_ROUTE);
        return;
      }

      debugPrint("User logged in $currentUser");

      setState(new HomeState.loading());

      await _dataService.initDB(currentUser);

      setState(new HomeState.tabProfile());
    } catch (e) {
      debugPrint(e.toString());

      setState(new HomeState.error(e.toString()));
    }
  }

  _showProfileTab(Null event) {
    setState(new HomeState.tabProfile());
  }

  _showHistoryTab(Null event) {
    setState(new HomeState.tabHistory());
  }

  _retryLoading(Null event) {
    _loadData();
  }

  _beerCheckIn(Null event) {
    // TODO
  }
}