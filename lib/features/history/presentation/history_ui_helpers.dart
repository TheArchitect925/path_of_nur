import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/hijri_date_utils.dart';
import '../domain/historical_event_models.dart';

String historicalCategoryLabel(
  AppLocalizations l10n,
  HistoricalEventCategory category,
) {
  switch (category) {
    case HistoricalEventCategory.seerah:
      return l10n.historyCategorySeerah;
    case HistoricalEventCategory.battles:
      return l10n.historyCategoryBattles;
    case HistoricalEventCategory.prophets:
      return l10n.historyCategoryProphets;
    case HistoricalEventCategory.revelation:
      return l10n.historyCategoryRevelation;
    case HistoricalEventCategory.khulafa:
      return l10n.historyCategoryKhulafa;
    case HistoricalEventCategory.scholars:
      return l10n.historyCategoryScholars;
    case HistoricalEventCategory.islamicHistory:
      return l10n.historyCategoryIslamicHistory;
    case HistoricalEventCategory.worldHistory:
      return l10n.historyCategoryWorldHistory;
    case HistoricalEventCategory.births:
      return l10n.historyCategoryBirths;
    case HistoricalEventCategory.deaths:
      return l10n.historyCategoryDeaths;
    case HistoricalEventCategory.sacredPlaces:
      return l10n.historyCategorySacredPlaces;
  }
}

String formatHistoricalGregorianDate(
  BuildContext context,
  AppLocalizations l10n,
  HistoricalEventDate date,
) {
  if (date.month == null || date.day == null || date.year == null) {
    return date.display ?? l10n.historyDateUnknown;
  }
  final locale = Localizations.localeOf(context).toLanguageTag();
  final reference = DateTime(date.year!, date.month!, date.day!);
  return l10n.historyGregorianDateValue(
    DateFormat.d(locale).format(reference),
    DateFormat.MMMM(locale).format(reference),
    NumberFormat.decimalPattern(locale).format(date.year),
  );
}

String formatHistoricalHijriDate(
  BuildContext context,
  AppLocalizations l10n,
  HistoricalEventDate date,
) {
  if (date.month == null || date.day == null || date.year == null) {
    return date.display ?? l10n.historyDateUnknown;
  }
  final locale = Localizations.localeOf(context).toLanguageTag();
  return l10n.historyHijriDateValue(
    NumberFormat.decimalPattern(locale).format(date.day),
    hijriMonthName(l10n, date.month!),
    NumberFormat.decimalPattern(locale).format(date.year),
  );
}

String formatTodayGregorianDate(
  BuildContext context,
  AppLocalizations l10n,
  DateTime date,
) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return l10n.historyTodayGregorianValue(
    DateFormat.d(locale).format(date),
    DateFormat.MMMM(locale).format(date),
    NumberFormat.decimalPattern(locale).format(date.year),
  );
}

String formatTodayHijriDate(
  BuildContext context,
  AppLocalizations l10n,
  HijriDateParts date,
) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return l10n.historyTodayHijriValue(
    NumberFormat.decimalPattern(locale).format(date.day),
    hijriMonthName(l10n, date.month),
    NumberFormat.decimalPattern(locale).format(date.year),
  );
}

String historicalMatchLabel(AppLocalizations l10n, HistoricalTodayMatch match) {
  if (match.matchesGregorian && match.matchesHijri) {
    return l10n.historyMatchBadgeBoth;
  }
  if (match.matchesHijri) {
    return l10n.historyMatchBadgeHijri;
  }
  return l10n.historyMatchBadgeGregorian;
}

String historyDateConfidenceLabel(
  AppLocalizations l10n,
  HistoricalDateConfidence confidence,
) {
  switch (confidence) {
    case HistoricalDateConfidence.approximate:
      return l10n.historyDateConfidenceApproximate;
    case HistoricalDateConfidence.disputed:
      return l10n.historyDateConfidenceDisputed;
    case HistoricalDateConfidence.exact:
      return l10n.historyDateConfidenceExact;
  }
}
