import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../learn/journey/application/family_learning_provider.dart';
import '../../../learn/journey/domain/learning_path_models.dart';
import '../../../learn/journey/domain/family_learning_models.dart';
import '../../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../../../profile/domain/profile_age_preferences.dart';
import '../application/bedtime_active_learner_service.dart';
import '../domain/bedtime_family_models.dart';

class BedtimeStoryFamilyModePage extends ConsumerWidget {
  const BedtimeStoryFamilyModePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final activeLearner = ref.watch(bedtimeActiveLearnerProvider);
    final learners = ref.watch(bedtimeAvailableLearnersProvider);
    final archived = ref.watch(bedtimeArchivedLearnersProvider);
    final canManage = ref.watch(bedtimeCanManageFamilyModeProvider);
    final activeChildren = learners
        .where((item) => !item.isArchived)
        .toList(growable: false);

    return LearnHubPageScaffold(
      title: l10n.bedtimeFamilyModeTitle,
      subtitle: l10n.bedtimeFamilyModeSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.bedtimeFamilyModeActiveLearnerTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _LearnerCard(
                learner: activeLearner,
                isActive: true,
                canManage: canManage,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (activeLearner.isFallbackLearner) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bedtimeFamilyModeFallbackTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(l10n.bedtimeFamilyModeFallbackSubtitle),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: canManage
                    ? () => _showCreateSheet(context, ref)
                    : null,
                icon: const Icon(Icons.add_circle_outline_rounded),
                label: Text(l10n.bedtimeFamilyModeAddChildAction),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    context.pushNamed('kidsBedtimeStoriesParentDashboard'),
                icon: const Icon(Icons.insights_rounded),
                label: Text(l10n.bedtimeFamilyModeParentDashboardAction),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.bedtimeFamilyModeProfilesTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (activeChildren.isEmpty)
                Text(l10n.bedtimeFamilyModeProfilesEmpty)
              else
                ...activeChildren.map(
                  (learner) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _LearnerCard(
                      learner: learner,
                      isActive: learner.learnerId == activeLearner.learnerId,
                      canManage: canManage,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (archived.isNotEmpty) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bedtimeFamilyModeArchivedTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                ...archived.map(
                  (learner) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ArchivedLearnerRow(learner: learner),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showCreateSheet(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _LearnerEditorSheet(
        title: l10n.bedtimeFamilyModeAddChildAction,
        submitLabel: l10n.bedtimeFamilyModeCreateChildSubmit,
        onSubmit:
            ({
              required String displayName,
              required String avatarReference,
              required LearningAgeGroup ageGroup,
              required String? nickname,
            }) async {
              final notifier = ref.read(familyLearningProvider.notifier);
              await notifier.createChildProfile(
                displayName: displayName,
                ageGroup: ageGroup,
                learningLevel: LearningPathLevel.beginner,
                avatarReference: avatarReference,
                kidsUiThemeMode: KidsUiThemeMode.auto,
                browsingMode: ChildBrowsingMode.guidedOnly,
                permissions: ChildLearningPermissions.defaultsFor(ageGroup),
              );
              final children = ref.read(
                familyLearningChildProfilesForGuardianProvider,
              );
              if (children.isEmpty) {
                return;
              }
              final created =
                  children
                      .where((child) => child.displayName == displayName)
                      .lastOrNull ??
                  children.last;
              if (nickname != null && nickname.trim().isNotEmpty) {
                await ref
                    .read(bedtimeFamilyModeProvider.notifier)
                    .updatePreferences(
                      learnerId: created.id,
                      preferences: BedtimeLearnerPreferences(
                        nickname: nickname.trim(),
                      ),
                    );
              }
              final learners = ref.read(bedtimeAvailableLearnersProvider);
              final createdLearner = learners.firstWhere(
                (item) => item.learnerId == created.id,
                orElse: () => BedtimeLearnerIdentity(
                  learnerId: created.id,
                  linkedChildProfileId: created.id,
                  displayName: created.displayName,
                  avatarReference: created.avatarReference,
                  ageGroup: created.ageGroup,
                  guardianProfileId: ref
                      .read(activeFamilyLearningContextProvider)
                      .activeGuardianProfileId,
                  isFallbackLearner: false,
                  preferences: const BedtimeLearnerPreferences(),
                ),
              );
              await ref
                  .read(bedtimeFamilyModeProvider.notifier)
                  .selectLearner(createdLearner);
            },
      ),
    );
  }
}

class _LearnerCard extends ConsumerWidget {
  const _LearnerCard({
    required this.learner,
    required this.isActive,
    required this.canManage,
  });

  final BedtimeLearnerIdentity learner;
  final bool isActive;
  final bool canManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _bedtimeNoorPanelDecoration(
        context,
        borderColor: isActive ? const Color(0xFFD9B98B) : null,
        borderWidth: isActive ? 1.5 : 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 22, child: Text(learner.avatarReference)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      learner.effectiveDisplayName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      learner.isFallbackLearner
                          ? l10n.bedtimeFamilyModeFallbackBadge
                          : _ageGroupLabel(l10n, learner.ageGroup),
                    ),
                  ],
                ),
              ),
              if (isActive)
                _Tag(label: l10n.bedtimeFamilyModeCurrentLearnerBadge),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (!isActive)
                OutlinedButton.icon(
                  onPressed: () async {
                    await ref
                        .read(bedtimeFamilyModeProvider.notifier)
                        .selectLearner(learner);
                  },
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: Text(l10n.bedtimeFamilyModeSwitchAction),
                ),
              if (canManage)
                FilledButton.tonalIcon(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) =>
                        _LearnerEditorSheet.forExisting(learner: learner),
                  ),
                  icon: const Icon(Icons.edit_rounded),
                  label: Text(l10n.bedtimeFamilyModeEditAction),
                ),
              if (canManage && !learner.isFallbackLearner)
                TextButton.icon(
                  onPressed: () => ref
                      .read(bedtimeFamilyModeProvider.notifier)
                      .archiveLearner(learner.learnerId),
                  icon: const Icon(Icons.archive_rounded),
                  label: Text(l10n.bedtimeFamilyModeArchiveAction),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArchivedLearnerRow extends ConsumerWidget {
  const _ArchivedLearnerRow({required this.learner});

  final BedtimeLearnerIdentity learner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(child: Text(learner.avatarReference)),
          const SizedBox(width: 12),
          Expanded(child: Text(learner.effectiveDisplayName)),
          OutlinedButton(
            onPressed: () => ref
                .read(bedtimeFamilyModeProvider.notifier)
                .unarchiveLearner(learner.learnerId),
            child: Text(l10n.bedtimeFamilyModeRestoreAction),
          ),
        ],
      ),
    );
  }
}

class _LearnerEditorSheet extends ConsumerStatefulWidget {
  const _LearnerEditorSheet({
    required this.title,
    required this.submitLabel,
    required this.onSubmit,
    this.initialDisplayName = '',
    this.initialNickname,
    this.initialAvatar = '🌙',
    this.initialAgeGroup = LearningAgeGroup.kids,
    this.existingLearner,
  });

  factory _LearnerEditorSheet.forExisting({
    required BedtimeLearnerIdentity learner,
  }) {
    return _LearnerEditorSheet(
      title: '',
      submitLabel: '',
      initialDisplayName: learner.displayName,
      initialNickname: learner.preferences.nickname,
      initialAvatar: learner.avatarReference,
      initialAgeGroup: learner.ageGroup,
      existingLearner: learner,
      onSubmit:
          ({
            required String displayName,
            required String avatarReference,
            required LearningAgeGroup ageGroup,
            required String? nickname,
          }) async {},
    );
  }

  final String title;
  final String submitLabel;
  final Future<void> Function({
    required String displayName,
    required String avatarReference,
    required LearningAgeGroup ageGroup,
    required String? nickname,
  })
  onSubmit;
  final String initialDisplayName;
  final String? initialNickname;
  final String initialAvatar;
  final LearningAgeGroup initialAgeGroup;
  final BedtimeLearnerIdentity? existingLearner;

  @override
  ConsumerState<_LearnerEditorSheet> createState() =>
      _LearnerEditorSheetState();
}

class _LearnerEditorSheetState extends ConsumerState<_LearnerEditorSheet> {
  static const _avatars = <String>['🌙', '⭐', '🕊️', '☁️', '🌿', '📘'];

  late final TextEditingController _nameController;
  late final TextEditingController _nicknameController;
  late LearningAgeGroup _ageGroup;
  late String _avatar;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialDisplayName);
    _nicknameController = TextEditingController(
      text: widget.initialNickname ?? '',
    );
    _ageGroup = widget.initialAgeGroup;
    _avatar = widget.initialAvatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final existing = widget.existingLearner;
    final title = existing == null
        ? widget.title
        : l10n.bedtimeFamilyModeEditTitle(existing.effectiveDisplayName);
    final submitLabel = existing == null
        ? widget.submitLabel
        : l10n.bedtimeFamilyModeSaveAction;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.bedtimeFamilyModeNameLabel,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: l10n.bedtimeFamilyModeNicknameLabel,
                  helperText: l10n.bedtimeFamilyModeNicknameHelper,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<LearningAgeGroup>(
                initialValue: _ageGroup,
                decoration: InputDecoration(
                  labelText: l10n.bedtimeFamilyModeAgeGroupLabel,
                ),
                items: LearningAgeGroup.values
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_ageGroupLabel(l10n, value)),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _ageGroup = value);
                },
              ),
              const SizedBox(height: 12),
              Text(
                l10n.bedtimeFamilyModeAvatarLabel,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _avatars
                    .map((avatar) {
                      final selected = _avatar == avatar;
                      return InkWell(
                        onTap: () => setState(() => _avatar = avatar),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: _bedtimeNoorPillDecoration(
                            context,
                            tintColor: selected
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.14)
                                : null,
                          ),
                          child: Text(avatar),
                        ),
                      );
                    })
                    .toList(growable: false),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitting
                      ? null
                      : () async {
                          final displayName = _nameController.text.trim();
                          if (displayName.isEmpty) {
                            return;
                          }
                          setState(() => _submitting = true);
                          try {
                            if (existing == null) {
                              await widget.onSubmit(
                                displayName: displayName,
                                avatarReference: _avatar,
                                ageGroup: _ageGroup,
                                nickname:
                                    _nicknameController.text.trim().isEmpty
                                    ? null
                                    : _nicknameController.text.trim(),
                              );
                            } else {
                              await _updateExisting(existing);
                            }
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _submitting = false);
                            }
                          }
                        },
                  child: Text(submitLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateExisting(BedtimeLearnerIdentity learner) async {
    final nickname = _nicknameController.text.trim();
    final preferences = learner.preferences.copyWith(
      nickname: nickname.isEmpty ? null : nickname,
      clearNickname: nickname.isEmpty,
    );
    await ref
        .read(bedtimeFamilyModeProvider.notifier)
        .updatePreferences(
          learnerId: learner.learnerId,
          preferences: preferences,
        );
    if (!learner.isLinkedChildProfile) {
      return;
    }
    final familyState = ref.read(familyLearningProvider);
    final child = familyState.childProfiles[learner.linkedChildProfileId];
    if (child == null) {
      return;
    }
    await ref
        .read(familyLearningProvider.notifier)
        .updateChildProfile(
          child.copyWith(
            displayName: _nameController.text.trim(),
            avatarReference: _avatar,
            ageGroup: _ageGroup,
          ),
        );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: _bedtimeNoorPillDecoration(context),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

BoxDecoration _bedtimeNoorPillDecoration(
  BuildContext context, {
  Color? tintColor,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.pill,
    tintColor: tintColor,
  );
  return style.decoration(radius: 999);
}

BoxDecoration _bedtimeNoorPanelDecoration(
  BuildContext context, {
  Color? borderColor,
  double borderWidth = 1,
}) {
  final base = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.panel,
  );
  return BoxDecoration(
    color: base.backgroundColor,
    gradient: base.gradient,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: borderColor ?? base.borderColor,
      width: borderWidth,
    ),
    boxShadow: base.boxShadows,
  );
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
