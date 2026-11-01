import 'package:flutter/material.dart';

/// Typography adjustments on top of the Material 3 type scale.
abstract final class AppTypography {
  static TextTheme apply(TextTheme base) => base.copyWith(
    titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
  );
}
