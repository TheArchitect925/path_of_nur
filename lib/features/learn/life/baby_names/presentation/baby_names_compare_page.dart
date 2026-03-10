import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';
import '../domain/baby_name_models.dart';

class BabyNamesComparePage extends ConsumerWidget {
  const BabyNamesComparePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(babyNamesCompareProvider);
    final notifier = ref.read(babyNamesControllerProvider.notifier);

    return AppPageScaffold(
      headerIcon: Icons.compare_arrows_rounded,
      title: l10n.babyNamesCompareTitle,
      subtitle: l10n.babyNamesCompareSubtitle,
      children: [
        PremiumCard(
          child: Row(
            children: [
              Text(
                '${selected.length}/4 ${l10n.babyNamesSelectedCountLabel}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton(
                onPressed: notifier.clearCompare,
                child: Text(l10n.babyNamesClearCompare),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (selected.length < 2)
          PremiumCard(
            child: Text(l10n.babyNamesCompareEmpty),
          ),
        if (selected.length >= 2)
          ...selected.map(
            (name) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _CompareCard(name: name),
            ),
          ),
      ],
    );
  }
}

class _CompareCard extends ConsumerWidget {
  const _CompareCard({required this.name});

  final BabyNameRecord name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(babyNamesControllerProvider.notifier);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${name.english} • ${name.arabic}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: () => notifier.toggleCompare(name.id),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          Text(name.transliteration, style: const TextStyle(color: Color(0xFF6A5A4A))),
          const SizedBox(height: 6),
          Text(name.meaning),
          const SizedBox(height: 6),
          Text('${l10n.babyNamesFieldOrigin}: ${name.origin}'),
          Text('${l10n.babyNamesFieldGender}: ${_genderLabel(l10n, name.gender)}'),
          if (name.rootLetters != null)
            Text('${l10n.babyNamesFieldRoot}: ${name.rootLetters}'),
          const SizedBox(height: 6),
          Text('${l10n.babyNamesFieldTags}: ${name.meaningTags.join(', ')}'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.pushNamed(
                'babyNameDetail',
                pathParameters: {'nameId': name.id},
              ),
              child: Text(l10n.babyNamesOpenDetails),
            ),
          ),
        ],
      ),
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
