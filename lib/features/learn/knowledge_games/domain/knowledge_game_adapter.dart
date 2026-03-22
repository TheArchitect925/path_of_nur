import 'package:flutter/widgets.dart';

import 'knowledge_game_models.dart';

abstract class KnowledgeGameAdapter<TGame, TProgress> {
  String get type;

  KnowledgeGame toGame(TGame game);

  KnowledgeGameSession createSession({
    required TGame game,
    required TProgress progress,
  });

  KnowledgeGameResult evaluate({
    required TGame game,
    required TProgress progress,
    required int xpEarned,
    required int dropsEarned,
  });

  Widget buildScreen({
    required BuildContext context,
    required String title,
    required String subtitle,
    required KnowledgeGame game,
    KnowledgeGameSession? session,
    KnowledgeGameResult? result,
    required List<Widget> children,
  });
}
