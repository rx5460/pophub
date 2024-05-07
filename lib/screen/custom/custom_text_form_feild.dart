import 'package:flutter/material.dart';

class CustomTextFormFeild extends StatefulWidget {
  final String titleName;
  final TextEditingController controller;
  final String hintText;
  final Function validator;
  final int maxlength;
  final TextInputType textInputType;

  const CustomTextFormFeild(
      {super.key,
      this.titleName = "",
      required this.controller,
      required this.hintText,
      required this.validator,
      this.maxlength = 100,
      this.textInputType = TextInputType.text});

  @override
  State<CustomTextFormFeild> createState() => _CustomTextFormFeildState();
}

class _CustomTextFormFeildState extends State<CustomTextFormFeild> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        keyboardType: widget.textInputType,
        maxLength: widget.maxlength,
        decoration: InputDecoration(
          hintText: widget.hintText,
          counterText: '',
        ),
        validator: (value) {
          return widget.validator(value);
        });
  }
}
