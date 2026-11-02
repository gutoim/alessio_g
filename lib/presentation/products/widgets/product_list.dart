import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/presentation/app/router/app_routes.dart';
import 'package:dummy_shop/presentation/products/widgets/product_list_footer.dart';
import 'package:dummy_shop/presentation/products/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The products, with infinite scrolling: [onLoadMore] is called when the
/// user gets close to the end and more products exist.
class ProductList extends StatefulWidget {
  const ProductList({
    required this.products,
    required this.hasMore,
    required this.onLoadMore,
    this.isLoadingMore = false,
    this.loadMoreFailure,
    super.key,
  });

  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;
  final Failure? loadMoreFailure;
  final VoidCallback onLoadMore;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  /// How close to the end (in logical pixels) the next page starts loading,
  /// so it usually arrives before the user reaches the bottom.
  static const double _loadMoreThreshold = 600;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreIfNearEnd);
    _checkAfterLayout();
  }

  @override
  void didUpdateWidget(ProductList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A short page may not fill the screen, so there is nothing to scroll.
    // Check again once the new items are laid out.
    _checkAfterLayout();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _checkAfterLayout() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadMoreIfNearEnd());

  void _loadMoreIfNearEnd() {
    if (!mounted || !_scrollController.hasClients) return;
    // After a failure only the retry button loads again, so scrolling does
    // not fire request after request while offline.
    if (!widget.hasMore ||
        widget.isLoadingMore ||
        widget.loadMoreFailure != null) {
      return;
    }
    if (_scrollController.position.extentAfter < _loadMoreThreshold) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.products;
    final footer = _footer();

    return ListView.separated(
      controller: _scrollController,
      // Pull-to-refresh must work even when the list is shorter than the
      // screen.
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: products.length + (footer == null ? 0 : 1),
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == products.length) return footer;
        final product = products[index];
        return ProductTile(
          product: product,
          // The product goes along so the detail page can show it at once.
          onTap: () =>
              context.go(AppRoutes.productDetail(product.id), extra: product),
        );
      },
    );
  }

  Widget? _footer() {
    if (widget.loadMoreFailure case final failure?) {
      return ProductListFooter.failure(
        failure: failure,
        onRetry: widget.onLoadMore,
      );
    }
    if (widget.isLoadingMore) return const ProductListFooter.loading();
    if (!widget.hasMore) {
      return ProductListFooter.end(productCount: widget.products.length);
    }
    return null;
  }
}
