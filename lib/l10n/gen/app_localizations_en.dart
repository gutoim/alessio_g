// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DummyJSON Shop';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get loginUsernameRequired => 'Enter your username';

  @override
  String get loginPasswordRequired => 'Enter your password';

  @override
  String get loginButton => 'Log in';

  @override
  String get loginInProgress => 'Logging in';

  @override
  String get logoutTooltip => 'Log out';

  @override
  String get productsTitle => 'Products';

  @override
  String get productsEmptyTitle => 'No products yet';

  @override
  String get productsEmptyMessage => 'Pull down to check again.';

  @override
  String productsEndOfList(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'That\'s all $count products',
      one: 'That\'s the only product',
    );
    return '$_temp0';
  }

  @override
  String get retryButton => 'Try again';

  @override
  String priceWithDiscount(String price, String originalPrice) {
    return '$price, reduced from $originalPrice';
  }

  @override
  String ratingLabel(String rating) {
    return 'Rated $rating out of 5';
  }

  @override
  String get productDetailTitle => 'Product details';

  @override
  String get failureInvalidCredentials => 'Wrong username or password.';

  @override
  String get failureNetwork =>
      'No internet connection. Check your connection and try again.';

  @override
  String get failureUnauthorized =>
      'Your session has expired. Please log in again.';

  @override
  String get failureNotFound => 'We couldn\'t find what you were looking for.';

  @override
  String get failureServer =>
      'Something went wrong on our side. Please try again.';

  @override
  String get failureUnknown => 'Something went wrong. Please try again.';
}
