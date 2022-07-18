// ignore_for_file: implementation_imports

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:authen_note_app/app/app.dart';
import 'package:authentication_repository/authentication_repository.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  Widget widget;
  int s;
  SplashScreen({super.key, required this.s,required this.widget});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: s,
        splash: Icons.note_add,
        nextScreen: widget,
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.blue);
  }
}
