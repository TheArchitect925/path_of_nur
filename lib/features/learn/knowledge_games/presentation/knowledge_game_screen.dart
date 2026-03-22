import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../domain/knowledge_game_models.dart';
import '../domain/knowledge_game_variations.dart';

class KnowledgeGameScreen extends StatefulWidget {
  const KnowledgeGameScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.game,
    this.session,
    this.result,
    required this.children,
  });

  final String title;
  final String subtitle;
  final KnowledgeGame game;
  final KnowledgeGameSession? session;
  final KnowledgeGameResult? result;
  final List<Widget> children;

  @override
  State<KnowledgeGameScreen> createState() => _KnowledgeGameScreenState();
}

class _KnowledgeGameScreenState extends State<KnowledgeGameScreen> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.game.config.hasVariation(GameVariationType.timed)) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() {
            _now = DateTime.now();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final variationPanel = _buildVariationPanel(context);
    return AppPageScaffold(
      title: widget.title,
      subtitle: widget.subtitle,
      children: [
        if (variationPanel != null) ...[
          variationPanel,
          const SizedBox(height: 12),
        ],
        ...widget.children,
      ],
    );
  }

  Widget? _buildVariationPanel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = widget.game.config;
    if (config.isStandard) return null;
    final chips = <Widget>[
      for (final variation in config.variations)
        if (variation != GameVariationType.standard)
          _chip(context, _variationLabel(l10n, variation)),
    ];
    if (config.hasVariation(GameVariationType.challenge) &&
        config.boolSetting('hintDisabled')) {
      chips.add(_chip(context, l10n.gameVariationHintDisabled));
    }
    final timerLabel = _timerLabel(context);
    if (timerLabel != null) {
      chips.add(_chip(context, timerLabel));
    }
    return PremiumCard(child: Wrap(spacing: 8, runSpacing: 8, children: chips));
  }

  String? _timerLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = widget.game.config;
    if (!config.hasVariation(GameVariationType.timed)) return null;
    final session = widget.session;
    if (session == null) return null;
    final durationSeconds = config.intSetting('durationSeconds', fallback: 180);
    final elapsed = _now.difference(session.startedAt).inSeconds;
    final remaining = durationSeconds - elapsed;
    final clamped = remaining < 0 ? 0 : remaining;
    final minutes = (clamped ~/ 60).toString().padLeft(2, '0');
    final seconds = (clamped % 60).toString().padLeft(2, '0');
    return l10n.gameVariationTimeRemaining('$minutes:$seconds');
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
