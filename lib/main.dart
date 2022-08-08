import 'package:authen_note_app/app/app.dart';
import 'package:authen_note_app/firebase_options.dart';
import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/model/user.dart';
import 'package:authen_note_app/repository/google_authenRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() {
  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await Hive.initFlutter();
      Hive.registerAdapter(NoteAdapter());
      await Hive.openBox<Note>('notes');
      Hive.registerAdapter(UserAdapter());
      await Hive.openBox<User>('users');
      // final authenticationRepository = GoogleAuthenRepository(
      //     firebaseAuth: auth.FirebaseAuth.instance,
      //     googleSignIn: GoogleSignIn());

      runApp(const AppView());
    },
    blocObserver: AppBlocObserver(),
  );
}
