import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A product photo from the DummyJSON CDN, cached on disk, with a neutral
/// placeholder while it loads and an icon if it fails.
class ProductImage extends StatelessWidget {
  const ProductImage({required this.url, this.fit = BoxFit.cover, super.key});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (_, _) => ColoredBox(color: colors.surfaceContainerHighest),
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
