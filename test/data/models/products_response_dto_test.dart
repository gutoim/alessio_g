import 'package:dummy_shop/data/models/products_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  test('maps a real page response to PaginatedProducts', () {
    // `GET /products?limit=2&skip=0`
    final page = ProductsResponseDto.fromJson(
      jsonFixture('products_page'),
    ).toDomain();

    expect(page.items.map((product) => product.id), [1, 2]);
    expect(page.items.first, testProduct);
    expect(page.skip, 0);
    expect(page.total, 194);
    expect(page.hasMore, isTrue);
  });

  test('maps the empty page DummyJSON returns past the end', () {
    final page = ProductsResponseDto.fromJson({
      'products': <Object>[],
      'total': 194,
      'skip': 500,
      'limit': 0,
    }).toDomain();

    expect(page.items, isEmpty);
    expect(page.hasMore, isFalse);
  });
}
