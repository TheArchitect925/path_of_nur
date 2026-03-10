import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';
import '../domain/baby_name_models.dart';

class BabyNamesFinderPage extends ConsumerStatefulWidget {
  const BabyNamesFinderPage({super.key});

  @override
  ConsumerState<BabyNamesFinderPage> createState() => _BabyNamesFinderPageState();
}

class _BabyNamesFinderPageState extends ConsumerState<BabyNamesFinderPage> {
  late final TextEditingController _fatherCtrl;
  late final TextEditingController _motherCtrl;
  late final TextEditingController _firstLetterCtrl;

  @override
  void initState() {
    super.initState();
    final input = ref.read(babyNamesControllerProvider).finderInput;
    _fatherCtrl = TextEditingController(text: input.fatherName);
    _motherCtrl = TextEditingController(text: input.motherName);
    _firstLetterCtrl = TextEditingController(text: input.firstLetter ?? '');
  }

  @override
  void dispose() {
    _fatherCtrl.dispose();
    _motherCtrl.dispose();
    _firstLetterCtrl.dispose();
    super.dispose();
  }

  void _syncInput({
    BabyNameGender? gender,
    Set<String>? meaningTags,
    String? regionPreference,
    String? classicVsRare,
    bool? easyInEnglish,
  }) {
    final state = ref.read(babyNamesControllerProvider).finderInput;
    ref.read(babyNamesControllerProvider.notifier).setFinderInput(
          BabyNameFinderInput(
            fatherName: _fatherCtrl.text.trim(),
            motherName: _motherCtrl.text.trim(),
            gender: gender ?? state.gender,
            meaningTags: meaningTags ?? state.meaningTags,
            regionPreference: regionPreference ?? state.regionPreference,
            firstLetter: _firstLetterCtrl.text.trim().isEmpty
                ? null
                : _firstLetterCtrl.text.trim().substring(0, 1),
            classicVsRare: classicVsRare ?? state.classicVsRare,
            easyInEnglish: easyInEnglish ?? state.easyInEnglish,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final finder = ref.watch(babyNamesControllerProvider).finderInput;
    final options = ref.watch(babyNamesFilterOptionsProvider);
    final suggestions = ref.watch(babyNamesFinderSuggestionsProvider);

    return AppPageScaffold(
      headerIcon: Icons.auto_awesome_rounded,
      title: l10n.babyNamesSmartFinderTitle,
      subtitle: l10n.babyNamesSmartFinderSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _fatherCtrl,
                onChanged: (_) => _syncInput(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  isDense: true,
                  labelText: l10n.babyNamesFatherNameLabel,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _motherCtrl,
                onChanged: (_) => _syncInput(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  isDense: true,
                  labelText: l10n.babyNamesMotherNameLabel,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<BabyNameGender>(
                      initialValue: finder.gender,
                      isDense: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l10n.babyNamesGenderLabel,
                      ),
                      items: [
                        DropdownMenuItem<BabyNameGender>(
                          value: null,
                          child: Text(l10n.babyNamesGenderAny),
                        ),
                        DropdownMenuItem(
                          value: BabyNameGender.boy,
                          child: Text(l10n.babyNamesBoysLabel),
                        ),
                        DropdownMenuItem(
                          value: BabyNameGender.girl,
                          child: Text(l10n.babyNamesGirlsLabel),
                        ),
                        DropdownMenuItem(
                          value: BabyNameGender.unisex,
                          child: Text(l10n.babyNamesUnisexLabel),
                        ),
                      ],
                      onChanged: (value) => _syncInput(gender: value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: finder.regionPreference,
                      isDense: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l10n.babyNamesRegionFilterLabel,
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text(l10n.babyNamesAnyOption),
                        ),
                        ...options.regions.map(
                          (region) => DropdownMenuItem<String>(
                            value: region,
                            child: Text(region),
                          ),
                        ),
                      ],
                      onChanged: (value) => _syncInput(regionPreference: value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _firstLetterCtrl,
                      maxLength: 1,
                      onChanged: (_) => _syncInput(),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        isDense: true,
                        counterText: '',
                        labelText: l10n.babyNamesFirstLetterLabel,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: finder.classicVsRare,
                      isDense: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: l10n.babyNamesClassicRareLabel,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'balanced',
                          child: Text(l10n.babyNamesClassicRareBalanced),
                        ),
                        DropdownMenuItem(
                          value: 'classic',
                          child: Text(l10n.babyNamesClassicRareClassic),
                        ),
                        DropdownMenuItem(
                          value: 'rare',
                          child: Text(l10n.babyNamesClassicRareRare),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) _syncInput(classicVsRare: value);
                      },
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: finder.easyInEnglish,
                onChanged: (v) => _syncInput(easyInEnglish: v == true),
                title: Text(l10n.babyNamesEasyEnglishLabel),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.babyNamesPreferredMeaningTags,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.meaningTags
                    .take(14)
                    .map((tag) {
                      final selected = finder.meaningTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: selected,
                        onSelected: (_) {
                          final tags = Set<String>.from(finder.meaningTags);
                          if (!tags.remove(tag)) tags.add(tag);
                          _syncInput(meaningTags: tags);
                        },
                      );
                    })
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Text(
            '${suggestions.length} ${l10n.babyNamesSuggestionsLabel}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        if (suggestions.isEmpty)
          PremiumCard(child: Text(l10n.babyNamesFinderEmpty)),
        ...suggestions.map(
          (suggestion) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${suggestion.record.english} • ${suggestion.record.arabic}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${suggestion.record.meaning}\n${suggestion.reasons.join(' · ')}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed(
                  'babyNameDetail',
                  pathParameters: {'nameId': suggestion.record.id},
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
