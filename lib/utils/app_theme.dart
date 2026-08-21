import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Neon Magenta/Cyan Theme
  static const Color primaryColor = Color(0xFFFF2E93); // Neon Magenta
  static const Color secondaryColor = Color(0xFFFF6FB8); // Soft Pink
  static const Color accentColor = Color(0xFF22D9FF); // Neon Cyan
  static const Color backgroundColor = Color(0xFF07060B); // Near-Black Violet
  static const Color surfaceColor = Color(0xFF14111C); // Dark Violet-Grey
  static const Color cardColor = Color(0xFF201B2C); // Medium Violet-Grey
  static const Color textPrimaryColor = Color(0xFFFFFFFF); // White
  static const Color textSecondaryColor = Color(0xFFC2B8D6); // Lavender-Grey
  static const Color textMutedColor = Color(0xFF8A81A0); // Muted Lavender
  static const Color gradientStart = Color(0xFFFF2E93);
  static const Color gradientEnd = Color(0xFF22D9FF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        // background: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme:
          GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 64,
          fontWeight: FontWeight.w900,
          color: textPrimaryColor,
          letterSpacing: -2,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 48,
          fontWeight: FontWeight.w800,
          color: textPrimaryColor,
          letterSpacing: -1.5,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
          letterSpacing: -1,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textSecondaryColor,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textSecondaryColor,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textMutedColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: surfaceColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: GoogleFonts.inter(
          color: textSecondaryColor,
          fontSize: 14,
        ),
      ),
    );
  }
}
