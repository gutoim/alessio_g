import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/common/widgets/empty_view.dart';
import 'package:flutter/material.dart';

/// The empty state, inside a scroll view so pull-to-refresh still works.
class ProductsEmptyView extends StatelessWidget {
  const ProductsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyView(
            icon: Icons.inventory_2_outlined,
            title: l10n.productsEmptyTitle,
            message: l10n.productsEmptyMessage,
          ),
        ),
      ],
    );
  }
}
