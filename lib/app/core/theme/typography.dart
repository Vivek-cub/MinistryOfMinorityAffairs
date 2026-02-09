

import 'package:flutter/material.dart';

class AppTextTheme {
  static get theme => TextTheme(
    displayLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      height: 40.0 / 32.0,
      letterSpacing: -0.64,
    ),
    displayMedium: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      height: 36.0 / 28.0,
      letterSpacing: -0.56,
    ),
    displaySmall: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      height: 32.0 / 24.0,
      letterSpacing: 0,
    ),
    headlineMedium: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      height: 28.0 / 20.0,
      letterSpacing: 0,
    ),
    headlineSmall: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      height: 24.0 / 18.0,
      letterSpacing: 0,
    ),
    titleLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      height: 22.0 / 16.0,
      letterSpacing: 0,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.0,
      height: 28.0 / 18.0,
      letterSpacing: 0,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.0,
      height: 24.0 / 16.0,
      letterSpacing: 0,
    ),
    bodySmall: TextStyle(
      fontSize: 14.0,
      height: 20.0 / 14.0,
      letterSpacing: 0,
    ),
  );

  static TextStyle get bodySmall1 => TextStyle(
    fontSize: 13.0,
    height: 20.0 / 14.0,
    letterSpacing: 0,
  );
  static TextStyle get bodyVSmall => TextStyle(
    fontSize: 12.0,
    height: 20.0 / 14.0,
    letterSpacing: 0,
  );
  static TextStyle get bodyVVSmall => TextStyle(
    fontSize: 10.0,
    height: 20.0 / 14.0,
    letterSpacing: 0,
  );
}
