import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
  });

  final VoidCallback? onPressed;
  final double? width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
