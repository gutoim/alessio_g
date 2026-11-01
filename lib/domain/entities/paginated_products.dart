import 'package:dummy_shop/domain/entities/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_products.freezed.dart';

/// One page of the product catalog.
@freezed
abstract class PaginatedProducts with _$PaginatedProducts {
  const factory PaginatedProducts({
    required List<Product> items,

    /// How many products come before this page.
    required int skip,

    /// Size of the whole catalog.
    required int total,
  }) = _PaginatedProducts;

  const PaginatedProducts._();

  /// Whether another page exists after this one. An empty page always ends
  /// the list, so a wrong `total` can never cause endless loading.
  bool get hasMore => items.isNotEmpty && skip + items.length < total;
}
