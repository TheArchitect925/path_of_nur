import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../arabic/presentation/widgets/arabic_learning_playback_speed_toggle.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_audio_service.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_words_provider.dart';
import '../domain/kids_arabic_word_models.dart';
import 'kids_arabic_localized_content.dart';
import '../../../core/theme/app_palette.dart';

class KidsArabicReadingModePage extends ConsumerStatefulWidget {
  const KidsArabicReadingModePage({super.key, this.initialWordId});

  final String? initialWordId;

  @override
  ConsumerState<KidsArabicReadingModePage> createState() =>
      _KidsArabicReadingModePageState();
}

class _KidsArabicReadingModePageState
    extends ConsumerState<KidsArabicReadingModePage> {
  String? _selectedWordId;
  String? _lastAutoPlayedWordId;
  bool _isPlaying = false;
  bool _showRepeatPrompt = false;

  Future<void> _playWord(KidsArabicBeginnerWord word) async {
    if (_isPlaying) {
      return;
    }
    setState(() {
      _isPlaying = true;
      _showRepeatPrompt = false;
    });
    try {
      await ref.read(kidsArabicAudioServiceProvider).speakWord(word);
    } catch (_) {
      // A failed TTS attempt should not break the calm reading flow.
    } finally {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _showRepeatPrompt = true;
        });
      }
    }
  }

  void _selectWord(String wordId) {
    if (_selectedWordId == wordId) {
      return;
    }
    setState(() {
      _selectedWordId = wordId;
      _showRepeatPrompt = false;
    });
  }

  KidsArabicBeginnerWord? _resolveActiveWord(
    List<KidsArabicBeginnerWord> words,
    KidsArabicBeginnerWord? recommended,
  ) {
    if (words.isEmpty) {
      return null;
    }

    for (final candidateId in <String?>[
      _selectedWordId,
      widget.initialWordId,
      recommended?.id,
    ]) {
      if (candidateId == null) {
        continue;
      }
      for (final word in words) {
        if (word.id == candidateId) {
          return word;
        }
      }
    }

    return words.first;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final availableWords = ref.watch(kidsArabicUnlockedWordsProvider);
    final recommended = ref.watch(kidsArabicReadingRecommendedWordProvider);
    final completedIds = ref
        .watch(kidsArabicWordProgressProvider)
        .completedWordIds;
    final parentPreferences = ref.watch(kidsArabicParentPreferencesProvider);
    final activeWord = _resolveActiveWord(availableWords, recommended);

    if (activeWord == null) {
      return LearnHubPageScaffold(
        headerIcon: Icons.menu_book_rounded,
        title: l10n.kidsArabicReadingModeTitle,
        subtitle: l10n.kidsArabicReadingModeSubtitle,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: context.palette.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: context.palette.surfaceSoft),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsArabicReadingModeLockedTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.palette.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.kidsArabicReadingModeLockedBody,
                  style: TextStyle(
                    color: context.palette.onSurfaceSubtle,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context.pushNamed('kidsArabicWordsHome'),
                  child: Text(l10n.kidsArabicWordsOpenAction),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final activeIndex = availableWords.indexWhere(
      (word) => word.id == activeWord.id,
    );
    final previousWord = activeIndex > 0
        ? availableWords[activeIndex - 1]
        : null;
    final nextWord = activeIndex >= 0 && activeIndex + 1 < availableWords.length
        ? availableWords[activeIndex + 1]
        : null;
    final isCompleted = completedIds.contains(activeWord.id);
    if (parentPreferences.audioAutoplay &&
        _lastAutoPlayedWordId != activeWord.id) {
      _lastAutoPlayedWordId = activeWord.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _playWord(activeWord);
      });
    }

    return LearnHubPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: l10n.kidsArabicReadingModeTitle,
      subtitle: l10n.kidsArabicReadingModeSubtitle,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _SummaryPill(
              label: l10n.kidsArabicReadingModePositionValue(
                activeIndex + 1,
                availableWords.length,
              ),
            ),
            _SummaryPill(
              label: l10n.kidsArabicWordsCompletedValue(completedIds.length),
            ),
            if (isCompleted)
              _SummaryPill(label: l10n.kidsArabicReadingModeCompletedBadge),
          ],
        ),
        const SizedBox(height: 12),
        const ArabicLearningPlaybackSpeedToggle(
          variant: ArabicLearningPlaybackToggleVariant.kids,
        ),
        const SizedBox(height: 14),
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: _isPlaying
                ? const Color(0xFFF6F0FF)
                : context.palette.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: _isPlaying
                  ? const Color(0xFFCDBAF3)
                  : context.palette.surfaceSoft,
            ),
            boxShadow: _isPlaying
                ? const [
                    BoxShadow(
                      color: Color(0x1F9E84D8),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: InkWell(
            onTap: () => _playWord(activeWord),
            borderRadius: BorderRadius.circular(26),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  AnimatedScale(
                    duration: const Duration(milliseconds: 220),
                    scale: _isPlaying ? 1.03 : 1,
                    child: Text(
                      activeWord.wordAr,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 64,
                        fontFamily: 'Noto Naskh Arabic',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3A2B18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    activeWord.transliteration,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurfaceSubtle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    localizedKidsArabicWordMeaning(l10n, activeWord.id),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    localizedKidsArabicWordSummary(l10n, activeWord.id),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.palette.onSurfaceSubtle,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: activeWord.joiningExamples
                        .map(
                          (example) => _WordLetterChip(
                            name: localizedKidsArabicJoiningLetterName(
                              l10n,
                              example.letterId,
                            ),
                            joinedGlyph: example.joinedGlyph,
                          ),
                        )
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _showRepeatPrompt
                        ? l10n.kidsArabicRepeatAfterMePrompt
                        : l10n.kidsArabicReadingModeTapHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.palette.successInk,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: () => _playWord(activeWord),
                    icon: Icon(
                      _isPlaying
                          ? Icons.volume_up_rounded
                          : Icons.play_circle_outline_rounded,
                    ),
                    label: Text(l10n.kidsArabicReadingModeListenAction),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                key: const Key('kidsArabicReadingModePreviousButton'),
                onPressed: previousWord == null
                    ? null
                    : () => _selectWord(previousWord.id),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(l10n.kidsArabicReadingModePreviousAction),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                key: const Key('kidsArabicReadingModeNextButton'),
                onPressed: nextWord == null
                    ? null
                    : () => _selectWord(nextWord.id),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(l10n.kidsArabicReadingModeNextAction),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            TextButton.icon(
              onPressed: () => context.pushNamed(
                'kidsArabicWordLesson',
                pathParameters: {'wordId': activeWord.id},
              ),
              icon: const Icon(Icons.edit_rounded),
              label: Text(l10n.kidsArabicReadingModeTraceWordAction),
            ),
            TextButton.icon(
              onPressed: () => context.pushNamed('kidsArabicWordsHome'),
              icon: const Icon(Icons.view_agenda_rounded),
              label: Text(l10n.kidsArabicWordsHomeAction),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppLayeredGlassPill(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      fillColor: Colors.white,
      borderColor: const Color(0xFFE3D7C8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6F5A43),
        ),
      ),
    );
  }
}

class _WordLetterChip extends StatelessWidget {
  const _WordLetterChip({required this.name, required this.joinedGlyph});

  final String name;
  final String joinedGlyph;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8DCCF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            joinedGlyph,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Noto Naskh Arabic',
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: context.palette.onSurfaceSubtle,
            ),
          ),
        ],
      ),
    );
  }
}
