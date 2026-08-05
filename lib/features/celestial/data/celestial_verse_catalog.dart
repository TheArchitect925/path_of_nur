import '../domain/celestial_models.dart';

const celestialVerseCatalog = <CelestialVerse>[
  CelestialVerse(
    id: 'sky_001',
    objectType: CelestialObjectType.heavens,
    ayahReference: 'Qur’an 3:190',
    arabicText:
        'إِنَّ فِي خَلْقِ السَّمَاوَاتِ وَالْأَرْضِ وَاخْتِلَافِ اللَّيْلِ وَالنَّهَارِ لَآيَاتٍ لِأُولِي الْأَلْبَابِ',
    translation:
        'Indeed, in the creation of the heavens and the earth and the alternation of the night and the day are signs for people of understanding.',
    shortReflection:
        'The sky changes without noise. Reflection grows when the heart learns to notice what is constant.',
    tags: ['heavens', 'night', 'day', 'signs'],
    priority: 10,
    usageContexts: [
      CelestialUsageContext.homeCard,
      CelestialUsageContext.overview,
    ],
  ),
  CelestialVerse(
    id: 'sky_002',
    objectType: CelestialObjectType.moon,
    ayahReference: 'Qur’an 10:5',
    arabicText:
        'هُوَ الَّذِي جَعَلَ الشَّمْسَ ضِيَاءً وَالْقَمَرَ نُورًا وَقَدَّرَهُ مَنَازِلَ',
    translation:
        'He is the One who made the sun a radiant light and the moon a reflected light and determined for it phases.',
    shortReflection:
        'The moon teaches gradualness. Its changing shape still follows a measured order.',
    tags: ['sun', 'moon', 'phases', 'order'],
    priority: 9,
    usageContexts: [
      CelestialUsageContext.homeCard,
      CelestialUsageContext.overview,
      CelestialUsageContext.explore,
    ],
  ),
  CelestialVerse(
    id: 'sky_003',
    objectType: CelestialObjectType.orbit,
    ayahReference: 'Qur’an 21:33',
    arabicText:
        'وَهُوَ الَّذِي خَلَقَ اللَّيْلَ وَالنَّهَارَ وَالشَّمْسَ وَالْقَمَرَ ۖ كُلٌّ فِي فَلَكٍ يَسْبَحُونَ',
    translation:
        'And He is the One who created the night and the day, and the sun and the moon. Each is floating in an orbit.',
    shortReflection:
        'Precision in creation invites humility. What appears effortless is held by divine command.',
    tags: ['orbit', 'sun', 'moon', 'night', 'day'],
    priority: 10,
    usageContexts: [
      CelestialUsageContext.overview,
      CelestialUsageContext.explore,
    ],
  ),
  CelestialVerse(
    id: 'sky_004',
    objectType: CelestialObjectType.sun,
    ayahReference: 'Qur’an 36:38',
    arabicText:
        'وَالشَّمْسُ تَجْرِي لِمُسْتَقَرٍّ لَّهَا ۚ ذَٰلِكَ تَقْدِيرُ الْعَزِيزِ الْعَلِيمِ',
    translation:
        'And the sun runs on to its appointed course. That is the determination of the Almighty, the All-Knowing.',
    shortReflection:
        'The sun keeps its course without pause. Consistency in worship is also built through steady movement.',
    tags: ['sun', 'course', 'consistency'],
    priority: 8,
    usageContexts: [
      CelestialUsageContext.overview,
      CelestialUsageContext.explore,
    ],
  ),
  CelestialVerse(
    id: 'sky_005',
    objectType: CelestialObjectType.phases,
    ayahReference: 'Qur’an 36:39',
    arabicText:
        'وَالْقَمَرَ قَدَّرْنَاهُ مَنَازِلَ حَتَّىٰ عَادَ كَالْعُرْجُونِ الْقَدِيمِ',
    translation:
        'And the moon, We determined for it phases until it returns like the old date stalk.',
    shortReflection:
        'The moon does not remain full. Its phases remind us that change can still belong to balance.',
    tags: ['moon', 'phases', 'balance'],
    priority: 10,
    usageContexts: [
      CelestialUsageContext.homeCard,
      CelestialUsageContext.overview,
      CelestialUsageContext.journal,
    ],
  ),
  CelestialVerse(
    id: 'sky_006',
    objectType: CelestialObjectType.stars,
    ayahReference: 'Qur’an 6:97',
    arabicText:
        'وَهُوَ الَّذِي جَعَلَ لَكُمُ النُّجُومَ لِتَهْتَدُوا بِهَا فِي ظُلُمَاتِ الْبَرِّ وَالْبَحْرِ',
    translation:
        'And He is the One who made for you the stars so that you may be guided by them through the darkness of land and sea.',
    shortReflection:
        'Creation is not only beautiful. It is also a mercy and a means of guidance.',
    tags: ['stars', 'guidance', 'night'],
    priority: 7,
    usageContexts: [
      CelestialUsageContext.explore,
      CelestialUsageContext.journal,
    ],
  ),
  CelestialVerse(
    id: 'sky_007',
    objectType: CelestialObjectType.stars,
    ayahReference: 'Qur’an 67:5',
    arabicText: 'وَلَقَدْ زَيَّنَّا السَّمَاءَ الدُّنْيَا بِمَصَابِيحَ',
    translation: 'And We have certainly adorned the nearest heaven with lamps.',
    shortReflection:
        'Beauty in the sky is not empty decoration. It is part of a created order that invites remembrance.',
    tags: ['stars', 'beauty', 'heavens'],
    priority: 6,
    usageContexts: [
      CelestialUsageContext.explore,
      CelestialUsageContext.journal,
    ],
  ),
  CelestialVerse(
    id: 'sky_008',
    objectType: CelestialObjectType.signs,
    ayahReference: 'Qur’an 51:20-21',
    arabicText:
        'وَفِي الْأَرْضِ آيَاتٌ لِّلْمُوقِنِينَ ۝ وَفِي أَنفُسِكُمْ ۚ أَفَلَا تُبْصِرُونَ',
    translation:
        'And on the earth are signs for those of sure faith, and in yourselves as well. Will you not then see?',
    shortReflection:
        'Observation is not complete when it stays outside. The signs in creation also invite inward honesty.',
    tags: ['signs', 'reflection', 'creation'],
    priority: 8,
    usageContexts: [
      CelestialUsageContext.homeCard,
      CelestialUsageContext.journal,
    ],
  ),
];
