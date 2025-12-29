import 'package:flutter/material.dart';

/// Material 3 스타일 버튼 타입
enum CustomButtonType {
  filled, // 주요 액션 (FilledButton)
  tonal, // 보조 액션 (FilledButton.tonal)
  outlined, // 강조되지 않는 액션 (OutlinedButton)
  text, // 최소 강조 액션 (TextButton)
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.type = CustomButtonType.filled,
    this.width,
    this.isLoading = false,
    this.icon,
  }) : _label = null;

  /// Filled 버튼 (주요 액션)
  const CustomButton.filled({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.isLoading = false,
    this.icon,
  }) : type = CustomButtonType.filled,
       _label = null;

  /// Tonal 버튼 (보조 액션)
  const CustomButton.tonal({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.isLoading = false,
    this.icon,
  }) : type = CustomButtonType.tonal,
       _label = null;

  /// Outlined 버튼 (강조되지 않는 액션)
  const CustomButton.outlined({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.isLoading = false,
    this.icon,
  }) : type = CustomButtonType.outlined,
       _label = null;

  /// Text 버튼 (최소 강조 액션)
  const CustomButton.text({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.isLoading = false,
    this.icon,
  }) : type = CustomButtonType.text,
       _label = null;

  /// 아이콘이 있는 버튼
  const CustomButton.withIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    required String label,
    this.type = CustomButtonType.filled,
    this.width,
    this.isLoading = false,
  }) : child = null,
       _label = label;

  final VoidCallback? onPressed;
  final Widget? child;
  final CustomButtonType type;
  final double? width;
  final bool isLoading;
  final IconData? icon;
  final String? _label;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final buttonChild = isLoading
        ? _buildLoadingIndicator(context)
        : (child ?? (_label != null ? Text(_label) : const SizedBox.shrink()));

    final button = _buildButton(
      context: context,
      onPressed: effectiveOnPressed,
      child: buttonChild,
    );

    return SizedBox(width: width ?? double.infinity, child: button);
  }

  Widget _buildButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    // 아이콘 버튼
    if (icon != null && _label != null) {
      return switch (type) {
        CustomButtonType.filled => FilledButton.icon(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: onPressed,
          icon: Icon(icon),
          label: child,
        ),
        CustomButtonType.tonal => FilledButton.tonalIcon(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: onPressed,
          icon: Icon(icon),
          label: child,
        ),
        CustomButtonType.outlined => OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: onPressed,
          icon: Icon(icon),
          label: child,
        ),
        CustomButtonType.text => TextButton.icon(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: onPressed,
          icon: Icon(icon),
          label: child,
        ),
      };
    }

    // 일반 버튼
    return switch (type) {
      CustomButtonType.filled => FilledButton(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
      CustomButtonType.tonal => FilledButton.tonal(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
      CustomButtonType.outlined => OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
      CustomButtonType.text => TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    };
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 버튼 타입에 따른 로딩 인디케이터 색상
    final indicatorColor = switch (type) {
      CustomButtonType.filled => colorScheme.onPrimary,
      CustomButtonType.tonal => colorScheme.onSecondaryContainer,
      CustomButtonType.outlined => colorScheme.primary,
      CustomButtonType.text => colorScheme.primary,
    };

    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
    );
  }
}
