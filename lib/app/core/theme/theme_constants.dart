
import 'package:flutter/widgets.dart';

/// Application color palette
/// Based on Indian government branding and modern UI standards
sealed class AppColors {
  // Primary Colors - Saffron and Blue from Indian National Flag
  static const Color primary = Color(0xFFFF9933); // Saffron
  static const Color primaryDark = Color(0xFFE67E00);
  static const Color primaryLight = Color(0xFFFFB366);

  static const Color secondary = Color(0xFF138808); // Green from flag
  static const Color secondaryDark = Color(0xFF0F6B06);
  static const Color secondaryLight = Color(0xFF45A049);

  static const Color accent = Color(0xFF000080); // Navy Blue (Ashoka Chakra)

  // Neutral Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFAFAFA);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF2196F3);

  // Divider & Border
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFBDBDBD);

  // Government specific colors
  static const Color governmentBlue = Color(0xFF003366);
  static const Color governmentGold = Color(0xFFFFD700);
}

sealed class AppDimensions {
  static const double none = 0.0;
  static const double x = 2.0;
  static const double xx = 3.0;
  static const double xxs = 4.0;
  static const double xxsm = 6.0;
  static const double xs = 8.0;
  static const double s = 10.0;
  static const double sm = 12.0;
  static const double sm1 = 14.0;
  static const double md = 16.0;
  static const double secondaryDimension = 18.0;
  static const double sideIndicatorHeight = 19.0;
  static const double primaryDimension = 24.0;
  static const double lg = 20.0;
  static const double xlg = 22.0;
  static const double xl = 24.0;
  static const double xxl = 28.0;
  static const double xxxl = 32.0;
  static const double huge = 36.0;
  static const double massive = 40.0;
  static const double gigantic = 44.0;
  static const double sideIndicator2Height = 66.0;
}

sealed class CardShadow {
  static BoxShadow get shadow => BoxShadow(
    color: Color.fromRGBO(142, 67, 62, 0.12),
    spreadRadius: 1,
    blurRadius: 5,
    offset: Offset(0, 3),
  );
}
