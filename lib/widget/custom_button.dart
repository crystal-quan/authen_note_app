import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  VoidCallback? onTap;
  String? imageAssets;
  CustomButton({Key? key, this.onTap, this.imageAssets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xff3B3B3B),
        ),
        child: FittedBox(
          alignment: Alignment.center,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            onTap: onTap,
            child: Image.asset(
              'assets/images/$imageAssets',
              width: 40,
              height: 40,
            ),
          ),
        ));
  }
}
