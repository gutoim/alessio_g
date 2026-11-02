import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';

class DiscountBadge extends StatelessWidget {
  const DiscountBadge({required this.discountPercentage, super.key});

  final double discountPercentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.sm)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          context.l10n.discountBadge(discountPercentage.round()),
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}
