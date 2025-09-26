import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.shape,
  });

  final VoidCallback? onPressed;
  final double? width;
  final Widget child;
  final OutlinedBorder? shape;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: shape,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
