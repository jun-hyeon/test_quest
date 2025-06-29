import 'package:flutter/material.dart';

class AppColors {
  // 🌞 Light Theme Colors
  static const Color lightBackground = Colors.white; // 배경색
  static const Color lightText = Colors.black; // 텍스트
  static const Color lightHint = Colors.black54; // 힌트 텍스트
  static const Color lightBorder = Colors.black; // 텍스트필드 테두리

  // 🌙 Dark Theme Colors
  static const Color darkBackground = Color(0xFF1E1E1E); // 다크 배경
  static const Color darkText = Color(0xFFF5E9D7); // 밝은 베이지 텍스트
  static final Color darkHint = darkText.withValues(alpha: 0.6); // 힌트
  static const Color darkBorder = Color(0xFFF5E9D7); // 테두리
}
