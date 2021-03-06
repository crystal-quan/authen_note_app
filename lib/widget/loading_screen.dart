// ignore_for_file: implementation_imports, must_be_immutable

import 'package:authen_note_app/theme/color.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  final double? height;
  const LoadingScreen({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      alignment: Alignment.center,
      color: backgroundColor2,
      child: const SpinKitFadingCircle(
        duration: Duration(milliseconds: 500),
        color: Colors.white,
        size: 60.0,
      ),
    );
  }
}
