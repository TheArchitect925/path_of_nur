import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';
import '../data/baby_names_repository.dart';
import '../domain/baby_name_models.dart';

class BabyNameDetailPage extends ConsumerStatefulWidget {
  const BabyNameDetailPage({super.key, required this.nameId});

  final String nameId;

  @override
  ConsumerState<BabyNameDetailPage> createState() => _BabyNameDetailPageState();
}

class _BabyNameDetailPageState extends ConsumerState<BabyNameDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(babyNamesControllerProvider.notifier).markViewed(widget.nameId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(babyNamesControllerProvider);
    final notifier = ref.read(babyNamesControllerProvider.notifier);
    final byIdAsync = ref.watch(babyNamesByIdProvider);
    final indexAsync = ref.watch(babyNamesIndexProvider);

    return byIdAsync.when(
      data: (byId) {
        final name = byId[widget.nameId];
        if (name == null) {
          return AppPageScaffold(
            title: 'Name not found',
            subtitle: 'The selected entry is unavailable.',
            children: const [PremiumCard(child: Text('Name not found.'))],
          );
        }

        final related = indexAsync.value == null
            ? const <BabyNameEntry>[]
            : ref
                  .watch(babyNamesRepositoryProvider)
                  .relatedNames(name, indexAsync.value!);

        final isFavorite = state.favorites.contains(name.id);

        return AppPageScaffold(
          title: name.name,
          subtitle: name.meaning,
          children: [
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      name.arabic,
                      textAlign: textAlignForContent(name.arabic),
                      textDirection: textDirectionForContent(name.arabic),
                      style: AppTextStyles.arabicLearning(
                        size: 44,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      name.transliteration,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF655A48),
                      ),
                    ),
                  ),
                  if (name.pronunciation != null) ...[
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Pronunciation: ${name.pronunciation}',
                        style: const TextStyle(color: Color(0xFF6E624E)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Chip(text: _genderLabel(name.gender)),
                      if (name.origin.isNotEmpty)
                        _Chip(text: 'Origin: ${name.origin.join(' / ')}'),
                      if (name.startsWith.isNotEmpty)
                        _Chip(text: 'Starts with ${name.startsWith}'),
                      if (name.syllables != null)
                        _Chip(text: '${name.syllables} syllables'),
                      if (name.isQuranic) const _Chip(text: 'Quranic'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            PremiumCard(
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      button: true,
                      label: isFavorite
                          ? l10n.accessibilityRemoveFromFavorites
                          : l10n.accessibilitySaveNameToFavorites,
                      child: FilledButton.tonalIcon(
                        onPressed: () => notifier.toggleFavorite(name.id),
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                        ),
                        label: Text(isFavorite ? 'Saved' : 'Save name'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Sharing support will be added in a future update.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.ios_share_rounded),
                    label: const Text('Share'),
                  ),
                ],
              ),
            ),
            if (name.description != null && name.description!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _Section(title: 'Overview', child: Text(name.description!)),
            ],
            const SizedBox(height: 10),
            _Section(title: 'Meaning', child: Text(name.meaning)),
            if (name.meaningThemes.isNotEmpty) ...[
              const SizedBox(height: 10),
              _Section(
                title: 'Meaning themes',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: name.meaningThemes
                      .map((t) => _Chip(text: t))
                      .toList(),
                ),
              ),
            ],
            if (name.quranReferences.isNotEmpty) ...[
              const SizedBox(height: 10),
              _Section(
                title: 'Qur’an relevance',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: name.quranReferences
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $item'),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            if (name.associatedFigures.isNotEmpty) ...[
              const SizedBox(height: 10),
              _Section(
                title: 'Associations',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: name.associatedFigures
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $item'),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            if (name.variants.isNotEmpty) ...[
              const SizedBox(height: 10),
              _Section(
                title: 'Variants',
                child: Text(name.variants.join(' • ')),
              ),
            ],
            if (name.audioPronunciation != null &&
                name.audioPronunciation!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _Section(
                title: 'Pronunciation audio',
                child: Text(
                  'Audio source prepared: ${name.audioPronunciation!}',
                ),
              ),
            ],
            if (name.popularityRegions.isNotEmpty) ...[
              const SizedBox(height: 10),
              _Section(
                title: 'Popularity regions',
                child: Text(name.popularityRegions.join(' • ')),
              ),
            ],
            if (related.isNotEmpty) ...[
              const SizedBox(height: 10),
              _Section(
                title: 'Similar names',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: related
                      .map(
                        (item) => ActionChip(
                          label: Text(item.name),
                          onPressed: () => context.pushNamed(
                            'babyNameDetail',
                            pathParameters: {'nameId': item.id},
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ] else ...[
              const SizedBox(height: 10),
              const _Section(
                title: 'Similar names',
                child: Text(
                  'No related names available yet. Try exploring by meaning theme.',
                ),
              ),
            ],
          ],
        );
      },
      loading: () => AppPageScaffold(
        title: 'Baby Names',
        subtitle: 'Loading name details',
        children: const [
          PremiumCard(
            child: SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ),
        ],
      ),
      error: (_, _) => AppPageScaffold(
        title: 'Baby Names',
        subtitle: 'Unable to open details',
        children: const [
          PremiumCard(child: Text('Unable to open this name right now.')),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD8CBAE)),
      ),
      child: Text(text),
    );
  }
}

String _genderLabel(BabyNameGender gender) {
  switch (gender) {
    case BabyNameGender.male:
      return 'Boy';
    case BabyNameGender.female:
      return 'Girl';
    case BabyNameGender.unisex:
      return 'Unisex';
  }
}
