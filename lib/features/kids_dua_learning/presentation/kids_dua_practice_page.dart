import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../application/kids_dua_experience_provider.dart';
import '../application/kids_dua_progress_provider.dart';
import '../domain/kids_dua_models.dart';

class KidsDuaPracticePage extends ConsumerStatefulWidget {
  const KidsDuaPracticePage({super.key});

  @override
  ConsumerState<KidsDuaPracticePage> createState() =>
      _KidsDuaPracticePageState();
}

class _KidsDuaPracticePageState extends ConsumerState<KidsDuaPracticePage> {
  int _index = 0;
  int _correct = 0;
  int? _selectedIndex;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final questions = ref.watch(kidsDuaPracticeQuestionsProvider);
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.kidsDuaPracticeTitle)),
        body: Center(child: Text(l10n.kidsDuaPracticeEmpty)),
      );
    }
    final question = questions[_index.clamp(0, questions.length - 1)];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.kidsDuaPracticeTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8EF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE7D7BE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _questionTypeLabel(l10n, question.type),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  question.prompt,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...question.options.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _PracticeOption(
                title: entry.value,
                selected: _selectedIndex == entry.key,
                correct: _submitted ? entry.key == question.correctIndex : null,
                onTap: _submitted
                    ? null
                    : () => setState(() => _selectedIndex = entry.key),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _selectedIndex == null
                ? null
                : () {
                    final isCorrect = _selectedIndex == question.correctIndex;
                    if (_submitted) {
                      if (!isCorrect) {
                        setState(() {
                          _submitted = false;
                          _selectedIndex = null;
                        });
                        return;
                      }
                      final nextIndex = _index + 1;
                      if (nextIndex >= questions.length) {
                        final result = ref
                            .read(kidsDuaLearningProvider.notifier)
                            .recordPracticeSession(
                              practicedLessonIds: questions
                                  .map((q) => q.relatedDuaId)
                                  .toList(growable: false),
                              correctAnswers: _correct,
                              totalQuestions: questions.length,
                            );
                        showModalBottomSheet<void>(
                          context: context,
                          showDragHandle: true,
                          builder: (context) =>
                              _PracticeSummary(result: result),
                        );
                        return;
                      }
                      setState(() {
                        _index = nextIndex;
                        _selectedIndex = null;
                        _submitted = false;
                      });
                      return;
                    }
                    setState(() {
                      _submitted = true;
                      if (isCorrect) _correct += 1;
                    });
                  },
            child: Text(
              _submitted
                  ? (_selectedIndex == question.correctIndex
                        ? l10n.kidsDuaPracticeNextAction
                        : l10n.kidsDuaPracticeRetryAction)
                  : l10n.kidsDuaPracticeCheckAction,
            ),
          ),
          if (_submitted) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _selectedIndex == question.correctIndex
                    ? const Color(0xFFEAF5E2)
                    : const Color(0xFFFFF4E8),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedIndex == question.correctIndex
                        ? l10n.kidsDuaPracticeMashaAllah
                        : l10n.kidsDuaPracticeTryAgain,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6D6255),
                    ),
                  ),
                  if (question.explanation != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      question.explanation!,
                      style: const TextStyle(
                        color: Color(0xFF6D6255),
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PracticeOption extends StatelessWidget {
  const _PracticeOption({
    required this.title,
    required this.selected,
    required this.correct,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final bool? correct;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor;
    if (correct == true) {
      borderColor = const Color(0xFF78A65A);
    } else if (selected) {
      borderColor = const Color(0xFFB58B4D);
    } else {
      borderColor = const Color(0xFFE8DDD0);
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (correct == true)
              const Icon(Icons.check_circle_rounded, color: Color(0xFF78A65A)),
          ],
        ),
      ),
    );
  }
}

class _PracticeSummary extends StatelessWidget {
  const _PracticeSummary({required this.result});

  final KidsDuaPracticeResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaPracticeSummaryTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.kidsDuaPracticeSummaryBody(
              result.correctAnswers,
              result.totalQuestions,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.kidsDuaPracticeAgainAction),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.goNamed('kidsDuaLanding');
                  },
                  child: Text(l10n.kidsDuaContinueAction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _questionTypeLabel(
  AppLocalizations l10n,
  KidsDuaPracticeQuestionType type,
) {
  switch (type) {
    case KidsDuaPracticeQuestionType.matchSituation:
      return l10n.kidsDuaPracticeModeMatchSituation;
    case KidsDuaPracticeQuestionType.meaning:
      return l10n.kidsDuaPracticeModeMeaning;
    case KidsDuaPracticeQuestionType.behavior:
      return l10n.kidsDuaPracticeModeBehavior;
  }
}
