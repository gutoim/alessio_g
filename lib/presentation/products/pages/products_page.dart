import 'package:dummy_shop/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Placeholder. The paginated list and `ProductsBloc` replace it in the
/// products feature.
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(context.l10n.productsTitle)));
  }
}
