import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user.dart';

class GoogleAuthenRepository {
  GoogleAuthenRepository({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  final auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  bool isWeb = kIsWeb;
  Future<auth.UserCredential> logInWithGoogle() async {
    // firebaseAuth = firebase_auth.FirebaseAuth.instance;
    try {
      late final auth.AuthCredential credential;
      if (isWeb) {
        final googleProvider = auth.GoogleAuthProvider();
        final userCredential = await firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      return await firebaseAuth.signInWithCredential(credential);
    } on auth.FirebaseAuthException catch (e) {
      print(e);
      throw Exception('LoginWith Google has error');
    } catch (_) {
      throw Exception('LoginWith Google has error');
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw Exception('LogOut error');
    }
  }

  Future<User?> getUser() async {
    final firebaseUser = await auth.FirebaseAuth.instance.currentUser;
    final User currentUser = User(
      id: (firebaseUser?.uid) ?? '',
      email: firebaseUser?.email,
      name: firebaseUser?.displayName,
      photo: firebaseUser?.photoURL,
    );
    return currentUser;
  }
}
