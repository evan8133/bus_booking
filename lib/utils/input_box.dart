import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function(String) onChanged;
  final String Function(String?)? validator;
  final TextInputType keyboardType;
  final String? initialValue;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,

      
    );
  }
}
