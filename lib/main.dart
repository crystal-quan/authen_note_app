import 'package:authen_note_app/app/app.dart';
import 'package:authen_note_app/firebase_options.dart';
import 'package:authen_note_app/google_login_page/google_login_screen.dart';
import 'package:authen_note_app/home/view/home_page.dart';
import 'package:authen_note_app/model/note_model.dart';
import 'package:authen_note_app/repository/hive_note.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() {
  
  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await Hive.initFlutter();
      Hive.registerAdapter(HiveNoteAdapter());

      await Hive.openBox<HiveNote>('notes');

      final authenticationRepository = AuthenticationRepository();
      await authenticationRepository.user.first;
      runApp(App(authenticationRepository: authenticationRepository));
    },
    blocObserver: AppBlocObserver(),
  );
}
