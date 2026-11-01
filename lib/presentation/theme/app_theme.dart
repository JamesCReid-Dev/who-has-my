import 'package:flutter/material.dart';

/// App-wide theme definitions using Material 3.
/// 
/// Custom color tokens aligned with WhoHasMy brand identity:
/// - Primary blue: #1565C0 (trust, reliability)
/// - Secondary amber: #FFA726 (approachable energy, CTAs)
/// - Risk semantic colors mapped per DESIGN.md specifications
/// - Typography: Inter font family, 7 sizes from display to caption
/// - Spacing tokens: xs=4px through xl=32px
/// - Dark mode support via Material 3 dynamic color scheme
class AppTheme {
  AppTheme._();

  // ─── Brand Colors ──────────────────────────────────────────────────────
  
  /// Primary blue — trust, reliability (#1565C0)
  static const Color primaryBlue = Color(0xFF1565C0);
  
  /// Lighter blue for hover/focus states (#42A5F5)
  static const Color primaryLight = Color(0xFF42A5F5);
  
  /// Darker blue for active/pressed states (#0D47A1)
  static const Color primaryDark = Color(0xFF0D47A1);
  
  /// Text on primary backgrounds
  static const Color primaryContrast = Color(0xFFFFFFFF);

  /// Secondary amber — approachable energy, CTAs (#FFA726)
  static const Color secondaryAmber = Color(0xFFFFA726);
  
  /// Lighter amber for subtle highlights (#FFB74D)
  static const Color secondaryLight = Color(0xFFFFB74D);
  
  /// Darker amber for emphasis (#F57C00)
  static const Color secondaryDark = Color(0xFFF57C00);
  
  /// Text on secondary backgrounds
  static const Color secondaryContrast = Color(0xFF212121);

  // ─── Status Colors ─────────────────────────────────────────────────────

  /// Success green — available items, on-time loans (#43A047)
  static const Color successGreen = Color(0xFF43A047);
  
  /// Warning amber — approaching due date (1-2 days) (#FB8C00)
  static const Color warningAmber = Color(0xFFFB8C00);
  
  /// Danger red — overdue, high risk (#E53935)
  static const Color dangerRed = Color(0xFFE53935);

  // ─── Risk Semantic Colors (from DESIGN.md) ─────────────────────────────
  
  /// On time / not overdue (green)
  static const Color riskNone = Color(0xFF43A047);
  
  /// 2-4 days overdue (amber)
  static const Color riskLow = Color(0xFFFB8C00);
  
  /// 5 days overdue (orange-red)
  static const Color riskMedium = Color(0xFFFF7043);
  
  /// >5 days overdue (red)
  static const Color riskHigh = Color(0xFFE53935);

  // ─── Neutral Colors ────────────────────────────────────────────────────

  /// Light mode background (#F5F5F5)
  static const Color surfaceLight = Color(0xFFF5F5F5);
  
  /// Dark mode background (#121212)
  static const Color surfaceDark = Color(0xFF121212);
  
  /// Light mode text (#212121)
  static const Color onSurfaceLight = Color(0xFF212121);
  
  /// Dark mode text (#EEEEEE)
  static const Color onSurfaceDark = Color(0xFFEEEEEE);
  
  /// Light mode borders/dividers (#E0E0E0)
  static const Color dividerLight = Color(0xFFE0E0E0);
  
  /// Dark mode borders/dividers (#333333)
  static const Color dividerDark = Color(0xFF333333);

  // ─── Typography - Inter font family, 7 sizes (DESIGN.md spec) ──────────
  
  /// Display Large — App title, hero text (57px)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.12,
    letterSpacing: -0.25,
  );
  
  /// Display Medium — Section headers (45px)
  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.16,
  );
  
  /// Headline Large — Page titles (34px)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 34,
    fontWeight: FontWeight.w400,
    height: 1.24,
  );
  
  /// Headline Medium — Card titles, item names (24px)
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );
  
  /// Title Large — Navigation labels, form titles (22px)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 1.27,
  );
  
  /// Body Large — Primary text content (16px)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );
  
  /// Body Medium — Secondary info, captions (14px)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );
  
  /// Label Large — Buttons, action labels (14px medium)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
  );

  // ─── Spacing Tokens (xs=4px through xl=32px) ──────────────────────────
  
  /// Extra small spacing — 4px
  static const double spacingXs = 4.0;
  
  /// Small spacing — 8px
  static const double spacingSm = 8.0;
  
  /// Medium spacing — 12px
  static const double spacingMd = 12.0;
  
  /// Large spacing — 16px
  static const double spacingLg = 16.0;
  
  /// Extra large spacing — 24px
  static const double spacingXl = 24.0;
  
  /// Double extra large spacing — 32px
  static const double spacingXXl = 32.0;

  // ─── Shape Tokens ──────────────────────────────────────────────────────

  /// Small border radius — 8px
  static const double shapeSm = 8.0;
  
  /// Medium border radius — 12px
  static const double shapeMd = 12.0;
  
  /// Large border radius — 16px
  static const double shapeLg = 16.0;
  
  /// Extra large border radius — 28px (bottom sheets, FAB)
  static const double shapeXl = 28.0;

  // ─── Light Theme Configuration ─────────────────────────────────────────

  /// Light theme configuration with Material 3 and WhoHasMy custom tokens.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Custom color scheme (not using seed to allow full control)
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryAmber,
        surface: surfaceLight,
        onSurface: onSurfaceLight,
        error: dangerRed,
        onPrimary: primaryContrast,
        onSecondary: secondaryContrast,
      ),
      
      // Typography scale — Inter font family, 7 sizes
      textTheme: TextTheme(
        displayLarge: displayLarge.copyWith(color: onSurfaceLight),
        displayMedium: displayMedium.copyWith(color: onSurfaceLight),
        headlineLarge: headlineLarge.copyWith(color: onSurfaceLight),
        headlineMedium: headlineMedium.copyWith(color: onSurfaceLight),
        titleLarge: titleLarge.copyWith(color: onSurfaceLight),
        bodyLarge: bodyLarge.copyWith(color: onSurfaceLight),
        bodyMedium: bodyMedium.copyWith(color: onSurfaceLight),
        labelLarge: labelLarge.copyWith(color: onSurfaceLight),
      ),
      
      // Material 3 component defaults
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: primaryContrast,
        elevation: 0,
        centerTitle: false,
      ),
      
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shapeMd),
        ),
        color: Colors.white,
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryAmber,
        foregroundColor: secondaryContrast,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shapeXl),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapeMd),
          borderSide: const BorderSide(color: dividerLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapeMd),
          borderSide: const BorderSide(color: dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapeMd),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: primaryContrast,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shapeMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shapeMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
        ),
      ),
    );
  }

  // ─── Dark Theme Configuration ──────────────────────────────────────────

  /// Dark theme configuration via Material 3 with custom color tokens.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Custom dark color scheme (not using seed to allow full control)
      colorScheme: const ColorScheme.dark(
        primary: primaryLight,
        secondary: secondaryAmber,
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        error: dangerRed,
        onPrimary: primaryContrast,
        onSecondary: secondaryContrast,
      ),
      
      // Typography scale — Inter font family with dark mode color adjustments
      textTheme: TextTheme(
        displayLarge: displayLarge.copyWith(color: onSurfaceDark),
        displayMedium: displayMedium.copyWith(color: onSurfaceDark),
        headlineLarge: headlineLarge.copyWith(color: onSurfaceDark),
        headlineMedium: headlineMedium.copyWith(color: onSurfaceDark),
        titleLarge: titleLarge.copyWith(color: onSurfaceDark),
        bodyLarge: bodyLarge.copyWith(color: onSurfaceDark),
        bodyMedium: bodyMedium.copyWith(color: onSurfaceDark),
        labelLarge: labelLarge.copyWith(color: onSurfaceDark),
      ),
      
      // Material 3 component defaults for dark mode
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: primaryContrast,
        elevation: 0,
        centerTitle: false,
      ),
      
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shapeMd),
        ),
        color: const Color(0xFF1E1E1E),
      ),
      
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryAmber,
        foregroundColor: secondaryContrast,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(shapeXl),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapeMd),
          borderSide: const BorderSide(color: dividerDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapeMd),
          borderSide: const BorderSide(color: dividerDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(shapeMd),
          borderSide: const BorderSide(color: primaryLight, width: 2),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: primaryContrast,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shapeMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLight,
          side: const BorderSide(color: primaryLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shapeMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
        ),
      ),
    );
  }

  // ─── Risk Color Helper ─────────────────────────────────────────────────

  /// Returns the appropriate risk color based on overdue days.
  /// 
  /// - 0 days overdue: [riskNone] (green) — On time / not overdue
  /// - 1-4 days overdue: [riskLow] (amber) — Approaching due date
  /// - 5 days overdue: [riskMedium] (orange-red) — Medium risk
  /// - >5 days overdue: [riskHigh] (red) — High/urgent risk
  static Color getRiskColor(int daysOverdue) {
    if (daysOverdue <= 0) return riskNone;
    if (daysOverdue <= 4) return riskLow;
    if (daysOverdue == 5) return riskMedium;
    return riskHigh;
  }

  /// Returns the appropriate risk label based on overdue days.
  static String getRiskLabel(int daysOverdue) {
    if (daysOverdue <= 0) return 'On time';
    if (daysOverdue == 1) return 'Due tomorrow';
    if (daysOverdue <= 4) return '$daysOverdue days overdue';
    if (daysOverdue == 5) return '5 days late!';
    return '$daysOverdue days overdue';
  }

  /// Returns the spacing token for the given semantic name.
  static double getSpacing(String name) {
    switch (name.toLowerCase()) {
      case 'xs': return spacingXs;
      case 'sm': return spacingSm;
      case 'md': return spacingMd;
      case 'lg': return spacingLg;
      case 'xl': return spacingXl;
      case 'xxl': return spacingXXl;
      default: return spacingMd;
    }
  }

  /// Returns the shape token for the given semantic name.
  static double getShape(String name) {
    switch (name.toLowerCase()) {
      case 'sm': return shapeSm;
      case 'md': return shapeMd;
      case 'lg': return shapeLg;
      case 'xl': return shapeXl;
      default: return shapeMd;
    }
  }
}
