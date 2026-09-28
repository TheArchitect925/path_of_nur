import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_reference_link.dart';
import '../../rewards/domain/kids_sticker_models.dart';
import '../../shared/application/kids_age_band_provider.dart';
import '../../shared/domain/kids_age_band.dart';
import '../../rewards/presentation/kids_celebration.dart';
import '../../shared/application/kids_read_aloud.dart';
import '../application/bedtime_story_learning_repository.dart';
import '../application/bedtime_story_progress_service.dart';
import '../application/bedtime_story_repository.dart';
import '../domain/bedtime_story_models.dart';
import '../domain/kids_story_pages.dart';
import 'kids_story_about_section.dart';

/// The storybook: one picture and a few big lines per page, a voice for
/// every line, and nothing else on the screen. The lesson, the Qur'an and
/// the hadith wait behind "About this story" for a parent.
class KidsStoryReaderPage extends ConsumerStatefulWidget {
  const KidsStoryReaderPage({
    super.key,
    required this.storyId,
    this.bedtime = false,
  });

  final String storyId;

  /// Opened from the Bedtime shelf: a picture book ends on its bedtime
  /// closing page ("Now close your eyes…") before The End.
  final bool bedtime;

  @override
  ConsumerState<KidsStoryReaderPage> createState() =>
      _KidsStoryReaderPageState();
}

class _KidsStoryReaderPageState extends ConsumerState<KidsStoryReaderPage> {
  int _pageIndex = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(bedtimeStoryProgressProvider.notifier)
          .openStory(
            widget.storyId,
            story: ref.read(bedtimeStoryByIdProvider(widget.storyId)),
          );
      ref.read(kidsReadAloudControllerProvider.notifier).prepare();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final story = ref.watch(bedtimeStoryByIdProvider(widget.storyId));
    if (story == null) {
      return AppPageScaffold(
        title: l10n.kidsStoryLibraryTitle,
        children: [PremiumCard(child: Text(l10n.routerNotFoundTitle))],
      );
    }
    final pages = kidsStoryPagesFor(story, bedtime: widget.bedtime);
    final refrain = story.refrain.isEmpty
        ? null
        : kidsBookRefrainCore(story.refrain);
    final readAloud = ref.watch(kidsReadAloudControllerProvider);
    final voice = ref.read(kidsReadAloudControllerProvider.notifier);
    final isEnd = _pageIndex >= pages.length;
    final page = isEnd ? null : pages[_pageIndex];
    final canHear = readAloud.available ?? false;
    // A pre-reader gets bigger lines and the tap-to-hear hint on every page;
    // a fluent reader gets neither (K6).
    final band = ref.watch(kidsAgeBandProvider);

    return AppPageScaffold(
      title: story.title,
      headerActions: [
        IconButton(
          onPressed: () => showKidsStoryAboutSheet(context, story),
          icon: const Icon(AppIcons.about),
          tooltip: l10n.kidsStoryReaderAboutAction,
        ),
      ],
      floatingBottom: PremiumCard(
        density: PremiumCardDensity.compact,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pageIndex == 0 ? null : () => _go(-1),
                    child: Text(l10n.kidsStoryReaderBackAction),
                  ),
                ),
                if (page != null && canHear) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: readAloud.isSpeaking
                        ? OutlinedButton(
                            onPressed: voice.stop,
                            child: Text(l10n.kidsStoryReaderStopAction),
                          )
                        : OutlinedButton.icon(
                            onPressed: () => voice.speakSequence(
                              _linesOf(page),
                              languageCode: story.readAloudLanguageCode,
                            ),
                            icon: const Icon(AppIcons.listen),
                            label: Text(l10n.kidsStoryReaderListenAction),
                          ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            if (page != null)
              FilledButton(
                onPressed: () => _go(1),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(l10n.kidsStoryReaderNextAction),
              )
            else if (!_finished)
              FilledButton(
                onPressed: () => _finish(story),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(l10n.kidsStoryReaderFinishAction),
              )
            else
              FilledButton.tonal(
                onPressed: () => setState(() {
                  _pageIndex = 0;
                  _finished = false;
                }),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(l10n.kidsStoryReaderReadAgainAction),
              ),
          ],
        ),
      ),
      children: [
        if (page != null)
          _StoryPageCard(
            page: page,
            pageLabel: l10n.kidsStoryReaderPageValue(
              page.index + 1,
              pages.length,
            ),
            hint: canHear && band != KidsAgeBand.plus
                ? l10n.kidsStoryReaderTapToHearHint
                : null,
            largeType: band == KidsAgeBand.early,
            refrainLine: refrain,
            speakingLineId: readAloud.speakingId,
            onLineTap: canHear
                ? (line) => voice.speak(
                    line,
                    languageCode: story.readAloudLanguageCode,
                  )
                : null,
            onTryIt: page.spread?.tryItRoute == null
                ? null
                : () => context.push(page.spread!.tryItRoute!),
            onNext: () => _go(1),
            onBack: _pageIndex == 0 ? null : () => _go(-1),
          )
        else
          _TheEndCard(story: story, finished: _finished),
        const SizedBox(height: 168),
      ],
    );
  }

  List<KidsReadAloudLine> _linesOf(KidsStoryPage page) => [
    for (var i = 0; i < page.lines.length; i++)
      KidsReadAloudLine(id: 'page-${page.index}-line-$i', text: page.lines[i]),
  ];

  void _go(int delta) {
    ref.read(kidsReadAloudControllerProvider.notifier).stop();
    setState(() => _pageIndex = (_pageIndex + delta).clamp(0, 1 << 20));
  }

  void _finish(BedtimeStorySeed story) {
    final outcome = ref
        .read(bedtimeStoryProgressProvider.notifier)
        .completeStory(story, completionSource: 'reader');
    setState(() => _finished = true);
    if (!outcome.firstCompletion) return;
    // The first time through, the story becomes a sticker (K4).
    showKidsCelebration(
      context,
      ref,
      sticker: KidsSticker(
        id: 'story:${story.id}',
        kind: KidsStickerKind.story,
        title: story.shortTitle,
        imageAsset: story.coverAssetPath.isEmpty ? null : story.coverAssetPath,
        icon: AppIcons.stories,
      ),
    );
  }
}

class _StoryPageCard extends StatelessWidget {
  const _StoryPageCard({
    required this.page,
    required this.pageLabel,
    required this.hint,
    required this.speakingLineId,
    required this.onLineTap,
    required this.onNext,
    required this.onBack,
    this.largeType = false,
    this.refrainLine,
    this.onTryIt,
  });

  final bool largeType;
  final KidsStoryPage page;
  final String pageLabel;
  final String? hint;
  final String? speakingLineId;
  final ValueChanged<KidsReadAloudLine>? onLineTap;
  final VoidCallback onNext;
  final VoidCallback? onBack;

  /// The book's refrain, set apart wherever it appears so a child who
  /// cannot read yet can still say it.
  final String? refrainLine;

  /// Opens the tool a First Steps book ends in.
  final VoidCallback? onTryIt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final spread = page.spread;
    final lineStyle =
        (largeType ? textTheme.headlineMedium : textTheme.headlineSmall)
            ?.copyWith(height: 1.4, fontWeight: FontWeight.w700);
    final arabicStyle = textTheme.headlineSmall?.copyWith(
      fontFamily: AppFonts.quranArabic,
      height: 1.9,
    );
    return GestureDetector(
      // A page turns the way a book does: swipe left for the next one.
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity < -200) onNext();
        if (velocity > 200) onBack?.call();
      },
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pageLabel, style: textTheme.bodySmall),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                // Short enough that four big lines still sit above the
                // floating page controls on a phone.
                height: 176,
                width: double.infinity,
                child: page.illustrationAsset == null
                    ? _ArtFallback()
                    : Image.asset(
                        page.illustrationAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _ArtFallback(),
                      ),
              ),
            ),
            const SizedBox(height: 18),
            for (var i = 0; i < page.lines.length; i++)
              _StoryLine(
                text: page.lines[i],
                style: lineStyle,
                speaking: speakingLineId == 'page-${page.index}-line-$i',
                refrainPhrase: refrainLine,
                onTap: onLineTap == null
                    ? null
                    : () => onLineTap!(
                        KidsReadAloudLine(
                          id: 'page-${page.index}-line-$i',
                          text: page.lines[i],
                        ),
                      ),
              ),
            // What a picture book carries beyond its lines: a duʿā or an
            // ayah in Arabic, the ayah it rests on, and the tool it ends in.
            if ((spread?.arabicLine ?? '').isNotEmpty) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  spread!.arabicLine!,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: arabicStyle,
                ),
              ),
            ],
            if (spread?.quranRef != null) ...[
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: QuranReferenceLinkTile.forRef(
                  referenceLabel: l10n.kidsStoryReaderQuranRefLabel(
                    spread!.quranRef!.surah,
                    spread.quranRef!.ayah,
                  ),
                  ref: spread.quranRef!,
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  showTrailingIcon: false,
                ),
              ),
            ],
            if (onTryIt != null) ...[
              const SizedBox(height: 14),
              FilledButton.tonal(
                onPressed: onTryIt,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(l10n.kidsStoryReaderTryItAction),
              ),
            ],
            if (hint != null) ...[
              const SizedBox(height: 10),
              Text(hint!, style: textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

class _StoryLine extends StatelessWidget {
  const _StoryLine({
    required this.text,
    required this.style,
    required this.speaking,
    required this.onTap,
    this.refrainPhrase,
  });

  final String text;
  final TextStyle? style;
  final bool speaking;
  final VoidCallback? onTap;

  /// The book's refrain, without its closing punctuation. Wherever it sits
  /// inside this line it reads in the accent colour and a heavier weight;
  /// the line being spoken sits on a soft ground, so both cues survive
  /// together.
  final String? refrainPhrase;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    // The refrain may open a sentence or sit inside one, so the match
    // ignores case and the lit span keeps the line's own letters.
    final phrase = refrainPhrase ?? '';
    final at = phrase.isEmpty
        ? -1
        : text.toLowerCase().indexOf(phrase.toLowerCase());
    final base = style?.copyWith(color: speaking ? palette.accent : null);
    final lit = style?.copyWith(
      color: palette.accent,
      fontWeight: FontWeight.w800,
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: speaking
            ? BoxDecoration(
                color: palette.surfaceSoft,
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: at < 0
            ? Text(text, style: base)
            : Text.rich(
                TextSpan(
                  style: base,
                  children: [
                    if (at > 0) TextSpan(text: text.substring(0, at)),
                    TextSpan(
                      text: text.substring(at, at + phrase.length),
                      style: lit,
                    ),
                    if (at + phrase.length < text.length)
                      TextSpan(text: text.substring(at + phrase.length)),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ArtFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.palette.surfaceSoft,
      child: Center(
        child: Icon(AppIcons.stories, size: 72, color: context.palette.accent),
      ),
    );
  }
}

/// The last page: what the story taught, then the quiz and the memory cards
/// once the child has said "I read it!".
class _TheEndCard extends ConsumerWidget {
  const _TheEndCard({required this.story, required this.finished});

  final BedtimeStorySeed story;
  final bool finished;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final quiz = ref.watch(bedtimeStoryQuizByStoryIdProvider(story.id));
    final memoryDeck = ref.watch(
      bedtimeStoryMemoryDeckByStoryIdProvider(story.id),
    );
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsStoryReaderTheEndTitle,
            style: textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.kidsStoryReaderLessonEyebrow.toUpperCase(),
            style: textTheme.labelMedium?.copyWith(letterSpacing: 1.1),
          ),
          const SizedBox(height: 6),
          Text(
            story.lesson,
            style: textTheme.headlineSmall?.copyWith(
              height: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (finished && (quiz != null || memoryDeck != null)) ...[
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (quiz != null)
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed(
                      'kidsStoryQuiz',
                      pathParameters: {'storyId': story.id},
                    ),
                    icon: const Icon(AppIcons.quiz),
                    label: Text(l10n.bedtimeStoryQuizStartAction),
                  ),
                if (memoryDeck != null)
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed(
                      'kidsStoryMemory',
                      pathParameters: {'storyId': story.id},
                    ),
                    icon: const Icon(AppIcons.games),
                    label: Text(l10n.bedtimeStoryMemoryStartAction),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
