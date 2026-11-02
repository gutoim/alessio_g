import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/common/widgets/price_label.dart';
import 'package:dummy_shop/presentation/common/widgets/rating_label.dart';
import 'package:dummy_shop/presentation/product_detail/widgets/discount_badge.dart';
import 'package:dummy_shop/presentation/product_detail/widgets/product_gallery.dart';
import 'package:dummy_shop/presentation/product_detail/widgets/stock_label.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      children: [
        ProductGallery(product: product),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.brand case final brand?)
                Text(
                  brand,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              Text(product.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                children: [
                  RatingLabel(rating: product.rating),
                  StockLabel(product: product),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(child: PriceLabel(product: product, large: true)),
                  if (product.hasDiscount)
                    DiscountBadge(
                      discountPercentage: product.discountPercentage,
                    ),
                ],
              ),
              const Divider(height: AppSpacing.xl),
              Text(
                l10n.productDescriptionTitle,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(product.description, style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.md),
              Chip(
                avatar: const Icon(Icons.sell_outlined, size: 18),
                label: Text(_categoryName(product.category)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// `mens-shirts` -> `Mens shirts`.
  static String _categoryName(String slug) {
    final words = slug.replaceAll('-', ' ');
    return words.isEmpty ? words : words[0].toUpperCase() + words.substring(1);
  }
}
