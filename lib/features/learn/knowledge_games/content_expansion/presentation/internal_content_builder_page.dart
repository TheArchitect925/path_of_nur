import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../../domain/knowledge_game_variations.dart';
import '../application/content_expansion_repository.dart';
import '../application/content_expansion_validation.dart';
import '../domain/content_expansion_models.dart';
import '../../../../../shared/widgets/premium_card.dart';

class InternalContentBuilderPage extends ConsumerStatefulWidget {
  const InternalContentBuilderPage({super.key});

  @override
  ConsumerState<InternalContentBuilderPage> createState() =>
      _InternalContentBuilderPageState();
}

class _InternalContentBuilderPageState
    extends ConsumerState<InternalContentBuilderPage> {
  late final TextEditingController _idController;
  late final TextEditingController _categoryController;
  late final TextEditingController _difficultyController;
  late final TextEditingController _tagsController;
  late final TextEditingController _packIdsController;
  late final TextEditingController _sourceTypeController;
  late final TextEditingController _sourceReferenceController;
  late final TextEditingController _payloadController;

  ContentItemType _selectedType = ContentItemType.crossword;
  ContentAudience _selectedAudience = ContentAudience.mixed;
  bool _isDailyEligible = false;
  final Set<GameVariationType> _selectedVariations = <GameVariationType>{
    GameVariationType.standard,
  };
  ContentValidationReport? _draftValidation;
  String? _exportJson;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _categoryController = TextEditingController();
    _difficultyController = TextEditingController(text: '1');
    _tagsController = TextEditingController();
    _packIdsController = TextEditingController();
    _sourceTypeController = TextEditingController();
    _sourceReferenceController = TextEditingController();
    _payloadController = TextEditingController();
    _resetPayloadTemplate();
  }

  @override
  void dispose() {
    _idController.dispose();
    _categoryController.dispose();
    _difficultyController.dispose();
    _tagsController.dispose();
    _packIdsController.dispose();
    _sourceTypeController.dispose();
    _sourceReferenceController.dispose();
    _payloadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(contentExpansionRepositoryProvider);
    final snapshot = repository.buildSnapshot();
    final systemReport = repository.validateSnapshot();

    return LearnHubPageScaffold(
      title: l10n.contentBuilderTitle,
      subtitle: l10n.contentBuilderSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.contentBuilderCatalogTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(
                    context,
                    l10n.contentBuilderCatalogCount(
                      l10n.contentBuilderTypeCrossword,
                      snapshot.crossword.length.toString(),
                    ),
                  ),
                  _chip(
                    context,
                    l10n.contentBuilderCatalogCount(
                      l10n.contentBuilderTypeWordSearch,
                      snapshot.wordSearch.length.toString(),
                    ),
                  ),
                  _chip(
                    context,
                    l10n.contentBuilderCatalogCount(
                      l10n.contentBuilderTypeMatching,
                      snapshot.matching.length.toString(),
                    ),
                  ),
                  _chip(
                    context,
                    l10n.contentBuilderCatalogCount(
                      l10n.contentBuilderTypeAyah,
                      snapshot.ayahCompletion.length.toString(),
                    ),
                  ),
                  _chip(
                    context,
                    l10n.contentBuilderCatalogCount(
                      l10n.contentBuilderTypeHadith,
                      snapshot.hadithScenario.length.toString(),
                    ),
                  ),
                  _chip(
                    context,
                    l10n.contentBuilderCatalogCount(
                      l10n.contentBuilderTypeGrowth,
                      snapshot.spiritualGrowth.length.toString(),
                    ),
                  ),
                  _chip(
                    context,
                    l10n.contentBuilderCatalogCount(
                      l10n.contentBuilderTypePack,
                      snapshot.packs.length.toString(),
                    ),
                  ),
                  _chip(
                    context,
                    l10n.contentBuilderCatalogCount(
                      l10n.contentBuilderTypeVariationProfile,
                      snapshot.variationProfiles.length.toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                systemReport.hasErrors
                    ? l10n.contentBuilderValidationErrorsTitle
                    : l10n.contentBuilderValidationCleanTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.contentBuilderValidationIssueCount(
                  systemReport.issues.length.toString(),
                ),
              ),
              if (systemReport.issues.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...systemReport.issues
                    .take(6)
                    .map(
                      (issue) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text('• ${issue.scope}: ${issue.message}'),
                      ),
                    ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.contentBuilderStorageTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(l10n.contentBuilderStorageSubtitle),
              const SizedBox(height: 8),
              const SelectableText(
                'content/crossword/\n'
                'content/word_search/\n'
                'content/matching/\n'
                'content/ayah/\n'
                'content/hadith/\n'
                'content/growth/\n'
                'content/packs/\n'
                'content/variations/',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.contentBuilderDraftTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ContentItemType>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  labelText: l10n.contentBuilderTypeLabel,
                ),
                items: ContentItemType.values
                    .map(
                      (item) => DropdownMenuItem<ContentItemType>(
                        value: item,
                        child: Text(_typeLabel(l10n, item)),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedType = value;
                    _selectedVariations
                      ..clear()
                      ..add(GameVariationType.standard);
                    _draftValidation = null;
                    _exportJson = null;
                    _resetPayloadTemplate();
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        labelText: l10n.contentBuilderIdLabel,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _categoryController,
                      decoration: InputDecoration(
                        labelText: l10n.contentBuilderCategoryLabel,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _difficultyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.contentBuilderDifficultyLabel,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<ContentAudience>(
                      initialValue: _selectedAudience,
                      decoration: InputDecoration(
                        labelText: l10n.contentBuilderAudienceLabel,
                      ),
                      items: ContentAudience.values
                          .map(
                            (item) => DropdownMenuItem<ContentAudience>(
                              value: item,
                              child: Text(_audienceLabel(l10n, item)),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedAudience = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: l10n.contentBuilderTagsLabel,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _packIdsController,
                decoration: InputDecoration(
                  labelText: l10n.contentBuilderPackIdsLabel,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _sourceTypeController,
                      decoration: InputDecoration(
                        labelText: l10n.contentBuilderSourceTypeLabel,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _sourceReferenceController,
                      decoration: InputDecoration(
                        labelText: l10n.contentBuilderSourceReferenceLabel,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _isDailyEligible,
                onChanged: (value) {
                  setState(() => _isDailyEligible = value);
                },
                title: Text(l10n.contentBuilderDailyEligibleLabel),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.contentBuilderVariationsLabel,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: GameVariationType.values
                    .map((variation) {
                      return FilterChip(
                        label: Text(_variationLabel(l10n, variation)),
                        selected: _selectedVariations.contains(variation),
                        onSelected: (selected) {
                          setState(() {
                            if (variation == GameVariationType.standard &&
                                selected) {
                              _selectedVariations
                                ..clear()
                                ..add(GameVariationType.standard);
                              return;
                            }
                            _selectedVariations.remove(
                              GameVariationType.standard,
                            );
                            if (selected) {
                              _selectedVariations.add(variation);
                            } else {
                              _selectedVariations.remove(variation);
                            }
                            if (_selectedVariations.isEmpty) {
                              _selectedVariations.add(
                                GameVariationType.standard,
                              );
                            }
                          });
                        },
                      );
                    })
                    .toList(growable: false),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _payloadController,
                minLines: 12,
                maxLines: 20,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: l10n.contentBuilderPayloadLabel,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => _validateDraft(repository),
                    icon: const Icon(Icons.verified_outlined),
                    label: Text(l10n.contentBuilderValidateAction),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      setState(() {
                        _draftValidation = null;
                        _exportJson = null;
                        _resetPayloadTemplate();
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.contentBuilderResetTemplateAction),
                  ),
                  FilledButton.tonalIcon(
                    onPressed:
                        _draftValidation == null || _draftValidation!.hasErrors
                        ? null
                        : () => _exportDraft(repository),
                    icon: const Icon(Icons.download_rounded),
                    label: Text(l10n.contentBuilderExportAction),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_draftValidation != null)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _draftValidation!.hasErrors
                      ? l10n.contentBuilderDraftInvalidTitle
                      : l10n.contentBuilderDraftValidTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (_draftValidation!.issues.isEmpty)
                  Text(l10n.contentBuilderDraftValidSubtitle)
                else
                  ..._draftValidation!.issues.map(
                    (issue) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '• ${issue.scope}: ${issue.message}',
                        style: TextStyle(
                          color:
                              issue.severity == ContentValidationSeverity.error
                              ? Theme.of(context).colorScheme.error
                              : null,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (_draftValidation != null) const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.contentBuilderPreviewTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ..._buildPreview(context),
            ],
          ),
        ),
        if ((_exportJson ?? '').isNotEmpty) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.contentBuilderExportTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SelectableText(_exportJson!),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildPreview(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final parsed = _buildDraft();
    if (parsed.$2 != null) {
      return <Widget>[Text(parsed.$2!)];
    }
    final draft = parsed.$1!;
    final payload = draft.payload;
    return <Widget>[
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _chip(
            context,
            draft.id.isEmpty ? l10n.contentBuilderPreviewMissingId : draft.id,
          ),
          _chip(
            context,
            draft.category.isEmpty
                ? l10n.contentBuilderPreviewMissingCategory
                : draft.category,
          ),
          _chip(
            context,
            l10n.contentBuilderPreviewDifficulty(draft.difficulty.toString()),
          ),
          _chip(context, _audienceLabel(l10n, draft.audience)),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        _typeLabel(l10n, draft.type),
        style: Theme.of(context).textTheme.titleSmall,
      ),
      const SizedBox(height: 6),
      Text(_previewSubtitle(l10n, draft.type, payload)),
    ];
  }

  String _previewSubtitle(
    AppLocalizations l10n,
    ContentItemType type,
    Map<String, Object?> payload,
  ) {
    return switch (type) {
      ContentItemType.crossword => l10n.contentBuilderPreviewCrossword(
        '${payload['gridSize'] ?? 0}',
        '${(payload['placements'] as List<dynamic>? ?? const []).length}',
      ),
      ContentItemType.wordSearch => l10n.contentBuilderPreviewWordSearch(
        '${payload['gridSize'] ?? 0}',
        '${(payload['entryIds'] as List<dynamic>? ?? const []).length}',
      ),
      ContentItemType.matching => l10n.contentBuilderPreviewMatching(
        '${(payload['pairIds'] as List<dynamic>? ?? const []).length}',
      ),
      ContentItemType.ayahCompletion => l10n.contentBuilderPreviewAyah(
        '${payload['surah'] ?? 0}',
        '${payload['ayah'] ?? 0}',
      ),
      ContentItemType.hadithScenario => l10n.contentBuilderPreviewHadith(
        '${(payload['choices'] as List<dynamic>? ?? const []).length}',
      ),
      ContentItemType.spiritualGrowth => l10n.contentBuilderPreviewGrowth(
        payload['subtype']?.toString() ?? '',
      ),
      ContentItemType.pack => l10n.contentBuilderPreviewPack(
        '${(payload['contentIds'] as List<dynamic>? ?? const []).length}',
      ),
      ContentItemType.variationProfile =>
        l10n.contentBuilderPreviewVariationProfile(
          payload['gameType']?.toString() ?? '',
        ),
    };
  }

  (InternalBuilderDraft?, String?) _buildDraft() {
    try {
      final payload = jsonDecode(_payloadController.text);
      if (payload is! Map) {
        return (
          null,
          AppLocalizations.of(context).contentBuilderPayloadInvalid,
        );
      }
      return (
        InternalBuilderDraft(
          type: _selectedType,
          id: _idController.text.trim(),
          category: _categoryController.text.trim(),
          difficulty: int.tryParse(_difficultyController.text.trim()) ?? 0,
          tags: _splitCsv(_tagsController.text),
          isDailyEligible: _isDailyEligible,
          supportedVariations: _selectedVariations.toList(growable: false),
          audience: _selectedAudience,
          sourceType: _sourceTypeController.text.trim().isEmpty
              ? null
              : _sourceTypeController.text.trim(),
          sourceReference: _sourceReferenceController.text.trim().isEmpty
              ? null
              : _sourceReferenceController.text.trim(),
          packIds: _splitCsv(_packIdsController.text),
          payload: Map<String, Object?>.from(payload),
        ),
        null,
      );
    } catch (_) {
      return (null, AppLocalizations.of(context).contentBuilderPayloadInvalid);
    }
  }

  void _validateDraft(ContentExpansionRepository repository) {
    final draft = _buildDraft();
    if (draft.$1 == null) {
      setState(() {
        _draftValidation = ContentValidationReport(<ContentValidationIssue>[
          ContentValidationIssue(
            severity: ContentValidationSeverity.error,
            scope: 'payload',
            message: draft.$2 ?? '',
          ),
        ]);
        _exportJson = null;
      });
      return;
    }
    setState(() {
      _draftValidation = repository.validateDraft(draft.$1!);
      _exportJson = null;
    });
  }

  void _exportDraft(ContentExpansionRepository repository) {
    final draft = _buildDraft();
    if (draft.$1 == null) return;
    setState(() {
      _exportJson = repository.exportDraftAsJson(draft.$1!);
    });
  }

  void _resetPayloadTemplate() {
    final repository = ref.read(contentExpansionRepositoryProvider);
    _payloadController.text = const JsonEncoder.withIndent(
      '  ',
    ).convert(repository.templatePayloadFor(_selectedType));
  }

  List<String> _splitCsv(String raw) {
    return raw
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  String _typeLabel(AppLocalizations l10n, ContentItemType type) {
    return switch (type) {
      ContentItemType.crossword => l10n.contentBuilderTypeCrossword,
      ContentItemType.wordSearch => l10n.contentBuilderTypeWordSearch,
      ContentItemType.matching => l10n.contentBuilderTypeMatching,
      ContentItemType.ayahCompletion => l10n.contentBuilderTypeAyah,
      ContentItemType.hadithScenario => l10n.contentBuilderTypeHadith,
      ContentItemType.spiritualGrowth => l10n.contentBuilderTypeGrowth,
      ContentItemType.pack => l10n.contentBuilderTypePack,
      ContentItemType.variationProfile =>
        l10n.contentBuilderTypeVariationProfile,
    };
  }

  String _audienceLabel(AppLocalizations l10n, ContentAudience audience) {
    return switch (audience) {
      ContentAudience.kids => l10n.contentBuilderAudienceKids,
      ContentAudience.adult => l10n.contentBuilderAudienceAdult,
      ContentAudience.mixed => l10n.contentBuilderAudienceMixed,
    };
  }

  String _variationLabel(AppLocalizations l10n, GameVariationType variation) {
    return switch (variation) {
      GameVariationType.standard => l10n.gameVariationStandard,
      GameVariationType.timed => l10n.gameVariationTimed,
      GameVariationType.memory => l10n.gameVariationMemory,
      GameVariationType.sequential => l10n.gameVariationSequential,
      GameVariationType.reflection => l10n.gameVariationReflection,
      GameVariationType.audio => l10n.gameVariationAudio,
      GameVariationType.challenge => l10n.gameVariationChallenge,
      GameVariationType.fog => l10n.gameVariationFog,
      GameVariationType.noClue => l10n.gameVariationNoClue,
      GameVariationType.reverse => l10n.gameVariationReverse,
    };
  }

  Widget _chip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Text(label),
    );
  }
}
