import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/res/app_colors.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';

class StockLabel extends StatelessWidget {
  const StockLabel({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final (icon, color, text) = switch (product.stockStatus) {
      StockStatus.inStock => (
        Icons.check_circle_outline_rounded,
        AppColors.success,
        l10n.stockIn,
      ),
      StockStatus.lowStock => (
        Icons.timelapse_rounded,
        AppColors.warning,
        l10n.stockLow(product.stock),
      ),
      StockStatus.outOfStock => (
        Icons.remove_shopping_cart_outlined,
        theme.colorScheme.error,
        l10n.stockOut,
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(text, style: theme.textTheme.labelLarge?.copyWith(color: color)),
      ],
    );
  }
}
