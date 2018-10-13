import 'dart:async';
import 'package:flutter/material.dart';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/page/home/homepage.dart';
import 'package:beer_me_up/page/tos/tospage.dart';

import 'state.dart';

class SettingsViewModel extends BaseViewModel<SettingsState> {
  final AuthenticationService _authService;
  String email;
  bool hapticFeedbackEnabled = true;
  bool analyticsEnabled = true;

  SettingsViewModel(
      this._authService,
      Stream<Null> onLogoutButtonPressed,
      Stream<bool> onHapticFeedbackSettingChanged,
      Stream<bool> onAnalyticsSettingChanged,
      Stream<Null> onToSButtonPressed,) {

    onLogoutButtonPressed.listen(_logout);
    onHapticFeedbackSettingChanged.listen(_hapticFeedbackSettingChanged);
    onAnalyticsSettingChanged.listen(_analyticsSettingChanged);
    onToSButtonPressed.listen(_showToS);
  }

  @override
  Stream<SettingsState> bind(BuildContext context) {
    _loadData();

    return super.bind(context);
  }

  @override
  SettingsState initialState() => SettingsState.loading();

  _loadData() async {
    setState(SettingsState.loading());

    final user = await _authService.getCurrentUser();
    email = user.email;
    hapticFeedbackEnabled = await _authService.hapticFeedbackEnabled();
    analyticsEnabled = await _authService.analyticsEnabled();

    setState(SettingsState.load(email, hapticFeedbackEnabled, analyticsEnabled));
  }

  _logout(Null event) async {
    await _authService.signOut();

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

  _hapticFeedbackSettingChanged(bool hapticFeedbackEnabled) async {
    _authService.setHapticFeedbackEnabled(hapticFeedbackEnabled);

    this.hapticFeedbackEnabled = hapticFeedbackEnabled;
    setState(SettingsState.load(email, hapticFeedbackEnabled, analyticsEnabled));
  }

  _analyticsSettingChanged(bool analyticsEnabled) async {
    _authService.setAnalyticsEnabled(analyticsEnabled);

    this.analyticsEnabled = analyticsEnabled;
    setState(SettingsState.load(email, hapticFeedbackEnabled, analyticsEnabled));
  }

  _showToS(Null event) async {
    pushNamed(TOS_PAGE_ROUTE);
  }
}