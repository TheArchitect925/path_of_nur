import '../models/wudu_models.dart';

const WuduContent wuduContent = WuduContent(
  heroTitle: 'Wudu (Ablution)',
  heroSubtitle: 'Step-by-step purification before prayer',
  whyWuduMatters:
      'Wudu prepares both body and heart before salah. It brings focus, cleanliness, and readiness to stand before الله with presence and humility.',
  quranVerse:
      '“O believers! When you rise up for prayer, wash your faces and your hands up to the elbows, wipe your heads, and wash your feet to the ankles.”',
  quranReference: 'Surah Al-Ma\'idah 5:6',
  steps: [
    WuduStep(
      number: 1,
      title: 'Make intention (niyyah) in the heart',
      description:
          'Begin with a sincere intention for purification before prayer.',
      iconKey: 'intention',
      illustrationAssetKey: 'wudu_step_01_intention',
      instructionAudioKey: 'wudu_step_01_instruction',
      trainerNote: 'Pause briefly and set your intention before starting.',
      whyItMatters:
          'Niyyah aligns your action with worship so Wudu is done consciously for prayer.',
    ),
    WuduStep(
      number: 2,
      title: 'Say “Bismillah”',
      description: 'Start in the name of الله before washing.',
      iconKey: 'bismillah',
      illustrationAssetKey: 'wudu_step_02_bismillah',
      instructionAudioKey: 'wudu_step_02_instruction',
      pronunciationAudioKey: 'wudu_step_02_pronunciation',
      whyItMatters:
          'Beginning with the name of الله turns a routine action into remembrance.',
    ),
    WuduStep(
      number: 3,
      title: 'Wash both hands up to the wrists three times',
      description:
          'Ensure both hands are fully washed, including between fingers.',
      iconKey: 'hands',
      illustrationAssetKey: 'wudu_step_03_hands',
      repeatCount: 3,
      instructionAudioKey: 'wudu_step_03_instruction',
      trainerNote: 'Use enough water to cover both hands fully each time.',
    ),
    WuduStep(
      number: 4,
      title: 'Rinse the mouth three times',
      description: 'Take water in gently and rinse thoroughly.',
      iconKey: 'mouth',
      illustrationAssetKey: 'wudu_step_04_mouth',
      repeatCount: 3,
      instructionAudioKey: 'wudu_step_04_instruction',
    ),
    WuduStep(
      number: 5,
      title: 'Rinse the nose three times',
      description: 'Draw water lightly into the nose and expel it.',
      iconKey: 'nose',
      illustrationAssetKey: 'wudu_step_05_nose',
      repeatCount: 3,
      instructionAudioKey: 'wudu_step_05_instruction',
    ),
    WuduStep(
      number: 6,
      title: 'Wash the face three times',
      description:
          'Cover the full face area from forehead to chin and side to side.',
      iconKey: 'face',
      illustrationAssetKey: 'wudu_step_06_face',
      repeatCount: 3,
      instructionAudioKey: 'wudu_step_06_instruction',
      whyItMatters:
          'The face is a required area. Full coverage is essential for valid Wudu.',
    ),
    WuduStep(
      number: 7,
      title: 'Wash the right arm including elbow three times',
      description: 'Wash from fingertips up to and including the elbow.',
      iconKey: 'arm_right',
      illustrationAssetKey: 'wudu_step_07_arm_right',
      repeatCount: 3,
      instructionAudioKey: 'wudu_step_07_instruction',
    ),
    WuduStep(
      number: 8,
      title: 'Wash the left arm including elbow three times',
      description: 'Wash completely with attention to the elbow area.',
      iconKey: 'arm_left',
      illustrationAssetKey: 'wudu_step_08_arm_left',
      repeatCount: 3,
      instructionAudioKey: 'wudu_step_08_instruction',
    ),
    WuduStep(
      number: 9,
      title: 'Wipe the head once',
      description: 'Moisten hands and wipe over the head one time.',
      iconKey: 'head',
      illustrationAssetKey: 'wudu_step_09_head',
      instructionAudioKey: 'wudu_step_09_instruction',
      trainerNote: 'This step is performed once, not three times.',
    ),
    WuduStep(
      number: 10,
      title: 'Wipe the ears once',
      description: 'Wipe the inner and outer parts of both ears.',
      iconKey: 'ears',
      illustrationAssetKey: 'wudu_step_10_ears',
      instructionAudioKey: 'wudu_step_10_instruction',
    ),
    WuduStep(
      number: 11,
      title: 'Wash the right foot up to the ankle three times',
      description:
          'Wash thoroughly, including between the toes and around the ankle.',
      iconKey: 'foot_right',
      illustrationAssetKey: 'wudu_step_11_foot_right',
      repeatCount: 3,
      instructionAudioKey: 'wudu_step_11_instruction',
      whyItMatters:
          'Feet are often missed around toes and ankles, so wash this area carefully.',
    ),
    WuduStep(
      number: 12,
      title: 'Wash the left foot up to the ankle three times',
      description:
          'Complete the left foot the same way, including between toes.',
      iconKey: 'foot_left',
      illustrationAssetKey: 'wudu_step_12_foot_left',
      repeatCount: 3,
      instructionAudioKey: 'wudu_step_12_instruction',
    ),
  ],
  requiredEssentials: [
    'Wash face',
    'Wash arms to elbows',
    'Wipe head',
    'Wash feet to ankles',
    'Keep correct order',
    'Perform continuously',
  ],
  sunnahEnhancements: [
    'Saying Bismillah',
    'Washing three times',
    'Starting with right side',
    'Wiping ears',
    'After-wudu dua',
  ],
  reminders: [
    'Water must reach every required area',
    'Do not miss between fingers and toes',
    'Remove anything that blocks water',
    'Keep order from start to finish',
    'Be mindful but not obsessive',
  ],
  afterWuduDua: WuduDua(
    arabic:
        'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
    transliteration:
        'Ashhadu an lā ilāha illa-llāh waḥdahu lā sharīka lah, wa ashhadu anna Muḥammadan ʿabduhu wa rasūluh.',
    translation:
        'I bear witness that none has the right to be worshipped except Allah alone with no partner, and I bear witness that Muhammad is His servant and messenger.',
  ),
  learningNote:
      'For learning purposes. A reviewed/verified badge will be added after full religious content review.',
);
