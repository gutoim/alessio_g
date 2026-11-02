import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/paginated_products.dart';
import 'package:dummy_shop/domain/entities/user.dart';
import 'package:dummy_shop/domain/use_cases/get_product_use_case.dart';
import 'package:dummy_shop/domain/use_cases/get_products_use_case.dart';
import 'package:dummy_shop/domain/use_cases/login_use_case.dart';
import 'package:dummy_shop/domain/use_cases/logout_use_case.dart';
import 'package:dummy_shop/domain/use_cases/watch_auth_status_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

/// Stubs or verifies a [LoginUseCase] call with any credentials.
Future<Result<User>> anyLogin(MockLoginUseCase useCase) => useCase(
  username: any(named: 'username'),
  password: any(named: 'password'),
);

class MockWatchAuthStatusUseCase extends Mock
    implements WatchAuthStatusUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

/// Stubs or verifies a [GetProductsUseCase] call for any page.
Future<Result<PaginatedProducts>> anyGetProducts(
  MockGetProductsUseCase useCase,
) => useCase(
  skip: any(named: 'skip'),
  limit: any(named: 'limit'),
);

class MockGetProductUseCase extends Mock implements GetProductUseCase {}
