import 'package:dummy_shop/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Placeholder. The product details and `ProductDetailBloc` replace it in the
/// product detail feature.
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.productDetailTitle)),
    );
  }
}
