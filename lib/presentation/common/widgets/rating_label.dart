import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';

/// A star with the average rating, for example ★ 4.6.
class RatingLabel extends StatelessWidget {
  const RatingLabel({required this.rating, super.key});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = rating.toStringAsFixed(1);

    return Semantics(
      label: context.l10n.ratingLabel(value),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 18, color: Colors.amber.shade700),
          const SizedBox(width: AppSpacing.xs),
          Text(value, style: theme.textTheme.labelLarge),
        ],
      ),
    );
  }
}
