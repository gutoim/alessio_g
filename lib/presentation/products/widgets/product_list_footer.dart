import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/common/failure_message.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';

/// What sits under the last product: a spinner while the next page loads,
/// the error with a retry, or the end of the list.
class ProductListFooter extends StatelessWidget {
  const ProductListFooter.loading({super.key})
    : failure = null,
      onRetry = null,
      productCount = null;

  const ProductListFooter.failure({
    required Failure this.failure,
    required VoidCallback this.onRetry,
    super.key,
  }) : productCount = null;

  const ProductListFooter.end({required int this.productCount, super.key})
    : failure = null,
      onRetry = null;

  final Failure? failure;
  final VoidCallback? onRetry;
  final int? productCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: switch ((failure, productCount)) {
          (final failure?, _) => Column(
            children: [
              Text(
                failure.message(l10n),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(l10n.retryButton),
              ),
            ],
          ),
          (_, final count?) => Text(
            l10n.productsEndOfList(count),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          _ => const SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        },
      ),
    );
  }
}
