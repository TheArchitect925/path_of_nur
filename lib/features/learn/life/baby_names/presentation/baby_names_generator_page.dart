import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../../shared/widgets/premium_card.dart';
import '../application/baby_names_controller.dart';
import '../data/baby_names_repository.dart';
import '../domain/baby_name_models.dart';

class BabyNamesGeneratorPage extends ConsumerStatefulWidget {
  const BabyNamesGeneratorPage({super.key});

  @override
  ConsumerState<BabyNamesGeneratorPage> createState() =>
      _BabyNamesGeneratorPageState();
}

class _BabyNamesGeneratorPageState
    extends ConsumerState<BabyNamesGeneratorPage> {
  BabyNameGender? _gender;
  String? _theme;
  String? _origin;
  bool _quranicOnly = false;
  List<BabyNameEntry> _generated = const [];
  bool _attempted = false;
  final _random = Random();

  void _generate(BabyNamesIndex index) {
    final candidates = index.all.where((item) {
      if (_gender != null && item.gender != _gender) return false;
      if (_quranicOnly && !item.isQuranic) return false;
      if (_theme != null && !item.meaningThemes.contains(_theme)) return false;
      if (_origin != null && !item.origin.contains(_origin)) return false;
      return true;
    }).toList();

    if (candidates.isEmpty) {
      setState(() {
        _generated = const [];
        _attempted = true;
      });
      return;
    }

    candidates.shuffle(_random);
    setState(() {
      _generated = candidates.take(min(3, candidates.length)).toList();
      _attempted = true;
    });
  }

  List<String> _reasonsFor(BabyNameEntry entry) {
    final reasons = <String>[];
    if (_theme != null && entry.meaningThemes.contains(_theme)) {
      reasons.add('Theme match');
    }
    if (entry.isQuranic) reasons.add('Quranic name');
    if (entry.associatedCategories.contains('classic') ||
        entry.isProphetAssociated) {
      reasons.add('Classic association');
    }
    if (_origin != null && entry.origin.contains(_origin)) {
      reasons.add('Origin preference match');
    }
    if (reasons.isEmpty) reasons.add('Balanced match from your filters');
    return reasons.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final indexAsync = ref.watch(babyNamesIndexProvider);
    final options = ref.watch(babyNamesFilterOptionsProvider);

    return AppPageScaffold(
      title: 'Name Generator',
      subtitle:
          'Generate 1 to 3 name suggestions from your selected preferences',
      children: [
        indexAsync.when(
          data: (index) => Column(
            children: [
              PremiumCard(
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final narrow = constraints.maxWidth < 520;
                        final fields = <Widget>[
                          SizedBox(
                            width: narrow
                                ? double.infinity
                                : (constraints.maxWidth - 8) / 2,
                            child: DropdownButtonFormField<BabyNameGender>(
                              initialValue: _gender,
                              isDense: true,
                              decoration: const InputDecoration(
                                labelText: 'Gender',
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
                              onChanged: (value) =>
                                  setState(() => _gender = value),
                            ),
                          ),
                          SizedBox(
                            width: narrow
                                ? double.infinity
                                : (constraints.maxWidth - 8) / 2,
                            child: DropdownButtonFormField<String>(
                              initialValue: _theme,
                              isDense: true,
                              decoration: const InputDecoration(
                                labelText: 'Meaning theme',
                                border: OutlineInputBorder(),
                              ),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('Any'),
                                ),
                                ...options.meaningThemes.map(
                                  (theme) => DropdownMenuItem<String>(
                                    value: theme,
                                    child: Text(theme),
                                  ),
                                ),
                              ],
                              onChanged: (value) =>
                                  setState(() => _theme = value),
                            ),
                          ),
                        ];
                        if (narrow) {
                          return Column(
                            children: [
                              fields[0],
                              const SizedBox(height: 8),
                              fields[1],
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(child: fields[0]),
                            const SizedBox(width: 8),
                            Expanded(child: fields[1]),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final narrow = constraints.maxWidth < 520;
                        final left = SizedBox(
                          width: narrow
                              ? double.infinity
                              : (constraints.maxWidth - 8) / 2,
                          child: DropdownButtonFormField<String>(
                            initialValue: _origin,
                            isDense: true,
                            decoration: const InputDecoration(
                              labelText: 'Origin',
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
                                  child: Text(origin),
                                ),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => _origin = value),
                          ),
                        );
                        final right = SizedBox(
                          width: narrow
                              ? double.infinity
                              : (constraints.maxWidth - 8) / 2,
                          child: CheckboxListTile(
                            value: _quranicOnly,
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Quranic only',
                              overflow: TextOverflow.ellipsis,
                            ),
                            onChanged: (value) =>
                                setState(() => _quranicOnly = value == true),
                          ),
                        );
                        if (narrow) {
                          return Column(
                            children: [left, const SizedBox(height: 8), right],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(child: left),
                            const SizedBox(width: 8),
                            Expanded(child: right),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _generate(index),
                        icon: const Icon(Icons.auto_awesome_rounded),
                        label: const Text('Generate Name'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (_generated.isEmpty)
                PremiumCard(
                  child: Text(
                    _attempted
                        ? 'No generated suggestions. Try adjusting theme, origin, or Quranic-only filters.'
                        : 'Tap "Generate Name" to get suggestions.',
                  ),
                ),
              ..._generated.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CompactListTile(
                    title: '${entry.name} • ${entry.arabic}',
                    subtitle:
                        '${entry.meaning}\n${_reasonsFor(entry).join(' · ')}',
                    onTap: () => context.pushNamed(
                      'babyNameDetail',
                      pathParameters: {'nameId': entry.id},
                    ),
                  ),
                ),
              ),
            ],
          ),
          loading: () => const PremiumCard(
            child: SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ),
          error: (_, _) => const PremiumCard(
            child: Text('Unable to load generator right now.'),
          ),
        ),
      ],
    );
  }
}
