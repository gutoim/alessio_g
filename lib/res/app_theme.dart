import 'package:dummy_shop/res/app_colors.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:dummy_shop/res/app_typography.dart';
import 'package:flutter/material.dart';

/// Light and dark [ThemeData] built from the design tokens in `res/`.
abstract final class AppTheme {
  static final ThemeData light = _build(Brightness.light);
  static final ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );
    final base = ThemeData(colorScheme: colorScheme);

    return base.copyWith(
      textTheme: AppTypography.apply(base.textTheme),
      appBarTheme: const AppBarThemeData(centerTitle: false),
      cardTheme: const CardThemeData(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
      ),
      inputDecorationTheme: const InputDecorationThemeData(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
        ),
      ),
    );
  }
}
