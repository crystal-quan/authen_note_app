
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user.dart';

class GoogleAuthenRepository {
  GoogleAuthenRepository({
    required this.firebaseAuth,
    required this.googleSignIn,
  });
  late firebase_auth.FirebaseAuth firebaseAuth;
  late GoogleSignIn googleSignIn;
  bool isWeb = kIsWeb;
  Future<firebase_auth.UserCredential> logInWithGoogle() async {
    // firebaseAuth = firebase_auth.FirebaseAuth.instance;
    try {
      late final firebase_auth.AuthCredential credential;
      if (isWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      return await firebaseAuth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
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
    late User currentUser;
    firebase_auth.FirebaseAuth.instance
        .authStateChanges()
        .listen((firebase_auth.User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        final User modelUser = User(
            id: user.uid,
            email: user.email,
            name: user.displayName,
            photo: user.photoURL);
        currentUser = modelUser;
        print('User is signed in!');
      }
    });
    return currentUser;
  }
}
