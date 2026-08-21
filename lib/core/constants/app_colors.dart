import 'package:flutter/material.dart';

class AppColors {
  // Primary blue-indigo (EduVerse style)
  static const Color primary = Color(0xFF3B4CE8);
  static const Color primaryDark = Color(0xFF2A3BD4);
  static const Color primaryLight = Color(0xFF6B7BF0);

  // Backgrounds
  static const Color background = Color(0xFFF5F6FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);

  // Accent
  static const Color orange = Color(0xFFFF6B35);
  static const Color green = Color(0xFF4CAF50);
  static const Color greenLight = Color(0xFFE8F5E9);

  // Text
  static const Color textPrimary = Color(0xFF1A1F36);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFB0B7C3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border / Divider
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B4CE8), Color(0xFF6B7BF0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF3B4CE8), Color(0xFF5162EC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Stars
  static const Color starColor = Color(0xFFFFC107);

  // Social login colors
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color googleRed = Color(0xFFDB4437);
  static const Color appleBlack = Color(0xFF000000);

  // Input field background
  static const Color inputBg = Color(0xFFF9FAFB);

  // Glass effect
  static const Color glassColor = Color(0x12FFFFFF);
  static const Color glassBorder = Color(0x1FE5E7EB);

  // Onboarding page colors
  static const List<Color> onboardingAccents = [
    Color(0xFF3B4CE8),
    Color(0xFF00BCD4),
    Color(0xFFFF6B35),
  ];
}
