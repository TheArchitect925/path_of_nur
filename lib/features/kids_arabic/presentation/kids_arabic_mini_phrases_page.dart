import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../arabic/presentation/widgets/arabic_learning_playback_speed_toggle.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_audio_service.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_phrases_provider.dart';
import '../domain/kids_arabic_phrase_models.dart';
import '../widgets/kids_arabic_audio_learning_widgets.dart';
import 'kids_arabic_localized_content.dart';
import '../../../core/theme/app_palette.dart';

class KidsArabicMiniPhrasesPage extends ConsumerStatefulWidget {
  const KidsArabicMiniPhrasesPage({super.key, this.initialPhraseId});

  final String? initialPhraseId;

  @override
  ConsumerState<KidsArabicMiniPhrasesPage> createState() =>
      _KidsArabicMiniPhrasesPageState();
}

class _KidsArabicMiniPhrasesPageState
    extends ConsumerState<KidsArabicMiniPhrasesPage> {
  String? _selectedPhraseId;
  String? _lastAutoPlayedPhraseId;
  bool _isPlaying = false;
  bool _showRepeatPrompt = false;

  Future<void> _playPhrase(KidsArabicMiniPhrase phrase) async {
    if (_isPlaying) {
      return;
    }
    setState(() {
      _isPlaying = true;
      _showRepeatPrompt = false;
    });
    ref
        .read(kidsArabicMiniPhraseProgressProvider.notifier)
        .markPhraseHeard(phrase.id);
    try {
      await ref.read(kidsArabicAudioServiceProvider).speakPhrase(phrase);
    } catch (_) {
      // Keep the phrase flow calm even if TTS is unavailable.
    } finally {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _showRepeatPrompt = true;
        });
      }
    }
  }

  void _selectPhrase(String phraseId) {
    if (_selectedPhraseId == phraseId) {
      return;
    }
    ref
        .read(kidsArabicMiniPhraseProgressProvider.notifier)
        .markPhraseOpened(phraseId);
    setState(() {
      _selectedPhraseId = phraseId;
      _showRepeatPrompt = false;
    });
  }

  KidsArabicMiniPhrase? _resolveActivePhrase(
    List<KidsArabicMiniPhrase> phrases,
    KidsArabicMiniPhrase? recommended,
  ) {
    if (phrases.isEmpty) {
      return null;
    }
    for (final candidateId in <String?>[
      _selectedPhraseId,
      widget.initialPhraseId,
      recommended?.id,
    ]) {
      if (candidateId == null) {
        continue;
      }
      for (final phrase in phrases) {
        if (phrase.id == candidateId) {
          return phrase;
        }
      }
    }
    return phrases.first;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phrases = ref.watch(kidsArabicMiniPhrasesProvider);
    final recommended = ref.watch(kidsArabicMiniPhraseRecommendedProvider);
    final heardCount = ref.watch(kidsArabicMiniPhraseHeardCountProvider);
    final heardIds = ref
        .watch(kidsArabicMiniPhraseProgressProvider)
        .heardPhraseIds;
    final parentPreferences = ref.watch(kidsArabicParentPreferencesProvider);
    final activePhrase = _resolveActivePhrase(phrases, recommended);

    if (activePhrase == null) {
      return LearnHubPageScaffold(
        title: l10n.kidsArabicMiniPhrasesTitle,
        subtitle: l10n.kidsArabicMiniPhrasesSubtitle,
        children: [Text(l10n.kidsArabicMiniPhrasesEmptyBody)],
      );
    }

    final activeIndex = phrases.indexWhere(
      (phrase) => phrase.id == activePhrase.id,
    );
    final previousPhrase = activeIndex > 0 ? phrases[activeIndex - 1] : null;
    final nextPhrase = activeIndex >= 0 && activeIndex + 1 < phrases.length
        ? phrases[activeIndex + 1]
        : null;
    final isHeard = heardIds.contains(activePhrase.id);

    if (parentPreferences.audioAutoplay &&
        _lastAutoPlayedPhraseId != activePhrase.id) {
      _lastAutoPlayedPhraseId = activePhrase.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _playPhrase(activePhrase);
      });
    }

    return LearnHubPageScaffold(
      title: l10n.kidsArabicMiniPhrasesTitle,
      subtitle: l10n.kidsArabicMiniPhrasesSubtitle,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _SummaryPill(
              label: l10n.kidsArabicMiniPhrasesPositionValue(
                activeIndex + 1,
                phrases.length,
              ),
            ),
            _SummaryPill(
              label: l10n.kidsArabicMiniPhrasesHeardValue(heardCount),
            ),
            if (isHeard)
              _SummaryPill(label: l10n.kidsArabicMiniPhrasesHeardBadge),
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
                ? const Color(0xFFF1F6FF)
                : context.palette.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: _isPlaying
                  ? const Color(0xFFC8D8F3)
                  : context.palette.surfaceSoft,
            ),
            boxShadow: _isPlaying
                ? const [
                    BoxShadow(
                      color: Color(0x149E84D8),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: InkWell(
            onTap: () => _playPhrase(activePhrase),
            borderRadius: BorderRadius.circular(26),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Text(
                    activePhrase.phraseAr,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 54,
                      fontFamily: 'Noto Naskh Arabic',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3A2B18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    activePhrase.transliteration,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurfaceSubtle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizedKidsArabicMiniPhraseMeaning(l10n, activePhrase.id),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.palette.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    localizedKidsArabicMiniPhraseSummary(l10n, activePhrase.id),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.palette.onSurfaceSubtle,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _showRepeatPrompt
                        ? l10n.kidsArabicRepeatAfterMePrompt
                        : l10n.kidsArabicMiniPhrasesTapHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.palette.successInk,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: () => _playPhrase(activePhrase),
                    icon: Icon(
                      _isPlaying
                          ? Icons.volume_up_rounded
                          : Icons.play_circle_outline_rounded,
                    ),
                    label: Text(l10n.kidsArabicMiniPhrasesListenAction),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        KidsArabicRepeatAfterMeCard(
          autoplayToken: activePhrase.id,
          displayText: activePhrase.phraseAr,
          title: l10n.kidsArabicRepeatAfterMeTitle,
          subtitle: l10n.kidsArabicMiniPhrasesRepeatSubtitle,
          listenLabel: l10n.kidsArabicMiniPhrasesListenAgainAction,
          repeatPromptLabel: l10n.kidsArabicRepeatAfterMePrompt,
          autoplayEnabled: false,
          onPlay: () => _playPhrase(activePhrase),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: previousPhrase == null
                    ? null
                    : () => _selectPhrase(previousPhrase.id),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(l10n.kidsArabicMiniPhrasesPreviousAction),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: nextPhrase == null
                    ? null
                    : () => _selectPhrase(nextPhrase.id),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(l10n.kidsArabicMiniPhrasesNextAction),
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
              onPressed: () => context.pushNamed('kidsArabicReadingMode'),
              icon: const Icon(Icons.menu_book_rounded),
              label: Text(l10n.kidsArabicMiniPhrasesWordsReadingAction),
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
