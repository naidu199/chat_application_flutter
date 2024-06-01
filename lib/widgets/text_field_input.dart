import 'package:chat_application/utils/colors.dart';
import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final bool isPassword;
  final TextInputType textInputType;
  const TextFieldInput(
      {super.key,
      required this.hintText,
      required this.textEditingController,
      required this.textInputType,
      this.isPassword = false});

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    // final inputBorder =
    //     OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: widget.textEditingController,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          labelText: widget.hintText,
          labelStyle:
              const TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
              gapPadding: 2,
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10)),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                )
              : null),
      obscureText: widget.isPassword && !isPasswordVisible,
      keyboardType: widget.textInputType,
    );
  }
}
