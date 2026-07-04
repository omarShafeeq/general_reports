import 'package:flutter/material.dart';
import 'package:general_reports/core/constants/app_sizes.dart';
import 'package:general_reports/theme/color_schemes.dart';

abstract final class AppTheme {
  static ThemeData light() => _buildTheme(AppColorSchemes.light);
  static ThemeData dark() => _buildTheme(AppColorSchemes.dark);

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final bool isDark = colorScheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? colorScheme.surface
          : colorScheme.surfaceContainerLowest,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          side: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(80),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: colorScheme.onPrimaryContainer),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withAlpha(80),
        space: 1,
      ),
    );
  }
}
