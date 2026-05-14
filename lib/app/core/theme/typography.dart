import 'package:flutter/material.dart';

class AppTextTheme {
  static TextTheme get theme => const TextTheme(
    // HERO / MAIN HEADINGS
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.5,
    ),

    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: -0.3,
    ),

    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.3,
    ),

    // SCREEN TITLES
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),

    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.35,
    ),

    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.35,
    ),

    // CARD TITLES / BUTTONS
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),

    titleMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),

    // BODY
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),

    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.45,
    ),

    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),

    // LABELS / CAPTIONS
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.3,
    ),

    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.3,
    ),
  );
}
