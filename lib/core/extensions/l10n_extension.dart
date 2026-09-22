import 'package:flutter/widgets.dart';
import 'package:vstech_hrm/l10n/app_localizations.dart';

/// Extension on [BuildContext] for ergonomic access to localized messages.
extension AppLocalizationsX on BuildContext {
  /// Shorthand accessor for [AppLocalizations].
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
