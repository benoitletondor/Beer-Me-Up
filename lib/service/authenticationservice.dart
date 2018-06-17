import 'dart:async';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beer_me_up/main.dart';

abstract class AuthenticationService {
  static final AuthenticationService instance
    = _AuthenticationServiceImpl(FirebaseAuth.instance, BeerMeUpApp.analytics);

  Future<FirebaseUser> signInWithGoogle();
  Future<FirebaseUser> signInWithFacebook();
  Future<FirebaseUser> signInWithAccount(String email, String password);
  Future<FirebaseUser> signUpWithAccount(String email, String password);
  Future<void> sendResetPasswordEmail(String email);

  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();

  Future<bool> hasUserSeenOnboarding();
  Future<void> setUserSawOnboarding();
  Future<void> resetUserSawOnboarding();

  Future<bool> hapticFeedbackEnabled();
  Future<void> setHapticFeedbackEnabled(bool enabled);

  Future<bool> analyticsEnabled();
  Future<void> setAnalyticsEnabled(bool enabled);
}

class AuthCancelledException implements Exception {
  final String message;

  AuthCancelledException(this.message);

  @override
  String toString() => message;
}

const String _USER_SAW_ONBOARDING_KEY = "sawOnboarding";
const String _ANALYTICS_ENABLED_KEY = "analyticsEnabled";
const String _HAPTIC_FEEDBACK_ENABLED_KEY = "hapticFeedbackEnabled";

class _AuthenticationServiceImpl implements AuthenticationService {

  final FirebaseAuth _firebaseAuth;
  final FirebaseAnalytics _analytics;

  _AuthenticationServiceImpl(this._firebaseAuth, this._analytics);

  @override
  Future<FirebaseUser> getCurrentUser() async {
    return await _firebaseAuth.currentUser().timeout(
      const Duration(seconds: 5),
      onTimeout: () => Future.error(Exception("Unable to get your user data. Please check your network connection."))
    );
  }

  @override
  Future<FirebaseUser> signInWithAccount(String email, String password) async {
    if( email == null || email.isEmpty ) {
      throw Exception("Email is empty");
    }

    if( password == null || password.isEmpty ){
      throw Exception("Password is empty");
    }

    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).timeout(
        const Duration(seconds: 5),
        onTimeout: () => Future.error(Exception("Unable to sign in. Please check your network connection."))
      );
      if( user == null ) {
        throw Exception("Unable to sign-in");
      }

      assert(user.email != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      _analytics.setUserId(user.uid);

      return user;
    } on PlatformException catch (e) {
      if (e.details != null && e.details is String) {
        throw Exception(e.details);
      }

      throw e;
    }
  }

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    GoogleSignInAccount googleUser = await _googleSignIn.signInSilently();
    if( googleUser == null ) {
      googleUser = await _googleSignIn.signIn();
    }

    if( googleUser == null ) {
      throw AuthCancelledException("User cancelled");
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final FirebaseUser user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () => Future.error(Exception("Unable to sign in. Please check your network connection."))
    );

    if( user == null ) {
      throw Exception("Unable to sign-in with Google");
    }

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    _analytics.setUserId(user.uid);

    return user;
  }

  @override
  Future<FirebaseUser> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    FacebookLoginResult result = await facebookLogin.logInWithReadPermissions(['email']);

    // ignore: missing_enum_constant_in_switch
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        throw AuthCancelledException("User cancelled");
      case FacebookLoginStatus.error:
        throw Exception("Error occurred: ${result.errorMessage}");
    }

    if( result.status != FacebookLoginStatus.loggedIn ) {
      throw Exception("Unknown status: ${result.status}");
    }

    final token = result.accessToken.token;
    final FirebaseUser user = await _firebaseAuth.signInWithFacebook(
      accessToken: token,
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () => Future.error(Exception("Unable to sign in. Please check your network connection."))
    );

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    _analytics.setUserId(user.uid);

    return user;
  }

  @override
  Future<FirebaseUser> signUpWithAccount(String email, String password) async {
    if( email == null || email.isEmpty ) {
      throw AuthCancelledException("Email is empty");
    }

    if( password == null || password.isEmpty ){
      throw AuthCancelledException("Password is empty");
    }

    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).timeout(
        const Duration(seconds: 5),
        onTimeout: () => Future.error(Exception("Unable to sign in. Please check your network connection."))
      );

      if( user == null ) {
        throw Exception("Unable to sign-up");
      }

      assert(user.email != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      _analytics.setUserId(user.uid);

      return user;
    } on PlatformException catch (e) {
      if( e.details != null && e.details is String ) {
        throw Exception(e.details);
      }

      throw e;
    }
  }

  @override
  signOut() async {
    await _firebaseAuth.signOut();
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

  @override
  Future<void> resetUserSawOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_USER_SAW_ONBOARDING_KEY);
  }

  @override
  Future<void> sendResetPasswordEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email).timeout(
      const Duration(seconds: 5),
      onTimeout: () => Future.error(Exception("Unable to send reset password request. Please check your network connection."))
    );
  }

  @override
  Future<bool> analyticsEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if( !prefs.getKeys().contains(_ANALYTICS_ENABLED_KEY) ) {
      return true;
    }

    return prefs.getBool(_ANALYTICS_ENABLED_KEY);
  }

  @override
  Future<bool> hapticFeedbackEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if( !prefs.getKeys().contains(_HAPTIC_FEEDBACK_ENABLED_KEY) ) {
      return true;
    }

    return prefs.getBool(_HAPTIC_FEEDBACK_ENABLED_KEY);
  }

  @override
  Future<void> setAnalyticsEnabled(bool enabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_ANALYTICS_ENABLED_KEY, enabled);
  }

  @override
  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_HAPTIC_FEEDBACK_ENABLED_KEY, enabled);
  }

}