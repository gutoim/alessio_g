import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/common/widgets/product_image.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';

/// Swipeable product photos with a page indicator.
///
/// The first photo is the Hero target of the list thumbnail, and shows that
/// (already cached) thumbnail until the full image has loaded.
class ProductGallery extends StatefulWidget {
  const ProductGallery({required this.product, super.key});

  final Product product;

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final urls = product.imageUrls.isEmpty
        ? [product.thumbnailUrl]
        : product.imageUrls;

    return Column(
      children: [
        ConstrainedBox(
          // Square on phones, capped on tablets.
          constraints: const BoxConstraints(maxHeight: 420),
          child: AspectRatio(
            aspectRatio: 1,
            child: PageView.builder(
              itemCount: urls.length,
              onPageChanged: (page) => setState(() => _page = page),
              itemBuilder: (context, index) {
                final image = ProductImage(
                  url: urls[index],
                  fit: BoxFit.contain,
                  previewUrl: index == 0 ? product.thumbnailUrl : null,
                );
                return index == 0
                    ? Hero(tag: productImageHeroTag(product.id), child: image)
                    : image;
              },
            ),
          ),
        ),
        if (urls.length > 1)
          Semantics(
            label: context.l10n.galleryPosition(_page + 1, urls.length),
            excludeSemantics: true,
            child: _PageDots(count: urls.length, current: _page),
          ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var index = 0; index < count; index++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              width: index == current ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == current
                    ? colors.primary
                    : colors.outlineVariant,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
            ),
        ],
      ),
    );
  }
}
