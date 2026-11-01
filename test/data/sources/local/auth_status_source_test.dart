import 'package:dummy_shop/data/sources/local/auth_status_source.dart';
import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthStatusSource source;

  setUp(() => source = AuthStatusSource());
  tearDown(() => source.dispose());

  test('broadcasts every change to all listeners', () async {
    final first = expectLater(
      source.changes,
      emitsInOrder([AuthStatus.authenticated, AuthStatus.unauthenticated]),
    );
    final second = expectLater(
      source.changes,
      emitsInOrder([AuthStatus.authenticated, AuthStatus.unauthenticated]),
    );

    source
      ..add(AuthStatus.authenticated)
      ..add(AuthStatus.unauthenticated);

    await Future.wait([first, second]);
  });
}
