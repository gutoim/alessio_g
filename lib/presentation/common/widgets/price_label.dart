import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/common/price_format.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';

/// The price to pay and, when discounted, the struck-through list price.
class PriceLabel extends StatelessWidget {
  const PriceLabel({required this.product, this.large = false, super.key});

  final Product product;

  /// Bigger text, for the detail page.
  final bool large;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = context.formatPrice(product.discountedPrice);
    final originalPrice = context.formatPrice(product.price);

    return Semantics(
      label: product.hasDiscount
          ? context.l10n.priceWithDiscount(price, originalPrice)
          : price,
      excludeSemantics: true,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: AppSpacing.sm,
        children: [
          Text(
            price,
            style:
                (large
                        ? theme.textTheme.headlineSmall
                        : theme.textTheme.titleMedium)
                    ?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
          ),
          if (product.hasDiscount)
            Text(
              originalPrice,
              style:
                  (large
                          ? theme.textTheme.bodyLarge
                          : theme.textTheme.bodySmall)
                      ?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        decoration: TextDecoration.lineThrough,
                      ),
            ),
        ],
      ),
    );
  }
}
