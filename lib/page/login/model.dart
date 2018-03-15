import 'dart:async';

import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'state.dart';
import 'package:beer_me_up/service/authenticationservice.dart';

import 'intent.dart';

class LoginViewModel extends BaseViewModel<LoginState> {
  final AuthenticationService _authService;

  LoginViewModel(
      this._authService,
      Stream<Null> onShowSignInButtonPressed,
      Stream<Null> onShowSignUpButtonPressed,
      Stream<LoginFormData> onSignInButtonPressed,
      Stream<LoginFormData> onSignUpButtonPressed,
      Stream<Null> onSignInWithGoogleButtonPressed,
      Stream<Null> onSignUpWithGoogleButtonPressed) {

    onSignInWithGoogleButtonPressed.listen(_signInWithGoogle);
    onSignUpWithGoogleButtonPressed.listen(_signUpWithGoogle);
  }

  @override
  LoginState initialState() => new LoginState.signUp();

  _signInWithGoogle(Null event) async {
    setState(new LoginState.authenticating());

    try {
      await _authService.signInWithGoogle();
      pushReplacementNamed("/");
    } catch (e) {
      setState(new LoginState.signInError(e.toString()));
    }
  }

  _signUpWithGoogle(Null event) async {
    setState(new LoginState.authenticating());

    try {
      await _authService.signInWithGoogle();
      pushReplacementNamed("/");
    } catch (e) {
      setState(new LoginState.signUpError(e.toString()));
    }
  }
}