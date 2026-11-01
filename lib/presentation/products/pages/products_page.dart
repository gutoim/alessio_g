import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/common/failure_message.dart';
import 'package:dummy_shop/presentation/common/widgets/failure_view.dart';
import 'package:dummy_shop/presentation/common/widgets/loading_view.dart';
import 'package:dummy_shop/presentation/products/bloc/products_bloc.dart';
import 'package:dummy_shop/presentation/products/bloc/products_event.dart';
import 'package:dummy_shop/presentation/products/bloc/products_state.dart';
import 'package:dummy_shop/presentation/products/widgets/product_list.dart';
import 'package:dummy_shop/presentation/products/widgets/products_empty_view.dart';
import 'package:dummy_shop/presentation/session/bloc/session_bloc.dart';
import 'package:dummy_shop/presentation/session/bloc/session_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Product list. Expects a [ProductsBloc] above it (provided by the router).
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productsTitle),
        actions: [
          IconButton(
            tooltip: l10n.logoutTooltip,
            icon: const Icon(Icons.logout),
            // The router's guard returns to login once the session ends.
            onPressed: () => context.read<SessionBloc>().add(
              const SessionEvent.logoutRequested(),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listenWhen: (previous, current) =>
            current is ProductsLoaded &&
            current.refreshFailure != null &&
            (previous is! ProductsLoaded ||
                previous.refreshFailure != current.refreshFailure),
        listener: (context, state) {
          final failure = (state as ProductsLoaded).refreshFailure!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(failure.message(l10n))));
        },
        builder: (context, state) => switch (state) {
          ProductsLoading() => const LoadingView(),
          ProductsFailure(:final failure) => FailureView(
            failure: failure,
            onRetry: () => context.read<ProductsBloc>().add(
              const ProductsEvent.loadRequested(),
            ),
          ),
          ProductsLoaded(:final products) => RefreshIndicator(
            onRefresh: () => _refresh(context.read<ProductsBloc>()),
            child: products.isEmpty
                ? const ProductsEmptyView()
                : ProductList(products: products),
          ),
        },
      ),
    );
  }

  /// Completes when the refresh is over, which hides the indicator.
  static Future<void> _refresh(ProductsBloc bloc) {
    bloc.add(const ProductsEvent.refreshRequested());
    return bloc.stream.firstWhere(
      (state) => state is! ProductsLoaded || !state.isRefreshing,
      orElse: () => bloc.state,
    );
  }
}
