import 'package:flutter/material.dart';

/// App color palette based on DahuKu design system
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF304AFF);
  static const Color primaryDark = Color(0xFF1a2fcc);
  static const Color accentPurple = Color(0xFFA788FD);

  // Background Colors
  static const Color bgPage = Color(0xFFF8F9FE);
  static const Color cardWhite = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textMain = Color(0xFF1F2937);
  static const Color textSub = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Wallet Colors
  static const Color walletShopping = Color(0xFFFF6B6B);
  static const Color walletSaving = Color(0xFF4ECDC4);
  static const Color walletEmergency = Color(0xFF45B7D1);

  // Gradient Colors (for splash screen)
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPurple, primary],
  );

  static const Gradient cardGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, Color(0xFF5C71FF)],
  );
}
