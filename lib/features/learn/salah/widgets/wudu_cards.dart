import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../models/wudu_models.dart';

class WuduHeroCard extends StatelessWidget {
  const WuduHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.note,
  });

  final String title;
  final String subtitle;
  final String note;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Text(
              note,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WuduVerseCard extends StatelessWidget {
  const WuduVerseCard({
    super.key,
    required this.verse,
    required this.reference,
  });

  final String verse;
  final String reference;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Qur’an basis',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            verse,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 10),
          Text(
            reference,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class WuduStepCard extends StatelessWidget {
  const WuduStepCard({super.key, required this.step});

  final WuduStep step;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          leading: _StepBadge(number: step.number),
          title: Text(
            step.title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _IconPill(icon: _iconFor(step.iconKey)),
                if (step.repeatCount == 3) _RepeatBadge(label: 'Repeat 3x'),
              ],
            ),
          ),
          children: [
            Text(
              step.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String key) {
    switch (key) {
      case 'intention':
        return Icons.favorite_outline_rounded;
      case 'bismillah':
        return Icons.record_voice_over_rounded;
      case 'hands':
        return Icons.front_hand_outlined;
      case 'mouth':
        return Icons.mood_rounded;
      case 'nose':
        return Icons.air_rounded;
      case 'face':
        return Icons.face_retouching_natural_rounded;
      case 'arm_right':
      case 'arm_left':
        return Icons.accessibility_new_rounded;
      case 'head':
        return Icons.self_improvement_rounded;
      case 'ears':
        return Icons.hearing_rounded;
      case 'foot_right':
      case 'foot_left':
        return Icons.directions_walk_rounded;
      default:
        return Icons.water_drop_outlined;
    }
  }
}

class WuduReminderCard extends StatelessWidget {
  const WuduReminderCard({
    super.key,
    required this.requiredEssentials,
    required this.sunnahEnhancements,
    required this.reminders,
  });

  final List<String> requiredEssentials;
  final List<String> sunnahEnhancements;
  final List<String> reminders;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Required vs Sunnah',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              _SectionList(
                title: 'Required essentials',
                items: requiredEssentials,
                icon: Icons.check_circle_outline_rounded,
              ),
              const SizedBox(height: 10),
              _SectionList(
                title: 'Sunnah enhancements',
                items: sunnahEnhancements,
                icon: Icons.auto_awesome_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Important reminders',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ...reminders.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Icon(Icons.circle, size: 8),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WuduDuaCard extends StatelessWidget {
  const WuduDuaCard({super.key, required this.dua});

  final WuduDua dua;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'After Wudu Dua',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          WuduArabicText(text: dua.arabic),
          const SizedBox(height: 10),
          Text(
            dua.transliteration,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            dua.translation,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class WuduCompletionCard extends StatelessWidget {
  const WuduCompletionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Completion',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'You now have a complete end-to-end Wudu sequence. Review calmly and repeat until each step feels natural before salah.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}

class WuduArabicText extends StatelessWidget {
  const WuduArabicText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.quranVerse(size: 29).copyWith(
      height: 1.85,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurface,
    );

    return Text(
      text,
      style: style,
      textAlign: textAlignForContent(text),
      textDirection: textDirectionForContent(text),
      strutStyle: StrutStyle(
        fontFamily: style.fontFamily,
        fontSize: style.fontSize,
        height: style.height,
        forceStrutHeight: true,
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.16),
      ),
      child: Text(
        '$number',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _RepeatBadge extends StatelessWidget {
  const _RepeatBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _IconPill extends StatelessWidget {
  const _IconPill({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Icon(icon, size: 16),
    );
  }
}

class _SectionList extends StatelessWidget {
  const _SectionList({
    required this.title,
    required this.items,
    required this.icon,
  });

  final String title;
  final List<String> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text('• $item'),
          ),
        ),
      ],
    );
  }
}
