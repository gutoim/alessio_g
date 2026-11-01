import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('discountedPrice', () {
    test('applies the discount and rounds to cents', () {
      // 9.99 - 10.48% = 8.943048
      expect(testProduct.discountedPrice, 8.94);
    });

    test('equals the price without a discount', () {
      final product = testProduct.copyWith(discountPercentage: 0);

      expect(product.discountedPrice, product.price);
      expect(product.hasDiscount, isFalse);
    });
  });

  test('hasDiscount is true for any positive discount', () {
    expect(testProduct.hasDiscount, isTrue);
  });
}
