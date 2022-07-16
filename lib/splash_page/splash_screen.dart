// ignore_for_file: implementation_imports

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:authen_note_app/app/app.dart';
import 'package:authentication_repository/authentication_repository.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 2500,
        splash: Icons.note_add,
        nextScreen: SizedBox(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.blue);
  }
}


