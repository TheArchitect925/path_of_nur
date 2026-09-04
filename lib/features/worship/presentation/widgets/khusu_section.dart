import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../application/khusu_settings_controller.dart';
import '../../../../core/theme/app_icons.dart';

class KhusuSection extends ConsumerWidget {
  const KhusuSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(khusuSettingsControllerProvider);
    final notifier = ref.read(khusuSettingsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: l10n.khusuSectionTitle,
          subtitle: l10n.khusuSectionSubtitle,
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.khusuSectionIntroBody,
                style: TextStyle(
                  color: context.palette.onSurfaceSubtle,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _FocusCard(
          icon: AppIcons.khushu,
          title: l10n.khusuSalahFocusTitle,
          subtitle: l10n.khusuSalahFocusSubtitle,
        ),
        const SizedBox(height: 10),
        _FocusCard(
          icon: Icons.auto_awesome_rounded,
          title: l10n.khusuDhikrFocusTitle,
          subtitle: l10n.khusuDhikrFocusSubtitle,
        ),
        const SizedBox(height: 10),
        _FocusCard(
          icon: Icons.pause_circle_filled_rounded,
          title: l10n.khusuReflectionPauseTitle,
          subtitle: l10n.khusuReflectionPauseSubtitle,
        ),
        const SizedBox(height: 10),
        _FocusCard(
          icon: Icons.refresh_rounded,
          title: l10n.khusuQuietResetTitle,
          subtitle: l10n.khusuQuietResetSubtitle,
        ),
        const SizedBox(height: 14),
        SectionTitle(
          title: l10n.khusuSessionSettingsTitle,
          subtitle: l10n.khusuSessionSettingsSubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              _SettingRow(
                title: l10n.khusuReduceVisualDistractionsTitle,
                value: settings.reduceVisualDistractions,
                onChanged: notifier.setReduceVisualDistractions,
              ),
              const Divider(),
              _SettingRow(
                title: l10n.khusuMinimalInterfaceTitle,
                value: settings.minimalInterface,
                onChanged: notifier.setMinimalInterface,
              ),
              const Divider(),
              _SettingRow(
                title: l10n.khusuGentleRemindersTitle,
                value: settings.gentleReminders,
                onChanged: notifier.setGentleReminders,
              ),
              const Divider(),
              _SettingRow(
                title: l10n.khusuAmbientModeTitle,
                value: settings.ambientMode,
                onChanged: notifier.setAmbientMode,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: Text(
            l10n.khusuClosingQuote,
            style: TextStyle(
              color: context.palette.onSurfaceSubtle,
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.pushNamed('khusuFocus'),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                l10n.khusuEnterAction,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final iconStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      tintColor: context.palette.accent,
    );
    return PremiumCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: iconStyle
                .decoration(radius: AppSpacing.s, includeShadow: false)
                .copyWith(
                  color: AppSurfaceTheme.adaptiveColor(
                    context,
                    context.palette.accent,
                    alpha: 0.18,
                    solidAlphaWhenDisabled: 0.28,
                  ),
                  gradient: null,
                  border: Border.all(
                    color: AppSurfaceTheme.adaptiveColor(
                      context,
                      context.palette.accent,
                      alpha: 0.28,
                      solidAlphaWhenDisabled: 0.34,
                    ),
                  ),
                ),
            child: Icon(icon, color: context.palette.onSurface),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: context.palette.onSurfaceSubtle,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(color: context.palette.onSurfaceSubtle),
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
