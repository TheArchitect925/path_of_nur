import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../domain/kids_arabic_models.dart';
import '../../../core/theme/app_palette.dart';

class KidsArabicParentSettingsPage extends ConsumerWidget {
  const KidsArabicParentSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final preferences = ref.watch(kidsArabicParentPreferencesProvider);
    final notifier = ref.read(kidsArabicParentPreferencesProvider.notifier);
    final focusLetters = ref.watch(
      kidsArabicParentAvailableFocusLettersProvider,
    );
    final reviewLetters = ref.watch(
      kidsArabicParentAvailableReviewLettersProvider,
    );

    return LearnHubPageScaffold(
      headerIcon: Icons.tune_rounded,
      title: l10n.kidsArabicParentSettingsTitle,
      subtitle: l10n.kidsArabicParentSettingsSubtitle,
      children: [
        _SettingToggle(
          title: l10n.kidsArabicParentGuidedProgressionTitle,
          subtitle: l10n.kidsArabicParentGuidedProgressionSubtitle,
          value: preferences.guidedProgressionEnabled,
          onChanged: notifier.setGuidedProgressionEnabled,
        ),
        _SettingToggle(
          title: l10n.kidsArabicParentPrioritizeReviewTitle,
          subtitle: l10n.kidsArabicParentPrioritizeReviewSubtitle,
          value: preferences.prioritizeReview,
          onChanged: notifier.setPrioritizeReview,
        ),
        _SettingToggle(
          title: l10n.kidsArabicParentShowTransliterationTitle,
          subtitle: l10n.kidsArabicParentShowTransliterationSubtitle,
          value: preferences.showTransliteration,
          onChanged: notifier.setShowTransliteration,
        ),
        _SettingToggle(
          title: l10n.kidsArabicParentAudioAutoplayTitle,
          subtitle: l10n.kidsArabicParentAudioAutoplaySubtitle,
          value: preferences.audioAutoplay,
          onChanged: notifier.setAudioAutoplay,
        ),
        _SettingToggle(
          title: l10n.kidsArabicParentAllowAssignedFocusTitle,
          subtitle: l10n.kidsArabicParentAllowAssignedFocusSubtitle,
          value: preferences.allowParentAssignedFocus,
          onChanged: notifier.setAllowParentAssignedFocus,
        ),
        const SizedBox(height: 12),
        _DropdownCard<KidsArabicLessonSupportLevel>(
          title: l10n.kidsArabicParentSupportLevelTitle,
          subtitle: l10n.kidsArabicParentSupportLevelSubtitle,
          value: preferences.lessonSupportLevel,
          items: KidsArabicLessonSupportLevel.values
              .map(
                (level) => DropdownMenuItem<KidsArabicLessonSupportLevel>(
                  value: level,
                  child: Text(_supportLevelLabel(l10n, level)),
                ),
              )
              .toList(growable: false),
          onChanged: (value) {
            if (value != null) {
              notifier.setLessonSupportLevel(value);
            }
          },
        ),
        const SizedBox(height: 12),
        _DropdownCard<String?>(
          title: l10n.kidsArabicParentFocusLetterTitle,
          subtitle: l10n.kidsArabicParentFocusLetterSubtitle,
          value:
              focusLetters.any(
                (letter) => letter.id == preferences.parentAssignedLetterId,
              )
              ? preferences.parentAssignedLetterId
              : null,
          items: <DropdownMenuItem<String?>>[
            DropdownMenuItem<String?>(
              value: null,
              child: Text(l10n.kidsArabicParentNoFocusOption),
            ),
            ...focusLetters.map(
              (letter) => DropdownMenuItem<String?>(
                value: letter.id,
                child: Text('${letter.glyph}  ${letter.nameAr}'),
              ),
            ),
          ],
          onChanged: (value) {
            final saved = notifier.assignFocusLetter(
              value,
              validLetterIds: focusLetters.map((letter) => letter.id).toSet(),
            );
            if (!saved && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.kidsArabicParentInvalidFocusMessage),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 12),
        _DropdownCard<String?>(
          title: l10n.kidsArabicParentReviewLetterTitle,
          subtitle: l10n.kidsArabicParentReviewLetterSubtitle,
          value:
              reviewLetters.any(
                (letter) =>
                    letter.id == preferences.parentAssignedReviewLetterId,
              )
              ? preferences.parentAssignedReviewLetterId
              : null,
          items: <DropdownMenuItem<String?>>[
            DropdownMenuItem<String?>(
              value: null,
              child: Text(l10n.kidsArabicParentNoReviewOption),
            ),
            ...reviewLetters.map(
              (letter) => DropdownMenuItem<String?>(
                value: letter.id,
                child: Text('${letter.glyph}  ${letter.nameAr}'),
              ),
            ),
          ],
          onChanged: (value) {
            final saved = notifier.assignReviewLetter(
              value,
              validLetterIds: reviewLetters.map((letter) => letter.id).toSet(),
            );
            if (!saved && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.kidsArabicParentInvalidReviewMessage),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  String _supportLevelLabel(
    AppLocalizations l10n,
    KidsArabicLessonSupportLevel level,
  ) {
    switch (level) {
      case KidsArabicLessonSupportLevel.gentle:
        return l10n.kidsArabicParentSupportLevelGentle;
      case KidsArabicLessonSupportLevel.standard:
        return l10n.kidsArabicParentSupportLevelStandard;
      case KidsArabicLessonSupportLevel.extraHelp:
        return l10n.kidsArabicParentSupportLevelExtraHelp;
    }
  }
}

class _SettingToggle extends StatelessWidget {
  const _SettingToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.palette.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: context.palette.surfaceSoft),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
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
            const SizedBox(width: 12),
            Switch.adaptive(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _DropdownCard<T> extends StatelessWidget {
  const _DropdownCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.palette.surfaceSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: context.palette.onSurfaceSubtle,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<T>(
            initialValue: value,
            isExpanded: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.palette.surfaceSoft),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.palette.surfaceSoft),
              ),
            ),
            items: items,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
