import 'package:flutter/material.dart';

/// App-wide theme definitions using Material 3.
/// 
/// Custom color tokens aligned with WhoHasMy brand identity:
/// - Primary blue: #1565C0
/// - Secondary amber: #FFA726
/// - Risk semantic colors mapped in status section
class AppTheme {
  AppTheme._();

  // Brand Colors
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color secondaryAmber = Color(0xFFFFA726);

  // Risk Semantic Colors (from DESIGN.md)
  static const Color riskGreen = Color(0xFF43A047);
  static const Color riskAmber = Color(0xFFFB8C00);
  static const Color riskOrangeRed = Color(0xFFFF7043);
  static const Color riskRed = Color(0xFFE53935);

  // Typography - Inter font family, 7 sizes
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.16,
  );
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 34,
    fontWeight: FontWeight.w400,
    height: 1.24,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 1.27,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
  );

  // Spacing tokens (xs=4px through xl=32px)
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 24.0;
  static const double spacingXXl = 32.0;

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: primaryBlue,
      textTheme: TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        titleLarge: titleLarge,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelLarge: labelLarge,
      ),
    );
  }

  /// Dark theme configuration via Material 3 dynamic color scheme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: primaryBlue,
      textTheme: TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        titleLarge: titleLarge,
        bodyLarge: bodyLarge.copyWith(color: Colors.white),
        bodyMedium: bodyMedium.copyWith(color: Colors.white70),
        labelLarge: labelLarge.copyWith(color: Colors.white),
      ),
    );
  }
}
