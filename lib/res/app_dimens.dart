/// Spacing scale in logical pixels. Use these instead of magic numbers.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Corner radii.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}

/// Fixed component sizes.
abstract final class AppSizes {
  /// Minimum height of tappable controls (Material accessibility guideline).
  static const double minTouchTarget = 48;
}
