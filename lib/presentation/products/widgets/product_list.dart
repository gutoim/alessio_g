import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/presentation/products/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductList extends StatelessWidget {
  const ProductList({required this.products, super.key});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // Pull-to-refresh must work even when the list is shorter than the
      // screen.
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: products.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductTile(
          product: product,
          onTap: () => context.go(AppRoutes.productDetail(product.id)),
        );
      },
    );
  }
}
