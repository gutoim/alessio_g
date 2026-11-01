import 'package:dummy_shop/domain/core/failure.dart';
import 'package:dummy_shop/l10n/l10n.dart';
import 'package:dummy_shop/presentation/common/failure_message.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  test('gives every failure its own message', () {
    const failures = [
      Failure.network(),
      Failure.invalidCredentials(),
      Failure.unauthorized(),
      Failure.notFound(),
      Failure.server(statusCode: 500, message: 'Internal error'),
      Failure.unknown(),
    ];

    final messages = failures.map((failure) => failure.message(l10n)).toSet();

    expect(messages, hasLength(failures.length));
  });

  test('does not show the raw API message for server errors', () {
    const failure = Failure.server(statusCode: 500, message: 'Internal error');

    expect(failure.message(l10n), l10n.failureServer);
  });
}
