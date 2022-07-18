// ignore_for_file: file_names

import 'package:authen_note_app/theme/color.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButtton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final onPressed;
  const CustomFloatingActionButtton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: FittedBox(
        child: FloatingActionButton(
          foregroundColor: backgroundColor1,
          onPressed: onPressed,
          backgroundColor: backgroundColor1,
          child: const Icon(Icons.add, size: 50, color: Colors.white),
        ),
      ),
    );
  }
}
