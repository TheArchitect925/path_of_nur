import '../domain/revelation_core_message.dart';
import '../domain/revelation_era.dart';
import '../domain/revelation_human_pattern.dart';

const List<RevelationEra> seededRevelationEras = [
  RevelationEra(
    id: 'beginnings_humanity',
    title: 'Beginnings of Humanity',
    summary: 'Creation, accountability, and the first return to Allah.',
    regionLabel: 'Early Earth / Symbolic human beginning',
    civilizationTitle: 'Early Humanity',
    civilizationSummary:
        'The beginning of human life where knowledge, obedience, and repentance are established as enduring foundations.',
    prophetIds: ['adam', 'idris'],
    featuredProphetIds: ['adam'],
    coreMessages: [
      CoreMessageItem(
        id: 'beginnings_tawhid',
        text: 'Worship Allah alone from the very beginning.',
      ),
      CoreMessageItem(
        id: 'beginnings_return',
        text: 'Return quickly in repentance after error.',
      ),
    ],
    humanPatterns: [
      RevelationHumanPattern(
        id: 'pride_and_slip',
        title: 'Arrogance and the First Slip',
        summary:
            'Pride leads to ruin while sincere repentance opens mercy again.',
        prophetIds: ['adam'],
      ),
      RevelationHumanPattern(
        id: 'knowledge_as_trust',
        title: 'Knowledge as Trust',
        summary:
            'Knowledge can elevate the heart when it remains tied to obedience.',
        prophetIds: ['adam', 'idris'],
      ),
    ],
    reflectionPrompts: [
      'What does it mean to begin again with sincerity?',
      'How can knowledge become worship in daily life?',
      'Where do I need repentance more than excuses?',
    ],
    relatedGrowthHabitIds: [
      'daily_istighfar',
      'make_dua_daily',
      'study_islamic_knowledge',
    ],
    mapMetadata: RevelationMapMetadata(
      label: 'Symbolic human beginning region',
      locationConfidence: 'symbolic',
    ),
    order: 1,
  ),
  RevelationEra(
    id: 'early_warnings',
    title: 'Early Warnings',
    summary: 'Long patience in calling people back to tawhid.',
    regionLabel: 'Mesopotamia region (traditional / approximate)',
    civilizationTitle: 'Early Civilizations',
    civilizationSummary:
        'Settled communities expanded while public disbelief and stubborn rejection grew.',
    prophetIds: ['nuh'],
    featuredProphetIds: ['nuh'],
    coreMessages: [
      CoreMessageItem(
        id: 'warnings_tawhid',
        text: 'Worship Allah alone and leave false worship.',
      ),
      CoreMessageItem(
        id: 'warnings_patience',
        text: 'Stay patient and sincere even when results are slow.',
      ),
    ],
    humanPatterns: [
      RevelationHumanPattern(
        id: 'mockery_of_truth',
        title: 'Mockery of Truth',
        summary:
            'Clear warning is often met with ridicule when hearts resist change.',
        prophetIds: ['nuh'],
      ),
      RevelationHumanPattern(
        id: 'stubborn_rejection',
        title: 'Stubborn Rejection',
        summary:
            'People may demand proof while refusing sincere response to the signs already present.',
        prophetIds: ['nuh'],
      ),
    ],
    reflectionPrompts: [
      'What helps a believer stay sincere when results are slow?',
      'How can patience remain active, not passive?',
      'Where do people dismiss warning through mockery today?',
    ],
    relatedGrowthHabitIds: [
      'practice_patience',
      'read_quran_daily',
      'make_dua_daily',
    ],
    mapMetadata: RevelationMapMetadata(
      label: 'Mesopotamia region',
      locationConfidence: 'approximate',
    ),
    order: 2,
  ),
  RevelationEra(
    id: 'post_flood_peoples',
    title: 'Post-Flood Peoples',
    summary: 'Civilizations rose again and repeated pride and denial.',
    regionLabel:
        'People of \u0027Ad and Thamud / Arabia (traditional / approximate)',
    civilizationTitle: 'Post-Flood Arabia',
    civilizationSummary:
        'Advanced communities rebuilt with visible strength, but many mistook power for security.',
    prophetIds: ['hud', 'salih', 'shuayb'],
    featuredProphetIds: ['hud', 'salih'],
    coreMessages: [
      CoreMessageItem(
        id: 'postflood_humility',
        text: 'Do not let worldly strength make you arrogant.',
      ),
      CoreMessageItem(
        id: 'postflood_obedience',
        text: 'Receive warning with humility before consequences arrive.',
      ),
    ],
    humanPatterns: [
      RevelationHumanPattern(
        id: 'false_confidence',
        title: 'False Confidence in Strength',
        summary:
            'Material strength can create the illusion of safety from Allah\'s command.',
        prophetIds: ['hud', 'salih', 'shuayb'],
      ),
      RevelationHumanPattern(
        id: 'rejection_after_signs',
        title: 'Rejection After Clear Signs',
        summary:
            'The heart may reject obvious signs when pride is stronger than sincerity.',
        prophetIds: ['salih'],
      ),
    ],
    reflectionPrompts: [
      'How does prosperity become a spiritual test?',
      'What prevents the heart from accepting warning?',
      'Where can humility protect me from false confidence?',
    ],
    relatedGrowthHabitIds: [
      'practice_humility',
      'practice_gratitude',
      'end_day_with_reflection_and_tawbah',
    ],
    mapMetadata: RevelationMapMetadata(
      label: 'Arabian regions of \u0027Ad and Thamud',
      locationConfidence: 'traditional / approximate',
    ),
    order: 3,
  ),
  RevelationEra(
    id: 'family_of_ibrahim',
    title: 'Family of Ibrahim',
    summary: 'A lineage of submission, sacrifice, and covenant.',
    regionLabel: 'Iraq, Palestine, and Arabia (traditional / approximate)',
    civilizationTitle: 'Family of Ibrahim',
    civilizationSummary:
        'A sacred family line carried tawhid across lands, generations, trials, and leadership.',
    prophetIds: ['ibrahim', 'lut', 'ismail', 'ishaq', 'yaqub', 'yusuf'],
    featuredProphetIds: ['ibrahim', 'yusuf'],
    coreMessages: [
      CoreMessageItem(
        id: 'ibrahim_tawhid',
        text: 'Submit with sincerity and reject false worship.',
      ),
      CoreMessageItem(
        id: 'ibrahim_family',
        text: 'Build a legacy of worship across generations.',
      ),
    ],
    humanPatterns: [
      RevelationHumanPattern(
        id: 'moral_corruption',
        title: 'Corruption Becoming Normalized',
        summary:
            'When wrongdoing is repeated publicly, truth can appear strange to society.',
        prophetIds: ['lut'],
      ),
      RevelationHumanPattern(
        id: 'jealousy_and_betrayal',
        title: 'Jealousy and Family Trial',
        summary:
            'Even family life can carry deep tests that require patience and forgiveness.',
        prophetIds: ['yusuf', 'yaqub'],
      ),
    ],
    reflectionPrompts: [
      'Which trial in this era speaks most to your life now?',
      'How can family life become a path of worship?',
      'What does sincere surrender look like for me today?',
    ],
    relatedGrowthHabitIds: [
      'read_quran_daily',
      'make_dua_daily',
      'reconnect_with_family',
      'practice_patience',
    ],
    mapMetadata: RevelationMapMetadata(
      label: 'Iraq to Levant and Arabia journey regions',
      locationConfidence: 'traditional / approximate',
    ),
    order: 4,
  ),
  RevelationEra(
    id: 'liberation_law',
    title: 'Liberation and Law',
    summary: 'Freedom from oppression and guidance through revelation.',
    regionLabel: 'Egypt and Sinai',
    civilizationTitle: 'Egypt and Sinai',
    civilizationSummary:
        'A people oppressed by tyranny were rescued and then tested through responsibility and law.',
    prophetIds: ['musa', 'harun'],
    featuredProphetIds: ['musa'],
    coreMessages: [
      CoreMessageItem(
        id: 'liberation_truth',
        text: 'Stand against tyranny with trust in Allah.',
      ),
      CoreMessageItem(
        id: 'liberation_law',
        text: 'Freedom must be anchored in obedience and justice.',
      ),
    ],
    humanPatterns: [
      RevelationHumanPattern(
        id: 'tyranny_and_oppression',
        title: 'Tyranny and Oppression',
        summary:
            'Power may be used to crush truth, but divine support remains with sincere believers.',
        prophetIds: ['musa', 'harun'],
      ),
      RevelationHumanPattern(
        id: 'weakness_after_rescue',
        title: 'Weakness After Clear Rescue',
        summary:
            'People may quickly forget blessings unless gratitude and discipline are preserved.',
        prophetIds: ['musa', 'harun'],
      ),
    ],
    reflectionPrompts: [
      'What does courage with humility look like?',
      'How can leadership stay rooted in worship?',
      'Where do I need trust before the path is fully visible?',
    ],
    relatedGrowthHabitIds: [
      'study_islamic_knowledge',
      'practice_patience',
      'make_dua_daily',
    ],
    mapMetadata: RevelationMapMetadata(
      label: 'Egypt and Sinai route',
      locationConfidence: 'strong / traditional',
    ),
    order: 5,
  ),
  RevelationEra(
    id: 'kingship_wisdom',
    title: 'Kingship and Wisdom',
    summary: 'Authority, justice, and gratitude under Allah\'s trust.',
    regionLabel: 'Levant / Palestine region (traditional / approximate)',
    civilizationTitle: 'Kingship and Governance',
    civilizationSummary:
        'Prophetic leadership in this era shows that power is a trust to be governed through worship and justice.',
    prophetIds: ['dawud', 'sulayman'],
    featuredProphetIds: ['dawud', 'sulayman'],
    coreMessages: [
      CoreMessageItem(
        id: 'kingship_justice',
        text: 'Lead with justice and humility before Allah.',
      ),
      CoreMessageItem(
        id: 'kingship_gratitude',
        text: 'Treat every gift as a test of gratitude, not superiority.',
      ),
    ],
    humanPatterns: [
      RevelationHumanPattern(
        id: 'power_test',
        title: 'Power as a Test',
        summary:
            'Authority can either produce justice and mercy or feed ego and corruption.',
        prophetIds: ['dawud', 'sulayman'],
      ),
      RevelationHumanPattern(
        id: 'gratitude_or_ego',
        title: 'Gratitude or Ego',
        summary:
            'Abundance can soften the heart with thankfulness or harden it with pride.',
        prophetIds: ['sulayman'],
      ),
    ],
    reflectionPrompts: [
      'How can influence be protected from ego?',
      'What does grateful leadership require?',
      'Where do I need justice with compassion in my life?',
    ],
    relatedGrowthHabitIds: [
      'practice_gratitude',
      'practice_humility',
      'help_someone',
    ],
    mapMetadata: RevelationMapMetadata(
      label: 'Palestine and nearby Levant regions',
      locationConfidence: 'traditional / approximate',
    ),
    order: 6,
  ),
  RevelationEra(
    id: 'later_reminders',
    title: 'Later Prophetic Reminders',
    summary: 'Renewed calls to purity, humility, and return.',
    regionLabel: 'Levant and Nineveh regions (traditional / approximate)',
    civilizationTitle: 'Later Prophetic Reminders',
    civilizationSummary:
        'Repeated reminders came to communities drifting into distortion, heedlessness, and moral confusion.',
    prophetIds: [
      'ilyas',
      'alyasa',
      'yunus',
      'ayyub',
      'dhul_kifl',
      'zakariya',
      'yahya',
      'isa',
    ],
    featuredProphetIds: ['yunus', 'isa'],
    coreMessages: [
      CoreMessageItem(
        id: 'later_tawhid',
        text: 'Return to worship Allah alone with sincerity.',
      ),
      CoreMessageItem(
        id: 'later_repentance',
        text: 'Repentance and mercy remain open to those who return.',
      ),
    ],
    humanPatterns: [
      RevelationHumanPattern(
        id: 'religious_distortion',
        title: 'Distortion of Faith',
        summary:
            'People can drift from revelation through excess, neglect, or altered priorities.',
        prophetIds: ['ilyas', 'isa'],
      ),
      RevelationHumanPattern(
        id: 'repentance_and_mercy',
        title: 'Repentance and Mercy',
        summary:
            'Even after error, sincere return brings relief and restoration.',
        prophetIds: ['yunus', 'ayyub', 'dhul_kifl', 'zakariya'],
      ),
    ],
    reflectionPrompts: [
      'Why do people resist truth after repeated reminders?',
      'What is one way to return gently today?',
      'Which reminder in this era feels most personal right now?',
    ],
    relatedGrowthHabitIds: [
      'daily_istighfar',
      'end_day_with_reflection_and_tawbah',
      'read_quran_daily',
      'make_dua_daily',
    ],
    mapMetadata: RevelationMapMetadata(
      label: 'Levant and Nineveh',
      locationConfidence: 'traditional / approximate',
    ),
    order: 7,
  ),
  RevelationEra(
    id: 'final_messenger',
    title: 'Final Messenger',
    summary: 'Completion of revelation through mercy and guidance.',
    regionLabel: 'Makkah and Madinah',
    civilizationTitle: 'Final Revelation Community',
    civilizationSummary:
        'The final message gathered worship, law, mercy, and character into a complete path for humanity.',
    prophetIds: ['muhammad'],
    featuredProphetIds: ['muhammad'],
    coreMessages: [
      CoreMessageItem(
        id: 'final_mercy',
        text: 'Follow prophetic mercy, justice, and sincerity.',
      ),
      CoreMessageItem(
        id: 'final_completion',
        text:
            'Hold firmly to the completed guidance of the Qur\'an and Sunnah.',
      ),
    ],
    humanPatterns: [
      RevelationHumanPattern(
        id: 'rejection_then_opening',
        title: 'Rejection Then Opening',
        summary:
            'Persistent truthfulness and mercy can open hearts after long resistance.',
        prophetIds: ['muhammad'],
      ),
      RevelationHumanPattern(
        id: 'perseverance_in_mission',
        title: 'Perseverance in Mission',
        summary:
            'Steadfastness under pressure carries the message with dignity and compassion.',
        prophetIds: ['muhammad'],
      ),
    ],
    reflectionPrompts: [
      'How can the Sunnah shape your conduct this week?',
      'Where can mercy become more visible in your daily life?',
      'What part of prophetic character do you want to practice now?',
    ],
    relatedGrowthHabitIds: [
      'send_salawat',
      'help_someone',
      'practice_humility',
      'read_quran_daily',
    ],
    mapMetadata: RevelationMapMetadata(
      label: 'Makkah and Madinah',
      locationConfidence: 'strong',
    ),
    order: 8,
  ),
];
