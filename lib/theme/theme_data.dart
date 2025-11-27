import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_quest/theme/app_colors.dart';
import 'package:test_quest/theme/text_theme.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.black,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.black,
    onSecondary: Colors.white,
    error: Color(0xFFD32F2F),
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  useMaterial3: true,
  textTheme: lightTextTheme,
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.grey),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.black),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(width: 2, color: Colors.grey),
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      textStyle: GoogleFonts.pressStart2p(fontSize: 10),
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.grey[100],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black.withAlpha(128),
    selectedIconTheme: const IconThemeData(size: 24),
    unselectedIconTheme: const IconThemeData(size: 20),
    selectedLabelStyle: GoogleFonts.pressStart2p(fontSize: 10),
    unselectedLabelStyle: GoogleFonts.pressStart2p(fontSize: 10),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBackground,
  primaryColor: AppColors.darkText,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkText,
    onPrimary: Colors.black,
    secondary: AppColors.darkText, // Example accent
    onSecondary: Colors.black,
    error: Color(0xFFEF5350),
    onError: Colors.black,
    surface: AppColors.darkBackground,
    onSurface: AppColors.darkText,
  ),
  useMaterial3: true,
  textTheme: darkTextTheme,
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: AppColors.darkHint),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.darkBorder),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.darkBorder, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.darkText,
      foregroundColor: AppColors.darkBackground,
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: AppColors.darkText),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(width: 2, color: AppColors.darkBorder),
      foregroundColor: AppColors.darkText,
      backgroundColor: Colors.transparent,
      textStyle: GoogleFonts.pressStart2p(fontSize: 10),
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.grey[900],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkBackground,
    selectedItemColor: AppColors.darkText,
    unselectedItemColor: AppColors.darkText.withValues(alpha: 0.5),
    selectedIconTheme: const IconThemeData(size: 24),
    unselectedIconTheme: const IconThemeData(size: 20),
    selectedLabelStyle: GoogleFonts.pressStart2p(fontSize: 10),
    unselectedLabelStyle: GoogleFonts.pressStart2p(fontSize: 10),
  ),
);
