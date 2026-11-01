import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/session/bloc/session_bloc.dart';
import 'package:dummy_shop/presentation/session/bloc/session_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Placeholder. The paginated list and `ProductsBloc` replace it in the
/// products feature.
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
    );
  }
}
