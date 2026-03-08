import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../application/khusu_settings_controller.dart';

class KhusuSection extends ConsumerWidget {
  const KhusuSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(khusuSettingsControllerProvider);
    final notifier = ref.read(khusuSettingsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Khusū Mode',
          subtitle: 'A calm space to reduce noise and return to presence.',
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Set intention, slow your breathing, and let worship be your anchor.',
                style: TextStyle(
                  color: AppColors.onSurfaceSubtle,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _FocusCard(
          icon: Icons.spa_outlined,
          title: 'Prayer Focus',
          subtitle: 'A minimal countdown and reminder card for one prayer window.',
        ),
        const SizedBox(height: 10),
        _FocusCard(
          icon: Icons.auto_awesome,
          title: 'Dhikr Focus',
          subtitle: 'Close-opened dhikr flow with a clean breathing rhythm.',
        ),
        const SizedBox(height: 10),
        _FocusCard(
          icon: Icons.pause_circle_filled_outlined,
          title: 'Reflection Pause',
          subtitle: 'A short pause with one reflective line and silence.',
        ),
        const SizedBox(height: 10),
        _FocusCard(
          icon: Icons.refresh_rounded,
          title: 'Quiet Reset',
          subtitle: 'Restart focus with gentle re-entry if attention drifted.',
        ),
        const SizedBox(height: 14),
        const SectionTitle(
          title: 'Session Settings',
          subtitle: 'Environment controls for distraction-light use.',
        ),
        PremiumCard(
          child: Column(
            children: [
              _SettingRow(
                title: 'Reduce visual distractions',
                value: settings.reduceVisualDistractions,
                onChanged: notifier.setReduceVisualDistractions,
              ),
              const Divider(),
              _SettingRow(
                title: 'Minimal interface',
                value: settings.minimalInterface,
                onChanged: notifier.setMinimalInterface,
              ),
              const Divider(),
              _SettingRow(
                title: 'Gentle reminders',
                value: settings.gentleReminders,
                onChanged: notifier.setGentleReminders,
              ),
              const Divider(),
              _SettingRow(
                title: 'Ambient mode',
                value: settings.ambientMode,
                onChanged: notifier.setAmbientMode,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PremiumCard(
          child: const Text(
            '“Pause without forcing. Breath settles, intention settles, and remembrance becomes softer.”',
            style: TextStyle(
              color: AppColors.onSurfaceSubtle,
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
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Enter Khusū', style: TextStyle(fontSize: 16)),
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
    return PremiumCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.s),
              color: AppColors.accentGold.withValues(alpha: 0.18),
            ),
            child: Icon(icon, color: AppColors.onSurface),
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
                  style: const TextStyle(
                    color: AppColors.onSurfaceSubtle,
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
            style: const TextStyle(color: AppColors.onSurfaceSubtle),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
