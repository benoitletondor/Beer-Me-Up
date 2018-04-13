import 'package:flutter/material.dart';
import 'dart:async';

import 'package:beer_me_up/common/exceptionprint.dart';
import 'package:beer_me_up/common/mvi/viewmodel.dart';
import 'package:beer_me_up/page/login/lostpassword/lostpassworddialog.dart';
import 'package:beer_me_up/service/authenticationservice.dart';

import 'state.dart';
import 'intent.dart';

class LoginViewModel extends BaseViewModel<LoginState> {
  final AuthenticationService _authService;

  LoginViewModel(
      this._authService,
      Stream<Null> onShowSignInButtonPressed,
      Stream<Null> onShowSignUpButtonPressed,
      Stream<LoginFormData> onSignUpButtonPressed,
      Stream<LoginFormData> onSignInButtonPressed,
      Stream<Null> onSignInWithGoogleButtonPressed,
      Stream<Null> onSignUpWithGoogleButtonPressed,
      Stream<Null> onSignInWithFacebookButtonPressed,
      Stream<Null> onSignUpWithFacebookButtonPressed,
      Stream<BuildContext> onForgotPasswordButtonPressed,
      Stream<Null> onSignUpEmailInputChanged,
      Stream<Null> onSignUpPasswordInputChanged,
      Stream<Null> onSignInEmailInputChanged,
      Stream<Null> onSignInPasswordInputChanged,) {

    onShowSignInButtonPressed.listen(_showSignIn);
    onShowSignUpButtonPressed.listen(_showSignUp);

    onSignUpButtonPressed.listen(_signUp);
    onSignUpEmailInputChanged.listen(_hideSignUpError);
    onSignUpPasswordInputChanged.listen(_hideSignUpError);

    onSignInButtonPressed.listen(_signIn);
    onSignInEmailInputChanged.listen(_hideSignInError);
    onSignInPasswordInputChanged.listen(_hideSignInError);

    onSignInWithGoogleButtonPressed.listen(_signInWithGoogle);
    onSignUpWithGoogleButtonPressed.listen(_signUpWithGoogle);

    onSignInWithFacebookButtonPressed.listen(_signInWithFacebook);
    onSignUpWithFacebookButtonPressed.listen(_signUpWithFacebook);

    onForgotPasswordButtonPressed.listen(_showLostPasswordDialog);
  }

  @override
  LoginState initialState() => new LoginState.signUp();

  _signInWithGoogle(Null event) async {
    setState(new LoginState.authenticating());

    try {
      await _authService.signInWithGoogle();
      pushReplacementNamed("/");
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error while _signInWithGoogle");
      setState(new LoginState.signInError(e.toString()));
    }
  }

  _signUpWithGoogle(Null event) async {
    setState(new LoginState.authenticating());

    try {
      await _authService.signInWithGoogle();
      pushReplacementNamed("/");
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error while _signUpWithGoogle");
      setState(new LoginState.signUpError(e.toString()));
    }
  }

  _signInWithFacebook(Null event) async {
    setState(new LoginState.authenticating());

    try {
      await _authService.signInWithFacebook();
      pushReplacementNamed("/");
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error while _signInWithFacebook");
      setState(new LoginState.signInError(e.toString()));
    }
  }

  _signUpWithFacebook(Null event) async {
    setState(new LoginState.authenticating());

    try {
      await _authService.signInWithFacebook();
      pushReplacementNamed("/");
    } catch (e, stackTrace) {
      printException(e, stackTrace, "Error while _signUpWithFacebook");
      setState(new LoginState.signUpError(e.toString()));
    }
  }

  _showLostPasswordDialog(BuildContext context) async {
    final email = await showLostPasswordDialog(getBuildContext());
    if( email != null ) {
      await _authService.sendResetPasswordEmail(email);
      showLostPasswordEmailSentSnackBar(context);
    }
  }

  _showSignIn(Null event) async {
    setState(new LoginState.signIn());
  }

  _showSignUp(Null event) async {
    setState(new LoginState.signUp());
  }

  _signUp(LoginFormData formData) async {
    if( formData.email.trim().isEmpty ) {
      setState(new LoginState.signUpError("Please provide an email"));
      return;
    }

    if( formData.password.trim().isEmpty ) {
      setState(new LoginState.signUpError("Please provide a password"));
      return;
    }

    setState(new LoginState.authenticating());

    try {
      await _authService.signUpWithAccount(formData.email, formData.password);
      pushReplacementNamed("/");
    }
    catch(e, stackTrace) {
      printException(e, stackTrace, "Error while creating an account");
      setState(new LoginState.signUpError(e.toString()));
    }
  }

  _signIn(LoginFormData formData) async {
    if( formData.email.trim().isEmpty ) {
      setState(new LoginState.signInError("Please provide an email"));
      return;
    }

    if( formData.password.trim().isEmpty ) {
      setState(new LoginState.signInError("Please provide a password"));
      return;
    }

    setState(new LoginState.authenticating());

    try {
      await _authService.signInWithAccount(formData.email, formData.password);
      pushReplacementNamed("/");
    }
    catch(e, stackTrace) {
      printException(e, stackTrace, "Error while logging-in with an account");
      setState(new LoginState.signInError(e.toString()));
    }
  }

  _hideSignInError(Null event) async {
    setState(new LoginState.signIn());
  }

  _hideSignUpError(Null event) async {
    setState(new LoginState.signUp());
  }
}