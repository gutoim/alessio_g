import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/presentation/common/widgets/price_label.dart';
import 'package:dummy_shop/presentation/common/widgets/product_image.dart';
import 'package:dummy_shop/presentation/common/widgets/rating_label.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({required this.product, required this.onTap, super.key});

  static const double _thumbnailSize = 72;

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flies into the detail page's gallery.
            Hero(
              tag: productImageHeroTag(product.id),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppRadius.sm),
                ),
                child: SizedBox.square(
                  dimension: _thumbnailSize,
                  child: ProductImage(url: product.thumbnailUrl),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.brand case final brand?)
                    Text(
                      brand,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(child: PriceLabel(product: product)),
                      RatingLabel(rating: product.rating),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
