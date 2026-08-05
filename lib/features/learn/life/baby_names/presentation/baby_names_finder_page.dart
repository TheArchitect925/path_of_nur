import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';
import '../data/baby_names_repository.dart';
import '../domain/baby_name_models.dart';

class BabyNamesFinderPage extends ConsumerStatefulWidget {
  const BabyNamesFinderPage({super.key});

  @override
  ConsumerState<BabyNamesFinderPage> createState() =>
      _BabyNamesFinderPageState();
}

class _BabyNamesFinderPageState extends ConsumerState<BabyNamesFinderPage> {
  late final TextEditingController _fatherCtrl;
  late final TextEditingController _motherCtrl;

  @override
  void initState() {
    super.initState();
    final input = ref.read(babyNamesControllerProvider).finderInput;
    _fatherCtrl = TextEditingController(text: input.fatherName);
    _motherCtrl = TextEditingController(text: input.motherName);
  }

  @override
  void dispose() {
    _fatherCtrl.dispose();
    _motherCtrl.dispose();
    super.dispose();
  }

  void _update({
    BabyNameGender? preferredGender,
    Set<String>? themes,
    bool? quranicOnly,
    String? origin,
  }) {
    final current = ref.read(babyNamesControllerProvider).finderInput;
    ref
        .read(babyNamesControllerProvider.notifier)
        .updateFinderInput(
          current.copyWith(
            fatherName: _fatherCtrl.text.trim(),
            motherName: _motherCtrl.text.trim(),
            preferredGender: preferredGender ?? current.preferredGender,
            meaningThemes: themes ?? current.meaningThemes,
            quranicOnly: quranicOnly ?? current.quranicOnly,
            originPreference: origin ?? current.originPreference,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(babyNamesControllerProvider).finderInput;
    final options = ref.watch(babyNamesFilterOptionsProvider);
    final suggestions = ref.watch(babyNamesFinderSuggestionsProvider);
    final index = ref.watch(babyNamesIndexProvider).value;
    final hasFatherMatch =
        index?.byNameLower.containsKey(state.fatherName.toLowerCase()) ?? false;
    final hasMotherMatch =
        index?.byNameLower.containsKey(state.motherName.toLowerCase()) ?? false;
    final shouldShowFallbackNote =
        (state.fatherName.trim().isNotEmpty ||
            state.motherName.trim().isNotEmpty) &&
        (!hasFatherMatch || !hasMotherMatch);

    return AppPageScaffold(
      headerIcon: Icons.auto_awesome_rounded,
      title: 'Parent-inspired Name Tool',
      subtitle:
          'Get ranked suggestions based on family inputs and meaning themes',
      children: [
        PremiumCard(
          child: Column(
            children: [
              TextField(
                controller: _fatherCtrl,
                onChanged: (_) => _update(),
                decoration: const InputDecoration(
                  labelText: 'Father name',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _motherCtrl,
                onChanged: (_) => _update(),
                decoration: const InputDecoration(
                  labelText: 'Mother name',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 560;
                  final genderField = DropdownButtonFormField<BabyNameGender>(
                    initialValue: state.preferredGender,
                    isDense: true,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Preferred gender',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem<BabyNameGender>(
                        value: null,
                        child: Text('Any'),
                      ),
                      DropdownMenuItem(
                        value: BabyNameGender.male,
                        child: Text('Boy'),
                      ),
                      DropdownMenuItem(
                        value: BabyNameGender.female,
                        child: Text('Girl'),
                      ),
                      DropdownMenuItem(
                        value: BabyNameGender.unisex,
                        child: Text('Unisex'),
                      ),
                    ],
                    onChanged: (value) => _update(preferredGender: value),
                  );
                  final originField = DropdownButtonFormField<String>(
                    initialValue: state.originPreference,
                    isDense: true,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Origin preference',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Any'),
                      ),
                      ...options.origins.map(
                        (origin) => DropdownMenuItem<String>(
                          value: origin,
                          child: Text(origin, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                    onChanged: (value) => _update(origin: value),
                  );

                  if (narrow) {
                    return Column(
                      children: [
                        genderField,
                        const SizedBox(height: 8),
                        originField,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: genderField),
                      const SizedBox(width: 8),
                      Expanded(child: originField),
                    ],
                  );
                },
              ),
              const SizedBox(height: 6),
              CheckboxListTile(
                value: state.quranicOnly,
                onChanged: (value) => _update(quranicOnly: value == true),
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: const Text('Quranic names only'),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Meaning themes',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.meaningThemes.take(20).map((theme) {
                  final selected = state.meaningThemes.contains(theme);
                  return FilterChip(
                    label: Text(theme),
                    selected: selected,
                    onSelected: (_) {
                      final next = Set<String>.from(state.meaningThemes);
                      if (!next.remove(theme)) next.add(theme);
                      _update(themes: next);
                    },
                  );
                }).toList(),
              ),
              if (shouldShowFallbackNote) ...[
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'We could not match one or both parent names directly, so suggestions are based on your selected preferences and themes.',
                    style: TextStyle(color: Color(0xFF6B604E)),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Text(
            '${suggestions.length} ranked suggestions',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        if (suggestions.isEmpty)
          const PremiumCard(
            child: Text(
              'No suggestions yet. Try choosing a meaning theme, changing gender, or disabling Quranic-only to broaden matches.',
            ),
          ),
        ...suggestions.map(
          (suggestion) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 560;
                  final title = Text(
                    '${suggestion.entry.name} • ${suggestion.entry.arabic}',
                    maxLines: compact ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  );
                  final subtitle = Text(
                    '${suggestion.entry.meaning}\n${suggestion.explanations.join(' · ')}',
                    maxLines: compact ? 5 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(height: 1.35),
                  );
                  void openDetail() {
                    context.pushNamed(
                      'babyNameDetail',
                      pathParameters: {'nameId': suggestion.entry.id},
                    );
                  }

                  if (compact) {
                    return InkWell(
                      onTap: openDetail,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title,
                            const SizedBox(height: 6),
                            subtitle,
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.chevron_right_rounded),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return InkWell(
                    onTap: openDetail,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                title,
                                const SizedBox(height: 6),
                                subtitle,
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.chevron_right_rounded),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
