import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/occasion_theme.dart';
import '../../features/profile/application/profile_settings_provider.dart';
import '../state/user_profile_state.dart';
import 'daily_clock_provider.dart';
import 'special_mode_provider.dart';

/// An occasion the consent sheet can offer to dress the app for. Wire names
/// are persisted in [ProfileSettings.occasionOffersSeen] — never rename.
enum OccasionOfferKind {
  qadrNights('qadrNights'),
  eid('eid'),
  ramadan('ramadan'),
  jummah('jummah');

  const OccasionOfferKind(this.wireName);

  final String wireName;
}

/// The highest-ranked occasion active right now whose dress-up is off and
/// whose offer hasn't been shown yet — or null when there is nothing to ask.
/// Ordering mirrors the theme ladder so the sheet always offers the most
/// special thing happening.
final pendingOccasionOfferProvider = Provider<OccasionOfferKind?>((ref) {
  final settings = ref.watch(profileSettingsProvider);
  final specialMode = ref.watch(specialModeProvider);
  if (specialMode.isKids) return null;
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();

  // Never on someone's first day — let them meet the app before it starts
  // offering to dress itself up. Occasions come back around.
  final createdAt = DateTime.tryParse(
    ref.watch(userProfileProvider.select((user) => user.createdAtIso)),
  );
  if (createdAt == null) return null;
  final createdDay = DateTime(createdAt.year, createdAt.month, createdAt.day);
  final today = DateTime(now.year, now.month, now.day);
  if (!createdDay.isBefore(today)) return null;

  bool unseen(OccasionOfferKind kind) =>
      !settings.occasionOffersSeen.contains(kind.wireName);

  if (!settings.dressUpQadrNights &&
      unseen(OccasionOfferKind.qadrNights) &&
      isLaylatAlQadrNightAt(
        ramadanStartIso: settings.ramadanStartDateIso,
        ramadanEndIso: settings.ramadanEndDateIso,
        now: now,
      )) {
    return OccasionOfferKind.qadrNights;
  }
  if (!settings.dressUpEid &&
      unseen(OccasionOfferKind.eid) &&
      (isEidAlFitrAt(ramadanEndIso: settings.ramadanEndDateIso, now: now) ||
          isEidAlAdhaAt(now))) {
    return OccasionOfferKind.eid;
  }
  if (!settings.dressUpRamadan &&
      unseen(OccasionOfferKind.ramadan) &&
      (specialMode.isRamadan || specialMode.ramadanDateWindowActive)) {
    return OccasionOfferKind.ramadan;
  }
  if (!settings.dressUpFridays &&
      unseen(OccasionOfferKind.jummah) &&
      now.weekday == DateTime.friday) {
    return OccasionOfferKind.jummah;
  }
  return null;
});
