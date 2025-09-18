import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color _deepTeal = Color(0xFF205781);
  static const Color _aquaTeal = Color(0xFF4F959D);
  static const Color _mistGreen = Color(0xFF98D2C0);
  static const Color _softSand = Color(0xFFF6F8D5);
  static const Color _ink = Color(0xFF0B1F2A);

  static ThemeData get light {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: _deepTeal,
      brightness: Brightness.light,
    );

    final colorScheme = baseScheme.copyWith(
      primary: _deepTeal,
      onPrimary: Colors.white,
      secondary: _aquaTeal,
      onSecondary: Colors.white,
      tertiary: _mistGreen,
      onTertiary: _ink,
      surface: Colors.white,
      surfaceTint: _deepTeal,
      onSurface: _ink,
    );

    final textTheme = ThemeData.light().textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ).copyWith(
          headlineMedium: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          titleLarge: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          bodyLarge: const TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: _softSand,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        surfaceTintColor: colorScheme.primary.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2,
        margin: const EdgeInsets.all(16),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primary.withValues(alpha: 0.12),
        labelStyle: textTheme.bodyMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        selectedLabelTextStyle: textTheme.titleSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
      ),
    );
  }
}
