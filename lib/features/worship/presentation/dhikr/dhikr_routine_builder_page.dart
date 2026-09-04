import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../../learn/dua/application/dua_repository.dart';
import '../../../learn/dua/domain/dua_models.dart';
import '../../application/dhikr_custom_routines_provider.dart';
import '../../application/dhikr_routine_catalog.dart';
import '../../domain/dhikr_custom_routine.dart';
import '../../domain/dhikr_preset.dart';
import '../../domain/dhikr_routine.dart';
import 'widgets/dhikr_pill_button.dart';
import 'widgets/dhikr_sheets.dart';

/// Builds or edits one of the user's own routines: a name and an ordered
/// list of (phrase, count) steps drawn from the presets, the Duas library,
/// or a phrase typed by hand.
class DhikrRoutineBuilderPage extends ConsumerStatefulWidget {
  const DhikrRoutineBuilderPage({super.key, this.routineId});

  /// Id of an existing custom routine to edit; null builds a new one.
  final String? routineId;

  @override
  ConsumerState<DhikrRoutineBuilderPage> createState() =>
      _DhikrRoutineBuilderPageState();
}

class _DhikrRoutineBuilderPageState
    extends ConsumerState<DhikrRoutineBuilderPage> {
  late final TextEditingController _name;
  final List<DhikrRoutineStep> _steps = <DhikrRoutineStep>[];
  DhikrCustomRoutine? _existing;
  String? _error;

  @override
  void initState() {
    super.initState();
    final id = widget.routineId;
    _existing = id == null
        ? null
        : ref.read(dhikrCustomRoutinesProvider.notifier).byId(id);
    _name = TextEditingController(text: _existing?.name ?? '');
    if (_existing != null) _steps.addAll(_existing!.steps);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _addStep(DhikrRoutineStep step) {
    setState(() {
      _steps.add(step);
      _error = null;
    });
  }

  void _move(int index, int delta) {
    final target = index + delta;
    if (target < 0 || target >= _steps.length) return;
    setState(() {
      final step = _steps.removeAt(index);
      _steps.insert(target, step);
    });
  }

  Future<void> _editCount(int index) async {
    final l10n = AppLocalizations.of(context);
    final value = await showDhikrNumberSheet(
      context,
      title: l10n.dhikrBuilderCountSheetTitle,
      initial: _steps[index].count,
    );
    if (value == null || !mounted) return;
    setState(() => _steps[index] = _steps[index].copyWith(count: value));
  }

  void _save() {
    final l10n = AppLocalizations.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.dhikrBuilderNeedsName);
      return;
    }
    if (_steps.isEmpty) {
      setState(() => _error = l10n.dhikrBuilderNeedsSteps);
      return;
    }
    final now = DateTime.now();
    final routine = DhikrCustomRoutine(
      id: _existing?.id ?? DhikrCustomRoutine.newId(now),
      name: name,
      steps: List<DhikrRoutineStep>.unmodifiable(_steps),
      createdAt: _existing?.createdAt ?? now,
    );
    ref.read(dhikrCustomRoutinesProvider.notifier).upsert(routine);
    _leave();
  }

  /// Back to the dhikr hub: pop when the builder was pushed from it, else
  /// (a deep link) go there directly.
  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed('worshipDhikrPage');
    }
  }

  Future<void> _delete() async {
    final existing = _existing;
    if (existing == null) return;
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.dhikrBuilderDeleteTitle),
        content: Text(l10n.dhikrBuilderDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.dhikrBuilderDeleteAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    ref.read(dhikrCustomRoutinesProvider.notifier).delete(existing.id);
    _leave();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = context.palette;
    final isEdit = _existing != null;

    return AppPageScaffold(
      ownsBackground: false,
      title: isEdit ? l10n.dhikrBuilderEditTitle : l10n.dhikrBuilderTitle,
      subtitle: l10n.dhikrBuilderSubtitle,
      children: [
        PremiumCard(
          density: PremiumCardDensity.compact,
          title: Text(l10n.dhikrBuilderNameLabel),
          child: TextField(
            key: const Key('dhikr-builder-name'),
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: l10n.dhikrBuilderNameHint,
              isDense: true,
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        SectionTitle(title: l10n.dhikrBuilderStepsTitle),
        if (_steps.isEmpty)
          PremiumCard(
            density: PremiumCardDensity.compact,
            child: Text(
              l10n.dhikrBuilderStepsEmpty,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: palette.onSurfaceSubtle,
              ),
            ),
          )
        else
          for (var i = 0; i < _steps.length; i++) ...[
            _StepRow(
              key: ValueKey('dhikr-builder-step-$i'),
              index: i,
              step: _steps[i],
              isFirst: i == 0,
              isLast: i == _steps.length - 1,
              onMoveUp: () => _move(i, -1),
              onMoveDown: () => _move(i, 1),
              onRemove: () => setState(() => _steps.removeAt(i)),
              onEditCount: () => _editCount(i),
            ),
            const SizedBox(height: AppSpacing.xxs + 2),
          ],
        const SizedBox(height: AppSpacing.xs),
        DhikrPillButton(
          key: const Key('dhikr-builder-add-step'),
          icon: Icons.add_rounded,
          label: l10n.dhikrBuilderAddStepAction,
          expand: true,
          onTap: () => _showAddStepSheet(context),
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.s),
          Text(
            _error!,
            key: const Key('dhikr-builder-error'),
            style: theme.textTheme.bodyMedium?.copyWith(color: palette.error),
          ),
        ],
        const SizedBox(height: AppSpacing.l),
        DhikrPillButton(
          key: const Key('dhikr-builder-save'),
          icon: Icons.check_rounded,
          label: l10n.dhikrBuilderSaveAction,
          emphasized: true,
          expand: true,
          onTap: _save,
        ),
        if (isEdit) ...[
          const SizedBox(height: AppSpacing.xs),
          DhikrPillButton(
            key: const Key('dhikr-builder-delete'),
            icon: Icons.delete_outline_rounded,
            label: l10n.dhikrBuilderDeleteAction,
            expand: true,
            onTap: _delete,
          ),
        ],
      ],
    );
  }

  Future<void> _showAddStepSheet(BuildContext context) async {
    final step = await showDhikrSheet<DhikrRoutineStep>(
      context,
      builder: (sheetContext) =>
          _AddStepSheet(dataset: ref.read(duaDatasetProvider).valueOrNull),
    );
    if (step != null && mounted) _addStep(step);
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    super.key,
    required this.index,
    required this.step,
    required this.isFirst,
    required this.isLast,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onRemove,
    required this.onEditCount,
  });

  final int index;
  final DhikrRoutineStep step;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onRemove;
  final VoidCallback onEditCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = context.palette;
    return PremiumCard(
      density: PremiumCardDensity.tile,
      child: Row(
        children: [
          CompactTileBadge(label: '${index + 1}'),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                if (step.arabic.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      step.arabic,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyles.quranVerse(
                        size: 16,
                        color: palette.onSurfaceSubtle,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Tooltip(
            message: l10n.dhikrBuilderCountTooltip,
            child: DhikrChoicePill(
              label: '× ${step.count}',
              isSelected: false,
              onTap: onEditCount,
            ),
          ),
          IconButton(
            tooltip: l10n.dhikrBuilderMoveUpTooltip,
            visualDensity: VisualDensity.compact,
            onPressed: isFirst ? null : onMoveUp,
            icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 20),
          ),
          IconButton(
            tooltip: l10n.dhikrBuilderMoveDownTooltip,
            visualDensity: VisualDensity.compact,
            onPressed: isLast ? null : onMoveDown,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          ),
          IconButton(
            tooltip: l10n.dhikrBuilderRemoveTooltip,
            visualDensity: VisualDensity.compact,
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}

enum _StepSource { phrases, adhkar, custom }

class _AddStepSheet extends StatefulWidget {
  const _AddStepSheet({required this.dataset});

  final DuaDataset? dataset;

  @override
  State<_AddStepSheet> createState() => _AddStepSheetState();
}

class _AddStepSheetState extends State<_AddStepSheet> {
  _StepSource _source = _StepSource.phrases;
  final TextEditingController _search = TextEditingController();
  final TextEditingController _label = TextEditingController();
  final TextEditingController _arabic = TextEditingController();
  final TextEditingController _transliteration = TextEditingController();
  final TextEditingController _meaning = TextEditingController();
  final TextEditingController _count = TextEditingController(text: '33');

  @override
  void dispose() {
    _search.dispose();
    _label.dispose();
    _arabic.dispose();
    _transliteration.dispose();
    _meaning.dispose();
    _count.dispose();
    super.dispose();
  }

  List<DuaItem> _matchingDuas() {
    final dataset = widget.dataset;
    if (dataset == null) return const <DuaItem>[];
    final query = _search.text.trim().toLowerCase();
    return <DuaItem>[
      for (final item in dataset.items)
        if (item.arabic.trim().isNotEmpty &&
            (query.isEmpty ||
                item.title.toLowerCase().contains(query) ||
                item.transliteration.toLowerCase().contains(query) ||
                item.subcategoryLabel.toLowerCase().contains(query)))
          item,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = context.palette;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.55;

    Widget row({
      required Key key,
      required String title,
      required String subtitle,
      String arabic = '',
      required DhikrRoutineStep step,
    }) {
      return Material(
        type: MaterialType.transparency,
        child: InkWell(
          key: key,
          borderRadius: BorderRadius.circular(AppRadii.glassTile),
          onTap: () => Navigator.of(context).pop(step),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: palette.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: palette.onSurfaceSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                if (arabic.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.s),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        arabic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.quranVerse(
                          size: 18,
                          color: palette.onSurface,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    final Widget body;
    switch (_source) {
      case _StepSource.phrases:
        body = ListView(
          shrinkWrap: true,
          children: [
            for (final preset in DhikrPreset.defaults)
              row(
                key: Key('dhikr-builder-phrase-${preset.id}'),
                title: preset.label,
                subtitle: preset.translation,
                arabic: preset.phrase,
                step: DhikrRoutineStep(
                  id: preset.id,
                  title: preset.label,
                  arabic: preset.phrase,
                  transliteration: preset.transliteration,
                  translation: preset.translation,
                  count: 33,
                  sourceRef: '',
                ),
              ),
          ],
        );
      case _StepSource.adhkar:
        final items = _matchingDuas();
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: l10n.dhikrBuilderSearchHint,
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final item in items)
                    row(
                      key: Key('dhikr-builder-dua-${item.id}'),
                      title: item.title,
                      subtitle: item.subcategoryLabel,
                      arabic: item.arabic,
                      step: DhikrRoutineStep(
                        id: item.id,
                        title: item.title,
                        arabic: item.arabic,
                        transliteration: item.transliteration,
                        translation: item.translation,
                        count: parseDhikrRepeatCount(item.whenToSay),
                        sourceRef: item.sourceRef,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      case _StepSource.custom:
        body = ListView(
          shrinkWrap: true,
          children: [
            TextField(
              key: const Key('dhikr-builder-custom-label'),
              controller: _label,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.dhikrBuilderCustomLabel,
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _arabic,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.dhikrBuilderCustomArabic,
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _transliteration,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.dhikrBuilderCustomTransliteration,
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _meaning,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.dhikrBuilderCustomMeaning,
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _count,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.dhikrBuilderCustomCount,
                isDense: true,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            DhikrPillButton(
              key: const Key('dhikr-builder-custom-add'),
              label: l10n.dhikrBuilderCustomAddAction,
              emphasized: true,
              expand: true,
              onTap: () {
                final label = _label.text.trim();
                if (label.isEmpty) return;
                final count = int.tryParse(_count.text.trim()) ?? 1;
                Navigator.of(context).pop(
                  DhikrRoutineStep(
                    id: 'phrase-${DateTime.now().microsecondsSinceEpoch}',
                    title: label,
                    arabic: _arabic.text.trim(),
                    transliteration: _transliteration.text.trim(),
                    translation: _meaning.text.trim(),
                    count: count < 1 ? 1 : count,
                    sourceRef: '',
                  ),
                );
              },
            ),
          ],
        );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.dhikrBuilderSheetTitle,
          style: AppTextStyles.titleSerif.copyWith(color: palette.onSurface),
        ),
        const SizedBox(height: AppSpacing.s),
        SegmentedPillControl<_StepSource>(
          items: _StepSource.values,
          selectedItem: _source,
          labelBuilder: (source) => switch (source) {
            _StepSource.phrases => l10n.dhikrBuilderSegmentPhrases,
            _StepSource.adhkar => l10n.dhikrBuilderSegmentAdhkar,
            _StepSource.custom => l10n.dhikrBuilderSegmentCustom,
          },
          onChanged: (source) => setState(() => _source = source),
        ),
        const SizedBox(height: AppSpacing.s),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: body,
        ),
      ],
    );
  }
}
