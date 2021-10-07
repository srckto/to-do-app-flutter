import 'package:flutter/material.dart';
import 'package:to_do_app/ui/theme.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  final String lable;
  final Function() onTap;
  late double height;
  late double width;
  late Color color;
  late double radius;
  late TextStyle lableStyle;

  MyButton({
    required this.lable,
    required this.onTap,
    this.height = 45.0,
    this.width = 100.0,
    this.color = k_primaryClr,
    this.radius = 10.0,
    this.lableStyle = const TextStyle(color: Colors.white ),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            lable,
            style: lableStyle,
          ),
        ),
      ),
    );
  }
}
