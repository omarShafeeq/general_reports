import 'package:flutter/material.dart';
import 'package:general_reports/l10n/app_localizations.dart';

extension L10nExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
