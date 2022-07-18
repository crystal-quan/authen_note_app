// ignore_for_file: implementation_imports, must_be_immutable

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:authen_note_app/theme/color.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      alignment: Alignment.center,
      color: backgroundColor2,
      child: SpinKitCircle(
        duration: Duration(milliseconds: 500),
        color: Colors.white,
        size: 50.0,
      ),
    );
  }
}
