import 'package:freezed_annotation/freezed_annotation.dart';

part 'products_event.freezed.dart';

@freezed
sealed class ProductsEvent with _$ProductsEvent {
  /// Loads the first page with a full-screen spinner: on open and on retry.
  const factory ProductsEvent.loadRequested() = ProductsLoadRequested;

  /// Pull-to-refresh: reloads the first page while the list stays visible.
  const factory ProductsEvent.refreshRequested() = ProductsRefreshRequested;
}
