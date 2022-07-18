// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomFloatingActionButtton extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final onPressed;
  const CustomFloatingActionButtton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, right: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(
              color: Colors.black, width: 4, strokeAlign: StrokeAlign.outside)),
      width: 70,
      height: 70,
      child: FittedBox(
        child: FloatingActionButton(
          splashColor: Colors.amber,
          onPressed: onPressed,
          backgroundColor: Colors.red,
          child: const Icon(Icons.add, size: 50, color: Colors.white),
        ),
      ),
    );
  }
}
