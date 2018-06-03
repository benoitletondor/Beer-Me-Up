import 'package:flutter/material.dart';

import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class LoginIntent {
  final VoidStreamCallback showSignIn;
  final VoidStreamCallback showSignUp;
  final ValueStreamCallback<LoginFormData> signUp;
  final ValueStreamCallback<LoginFormData> signIn;
  final VoidStreamCallback signInWithGoogle;
  final VoidStreamCallback signUpWithGoogle;
  final VoidStreamCallback signInWithFacebook;
  final VoidStreamCallback signUpWithFacebook;
  final ValueStreamCallback<BuildContext> forgotPassword;
  final VoidStreamCallback signUpEmailInputChanged;
  final VoidStreamCallback signUpPasswordInputChanged;
  final VoidStreamCallback signInEmailInputChanged;
  final VoidStreamCallback signInPasswordInputChanged;
  final VoidStreamCallback privacyPolicyClicked;

  LoginIntent({
    final VoidStreamCallback showSignInIntent,
    final VoidStreamCallback showSignUpIntent,
    ValueStreamCallback<LoginFormData> signUpIntent,
    ValueStreamCallback<LoginFormData> signInIntent,
    VoidStreamCallback signInWithGoogleIntent,
    VoidStreamCallback signUpWithGoogleIntent,
    VoidStreamCallback signInWithFacebookIntent,
    VoidStreamCallback signUpWithFacebookIntent,
    ValueStreamCallback<BuildContext> forgotPasswordIntent,
    VoidStreamCallback signUpEmailInputChangedIntent,
    VoidStreamCallback signUpPasswordInputChangedIntent,
    VoidStreamCallback signInEmailInputChangedIntent,
    VoidStreamCallback signInPasswordInputChangedIntent,
    VoidStreamCallback privacyPolicyClickedIntent,
  }) :
    this.showSignIn = showSignInIntent ?? VoidStreamCallback(),
    this.showSignUp = showSignUpIntent ?? VoidStreamCallback(),
    this.signUp = signUpIntent ?? ValueStreamCallback<LoginFormData>(),
    this.signIn = signInIntent ?? ValueStreamCallback<LoginFormData>(),
    this.signInWithGoogle = signInWithGoogleIntent ?? VoidStreamCallback(),
    this.signUpWithGoogle = signUpWithGoogleIntent ?? VoidStreamCallback(),
    this.signInWithFacebook = signInWithFacebookIntent ?? VoidStreamCallback(),
    this.signUpWithFacebook = signUpWithFacebookIntent ?? VoidStreamCallback(),
    this.forgotPassword = forgotPasswordIntent ?? ValueStreamCallback<BuildContext>(),
    this.signUpEmailInputChanged = signUpEmailInputChangedIntent ?? VoidStreamCallback(),
    this.signUpPasswordInputChanged = signUpPasswordInputChangedIntent ?? VoidStreamCallback(),
    this.signInEmailInputChanged = signInEmailInputChangedIntent ?? VoidStreamCallback(),
    this.signInPasswordInputChanged = signInPasswordInputChangedIntent ?? VoidStreamCallback(),
    this.privacyPolicyClicked = privacyPolicyClickedIntent ?? VoidStreamCallback();
}

class LoginFormData {
  final String email;
  final String password;

  LoginFormData(
      this.email,
      this.password,
  );
}