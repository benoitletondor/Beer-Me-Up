import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationService {
  static final AuthenticationService instance = new _AuthenticationServiceImpl();

  Future<FirebaseUser> signInWithGoogle();
  Future<FirebaseUser> signInWithFacebook();
  Future<FirebaseUser> signInWithAccount(String email, String password);
  Future<FirebaseUser> signUpWithAccount(String email, String password);

  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();

  Future<bool> hasUserSeenOnboarding();
  Future<void> setUserSawOnboarding();
}

const String _USER_SAW_ONBOARDING_KEY = "sawOnboarding";

class _AuthenticationServiceImpl implements AuthenticationService {

  @override
  Future<FirebaseUser> getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  @override
  Future<FirebaseUser> signInWithAccount(String email, String password) async {
    if( email == null || email.isEmpty ) {
      throw new Exception("Email is empty");
    }

    if( password == null || password.isEmpty ){
      throw new Exception("Password is empty");
    }

    final user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    if( user == null ) {
      throw new Exception("Unable to sign-in");
    }

    assert(user.email != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    return user;
  }

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    GoogleSignInAccount googleUser = await _googleSignIn.signInSilently();
    if( googleUser == null ) {
      googleUser = await _googleSignIn.signIn();
    }

    if( googleUser == null ) {
      throw new Exception("User cancelled");
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final FirebaseUser user = await FirebaseAuth.instance.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    if( user == null ) {
      throw new Exception("Unable to sign-in with Google");
    }

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    return user;
  }

  @override
  Future<FirebaseUser> signInWithFacebook() async {
    final facebookLogin = new FacebookLogin();
    FacebookLoginResult result = await facebookLogin.logInWithReadPermissions(['email']);

    // ignore: missing_enum_constant_in_switch
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        throw new Exception("User cancelled");
      case FacebookLoginStatus.error:
        throw new Exception("Error occurred: ${result.errorMessage}");
    }

    if( result.status != FacebookLoginStatus.loggedIn ) {
      throw new Exception("Unknown status: ${result.status}");
    }

    final token = result.accessToken.token;
    final FirebaseUser user = await FirebaseAuth.instance.signInWithFacebook(
      accessToken: token,
    );

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    return user;
  }

  @override
  Future<FirebaseUser> signUpWithAccount(String email, String password) async {
    if( email == null || email.isEmpty ) {
      throw new Exception("Email is empty");
    }

    if( password == null || password.isEmpty ){
      throw new Exception("Password is empty");
    }

    final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    if( user == null ) {
      throw new Exception("Unable to sign-up");
    }

    assert(user.email != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    return user;
  }

  @override
  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<bool> hasUserSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_USER_SAW_ONBOARDING_KEY);
  }

  @override
  Future<void> setUserSawOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_USER_SAW_ONBOARDING_KEY, true);
  }

}