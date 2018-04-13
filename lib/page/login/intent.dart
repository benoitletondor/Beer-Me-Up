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
  }) :
    this.showSignIn = showSignInIntent ?? new VoidStreamCallback(),
    this.showSignUp = showSignUpIntent ?? new VoidStreamCallback(),
    this.signUp = signUpIntent ?? new ValueStreamCallback<LoginFormData>(),
    this.signIn = signInIntent ?? new ValueStreamCallback<LoginFormData>(),
    this.signInWithGoogle = signInWithGoogleIntent ?? new VoidStreamCallback(),
    this.signUpWithGoogle = signUpWithGoogleIntent ?? new VoidStreamCallback(),
    this.signInWithFacebook = signInWithFacebookIntent ?? new VoidStreamCallback(),
    this.signUpWithFacebook = signUpWithFacebookIntent ?? new VoidStreamCallback(),
    this.forgotPassword = forgotPasswordIntent ?? new ValueStreamCallback<BuildContext>(),
    this.signUpEmailInputChanged = signUpEmailInputChangedIntent ?? new VoidStreamCallback(),
    this.signUpPasswordInputChanged = signUpPasswordInputChangedIntent ?? new VoidStreamCallback(),
    this.signInEmailInputChanged = signInEmailInputChangedIntent ?? new VoidStreamCallback(),
    this.signInPasswordInputChanged = signInPasswordInputChangedIntent ?? new VoidStreamCallback();
}

class LoginFormData {
  final String email;
  final String password;

  LoginFormData(
      this.email,
      this.password,
  );
}