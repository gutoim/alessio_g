import 'dart:convert';
import 'dart:io';

import 'package:dummy_shop/domain/entities/paginated_products.dart';
import 'package:dummy_shop/domain/entities/product.dart';
import 'package:dummy_shop/domain/entities/user.dart';

const testUser = User(
  id: 1,
  username: 'emilys',
  email: 'emily.johnson@x.dummyjson.com',
  firstName: 'Emily',
  lastName: 'Johnson',
  imageUrl: 'https://dummyjson.com/icon/emilys/128',
);

/// A real DummyJSON response saved in `test/fixtures/<name>.json`.
Map<String, dynamic> jsonFixture(String name) =>
    jsonDecode(File('test/fixtures/$name.json').readAsStringSync())
        as Map<String, dynamic>;

/// Product 1 of the DummyJSON catalog (`test/fixtures/product.json`).
const testProduct = Product(
  id: 1,
  title: 'Essence Mascara Lash Princess',
  description:
      'The Essence Mascara Lash Princess is a popular mascara known for its '
      'volumizing and lengthening effects. Achieve dramatic lashes with this '
      'long-lasting and cruelty-free formula.',
  category: 'beauty',
  price: 9.99,
  discountPercentage: 10.48,
  rating: 2.56,
  stock: 99,
  stockStatus: StockStatus.inStock,
  thumbnailUrl:
      'https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp',
  imageUrls: [
    'https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp',
  ],
  brand: 'Essence',
);

/// A second, different product (no discount, no brand).
final otherProduct = testProduct.copyWith(
  id: 26,
  title: 'Green Chili Pepper',
  category: 'groceries',
  price: 0.99,
  discountPercentage: 0,
  brand: null,
);

/// A page of [items] starting at [skip], out of a catalog of [total].
PaginatedProducts productsPage(
  List<Product> items, {
  int skip = 0,
  int total = 194,
}) => PaginatedProducts(items: items, skip: skip, total: total);
