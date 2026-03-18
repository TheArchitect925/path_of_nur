import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';

enum FastingStatus { notFasting, intending, completed, broken }

extension FastingStatusX on FastingStatus {
  String get label {
    final l10n = _fastingStatusL10n();
    switch (this) {
      case FastingStatus.notFasting:
        return l10n.fastingStatusNotFasting;
      case FastingStatus.intending:
        return l10n.fastingStatusIntending;
      case FastingStatus.completed:
        return l10n.fastingStatusCompleted;
      case FastingStatus.broken:
        return l10n.fastingStatusBroken;
    }
  }
}

AppLocalizations _fastingStatusL10n() {
  final locale = Intl.getCurrentLocale().replaceAll('-', '_').split('_');
  return lookupAppLocalizations(
    Locale.fromSubtags(
      languageCode: locale.isNotEmpty && locale.first.isNotEmpty
          ? locale.first
          : 'en',
      countryCode: locale.length > 1 ? locale.last : null,
    ),
  );
}
