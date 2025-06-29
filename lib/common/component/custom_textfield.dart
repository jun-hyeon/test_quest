import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    this.hintText,
    this.labelText,
    this.onChanged,
    required this.obscure,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.errorText,
    this.validator,
  });

  final bool obscure;
  final String? hintText;
  final String? labelText;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final String? errorText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            width: 2.0,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            width: 2.0,
          ),
        ),
        errorText: errorText,
        hintText: hintText,
        labelText: labelText,
        suffixIcon: suffixIcon != null
            ? Icon(
                suffixIcon,
                color: Theme.of(context).hintColor,
              )
            : null,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Theme.of(context).hintColor,
              )
            : null,
        hintStyle: TextStyle(
            color: Theme.of(context).hintColor.withValues(alpha: 0.6)),
        fillColor: Theme.of(context).cardColor,
      ),
    );
  }
}

class LabelTextField extends StatelessWidget {
  const LabelTextField({
    super.key,
    this.hintText,
    this.labelText,
    required this.onChanged,
    required this.isPassword,
    this.suffixIcon,
  });

  final bool isPassword;
  final String? hintText;
  final String? labelText;
  final Icon? suffixIcon;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword, // 비밀번호 필드 여부
      onChanged: onChanged,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        ),
        hintText: hintText ?? '',
        labelText: labelText ?? '',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
