import 'package:flutter/material.dart';

/// Brand and status colors.
///
/// The full light and dark color schemes are derived from [seed] with
/// Material 3's tonal palettes, so both modes stay consistent. The status
/// colors are for meanings Material 3 has no role for.
abstract final class AppColors {
  static const Color seed = Color(0xFF3D5AFE);

  /// Rating stars.
  static const Color rating = Color(0xFFFFA000);

  /// Positive status, such as "In stock".
  static const Color success = Color(0xFF2E7D32);

  /// Attention status, such as "Only 3 left".
  static const Color warning = Color(0xFFE65100);
}
