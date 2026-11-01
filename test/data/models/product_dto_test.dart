import 'package:dummy_shop/data/models/product_dto.dart';
import 'package:dummy_shop/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  Product parse(Map<String, dynamic> json) =>
      ProductDto.fromJson(json).toDomain();

  test('maps a real product response to a Product', () {
    expect(parse(jsonFixture('product')), testProduct);
  });

  group('a product without a brand and with an integer discount', () {
    // Product 26: `"discountPercentage": 1` and no `brand` key.
    final product = parse(jsonFixture('product_without_brand'));

    test('has no brand', () => expect(product.brand, isNull));

    test('reads the discount as a double', () {
      expect(product.discountPercentage, 1.0);
    });

    test('keeps the API stock status', () {
      expect(product.stockStatus, StockStatus.lowStock);
    });
  });

  group('stock status', () {
    StockStatus statusOf({String? availability, int stock = 5}) {
      final json = jsonFixture('product')
        ..['stock'] = stock
        ..['availabilityStatus'] = availability;
      return parse(json).stockStatus;
    }

    test('maps every value the API sends', () {
      expect(statusOf(availability: 'In Stock'), StockStatus.inStock);
      expect(statusOf(availability: 'Low Stock'), StockStatus.lowStock);
      expect(statusOf(availability: 'Out of Stock'), StockStatus.outOfStock);
    });

    test('falls back to the stock count for an unknown value', () {
      expect(
        statusOf(availability: 'Backorder', stock: 3),
        StockStatus.inStock,
      );
      // No availability status at all.
      expect(statusOf(stock: 0), StockStatus.outOfStock);
    });
  });

  test('accepts a product without images', () {
    final json = jsonFixture('product')..remove('images');

    expect(parse(json).imageUrls, isEmpty);
  });
}
