import 'package:dio/dio.dart';
import 'package:dummy_shop/data/models/login_request_dto.dart';
import 'package:dummy_shop/data/models/login_response_dto.dart';
import 'package:dummy_shop/data/repositories/auth_repository_impl.dart';
import 'package:dummy_shop/data/sources/local/auth_status_source.dart';
import 'package:dummy_shop/data/sources/local/token_storage.dart';
import 'package:dummy_shop/data/sources/remote/auth_api.dart';
import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/domain/core/result.dart';
import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:dummy_shop/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthApi extends Mock implements AuthApi {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  const response = LoginResponseDto(
    id: 1,
    username: 'emilys',
    email: 'emily.johnson@x.dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    image: 'https://dummyjson.com/icon/emilys/128',
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
  );
  const storedTokens = (
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
  );

  late _MockAuthApi api;
  late _MockTokenStorage tokenStorage;
  late AuthStatusSource authStatus;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const LoginRequestDto(username: '', password: ''));
    const AuthTokens fallbackTokens = (accessToken: '', refreshToken: '');
    registerFallbackValue(fallbackTokens);
  });

  setUp(() {
    api = _MockAuthApi();
    tokenStorage = _MockTokenStorage();
    authStatus = AuthStatusSource();
    repository = AuthRepositoryImpl(api, tokenStorage, authStatus);

    when(() => tokenStorage.read()).thenAnswer((_) async => null);
    when(() => tokenStorage.save(any())).thenAnswer((_) async {});
    when(() => tokenStorage.clear()).thenAnswer((_) async {});
  });

  tearDown(() => authStatus.dispose());

  DioException loginRejected(int statusCode) {
    final requestOptions = RequestOptions(path: '/auth/login');
    return DioException(
      requestOptions: requestOptions,
      type: DioExceptionType.badResponse,
      response: Response<Object?>(
        requestOptions: requestOptions,
        statusCode: statusCode,
        data: {'message': 'Invalid credentials'},
      ),
    );
  }

  Future<Result<User>> login() =>
      repository.login(username: 'emilys', password: 'emilyspass');

  group('login', () {
    test(
      'sends the credentials, stores the tokens, returns the user',
      () async {
        when(() => api.login(any())).thenAnswer((_) async => response);

        final result = await login();

        expect(result, Result.ok(response.toDomain()));
        final request =
            verify(() => api.login(captureAny())).captured.single
                as LoginRequestDto;
        expect(request.toJson(), {
          'username': 'emilys',
          'password': 'emilyspass',
        });
        verify(() => tokenStorage.save(storedTokens)).called(1);
      },
    );

    test('maps a 400 to invalidCredentials and stores nothing', () async {
      when(() => api.login(any())).thenThrow(loginRejected(400));

      final result = await login();

      expect(result, const Result<User>.err(Failure.invalidCredentials()));
      verifyNever(() => tokenStorage.save(any()));
    });

    test('passes other failures through unchanged', () async {
      when(() => api.login(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(await login(), const Result<User>.err(Failure.network()));
    });

    test('fails with unknown when the tokens cannot be stored', () async {
      when(() => api.login(any())).thenAnswer((_) async => response);
      when(
        () => tokenStorage.save(any()),
      ).thenThrow(Exception('Keychain unavailable'));

      expect(await login(), const Result<User>.err(Failure.unknown()));
    });
  });

  group('logout', () {
    test('clears the stored tokens', () async {
      await repository.logout();

      verify(() => tokenStorage.clear()).called(1);
    });

    test('completes even when clearing the storage fails', () async {
      when(
        () => tokenStorage.clear(),
      ).thenThrow(Exception('Keychain unavailable'));

      await expectLater(repository.logout(), completes);
    });
  });

  group('watchStatus', () {
    test('starts unauthenticated when no tokens are stored', () async {
      expect(await repository.watchStatus().first, AuthStatus.unauthenticated);
    });

    test('starts authenticated when tokens are stored', () async {
      when(() => tokenStorage.read()).thenAnswer((_) async => storedTokens);

      expect(await repository.watchStatus().first, AuthStatus.authenticated);
    });

    test('emits every change caused by login and logout', () async {
      when(() => api.login(any())).thenAnswer((_) async => response);

      final statuses = expectLater(
        repository.watchStatus(),
        emitsInOrder([
          AuthStatus.unauthenticated,
          AuthStatus.authenticated,
          AuthStatus.unauthenticated,
        ]),
      );
      // Let the stream emit its initial status before changing it.
      await Future<void>.delayed(Duration.zero);

      await login();
      await repository.logout();

      await statuses;
    });

    test('does not emit when login fails', () async {
      when(() => api.login(any())).thenThrow(loginRejected(400));

      final statuses = <AuthStatus>[];
      final subscription = repository.watchStatus().listen(statuses.add);
      await Future<void>.delayed(Duration.zero);

      await login();
      await Future<void>.delayed(Duration.zero);
      await subscription.cancel();

      expect(statuses, [AuthStatus.unauthenticated]);
    });
  });
}
