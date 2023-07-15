// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Widget text;
  final VoidCallback onPressed;
  Color color = Colors.blue;

  MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: text
    );
  }
}
