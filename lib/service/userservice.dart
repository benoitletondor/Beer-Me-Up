import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class UserService {
  static UserService instance = new _UserServiceImpl();

  Future<FirebaseUser> signInWithGoogle();
  Future<FirebaseUser> signInWithAccount(String email, String password);
  Future<FirebaseUser> signUpWithAccount(String email, String password);

  Future<FirebaseUser> getCurrentUser();
}

class _UserServiceImpl extends UserService {

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

}