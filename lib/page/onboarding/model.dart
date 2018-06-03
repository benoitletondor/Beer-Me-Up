import 'dart:async';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'state.dart';
import 'package:beer_me_up/service/authenticationservice.dart';
import 'package:beer_me_up/main.dart';

class OnboardingViewModel extends BaseViewModel<OnboardingState> {
  final AuthenticationService _authService;

  OnboardingViewModel(
      this._authService,
      Stream<Null> onFinishButtonPressed,) {

    onFinishButtonPressed.listen(_finish);
  }

  @override
  OnboardingState initialState() => OnboardingState.onboarding();

  _finish(Null event) async {
    await _authService.setUserSawOnboarding();
    BeerMeUpApp.analytics.logTutorialComplete();

    pushReplacementNamed("/");
  }
}