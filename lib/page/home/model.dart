import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/common/exceptionprint.dart';
import 'state.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/service/userdataservice.dart';
import 'package:beer_me_up/page/onboarding/onboardingpage.dart';
import 'package:beer_me_up/page/login/loginpage.dart';
import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/page/checkin/checkinpage.dart';
import 'package:beer_me_up/page/settings/settingspage.dart';

class HomeViewModel extends BaseViewModel<HomeState> {
  final AuthenticationService _authService;
  final UserDataService _dataService;

  HomeViewModel(
      this._authService,
      this._dataService,
      Stream<Null> onProfileTabButtonPressed,
      Stream<Null> onHistoryTabButtonPressed,
      Stream<Null> onErrorRetryButtonPressed,
      Stream<Null> onBeerCheckInButtonPressed,
      Stream<Null> onSettingsButtonPressed,) {

    onProfileTabButtonPressed.listen(_showProfileTab);
    onHistoryTabButtonPressed.listen(_showHistoryTab);
    onErrorRetryButtonPressed.listen(_retryLoading);
    onBeerCheckInButtonPressed.listen(_beerCheckIn);
    onSettingsButtonPressed.listen(_showSettingsPage);
  }

  @override
  HomeState initialState() => HomeState.authenticating();

  @override
  Stream<HomeState> bind(BuildContext context) {
    _loadData();

    return super.bind(context);
  }

  _loadData() async {
    try {
      setState(HomeState.authenticating());

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

      setState(HomeState.loading());

      await _dataService.initDB(currentUser);

      setState(HomeState.tabProfile());
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error loading home");

      setState(HomeState.error(e.toString()));
    }
  }

  _showProfileTab(Null event) {
    setState(HomeState.tabProfile());
  }

  _showHistoryTab(Null event) {
    setState(HomeState.tabHistory());
  }

  _retryLoading(Null event) {
    _loadData();
  }

  _beerCheckIn(Null event) async {
    final Map returnValue = await pushNamed(CHECK_IN_PAGE_ROUTE);

    if( returnValue != null ) {
      final Beer selectedBeer = returnValue[SELECTED_BEER_KEY];
      final CheckInQuantity selectedQuantity = returnValue[SELECTED_QUANTITY_KEY];
      final DateTime checkInDate = returnValue[SELECTED_DATE_KEY];
      final int checkInPoints = returnValue[POINTS_KEY];

      try {
        await _dataService.saveBeerCheckIn(CheckIn(
          creationDate: new DateTime.now(),
          date: checkInDate,
          beer: selectedBeer,
          quantity: selectedQuantity,
          points: checkInPoints,
        ));
      } catch ( e, stackTrace) {
        printException(e, stackTrace, "Error saving checkin");
      }
    }
  }

  _showSettingsPage(Null event) async {
    pushNamed(SETTINGS_PAGE_ROUTE);
  }
}