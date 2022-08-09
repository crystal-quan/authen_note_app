import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

import '../model/note_model.dart';
import '../model/user.dart';

class GoogleAuthenRepository {
  GoogleAuthenRepository({
    auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    Box<User>? userBox,
  })  : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _userBox = userBox ?? Hive.box<User>('users');

  final Box<User> _userBox;
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool isWeb = kIsWeb;
  Future<User> logInWithGoogle() async {
    try {
      late final auth.AuthCredential credential;
      // if (isWeb) {
      //   final googleProvider = auth.GoogleAuthProvider();
      //   final userCredential = await _firebaseAuth.signInWithPopup(
      //     googleProvider,
      //   );
      //   credential = userCredential.credential!;
      // } else {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // }
      final credentialUser =
          await _firebaseAuth.signInWithCredential(credential);
      User currentUser = User(
          id: credentialUser.user?.uid ?? '',
          email: credentialUser.user?.email,
          name: credentialUser.user?.displayName,
          photo: credentialUser.user?.photoURL);
      await _userBox.put('userKey', currentUser);
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
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      await Hive.box<Note>('notes').clear();
      await Hive.box<User>('users').clear();
    } catch (_) {
      throw Exception('LogOut error');
    }
  }

  Future<User?> getUser() async {
    try {
      final hiveUser = _userBox.get('userKey');
      return hiveUser;
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      return const User(id: '');
    }
  }
}
