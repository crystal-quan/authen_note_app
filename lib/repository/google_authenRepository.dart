import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

import '../model/note_model.dart';
import '../model/user.dart';

class GoogleAuthenRepository {
  GoogleAuthenRepository({
    required this.firebaseAuth,
    required this.googleSignIn,
  });
  final Box<User> userBox = Hive.box<User>('users');
  final auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  bool isWeb = kIsWeb;
  Future<User> logInWithGoogle() async {
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
      final credentialUser =
          await firebaseAuth.signInWithCredential(credential);
      User currentUser = User(
          id: credentialUser.user?.uid ?? '',
          email: credentialUser.user?.email,
          name: credentialUser.user?.displayName,
          photo: credentialUser.user?.photoURL);
      await userBox.put('userKey', currentUser);
      return currentUser;
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
      await Hive.box<Note>('notes').clear();
      await Hive.box<User>('users').clear();
    } catch (_) {
      throw Exception('LogOut error');
    }
  }

  Future<User?> getUser() async {
    try {
      final hiveUser = userBox.get('userKey');
      return hiveUser;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      return const User(id: '');
    }
  }
}
