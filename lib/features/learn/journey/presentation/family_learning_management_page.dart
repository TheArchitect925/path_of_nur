import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../accounts_sync/application/accounts_sync_controller.dart';
import '../../../profile/domain/profile_age_preferences.dart';
import '../application/family_learning_provider.dart';
import '../application/learn_together_provider.dart';
import '../data/learning_journey_localized_metadata.dart';
import '../data/learning_journey_registry.dart';
import '../data/learning_path_registry.dart';
import '../domain/family_learning_models.dart';
import '../domain/learning_path_models.dart';

class FamilyLearningManagementPage extends ConsumerStatefulWidget {
  const FamilyLearningManagementPage({super.key});

  @override
  ConsumerState<FamilyLearningManagementPage> createState() =>
      _FamilyLearningManagementPageState();
}

class _FamilyLearningManagementPageState
    extends ConsumerState<FamilyLearningManagementPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final activeContext = ref.watch(activeFamilyLearningContextProvider);
    final accounts = ref.watch(accountsSyncControllerProvider);
    final children = ref.watch(familyLearningChildProfilesForGuardianProvider);
    final activeProfile = accounts.activeProfile;
    final canManage = activeProfile != null &&
        activeProfile.profileType != ProfileKind.child &&
        activeProfile.profileType != ProfileKind.guest;

    return AppPageScaffold(
      headerIcon: Icons.family_restroom_rounded,
      title: l10n.familyLearningManagementTitle,
      subtitle: l10n.familyLearningManagementSubtitle,
      children: [
        if (!canManage)
          PremiumCard(
            child: Text(
              l10n.familyLearningManagementUnavailable,
              style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
            ),
          )
        else ...[
          PremiumCard(
            child: Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.verified_user_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.familyLearningGuardianTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E261F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activeProfile.displayName,
                        style: const TextStyle(
                          color: Color(0xFF675B4E),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: _showAddChildSheet,
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  label: Text(l10n.familyLearningAddChildAction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (children.isEmpty)
            PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.familyLearningEmptyTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E261F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.familyLearningEmptySubtitle,
                    style: const TextStyle(
                      color: Color(0xFF675B4E),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: _showAddChildSheet,
                    child: Text(l10n.familyLearningAddFirstChildAction),
                  ),
                ],
              ),
            )
          else
            ...children.map((child) {
              final progress = ref.watch(
                familyLearningChildProgressProvider(child.id),
              );
              final path = LearningPathRegistry.pathForLevel(child.learningLevel);
              final currentPhase = path?.phases
                  .where((item) => item.id == progress.currentPhaseId)
                  .firstOrNull;
              final currentJourney = progress.currentJourneyId == null
                  ? null
                  : LearningJourneyRegistry.journeyById(progress.currentJourneyId!);
              final recentStage = progress.recentCompletedStageId == null
                  ? null
                  : LearningJourneyRegistry.stageById(progress.recentCompletedStageId!);
              final learnedTogether = ref.watch(
                learnTogetherProvider.select(
                  (state) =>
                      state.learnedTogetherStageIds[child.id]?.contains(
                        progress.currentStageId ?? '',
                      ) ??
                      false,
                ),
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(child: Text(child.avatarReference)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  child.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2E261F),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  LearningPathRegistry.localizedPathTitle(
                                    l10n,
                                    path!,
                                  ),
                                  style: const TextStyle(
                                    color: Color(0xFF675B4E),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showEditChildSheet(child),
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: l10n.familyLearningEditChildAction,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress.progressValue.clamp(0.0, 1.0),
                        minHeight: 7,
                        backgroundColor: const Color(0xFFE8DED1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF8B6A44),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.familyLearningChildProgressLabel(
                          progress.completedJourneyCount,
                          progress.totalJourneyCount,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7A6650),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (currentPhase != null)
                        Text(
                          l10n.familyLearningCurrentPhaseLabel(
                            LearningPathRegistry.localizedPhaseTitle(
                              l10n,
                              currentPhase,
                            ),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF675B4E),
                            height: 1.35,
                          ),
                        ),
                      if (currentJourney != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          l10n.familyLearningCurrentJourneyLabel(
                            localizedJourneyTitle(context, currentJourney),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF675B4E),
                            height: 1.35,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        l10n.familyLearningStreakLabel(progress.currentStreakDays),
                        style: const TextStyle(
                          color: Color(0xFF675B4E),
                          height: 1.35,
                        ),
                      ),
                      if (recentStage != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          l10n.familyLearningRecentActivityLabel(
                            localizedStageTitle(context, recentStage),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF675B4E),
                            height: 1.35,
                          ),
                        ),
                      ],
                      if (learnedTogether) ...[
                        const SizedBox(height: 4),
                        Text(
                          l10n.learnTogetherLearnedTogetherLabel,
                          style: const TextStyle(
                            color: Color(0xFF866A49),
                            height: 1.35,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F1E8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE3D6C4)),
                        ),
                        child: Text(
                          _sharedPrompt(
                            l10n,
                            progress.currentJourneyId,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF675B4E),
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await ref
                                    .read(familyLearningProvider.notifier)
                                    .switchToProfile(child.id);
                                if (!context.mounted) {
                                  return;
                                }
                                context.go('/learn');
                              },
                              icon: const Icon(Icons.switch_account_rounded),
                              label: Text(
                                l10n.familyLearningSwitchToChildAction,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: currentJourney == null
                                  ? null
                                  : () async {
                                      await ref
                                          .read(familyLearningProvider.notifier)
                                          .switchToProfile(child.id);
                                      if (!context.mounted) {
                                        return;
                                      }
                                      context.goNamed(
                                        'learnJourneyDetail',
                                        pathParameters: {
                                          'journeyId': currentJourney.id,
                                        },
                                      );
                                    },
                              icon: const Icon(Icons.favorite_outline_rounded),
                              label: Text(
                                l10n.familyLearningContinueTogetherAction,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (currentJourney != null && progress.currentStageId != null) ...[
                        const SizedBox(height: 10),
                        FilledButton.tonalIcon(
                          onPressed: () async {
                            await ref.read(learnTogetherProvider.notifier).startSession(
                                  childProfileId: child.id,
                                  journeyId: currentJourney.id,
                                  stageId: progress.currentStageId!,
                                );
                            if (!context.mounted) {
                              return;
                            }
                            context.pushNamed(
                              'learnJourneyStage',
                              pathParameters: {
                                'journeyId': currentJourney.id,
                                'stageId': progress.currentStageId!,
                              },
                              queryParameters: {
                                'learnTogetherChildProfileId': child.id,
                              },
                            );
                          },
                          icon: const Icon(Icons.family_restroom_rounded),
                          label: Text(l10n.learnTogetherReviewTogetherAction),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          if (activeContext.familyGroup != null) const SizedBox(height: 4),
        ],
      ],
    );
  }

  Future<void> _showAddChildSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChildProfileEditorSheet(
        titleBuilder: (l10n) => l10n.familyLearningAddChildAction,
        initialDisplayName: '',
        initialAvatar: '🌙',
        initialAgeGroup: LearningAgeGroup.kids,
        initialLevel: LearningPathLevel.beginner,
        initialKidsUiThemeMode: KidsUiThemeMode.auto,
        initialBrowsingMode: ChildBrowsingMode.guidedOnly,
        initialPermissions: ChildLearningPermissions.defaultsFor(
          LearningAgeGroup.kids,
        ),
        onSave: (payload) async {
          await ref.read(familyLearningProvider.notifier).createChildProfile(
                displayName: payload.displayName,
                ageGroup: payload.ageGroup,
                learningLevel: payload.learningLevel,
                avatarReference: payload.avatarReference,
                kidsUiThemeMode: payload.kidsUiThemeMode,
                browsingMode: payload.browsingMode,
                permissions: payload.permissions,
              );
        },
      ),
    );
  }

  Future<void> _showEditChildSheet(ChildLearningProfile child) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChildProfileEditorSheet(
        titleBuilder: (l10n) => l10n.familyLearningEditChildAction,
        initialDisplayName: child.displayName,
        initialAvatar: child.avatarReference,
        initialAgeGroup: child.ageGroup,
        initialLevel: child.learningLevel,
        initialKidsUiThemeMode: child.kidsUiThemeMode,
        initialBrowsingMode: child.browsingMode,
        initialPermissions: child.permissions,
        onSave: (payload) async {
          final assignedPath =
              LearningPathRegistry.pathForLevel(payload.learningLevel);
          if (assignedPath == null) {
            return;
          }
          await ref.read(familyLearningProvider.notifier).updateChildProfile(
                child.copyWith(
                  displayName: payload.displayName,
                  ageGroup: payload.ageGroup,
                  learningLevel: payload.learningLevel,
                  assignedPathId: assignedPath.id,
                  avatarReference: payload.avatarReference,
                  kidsUiThemeMode: payload.kidsUiThemeMode,
                  browsingMode: payload.browsingMode,
                  contentSafetyMode:
                      payload.browsingMode == ChildBrowsingMode.guidedOnly
                      ? ChildContentSafetyMode.guided
                      : ChildContentSafetyMode.guidedWithExplore,
                  permissions: payload.permissions,
                ),
              );
        },
      ),
    );
  }
}

String _sharedPrompt(AppLocalizations l10n, String? journeyId) {
  switch (journeyId) {
    case 'prophets-journey':
    case 'seerah-journey':
      return l10n.familyLearningPromptProphets;
    case 'duas-daily-life':
      return l10n.familyLearningPromptDua;
    case 'daily-dhikr':
      return l10n.familyLearningPromptDhikr;
    default:
      return l10n.familyLearningPromptGeneral;
  }
}

class _ChildProfileEditorPayload {
  const _ChildProfileEditorPayload({
    required this.displayName,
    required this.avatarReference,
    required this.ageGroup,
    required this.learningLevel,
    required this.kidsUiThemeMode,
    required this.browsingMode,
    required this.permissions,
  });

  final String displayName;
  final String avatarReference;
  final LearningAgeGroup ageGroup;
  final LearningPathLevel learningLevel;
  final KidsUiThemeMode kidsUiThemeMode;
  final ChildBrowsingMode browsingMode;
  final ChildLearningPermissions permissions;
}

class _ChildProfileEditorSheet extends StatefulWidget {
  const _ChildProfileEditorSheet({
    required this.titleBuilder,
    required this.initialDisplayName,
    required this.initialAvatar,
    required this.initialAgeGroup,
    required this.initialLevel,
    required this.initialKidsUiThemeMode,
    required this.initialBrowsingMode,
    required this.initialPermissions,
    required this.onSave,
  });

  final String Function(AppLocalizations l10n) titleBuilder;
  final String initialDisplayName;
  final String initialAvatar;
  final LearningAgeGroup initialAgeGroup;
  final LearningPathLevel initialLevel;
  final KidsUiThemeMode initialKidsUiThemeMode;
  final ChildBrowsingMode initialBrowsingMode;
  final ChildLearningPermissions initialPermissions;
  final Future<void> Function(_ChildProfileEditorPayload payload) onSave;

  @override
  State<_ChildProfileEditorSheet> createState() =>
      _ChildProfileEditorSheetState();
}

class _ChildProfileEditorSheetState extends State<_ChildProfileEditorSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _avatarController;
  late LearningAgeGroup _ageGroup;
  late LearningPathLevel _level;
  late KidsUiThemeMode _kidsUiThemeMode;
  late ChildBrowsingMode _browsingMode;
  late ChildLearningPermissions _permissions;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialDisplayName);
    _avatarController = TextEditingController(text: widget.initialAvatar);
    _ageGroup = widget.initialAgeGroup;
    _level = widget.initialLevel;
    _kidsUiThemeMode = widget.initialKidsUiThemeMode;
    _browsingMode = widget.initialBrowsingMode;
    _permissions = widget.initialPermissions;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.titleBuilder(l10n),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.familyLearningChildNameLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _avatarController,
                    decoration: InputDecoration(
                      labelText: l10n.familyLearningChildAvatarLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<LearningAgeGroup>(
                    initialValue: _ageGroup,
                    decoration: InputDecoration(
                      labelText: l10n.familyLearningChildAgeGroupLabel,
                    ),
                    items: LearningAgeGroup.values
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(_ageGroupLabel(l10n, item)),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _ageGroup = value;
                        _permissions =
                            ChildLearningPermissions.defaultsFor(value);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<LearningPathLevel>(
                    initialValue: _level,
                    decoration: InputDecoration(
                      labelText: l10n.familyLearningChildPathLabel,
                    ),
                    items: LearningPathLevel.values
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              LearningPathRegistry.localizedPathTitle(
                                l10n,
                                LearningPathRegistry.pathForLevel(item)!,
                              ),
                            ),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() => _level = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<KidsUiThemeMode>(
                    initialValue: _kidsUiThemeMode,
                    decoration: InputDecoration(
                      labelText: l10n.kidsUiThemeSettingTitle,
                    ),
                    items: KidsUiThemeMode.values
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(_kidsUiModeLabel(l10n, item)),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() => _kidsUiThemeMode = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ChildBrowsingMode>(
                    segments: [
                      ButtonSegment(
                        value: ChildBrowsingMode.guidedOnly,
                        label: Text(l10n.familyLearningGuidedOnlyLabel),
                      ),
                      ButtonSegment(
                        value: ChildBrowsingMode.guidedPlusExplore,
                        label: Text(l10n.familyLearningGuidedPlusExploreLabel),
                      ),
                    ],
                    selected: {_browsingMode},
                    onSelectionChanged: (selection) {
                      setState(() => _browsingMode = selection.first);
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.familyLearningAllowBrowseAll),
                    value: _permissions.allowBrowseAll,
                    onChanged: (value) => setState(
                      () => _permissions =
                          _permissions.copyWith(allowBrowseAll: value),
                    ),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.familyLearningAllowDiscovery),
                    value: _permissions.allowDiscovery,
                    onChanged: (value) => setState(
                      () => _permissions =
                          _permissions.copyWith(allowDiscovery: value),
                    ),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.familyLearningAllowTrivia),
                    value: _permissions.allowTrivia,
                    onChanged: (value) => setState(
                      () => _permissions =
                          _permissions.copyWith(allowTrivia: value),
                    ),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.familyLearningAllowLegacy),
                    value: _permissions.allowLegacyLearning,
                    onChanged: (value) => setState(
                      () => _permissions =
                          _permissions.copyWith(allowLegacyLearning: value),
                    ),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.familyLearningAllowAdvanced),
                    value: _permissions.allowAdvancedJourneys,
                    onChanged: (value) => setState(
                      () => _permissions =
                          _permissions.copyWith(
                            allowAdvancedJourneys: value,
                          ),
                    ),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.familyLearningAllowExploration),
                    value: _permissions.allowSecondaryExploration,
                    onChanged: (value) => setState(
                      () => _permissions =
                          _permissions.copyWith(
                            allowSecondaryExploration: value,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _saving ? null : () => Navigator.of(context).pop(),
                          child: Text(l10n.familyLearningCancelAction),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _saving
                              ? null
                              : () async {
                                  setState(() => _saving = true);
                                  await widget.onSave(
                                    _ChildProfileEditorPayload(
                                      displayName: _nameController.text.trim().isEmpty
                                          ? l10n.familyLearningDefaultChildName
                                          : _nameController.text.trim(),
                                      avatarReference:
                                          _avatarController.text.trim().isEmpty
                                          ? '🌙'
                                          : _avatarController.text.trim(),
                                      ageGroup: _ageGroup,
                                      learningLevel: _level,
                                      kidsUiThemeMode: _kidsUiThemeMode,
                                      browsingMode: _browsingMode,
                                      permissions: _permissions,
                                    ),
                                  );
                                  if (!context.mounted) {
                                    return;
                                  }
                                  Navigator.of(context).pop();
                                },
                          child: Text(l10n.familyLearningSaveAction),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _ageGroupLabel(AppLocalizations l10n, LearningAgeGroup ageGroup) {
  switch (ageGroup) {
    case LearningAgeGroup.kids:
      return l10n.familyLearningAgeGroupKids;
    case LearningAgeGroup.teens:
      return l10n.familyLearningAgeGroupTeens;
    case LearningAgeGroup.adults:
      return l10n.familyLearningAgeGroupAdults;
  }
}

String _kidsUiModeLabel(AppLocalizations l10n, KidsUiThemeMode mode) {
  switch (mode) {
    case KidsUiThemeMode.auto:
      return l10n.kidsUiThemeModeAuto;
    case KidsUiThemeMode.on:
      return l10n.kidsUiThemeModeOn;
    case KidsUiThemeMode.off:
      return l10n.kidsUiThemeModeOff;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
