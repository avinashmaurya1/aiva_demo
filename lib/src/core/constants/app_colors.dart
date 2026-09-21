import 'package:flutter/material.dart';

/// App color palette with travel accents (inspired by modern travel OTAs & dark mode AI)
class AppColors {
  AppColors._();

  // Primary Brand Colors (Travel Orange / AI Cyan)
  static const Color primary = Color(0xFFF9652B);
  static const Color primaryDark = Color(0xFFD94E18);
  static const Color primaryLight = Color(0xFFFF8552);

  static const Color accent = Color(0xFF00B4D8);
  static const Color accentCyan = Color(0xFF38BDF8);

  // Neutral Dark Theme
  static const Color backgroundDark = Color(0xFF0B1120);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color cardBorderDark = Color(0xFF334155);

  // Neutral Light Theme
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardBorderLight = Color(0xFFE2E8F0);

  // Text Colors
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);

  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textMutedLight = Color(0xFF94A3B8);

  // Status & Utility Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Flight & Travel specific
  static const Color indigoAirline = Color(0xFF001B94);
  static const Color airIndiaAirline = Color(0xFFE31837);
  static const Color vistaraAirline = Color(0xFF531E44);
  static const Color spiceJetAirline = Color(0xFFED1C24);
  static const Color akasaAirline = Color(0xFFFF5722);
}
