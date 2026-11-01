import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/common/failure_message.dart';
import 'package:dummy_shop/res/app_dimens.dart';
import 'package:flutter/material.dart';

/// Full-screen error with a retry button, for when nothing can be shown.
class FailureView extends StatelessWidget {
  const FailureView({required this.failure, required this.onRetry, super.key});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                failure is NetworkFailure
                    ? Icons.wifi_off_rounded
                    : Icons.error_outline_rounded,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                failure.message(l10n),
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(l10n.retryButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
