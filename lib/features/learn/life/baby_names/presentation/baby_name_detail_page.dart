import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';
import '../domain/baby_name_models.dart';

class BabyNameDetailPage extends ConsumerStatefulWidget {
  const BabyNameDetailPage({
    super.key,
    required this.nameId,
  });

  final String nameId;

  @override
  ConsumerState<BabyNameDetailPage> createState() => _BabyNameDetailPageState();
}

class _BabyNameDetailPageState extends ConsumerState<BabyNameDetailPage> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(babyNamesControllerProvider);
    _noteController = TextEditingController(
      text: state.notesById[widget.nameId] ?? '',
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final byId = ref.watch(babyNamesByIdProvider);
    final state = ref.watch(babyNamesControllerProvider);
    final notifier = ref.read(babyNamesControllerProvider.notifier);
    final name = byId[widget.nameId];

    if (name == null) {
      return AppPageScaffold(
        headerIcon: Icons.child_friendly_rounded,
        title: l10n.babyNamesTitle,
        subtitle: l10n.learnContentNotFound,
        children: [PremiumCard(child: Text(l10n.learnContentNotFound))],
      );
    }

    final related = name.relatedIds.map((id) => byId[id]).whereType<BabyNameRecord>().toList();
    final isFav = state.favorites.contains(name.id);
    final isShort = state.shortlist.contains(name.id);
    final inCompare = state.compareIds.contains(name.id);

    return AppPageScaffold(
      headerIcon: Icons.badge_outlined,
      title: name.english,
      subtitle: '${name.transliteration} • ${name.meaning}',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  name.arabic,
                  style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 8),
              Text(name.extendedMeaning),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaChip('${l10n.babyNamesOriginFilterLabel}: ${name.origin}'),
                  _MetaChip('${l10n.babyNamesGenderLabel}: ${_genderLabel(l10n, name.gender)}'),
                  if (name.rootLetters != null)
                    _MetaChip('${l10n.babyNamesFieldRoot}: ${name.rootLetters}'),
                  _MetaChip(
                    '${l10n.babyNamesRarityLabel}: ${_rarityLabel(l10n, name.rarity)}',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: Text(l10n.babyNamesFavoriteAction),
                avatar: Icon(isFav ? Icons.favorite : Icons.favorite_border, size: 16),
                onPressed: () => notifier.toggleFavorite(name.id),
              ),
              ActionChip(
                label: Text(l10n.babyNamesShortlistAction),
                avatar: Icon(isShort ? Icons.bookmark : Icons.bookmark_border, size: 16),
                onPressed: () => notifier.toggleShortlist(name.id),
              ),
              ActionChip(
                label: Text(l10n.babyNamesCompareAction),
                avatar: Icon(
                  inCompare ? Icons.check_circle_outline : Icons.add_circle_outline,
                  size: 16,
                ),
                onPressed: () => notifier.toggleCompare(name.id),
              ),
              ActionChip(
                label: Text(l10n.babyNamesOpenCompare),
                avatar: const Icon(Icons.compare_arrows_rounded, size: 16),
                onPressed: () => context.pushNamed('babyNamesCompare'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.babyNamesMeaningTags,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: name.meaningTags.map((tag) => _MetaChip(tag)).toList(),
          ),
        ),
        _SectionCard(
          title: l10n.babyNamesStyleTags,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: name.styleTags.map((tag) => _MetaChip(tag)).toList(),
          ),
        ),
        _SectionCard(
          title: l10n.babyNamesHistoricalTags,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: name.historicalTags.map((tag) => _MetaChip(tag)).toList(),
          ),
        ),
        _SectionCard(
          title: l10n.babyNamesRegionsTitle,
          child: Text(name.regions.join(' • ')),
        ),
        _SectionCard(
          title: l10n.babyNamesVariantsTitle,
          child: Text(name.variants.join(' • ')),
        ),
        if (name.quranicAssociations.isNotEmpty)
          _SectionCard(
            title: l10n.babyNamesQuranicAssociationsTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: name.quranicAssociations
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $item'),
                      ))
                  .toList(),
            ),
          ),
        if (name.historicalAssociations.isNotEmpty)
          _SectionCard(
            title: l10n.babyNamesHistoricalAssociationsTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: name.historicalAssociations
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $item'),
                      ))
                  .toList(),
            ),
          ),
        _SectionCard(
          title: l10n.babyNamesReflectionTitle,
          child: Text(name.reflection),
        ),
        _SectionCard(
          title: l10n.babyNamesPrivateNotesTitle,
          child: Column(
            children: [
              TextField(
                controller: _noteController,
                minLines: 3,
                maxLines: 6,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: l10n.babyNamesPrivateNotesHint,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonal(
                  onPressed: () => notifier.setNote(name.id, _noteController.text),
                  child: Text(l10n.babyNamesSaveNote),
                ),
              ),
            ],
          ),
        ),
        if (related.isNotEmpty)
          _SectionCard(
            title: l10n.babyNamesRelatedNamesTitle,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: related
                  .map(
                    (item) => ActionChip(
                      label: Text(item.english),
                      onPressed: () => context.pushNamed(
                        'babyNameDetail',
                        pathParameters: {'nameId': item.id},
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}

String _genderLabel(AppLocalizations l10n, BabyNameGender value) {
  switch (value) {
    case BabyNameGender.boy:
      return l10n.babyNamesBoysLabel;
    case BabyNameGender.girl:
      return l10n.babyNamesGirlsLabel;
    case BabyNameGender.unisex:
      return l10n.babyNamesUnisexLabel;
  }
}

String _rarityLabel(AppLocalizations l10n, BabyNameRarity value) {
  switch (value) {
    case BabyNameRarity.classic:
      return l10n.babyNamesRarityClassic;
    case BabyNameRarity.common:
      return l10n.babyNamesRarityCommon;
    case BabyNameRarity.uncommon:
      return l10n.babyNamesRarityUncommon;
    case BabyNameRarity.rare:
      return l10n.babyNamesRarityRare;
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0xFFF7EFD9),
        border: Border.all(color: const Color(0xFFD9C79A)),
      ),
      child: Text(text),
    );
  }
}
