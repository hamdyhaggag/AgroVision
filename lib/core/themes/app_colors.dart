import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ----------------------
  // PRIMARY COLORS
  // ----------------------
  /// The main brand color.
  static const Color primaryColor = Color(0xFF34C759);

  /// A lighter tint of [primaryColor].
  static const Color primaryColorshade = Color(0xFFB2E2C3);

  // ----------------------
  // SELECTION & ACCENTS
  // ----------------------
  /// Highlight or selection background.
  static const Color selectionColor = Color(0xFF99EFCE);

  /// Secondary accent color (identical to primary).
  static const Color secondaryColor = Color(0xFF34C759);

  /// Surface elements such as cards or panels.
  static const Color surfaceColor = Color(0xFFF9FAFB);

  /// Secondary text color for less emphasis.
  static const Color secondaryText = Color(0xFF64748B);

  /// Accent hue for buttons or links.
  static const Color accentColor = Color(0xFF218838);

  // ----------------------
  // BACKGROUND & ERRORS
  // ----------------------
  /// App-wide background.
  static const Color background = Color(0xFF1A858D);

  /// Error background or state (same as [background]).
  static const Color error = Color(0xFF1A858D);

  // ----------------------
  // NEUTRALS & NAVIGATION
  // ----------------------
  /// Pure white color.
  static const Color whiteColor = Color(0xFFFFFFFF);

  /// Pure black color.
  static const Color blackColor = Color(0xFF000000);

  /// Deep neutral for text or icons.
  static const Color navy = Color(0xFF51526C);

  /// Navigation bar background.
  static const Color navBarColor = Color(0xFFE6E6E6);

  /// Light grey for dividers and borders.
  static const Color greyLight = Color(0xFFE8E8E8);

  /// Standard grey for text or icons.
  static const Color greyColor = Color(0xFFA1A1A1);

  // ----------------------
  // COMPLETION STATES
  // ----------------------
  /// Indicates completed portion.
  static const Color completeColor = Color(0xFFC0FCE3);

  /// Indicates incomplete or pending portion.
  static const Color inCompleteColor = Color(0xFFFEBBBB);

  // ----------------------
  // MATERIAL SURFACE & TEXT
  // ----------------------
  /// Scaffold background color.
  static const Color scaffoldBackground = Color(0xFFF4F6F8);

  /// Primary text.
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Secondary text.
  static const Color textSecondary = Color(0xFF666666);

  /// Tertiary text.
  static const Color textTertiary = Color(0xFF999999);

  /// Background for gauge components.
  static const Color gaugeBackground = Color(0xFFEAECF0);

  // ----------------------
  // STATUS COLORS
  // ----------------------
  /// Warning indicators.
  static const Color warningColor = Color(0xFFFFC107);

  /// Success indicators.
  static const Color successColor = Color(0xFF8BC34A);

  /// Error indicators (e.g., text or icons).
  static const Color errorColor = Color(0xFFEF5350);

  // ----------------------
  // DIVIDER & SURFACES
  // ----------------------
  /// Standard divider lines.
  static const Color divider = Color(0xFFE0E0E0);

  /// Default surface for components.
  static const Color surface = Color(0xFFFFFFFF);

  /// Text and icon color on [surface].
  static const Color onSurface = Color(0xFF2F2F2F);
}

Color getColorForType(String type) {
  switch (type) {
    case 'temperature':
      return const Color(0xFFFF6D00);
    case 'humidity':
      return const Color(0xFF0288D1);
    case 'soil':
      return const Color(0xFF795548);
    case 'ec':
      return const Color(0xFF388E3C);
    case 'ph':
      return const Color(0xFF7B1FA2);
    case 'n':
      return const Color(0xFF1976D2);
    case 'p':
      return const Color(0xFFD32F2F);
    case 'k': // Potassium
      return const Color(0xFF388E3C);
    case 'fertility':
      return const Color(0xFFFBC02D);
    default:
      return const Color(0xFF9E9E9E);
  }
}
