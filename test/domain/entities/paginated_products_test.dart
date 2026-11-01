import 'package:dummy_shop/domain/entities/paginated_products.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  PaginatedProducts page({
    required int skip,
    required int count,
    int total = 194,
  }) => PaginatedProducts(
    items: List.filled(count, testProduct),
    skip: skip,
    total: total,
  );

  group('hasMore', () {
    test('is true while products remain after this page', () {
      expect(page(skip: 0, count: 20).hasMore, isTrue);
      expect(page(skip: 160, count: 20).hasMore, isTrue);
    });

    test('is false on the last page', () {
      // 180 + 14 = 194
      expect(page(skip: 180, count: 14).hasMore, isFalse);
    });

    test('is false for an empty page, even if total says otherwise', () {
      expect(page(skip: 40, count: 0).hasMore, isFalse);
    });
  });
}
