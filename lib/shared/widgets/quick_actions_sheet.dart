import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/prayer/prayer_preferences.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_surfaces.dart';
import '../../core/theme/app_theme.dart';
import '../../features/learn/quran/application/quran_providers.dart';
import '../../features/worship/application/dhikr_daily_goal_provider.dart';
import '../../features/worship/application/prayer_controller.dart';
import '../../features/worship/domain/prayer_name.dart';
import '../../features/worship/domain/prayer_status.dart';
import '../../l10n/app_localizations.dart';
import '../application/app_summary_providers.dart';
import '../application/daily_clock_provider.dart';
import '../persistence/local_store.dart';
import 'noor_glass_card.dart';
import '../../core/theme/app_icons.dart';

const String _quickActionsHintShownKey = 'home.quickActionsHintShown.v1';

/// The one global shortcut affordance that replaced the five per-tab
/// floating docks: hold the Home tab anywhere to open it.
Future<void> showQuickActionsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: false,
    builder: (context) => const QuickActionsSheet(),
  );
}

class QuickActionsSheet extends ConsumerWidget {
  const QuickActionsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final subtle = appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurface;

    final continueReading = ref.watch(quranContinueReadingSummaryProvider);
    final worship = ref.watch(worshipSummaryProvider);
    final scheduleContext = ref.watch(prayerScheduleContextProvider);
    final records = ref.watch(prayerControllerProvider);
    final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final countFormat = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );

    // The salah tile targets the open prayer window when there is one,
    // otherwise it points at the next prayer.
    final current = scheduleContext.items
        .where((item) => item.id == scheduleContext.currentPrayerId)
        .firstOrNull;
    final next = scheduleContext.items
        .where((item) => item.id == scheduleContext.nextPrayerId)
        .firstOrNull;
    final currentPrayerName = current == null
        ? null
        : PrayerName.values
              .where((value) => value.name == current.id)
              .firstOrNull;
    final currentCompleted =
        currentPrayerName != null &&
        records
                .where((record) => record.prayer == currentPrayerName)
                .firstOrNull
                ?.status ==
            PrayerStatus.completed;

    final String salahTitle;
    final String salahSubtitle;
    final VoidCallback salahAction;
    if (current != null && currentPrayerName != null && !currentCompleted) {
      final localized = localizedPrayerNameForDate(
        prayerId: current.id,
        l10n: l10n,
        date: now,
      );
      salahTitle = l10n.quickActionsMarkPrayer(localized);
      salahSubtitle = l10n.homeUntilTime(current.overdueAt);
      salahAction = () {
        ref
            .read(prayerControllerProvider.notifier)
            .markCompleted(currentPrayerName);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.quickActionsPrayerOffered(localized))),
        );
      };
    } else {
      final target = (currentCompleted ? next : (next ?? current));
      final localized = target == null
          ? ''
          : localizedPrayerNameForDate(
              prayerId: target.id,
              l10n: l10n,
              date: now,
            );
      salahTitle = current != null && currentCompleted
          ? l10n.quickActionsPrayerOffered(
              localizedPrayerNameForDate(
                prayerId: current.id,
                l10n: l10n,
                date: now,
              ),
            )
          : l10n.homeShortcutSalahLabel;
      salahSubtitle = target == null
          ? l10n.homeShortcutDailyCaption
          : l10n.quickActionsNextPrayerAt(localized, target.offerTime);
      salahAction = () {
        Navigator.of(context).pop();
        context.pushNamed('worshipPrayerPage');
      };
    }

    return SafeArea(
      // Six tiles now; scrollable so a large text scale shortens the sheet
      // instead of overflowing its 9/16-height constraint.
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s,
            0,
            AppSpacing.s,
            AppSpacing.s,
          ),
          child: NoorGlassCard(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.m + 2,
              AppSpacing.s,
              AppSpacing.m + 2,
              AppSpacing.m + 2,
            ),
            surfaceVariant: AppSurfaceVariant.panel,
            borderRadius: AppRadii.glassCard,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: subtle.withValues(alpha: 0.35),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  l10n.quickActionsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionTile(
                        icon: Icons.auto_stories_rounded,
                        title: l10n.quickActionsContinueReading,
                        subtitle: continueReading.locationLabel,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pushNamed(
                            'quranReader',
                            pathParameters: {
                              'surahNumber': '${continueReading.surahNumber}',
                            },
                            queryParameters: {
                              'ayah': '${continueReading.ayahNumber}',
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Expanded(
                      child: _QuickActionTile(
                        icon: Icons.favorite_outline_rounded,
                        title: l10n.homeShortcutDhikrLabel,
                        subtitle: l10n.homeFractionValue(
                          countFormat.format(worship.dhikrCount),
                          countFormat.format(ref.watch(dhikrDailyGoalProvider)),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pushNamed('worshipDhikrPage');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionTile(
                        icon: Icons.checklist_rounded,
                        title: salahTitle,
                        subtitle: salahSubtitle,
                        highlighted:
                            current != null &&
                            currentPrayerName != null &&
                            !currentCompleted,
                        onTap: salahAction,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Expanded(
                      child: _QuickActionTile(
                        icon: AppIcons.qibla,
                        title: l10n.homeShortcutQiblaLabel,
                        subtitle: l10n.worshipQiblaFinderSubtitle,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pushNamed('qiblaFinder');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                // Settings and search used to live only in the Home header, so
                // changing the adhan from inside the reader meant walking back
                // to Home first.
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionTile(
                        icon: Icons.settings_rounded,
                        title: l10n.settingsLandingTitle,
                        subtitle: l10n.quickActionsSettingsSubtitle,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pushNamed('settings');
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Expanded(
                      child: _QuickActionTile(
                        icon: Icons.search_rounded,
                        title: l10n.homeSearchTooltip,
                        subtitle: l10n.quickActionsSearchSubtitle,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pushNamed('allSearch');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  l10n.quickActionsHint,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(color: subtle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    final subtle = appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.glassTile),
      onTap: onTap,
      child: NoorGlassCard(
        padding: const EdgeInsets.all(AppSpacing.s + 2),
        surfaceVariant: AppSurfaceVariant.pill,
        borderRadius: AppRadii.glassTile,
        includeShadow: false,
        surfaceTintColor: highlighted ? accent : null,
        surfaceAlphaOverride: highlighted ? 0.2 : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: accent),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: subtle),
            ),
          ],
        ),
      ),
    );
  }
}

/// One-time discovery hint for the long-press gesture, mounted on Home.
class QuickActionsHintCoordinator extends ConsumerStatefulWidget {
  const QuickActionsHintCoordinator({super.key});

  @override
  ConsumerState<QuickActionsHintCoordinator> createState() =>
      _QuickActionsHintCoordinatorState();
}

class _QuickActionsHintCoordinatorState
    extends ConsumerState<QuickActionsHintCoordinator> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final store = ref.read(localStoreProvider);
      if (store.getBool(_quickActionsHintShownKey) ?? false) return;
      store.setBool(_quickActionsHintShownKey, true);
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.quickActionsDiscoveryHint),
          duration: const Duration(seconds: 5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
