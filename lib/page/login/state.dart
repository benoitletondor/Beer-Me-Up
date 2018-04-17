import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

class LoginState extends Union5Impl<
    LoginStateSignUp,
    LoginStateSignIn,
    LoginStateAuthenticating,
    LoginStateSignUpError,
    LoginStateSignInError> {

  static final Quintet<
      LoginStateSignUp,
      LoginStateSignIn,
      LoginStateAuthenticating,
      LoginStateSignUpError,
      LoginStateSignInError> factory = const Quintet<
      LoginStateSignUp,
      LoginStateSignIn,
      LoginStateAuthenticating,
      LoginStateSignUpError,
      LoginStateSignInError>();

  LoginState._(Union5<
      LoginStateSignUp,
      LoginStateSignIn,
      LoginStateAuthenticating,
      LoginStateSignUpError,
      LoginStateSignInError> union) : super(union);

  factory LoginState.signUp() => new LoginState._(factory.first(new LoginStateSignUp()));
  factory LoginState.signIn() => new LoginState._(factory.second(new LoginStateSignIn()));
  factory LoginState.authenticating() => new LoginState._(factory.third(new LoginStateAuthenticating()));
  factory LoginState.signUpError(String error) => new LoginState._(factory.fourth(new LoginStateSignUpError(error)));
  factory LoginState.signInError(String error) => new LoginState._(factory.fifth(new LoginStateSignInError(error)));
}

class LoginStateSignUp extends State {}
class LoginStateSignIn extends State {}
class LoginStateAuthenticating extends State {}

class LoginStateSignUpError extends State {
  final String error;

  LoginStateSignUpError(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is LoginStateSignUpError &&
        runtimeType == other.runtimeType &&
        error == other.error;

  @override
  int get hashCode =>
      super.hashCode ^
      error.hashCode;
}

class LoginStateSignInError extends State {
  final String error;

  LoginStateSignInError(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LoginStateSignInError &&
              runtimeType == other.runtimeType &&
              error == other.error;

  @override
  int get hashCode =>
      super.hashCode ^
      error.hashCode;
}