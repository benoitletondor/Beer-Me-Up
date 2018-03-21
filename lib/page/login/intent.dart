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

  LoginIntent({
    final VoidStreamCallback showSignInIntent,
    final VoidStreamCallback showSignUpIntent,
    ValueStreamCallback<LoginFormData> signUpIntent,
    ValueStreamCallback<LoginFormData> signInIntent,
    VoidStreamCallback signInWithGoogleIntent,
    VoidStreamCallback signUpWithGoogleIntent,
    VoidStreamCallback signInWithFacebookIntent,
    VoidStreamCallback signUpWithFacebookIntent,
  }) :
    this.showSignIn = showSignInIntent ?? new VoidStreamCallback(),
    this.showSignUp = showSignUpIntent ?? new VoidStreamCallback(),
    this.signUp = signUpIntent ?? new ValueStreamCallback<LoginFormData>(),
    this.signIn = signInIntent ?? new ValueStreamCallback<LoginFormData>(),
    this.signInWithGoogle = signInWithGoogleIntent ?? new VoidStreamCallback(),
    this.signUpWithGoogle = signUpWithGoogleIntent ?? new VoidStreamCallback(),
    this.signInWithFacebook = signInWithFacebookIntent ?? new VoidStreamCallback(),
    this.signUpWithFacebook = signUpWithFacebookIntent ?? new VoidStreamCallback();
}

class LoginFormData {
  final String email;
  final String password;

  LoginFormData(
      this.email,
      this.password,
  );
}