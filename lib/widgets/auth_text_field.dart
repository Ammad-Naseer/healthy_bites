// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:healthy_bites/Models/colors.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool showSuffixIcon;
  final bool isPassword;

  const AuthTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.showSuffixIcon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _AuthTextFieldState createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter an email address";
    } else if (!isEmailValid(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    } else if (value.length < 8) {
      return "Password must be at least 8 characters long";
    } else if (!value.contains(RegExp(r'\d'))) {
      return "Password must contain at least one number";
    } else if (!value.contains(RegExp(r'[a-zA-Z]'))) {
      return "Password must contain at least one letter";
    }
    return null;
  }

  bool isEmailValid(String value) {
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(value);
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.hintText.toLowerCase().contains('email')
          ? _validateEmail
          : widget.isPassword
              ? _validatePassword
              : _validateName,
      cursorColor: MyColors.darkGreen,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(widget.icon, color: MyColors.darkGreen),
        suffixIcon: widget.showSuffixIcon && widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: MyColors.darkGreen,
                ),
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        filled: true,
        fillColor: Colors.green.withOpacity(0.6),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColors.green),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColors.green),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
