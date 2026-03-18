import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';

enum FastingType { ramadan, sunnah, qada, voluntary, other }

extension FastingTypeX on FastingType {
  String get label {
    final l10n = _fastingTypeL10n();
    switch (this) {
      case FastingType.ramadan:
        return l10n.fastingTypeRamadan;
      case FastingType.sunnah:
        return l10n.fastingTypeSunnah;
      case FastingType.qada:
        return l10n.fastingTypeQada;
      case FastingType.voluntary:
        return l10n.fastingTypeVoluntary;
      case FastingType.other:
        return l10n.fastingTypeOther;
    }
  }
}

AppLocalizations _fastingTypeL10n() {
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
