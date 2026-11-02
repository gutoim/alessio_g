import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/common/widgets/failure_view.dart';
import 'package:dummy_shop/presentation/common/widgets/loading_view.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_bloc.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_event.dart';
import 'package:dummy_shop/presentation/product_detail/bloc/product_detail_state.dart';
import 'package:dummy_shop/presentation/product_detail/widgets/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Product detail screen. Expects a [ProductDetailBloc] above it (provided by
/// the router).
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.productDetailTitle)),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) => switch (state) {
          ProductDetailLoading() => const LoadingView(),
          ProductDetailFailure(:final failure) => FailureView(
            failure: failure,
            onRetry: () => context.read<ProductDetailBloc>().add(
              ProductDetailEvent.loadRequested(productId),
            ),
          ),
          ProductDetailLoaded(:final product) => ProductDetailsView(
            product: product,
          ),
        },
      ),
    );
  }
}
