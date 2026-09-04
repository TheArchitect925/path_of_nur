import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/nav_tabs.dart';
import '../../../../core/prayer/prayer_preferences.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/widgets/noor_glass_card.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../worship/application/prayer_controller.dart';
import '../../../worship/domain/prayer_name.dart';
import '../../../worship/domain/prayer_status.dart';

/// Compact five-prayer strip for the Mihrab Home: name, time, and offered
/// state per prayer at a glance. The full timings tracker lives on the
/// Ibadah tab — tapping the strip goes there.
class HomePrayerStrip extends ConsumerWidget {
  const HomePrayerStrip({super.key});

  static const List<String> _stripPrayerIds = <String>[
    'fajr',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final records = ref.watch(prayerControllerProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();

    bool isCompleted(String prayerId) {
      final prayerName = PrayerName.values
          .where((value) => value.name == prayerId)
          .firstOrNull;
      if (prayerName == null) return false;
      final record = records
          .where((item) => item.prayer == prayerName)
          .firstOrNull;
      return record?.status == PrayerStatus.completed;
    }

    return Semantics(
      button: true,
      label: l10n.worshipSectionLandingPrayerTitle,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.glassTile),
        onTap: () => goToTab(context, NavTab.worship),
        child: Row(
          children: [
            for (final prayerId in _stripPrayerIds) ...[
              Expanded(
                child: _PrayerStripTile(
                  name: localizedPrayerNameForDate(
                    prayerId: prayerId,
                    l10n: l10n,
                    date: now,
                  ),
                  time: scheduleContext.items
                      .where((item) => item.id == prayerId)
                      .firstOrNull
                      ?.offerTime,
                  completed: isCompleted(prayerId),
                  isNext: scheduleContext.nextPrayerId == prayerId,
                  isCurrent: scheduleContext.currentPrayerId == prayerId,
                ),
              ),
              if (prayerId != _stripPrayerIds.last)
                const SizedBox(width: AppSpacing.xs - 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrayerStripTile extends StatelessWidget {
  const _PrayerStripTile({
    required this.name,
    required this.time,
    required this.completed,
    required this.isNext,
    required this.isCurrent,
  });

  final String name;
  final String? time;
  final bool completed;
  final bool isNext;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    final subtle = appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurface;
    final success = appearance?.success ?? theme.colorScheme.tertiary;
    final highlighted = isNext || isCurrent;

    return NoorGlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xs + 1,
      ),
      surfaceVariant: AppSurfaceVariant.pill,
      borderRadius: AppRadii.glassTile,
      includeShadow: false,
      surfaceTintColor: highlighted ? accent : (completed ? success : null),
      surfaceAlphaOverride: highlighted ? 0.22 : (completed ? 0.14 : null),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: highlighted ? accent : subtle,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time ?? '—',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
              color: highlighted ? accent : subtle,
            ),
          ),
          const SizedBox(height: 3),
          completed
              ? Icon(Icons.check_rounded, size: 13, color: success)
              : Icon(
                  Icons.radio_button_unchecked_rounded,
                  size: 12,
                  color: highlighted ? accent : subtle.withValues(alpha: 0.55),
                ),
        ],
      ),
    );
  }
}
