import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/persistence/local_store.dart';
import '../../journal/application/journal_provider.dart';
import '../../learn/content/application/learn_progress_provider.dart';

enum AssistantRole { user, assistant }

enum AssistantIntent {
  appGuide,
  dailyFocus,
  quranSuggestion,
  reflectionPrompt,
  journalPrompt,
  learnPath,
  circles,
}

class AssistantQuickAction {
  const AssistantQuickAction({
    required this.label,
    required this.routeName,
  });

  final String label;
  final String routeName;
}

class AssistantMessage {
  const AssistantMessage({
    required this.role,
    required this.text,
    required this.createdAtIso,
    this.intent,
  });

  final AssistantRole role;
  final String text;
  final String createdAtIso;
  final AssistantIntent? intent;

  Map<String, dynamic> toJson() => {
        'role': role.name,
        'text': text,
        'createdAtIso': createdAtIso,
        'intent': intent?.name,
      };

  static AssistantMessage? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final roleName = raw['role']?.toString();
    final text = raw['text']?.toString();
    final createdAtIso = raw['createdAtIso']?.toString();
    if (roleName == null || text == null || createdAtIso == null) return null;

    AssistantRole? role;
    for (final item in AssistantRole.values) {
      if (item.name == roleName) {
        role = item;
        break;
      }
    }
    if (role == null) return null;

    AssistantIntent? intent;
    final intentName = raw['intent']?.toString();
    if (intentName != null) {
      for (final item in AssistantIntent.values) {
        if (item.name == intentName) {
          intent = item;
          break;
        }
      }
    }

    return AssistantMessage(
      role: role,
      text: text,
      createdAtIso: createdAtIso,
      intent: intent,
    );
  }
}

class AssistantState {
  const AssistantState({
    required this.messages,
    required this.quickPrompts,
    required this.recentPrompts,
  });

  final List<AssistantMessage> messages;
  final List<String> quickPrompts;
  final List<String> recentPrompts;

  AssistantState copyWith({
    List<AssistantMessage>? messages,
    List<String>? quickPrompts,
    List<String>? recentPrompts,
  }) {
    return AssistantState(
      messages: messages ?? this.messages,
      quickPrompts: quickPrompts ?? this.quickPrompts,
      recentPrompts: recentPrompts ?? this.recentPrompts,
    );
  }

  Map<String, dynamic> toJson() => {
        'messages': messages.map((e) => e.toJson()).toList(),
        'recentPrompts': recentPrompts,
      };

  static AssistantState fromJson(Map<String, dynamic>? json) {
    final prompts = const [
      'Help me find a section',
      'What should I focus on today?',
      'Give me a reflection prompt',
      'Suggest a Quran topic',
      'Help me continue learning',
      'Suggest a journal prompt',
    ];

    if (json == null) {
      return AssistantState(
        messages: const [],
        quickPrompts: prompts,
        recentPrompts: const [],
      );
    }

    final items = <AssistantMessage>[];
    final rawMessages = json['messages'];
    if (rawMessages is List) {
      for (final row in rawMessages) {
        final parsed = AssistantMessage.fromJson(row);
        if (parsed != null) items.add(parsed);
      }
    }

    final recent = <String>[];
    final rawRecent = json['recentPrompts'];
    if (rawRecent is List) {
      for (final row in rawRecent) {
        final value = row.toString().trim();
        if (value.isNotEmpty) recent.add(value);
      }
    }

    return AssistantState(messages: items, quickPrompts: prompts, recentPrompts: recent);
  }
}

class AssistantNotifier extends StateNotifier<AssistantState> {
  AssistantNotifier(this._store)
      : super(AssistantState.fromJson(_store.getJsonMap(_key)));

  static const _key = 'assistant.thread';
  final LocalStore _store;

  void send(String input) {
    final text = input.trim();
    if (text.isEmpty) return;

    final now = DateTime.now().toIso8601String();
    final userMessage = AssistantMessage(
      role: AssistantRole.user,
      text: text,
      createdAtIso: now,
    );

    final reply = _mockReply(text);
    final assistantMessage = AssistantMessage(
      role: AssistantRole.assistant,
      text: reply.$1,
      createdAtIso: DateTime.now().toIso8601String(),
      intent: reply.$2,
    );

    final recentPrompts = List<String>.from(state.recentPrompts);
    recentPrompts.remove(text);
    recentPrompts.insert(0, text);
    if (recentPrompts.length > 12) {
      recentPrompts.removeRange(12, recentPrompts.length);
    }

    state = state.copyWith(
      messages: [...state.messages, userMessage, assistantMessage],
      recentPrompts: recentPrompts,
    );
    _save();
  }

  void clear() {
    state = state.copyWith(messages: []);
    _save();
  }

  (String, AssistantIntent) _mockReply(String input) {
    final q = input.toLowerCase();
    if (q.contains('focus') || q.contains('today')) {
      return (
        'Start with your next prayer, then a short dhikr set, and one reflection note.',
        AssistantIntent.dailyFocus,
      );
    }
    if (q.contains('learn') || q.contains('topic')) {
      return (
        'Open Learn and resume your latest topic, then add a short reflection entry.',
        AssistantIntent.learnPath,
      );
    }
    if (q.contains('quran') || q.contains('surah')) {
      return (
        'Try continuing your current surah, then open Life Through the Quran for one topic.',
        AssistantIntent.quranSuggestion,
      );
    }
    if (q.contains('journal') || q.contains('reflection')) {
      return (
        'Write one sincere line about what softened your heart today.',
        AssistantIntent.journalPrompt,
      );
    }
    if (q.contains('community') || q.contains('circle')) {
      return (
        'Open Community Circles and join one group aligned with your current goals.',
        AssistantIntent.circles,
      );
    }
    return (
      'I can help you navigate Worship, Learn, Journey, Journal, and Circles. Ask where to go next.',
      AssistantIntent.appGuide,
    );
  }

  void _save() {
    _store.setJsonMap(_key, state.toJson());
  }
}

final assistantProvider =
    StateNotifierProvider<AssistantNotifier, AssistantState>(
  (ref) => AssistantNotifier(ref.watch(localStoreProvider)),
);

final assistantModeAwarePromptProvider = Provider<List<String>>((ref) {
  final mode = ref.watch(specialModeProvider);
  final learn = ref.watch(learnProgressSummaryProvider);
  final journal = ref.watch(journalProvider);

  final prompts = <String>[
    'Show me what to focus on today',
    'Guide me to continue my learning path',
    'Give me a short reflection prompt',
  ];

  if (mode.isRamadan) {
    prompts.add('Give me a Ramadan-friendly focus plan');
  }
  if (mode.isLoss) {
    prompts.add('Offer a gentle reminder for heavy days');
  }
  if (mode.isGentle) {
    prompts.add('Give me one easy step for today');
  }
  if (mode.isKids) {
    prompts.add('Give me a kids-friendly story prompt');
  }
  if (learn.completedCount < learn.startedCount) {
    prompts.add('What topic should I resume now?');
  }
  if (journal.entries.isEmpty) {
    prompts.add('Help me start my first journal entry');
  }

  return prompts;
});

final assistantQuickActionsProvider = Provider<List<AssistantQuickAction>>((ref) {
  return const [
    AssistantQuickAction(label: 'Open Learn', routeName: 'learnLifeLanding'),
    AssistantQuickAction(label: 'Open Quran', routeName: 'quranExplorer'),
    AssistantQuickAction(label: 'Open Journal', routeName: 'journalTimeline'),
    AssistantQuickAction(label: 'Open Circles', routeName: 'circlesDiscovery'),
  ];
});
