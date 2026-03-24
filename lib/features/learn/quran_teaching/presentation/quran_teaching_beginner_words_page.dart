import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../arabic/application/arabic_learning_audio_controller.dart';
import '../../../arabic/data/arabic_alphabet_catalog.dart';
import '../../../arabic/domain/arabic_alphabet_models.dart';
import '../../../arabic/presentation/widgets/arabic_learning_playback_speed_toggle.dart';
import '../application/quran_teaching_audio_playback_service.dart';
import '../application/quran_teaching_controller.dart';
import '../domain/quran_teaching_models.dart';

class QuranTeachingBeginnerWordsPage extends ConsumerStatefulWidget {
  const QuranTeachingBeginnerWordsPage({super.key, this.initialWordId});

  final String? initialWordId;

  @override
  ConsumerState<QuranTeachingBeginnerWordsPage> createState() =>
      _QuranTeachingBeginnerWordsPageState();
}

class _QuranTeachingBeginnerWordsPageState
    extends ConsumerState<QuranTeachingBeginnerWordsPage> {
  String? _selectedWordId;
  String? _playingWordId;
  String? _lastTrackedWordId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final words = ref.watch(quranTeachingBeginnerWordsProvider);
    final audioState = ref.watch(arabicLearningAudioControllerProvider);
    final activeWord = _resolveActiveWord(words);
    final activeIndex = activeWord == null
        ? -1
        : words.indexWhere((item) => item.id == activeWord.id);
    final previousWord = activeIndex > 0 ? words[activeIndex - 1] : null;
    final nextWord = activeIndex >= 0 && activeIndex + 1 < words.length
        ? words[activeIndex + 1]
        : null;

    if (activeWord != null && _lastTrackedWordId != activeWord.id) {
      _lastTrackedWordId = activeWord.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ref
            .read(quranTeachingBeginnerWordsProgressProvider.notifier)
            .recordWordOpened(activeWord.sharedBeginnerWordId ?? activeWord.id);
      });
    }

    return AppPageScaffold(
      title: l10n.quranTeachingBeginnerWordsTitle,
      subtitle: l10n.quranTeachingBeginnerWordsSubtitle,
      children: [
        if (words.isEmpty)
          PremiumCard(child: Text(l10n.quranTeachingBeginnerWordsEmpty))
        else ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranTeachingBeginnerWordsHowToReadTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranTeachingBeginnerWordsHowToReadSubtitle),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _WordSummaryChip(
                      label: l10n.quranTeachingBeginnerWordsCount(words.length),
                    ),
                    _WordSummaryChip(
                      label: l10n.quranTeachingBeginnerWordsJoinedLabel,
                    ),
                    _WordSummaryChip(
                      label: l10n.quranTeachingBeginnerWordsAudioLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const ArabicLearningPlaybackSpeedToggle(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: words
                  .map(
                    (word) => ChoiceChip(
                      label: Text(word.transliteration),
                      selected: activeWord?.id == word.id,
                      onSelected: (_) {
                        setState(() {
                          _selectedWordId = word.id;
                        });
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          const SizedBox(height: 12),
          if (activeWord != null) ...[
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeWord.arabic,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 42,
                                fontFamily: 'AmiriQuran',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              activeWord.transliteration,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(activeWord.meaning),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => _playWord(activeWord),
                        icon: Icon(
                          audioState.activePlaybackId ==
                                      'teaching:${activeWord.audio?.id}' ||
                                  _playingWordId == activeWord.id
                              ? Icons.volume_up_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        tooltip: l10n.quranTeachingBeginnerWordsReplayAction,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (activeWord.exampleReference != null)
                    Text(
                      l10n.quranTeachingBeginnerWordsSource(
                        activeWord.exampleReference!,
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.quranTeachingBeginnerWordsJoinedLettersTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.quranTeachingBeginnerWordsJoinedLettersSubtitle),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _joinedLetterCards(activeWord, l10n),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.quranTeachingBeginnerWordsReadingHelperTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.quranTeachingBeginnerWordsReadingHelperSubtitle),
                  const SizedBox(height: 12),
                  Material(
                    color: Colors.transparent,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _letterHelperChips(activeWord),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: previousWord == null
                        ? null
                        : () => setState(() {
                            _selectedWordId = previousWord.id;
                          }),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: Text(l10n.quranTeachingBeginnerWordsPreviousAction),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: nextWord == null
                        ? null
                        : () => setState(() {
                            _selectedWordId = nextWord.id;
                          }),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(l10n.quranTeachingBeginnerWordsNextAction),
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  QuranWordEntry? _resolveActiveWord(List<QuranWordEntry> words) {
    if (words.isEmpty) {
      return null;
    }
    final candidateIds = <String?>[_selectedWordId, widget.initialWordId];
    for (final candidateId in candidateIds) {
      if (candidateId == null) {
        continue;
      }
      for (final word in words) {
        if (word.id == candidateId ||
            word.sharedBeginnerWordId == candidateId) {
          return word;
        }
      }
    }
    return words.first;
  }

  List<Widget> _joinedLetterCards(QuranWordEntry word, AppLocalizations l10n) {
    final resolved = resolveArabicLetterSequenceForms(word.letterIds);
    return resolved
        .map((item) {
          final letter = arabicAlphabetLetterById(item.letterId);
          return Container(
            width: 118,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.surfaceSoft.withValues(alpha: 0.45),
              border: Border.all(color: AppColors.surfaceSoft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.isolatedGlyph,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 26,
                    fontFamily: 'AmiriQuran',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.displayGlyph,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 30,
                    fontFamily: 'AmiriQuran',
                    color: Color(0xFF5E462A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  letter?.adultNameEn ?? item.letterId,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  _formLabel(l10n, item.displayForm),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ],
            ),
          );
        })
        .toList(growable: false);
  }

  List<Widget> _letterHelperChips(QuranWordEntry word) {
    return word.letterIds
        .map((letterId) {
          final letter = arabicAlphabetLetterById(letterId);
          return Chip(
            label: Text(
              letter == null
                  ? letterId
                  : '${letter.glyph} • ${letter.adultTransliteration}',
            ),
          );
        })
        .toList(growable: false);
  }

  String _formLabel(AppLocalizations l10n, ArabicLetterDisplayForm form) {
    switch (form) {
      case ArabicLetterDisplayForm.isolated:
        return l10n.quranTeachingLessonFormIsolated;
      case ArabicLetterDisplayForm.initial:
        return l10n.quranTeachingLessonFormInitial;
      case ArabicLetterDisplayForm.medial:
        return l10n.quranTeachingLessonFormMedial;
      case ArabicLetterDisplayForm.finalForm:
        return l10n.quranTeachingLessonFormFinal;
    }
  }

  Future<void> _playWord(QuranWordEntry word) async {
    final l10n = AppLocalizations.of(context);
    final audio = word.audio;
    if (audio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.quranTeachingBeginnerWordsAudioUnavailable)),
      );
      return;
    }
    setState(() {
      _playingWordId = word.id;
    });
    final played = await ref
        .read(quranTeachingAudioPlaybackServiceProvider)
        .playCue(audio);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          played
              ? l10n.quranTeachingBeginnerWordsPlaying(word.transliteration)
              : l10n.quranTeachingBeginnerWordsAudioUnavailable,
        ),
      ),
    );
    if (_playingWordId == word.id) {
      setState(() {
        _playingWordId = null;
      });
    }
  }
}

class _WordSummaryChip extends StatelessWidget {
  const _WordSummaryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surfaceSoft.withValues(alpha: 0.45),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
