import 'package:flutter/material.dart';

/// NeoCare+ Color Palette - Material 3 Design
class AppColors {
  AppColors._();

  // === Brand Colors ===
  static const Color primary = Color(0xFF0B1F3A); // Midnight Blue
  static const Color secondary = Color(0xFF1BB5A5); // Teal
  static const Color accent = Color(0xFFD4AF37); // Gold

  // === Neutrals ===
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF7F7F9);
  static const Color lightGray = Color(0xFFE9ECEF);
  static const Color textGray = Color(0xFF222222);
  static const Color divider = Color(0xFFD8DEE4);

  // === States ===
  static const Color danger = Color(0xFFD92D20);
  static const Color warning = Color(0xFFF79009);
  static const Color info = Color(0xFF1570EF);
  static const Color success = secondary;

  // === Dark Mode Variants ===
  static const Color darkBackground = Color(0xFF0F1419);
  static const Color darkSurface = Color(0xFF1A1F25);
  static const Color darkText = Color(0xFFE9ECEF);

  // === Gradients ===
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF1A3A5F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFEAC860)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFF2DD4C1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
