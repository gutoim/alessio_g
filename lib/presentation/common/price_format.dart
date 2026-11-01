import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension PriceFormat on BuildContext {
  /// Formats a DummyJSON price (US dollars) for the current locale, for
  /// example `$8.94`.
  String formatPrice(double amount) => NumberFormat.simpleCurrency(
    locale: Localizations.localeOf(this).toLanguageTag(),
    name: 'USD',
  ).format(amount);
}
