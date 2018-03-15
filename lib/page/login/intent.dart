import 'package:flutter_stream_friends/flutter_stream_friends.dart';

class LoginIntent {
  final VoidStreamCallback showSignIn;
  final VoidStreamCallback showSignUp;
  final ValueStreamCallback<LoginFormData> signUp;
  final ValueStreamCallback<LoginFormData> signIn;
  final VoidStreamCallback signInWithGoogle;
  final VoidStreamCallback signUpWithGoogle;

  LoginIntent({
    final VoidStreamCallback showSignInIntent,
    final VoidStreamCallback showSignUpIntent,
    ValueStreamCallback<LoginFormData> signUpIntent,
    ValueStreamCallback<LoginFormData> signInIntent,
    VoidStreamCallback signInWithGoogleIntent,
    VoidStreamCallback signUpWithGoogleIntent,
  }) :
    this.showSignIn = showSignInIntent ?? new VoidStreamCallback(),
    this.showSignUp = showSignUpIntent ?? new VoidStreamCallback(),
    this.signUp = signUpIntent ?? new ValueStreamCallback<LoginFormData>(),
    this.signIn = signInIntent ?? new ValueStreamCallback<LoginFormData>(),
    this.signInWithGoogle = signInWithGoogleIntent ?? new VoidStreamCallback(),
    this.signUpWithGoogle = signUpWithGoogleIntent ?? new VoidStreamCallback();
}

class LoginFormData {
  final String email;
  final String password;

  LoginFormData(
      this.email,
      this.password,
  );
}