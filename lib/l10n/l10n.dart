import 'package:dummy_shop/l10n/gen/app_localizations.dart';
import 'package:flutter/widgets.dart';

export 'package:dummy_shop/l10n/gen/app_localizations.dart';

/// Shorthand for [AppLocalizations.of]: `context.l10n.appTitle`.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
