import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Hero tag shared by a product's list thumbnail and its detail gallery.
String productImageHeroTag(int productId) => 'product-image-$productId';

/// A product photo from the DummyJSON CDN, cached on disk, with a neutral
/// placeholder while it loads and an icon if it fails.
class ProductImage extends StatelessWidget {
  const ProductImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.previewUrl,
    super.key,
  });

  final String url;
  final BoxFit fit;

  /// A smaller image that is probably cached already (the list thumbnail),
  /// shown while [url] loads.
  final String? previewUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final emptyBox = ColoredBox(color: colors.surfaceContainerHighest);

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (_, _) => switch (previewUrl) {
        final previewUrl? => CachedNetworkImage(
          imageUrl: previewUrl,
          fit: fit,
          placeholder: (_, _) => emptyBox,
          errorWidget: (_, _, _) => emptyBox,
        ),
        null => emptyBox,
      },
      errorWidget: (_, _, _) => ColoredBox(
        color: colors.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
