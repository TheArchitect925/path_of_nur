import '../domain/world_models.dart';

const worldCurriculum = WorldCurriculum(
  themes: _themes,
  subcategories: _subcategories,
  lessons: _lessons,
  suggestedThemeOrder: [
    'time-cycles-seasons',
    'heavens-sky-celestial-signs',
    'water-rain-oceans',
    'earth-land-landscapes',
    'plants-trees-growth',
    'animals-birds-insects',
    'travel-reflection-signs',
  ],
  featuredLessonId: 'time-night-day-alternation',
);

const _themes = <WorldTheme>[
  WorldTheme(
    id: 'heavens-sky-celestial-signs',
    title: 'Heavens, Sky & Celestial Signs',
    summary: 'Moon, sun, stars, sky order, and orientation in time and space.',
    whyItMatters:
        'The Qur’an repeatedly invites reflection on the sky so people reconnect wonder with humility and purpose.',
    subcategoryIds: ['celestial-moon-sun', 'celestial-stars-sky-order'],
    relatedThemeIds: ['time-cycles-seasons', 'travel-reflection-signs'],
    order: 2,
  ),
  WorldTheme(
    id: 'earth-land-landscapes',
    title: 'Earth, Land & Landscapes',
    summary: 'Mountains, pathways, terrains, and the spread of the earth.',
    whyItMatters:
        'Landforms are presented as signs for stability, movement, and gratitude, not mere background scenery.',
    subcategoryIds: ['earth-mountains-terrain', 'earth-pathways-settlement'],
    relatedThemeIds: ['travel-reflection-signs', 'water-rain-oceans'],
    order: 4,
  ),
  WorldTheme(
    id: 'water-rain-oceans',
    title: 'Water, Rain & Oceans',
    summary: 'Rain cycles, rivers, seas, winds, and life sustained by water.',
    whyItMatters:
        'Water is framed as mercy, provision, and a recurring lesson in dependence on الله.',
    subcategoryIds: ['water-rain-revival', 'water-rivers-seas'],
    relatedThemeIds: ['plants-trees-growth', 'earth-land-landscapes'],
    order: 3,
  ),
  WorldTheme(
    id: 'plants-trees-growth',
    title: 'Plants, Trees & Growth',
    summary: 'Seeds, crops, fruits, gardens, and nourishment.',
    whyItMatters:
        'Growth in nature trains the heart in patience, gratitude, and recognition of provision.',
    subcategoryIds: ['plants-seeds-crops', 'plants-fruits-gardens'],
    relatedThemeIds: ['water-rain-oceans', 'time-cycles-seasons'],
    order: 5,
  ),
  WorldTheme(
    id: 'animals-birds-insects',
    title: 'Animals, Birds & Insects',
    summary: 'Creatures as signs of order, provision, beauty, and dependence.',
    whyItMatters:
        'Observing creatures can soften the heart and deepen respect for life, balance, and responsibility.',
    subcategoryIds: ['animals-bees-insects', 'animals-birds-livestock'],
    relatedThemeIds: ['plants-trees-growth', 'travel-reflection-signs'],
    order: 6,
  ),
  WorldTheme(
    id: 'time-cycles-seasons',
    title: 'Time, Cycles & Seasons',
    summary: 'Night/day alternation, dawn/sunset, and human life within time.',
    whyItMatters:
        'Time signs are among the most immediate reminders for reflection, discipline, and accountability.',
    subcategoryIds: ['time-night-day', 'time-seasons-lifecycles'],
    relatedThemeIds: ['heavens-sky-celestial-signs', 'work-time-discipline'],
    order: 1,
  ),
  WorldTheme(
    id: 'travel-reflection-signs',
    title: 'Travel, Reflection & Signs in the World',
    summary:
        'Travel, ruins, lived observation, and learning from what remains.',
    whyItMatters:
        'Travel and attentive observation prevent heedlessness and reconnect daily life with lessons in creation.',
    subcategoryIds: ['travel-observe-earth', 'travel-history-remains'],
    relatedThemeIds: ['earth-land-landscapes', 'time-cycles-seasons'],
    order: 7,
  ),
];

const _subcategories = <WorldSubcategory>[
  WorldSubcategory(
    id: 'time-night-day',
    themeId: 'time-cycles-seasons',
    title: 'Night, Day, Dawn & Sunset',
    summary: 'Alternation as rhythm, mercy, and accountability.',
    lessonIds: ['time-night-day-alternation', 'time-dawn-sunset-heart-rhythm'],
    order: 1,
  ),
  WorldSubcategory(
    id: 'time-seasons-lifecycles',
    themeId: 'time-cycles-seasons',
    title: 'Seasons, Change & Human Time',
    summary: 'Cycles in nature and cycles in the human heart.',
    lessonIds: [
      'time-seasons-change-reflection',
      'time-lifespan-urgency-gratitude',
    ],
    order: 2,
  ),
  WorldSubcategory(
    id: 'celestial-moon-sun',
    themeId: 'heavens-sky-celestial-signs',
    title: 'Moon & Sun',
    summary: 'Light, measure, and orientation through celestial signs.',
    lessonIds: ['celestial-moon-measure-time', 'celestial-sun-light-provision'],
    order: 1,
  ),
  WorldSubcategory(
    id: 'celestial-stars-sky-order',
    themeId: 'heavens-sky-celestial-signs',
    title: 'Stars, Sky Order & Vastness',
    summary: 'Guidance, proportion, and humility before vast creation.',
    lessonIds: ['celestial-stars-guidance-humility', 'celestial-sky-order-awe'],
    order: 2,
  ),
  WorldSubcategory(
    id: 'water-rain-revival',
    themeId: 'water-rain-oceans',
    title: 'Rain, Clouds & Revival',
    summary: 'Rain cycles and revival after dryness.',
    lessonIds: ['water-rain-mercy-revival', 'water-clouds-wind-patterns'],
    order: 1,
  ),
  WorldSubcategory(
    id: 'water-rivers-seas',
    themeId: 'water-rain-oceans',
    title: 'Rivers, Seas & Dependence',
    summary: 'Flow, boundaries, and dependence on water.',
    lessonIds: [
      'water-rivers-provision-settlement',
      'water-seas-vastness-boundary',
    ],
    order: 2,
  ),
  WorldSubcategory(
    id: 'earth-mountains-terrain',
    themeId: 'earth-land-landscapes',
    title: 'Mountains & Terrain',
    summary: 'Elevation, stability, and perspective.',
    lessonIds: [
      'earth-mountains-stability-reflection',
      'earth-valleys-plains-contrast',
    ],
    order: 1,
  ),
  WorldSubcategory(
    id: 'earth-pathways-settlement',
    themeId: 'earth-land-landscapes',
    title: 'Paths, Roads & Settlement',
    summary: 'Routes, shelter, and responsibility in habitation.',
    lessonIds: [
      'earth-pathways-travel-guidance',
      'earth-settlement-gratitude-stewardship',
    ],
    order: 2,
  ),
  WorldSubcategory(
    id: 'plants-seeds-crops',
    themeId: 'plants-trees-growth',
    title: 'Seeds, Crops & Cultivation',
    summary: 'From hidden beginnings to visible provision.',
    lessonIds: ['plants-seeds-hidden-growth', 'plants-crops-labor-provision'],
    order: 1,
  ),
  WorldSubcategory(
    id: 'plants-fruits-gardens',
    themeId: 'plants-trees-growth',
    title: 'Fruits, Trees & Gardens',
    summary: 'Variety, nourishment, and beauty as signs.',
    lessonIds: [
      'plants-fruits-variety-sign',
      'plants-gardens-beauty-responsibility',
    ],
    order: 2,
  ),
  WorldSubcategory(
    id: 'animals-bees-insects',
    themeId: 'animals-birds-insects',
    title: 'Bees & Insects',
    summary: 'Small creatures and meaningful patterns.',
    lessonIds: [
      'animals-bee-order-benefit',
      'animals-small-creatures-humility',
    ],
    order: 1,
  ),
  WorldSubcategory(
    id: 'animals-birds-livestock',
    themeId: 'animals-birds-insects',
    title: 'Birds, Livestock & Wild Creatures',
    summary: 'Movement, dependence, and entrusted care.',
    lessonIds: [
      'animals-birds-motion-trust',
      'animals-livestock-care-thankfulness',
    ],
    order: 2,
  ),
  WorldSubcategory(
    id: 'travel-observe-earth',
    themeId: 'travel-reflection-signs',
    title: 'Travel and Observing the Earth',
    summary: 'Learning through movement and attentive seeing.',
    lessonIds: [
      'travel-observe-patterns-signs',
      'travel-walk-reflect-remember',
    ],
    order: 1,
  ),
  WorldSubcategory(
    id: 'travel-history-remains',
    themeId: 'travel-reflection-signs',
    title: 'Ruins, History & Lessons',
    summary: 'Past peoples, remains, and moral memory.',
    lessonIds: [
      'travel-ruins-humility-lesson',
      'travel-history-accountability',
    ],
    order: 2,
  ),
];

const _lessons = <WorldLesson>[
  WorldLesson(
    id: 'time-night-day-alternation',
    themeId: 'time-cycles-seasons',
    subcategoryId: 'time-night-day',
    title: 'Alternation of Night and Day',
    subtitle: 'Daily rhythm as a sign for reflection and discipline.',
    overview:
        'The alternation of light and darkness is one of the most immediate signs of order in creation.',
    quranicPerspective:
        'The Qur’an presents night and day as signs for people who reflect, linking cosmic rhythm with remembrance and gratitude.',
    reflectiveTakeaway:
        'A changing sky can gently reset intention: every evening closes a chapter and every morning opens a new one.',
    practicalTakeaway:
        'Tie one short remembrance to dawn and one to evening so time itself invites worship.',
    keyConcepts: ['alternation', 'rhythm', 'remembrance'],
    reflectionPrompt:
        'How does your relationship with morning and evening affect your spiritual steadiness?',
    observationPrompt:
        'Observe sunrise or sunset this week; note how color and light change gradually, not instantly.',
    relatedLessonIds: [
      'time-dawn-sunset-heart-rhythm',
      'celestial-moon-measure-time',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Psalms / Wisdom reflection traditions',
        themeSummary:
            'Day and night cycles are often used as invitations to praise, remembrance, and humility before the Creator.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'time-dawn-sunset-heart-rhythm',
    themeId: 'time-cycles-seasons',
    subcategoryId: 'time-night-day',
    title: 'Dawn and Sunset as Heart Markers',
    subtitle: 'Transitions in light as transitions in attention.',
    overview:
        'Dawn and sunset naturally interrupt routine and invite conscious reflection.',
    quranicPerspective:
        'Qur’anic discourse repeatedly references these transitions as moments for remembrance and orientation.',
    reflectiveTakeaway:
        'Regular transitions can train the heart to return, even after distraction.',
    practicalTakeaway:
        'Use one-minute pauses at dawn and sunset for gratitude and intention renewal.',
    keyConcepts: ['transition', 'return', 'gratitude'],
    reflectionPrompt:
        'Which daily transition could become your most reliable reflection moment?',
    observationPrompt:
        'During sunset, notice shifting shadows and how the environment becomes quieter and softer.',
    relatedLessonIds: [
      'time-night-day-alternation',
      'time-seasons-change-reflection',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Biblical prayer-hour traditions',
        themeSummary:
            'Morning and evening are treated as meaningful times for turning back to God.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'time-seasons-change-reflection',
    themeId: 'time-cycles-seasons',
    subcategoryId: 'time-seasons-lifecycles',
    title: 'Seasonal Change and Reflection',
    subtitle: 'Change in weather as a teacher of patience and perspective.',
    overview:
        'Seasonal shifts reveal that change is built into creation, not an exception to it.',
    quranicPerspective:
        'The Qur’anic worldview treats changing conditions as signs that call for awareness, gratitude, and trust.',
    reflectiveTakeaway:
        'External change can soften resistance to healthy internal change.',
    practicalTakeaway:
        'At each season change, set one spiritual intention and one practical habit adjustment.',
    keyConcepts: ['change', 'adaptation', 'patience'],
    reflectionPrompt:
        'How do you respond when your environment changes unexpectedly?',
    observationPrompt:
        'During a season shift, record one change in daylight, one in plant life, and one in your routine.',
    relatedLessonIds: [
      'time-lifespan-urgency-gratitude',
      'plants-seeds-hidden-growth',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Wisdom literature',
        themeSummary:
            'Seasonal cycles are often used to teach timing, humility, and wise response to change.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'time-lifespan-urgency-gratitude',
    themeId: 'time-cycles-seasons',
    subcategoryId: 'time-seasons-lifecycles',
    title: 'Human Lifespan Within Time',
    subtitle: 'Finite time as motivation for purposeful living.',
    overview:
        'Reflecting on finite lifespan can sharpen priorities and reduce distraction.',
    quranicPerspective:
        'Qur’anic reminders about time and mortality direct people toward meaningful deeds and sincere repentance.',
    reflectiveTakeaway:
        'A finite life is not cause for panic; it is a call to clarity and sincerity.',
    practicalTakeaway:
        'Choose one time-wasting habit to reduce and one beneficial habit to protect daily.',
    keyConcepts: ['mortality', 'priority', 'purpose'],
    reflectionPrompt:
        'If you treated time as trust, what would you change this month?',
    observationPrompt: null,
    relatedLessonIds: [
      'time-night-day-alternation',
      'time-seasons-change-reflection',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Psalms and memento mori traditions',
        themeSummary:
            'Human finitude is often framed as a reason for wisdom, repentance, and humble living.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'celestial-moon-measure-time',
    themeId: 'heavens-sky-celestial-signs',
    subcategoryId: 'celestial-moon-sun',
    title: 'Moon as a Measure of Time',
    subtitle: 'Visible phases and the discipline of observing cycles.',
    overview:
        'The moon’s changing appearance helps people notice rhythm, count time, and remain attentive.',
    quranicPerspective:
        'Qur’anic language presents celestial movement as measured and purposeful, encouraging reflection rather than heedlessness.',
    reflectiveTakeaway:
        'Watching the moon builds patience with gradual change and respect for ordered cycles.',
    practicalTakeaway:
        'Observe the moon across one week and note how regular attention deepens awareness.',
    keyConcepts: ['lunar cycle', 'measure', 'consistency'],
    reflectionPrompt:
        'What does gradual change in the moon teach you about gradual growth in yourself?',
    observationPrompt:
        'Look for the moon at the same time over several nights and record visible changes.',
    relatedLessonIds: [
      'time-night-day-alternation',
      'celestial-stars-guidance-humility',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Hebrew Bible festival/time traditions',
        themeSummary:
            'Lunar signs are linked to communal timekeeping and sacred rhythm in earlier traditions.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'celestial-sun-light-provision',
    themeId: 'heavens-sky-celestial-signs',
    subcategoryId: 'celestial-moon-sun',
    title: 'Sunlight, Warmth, and Provision',
    subtitle: 'Daily light as mercy and dependence.',
    overview:
        'Sunlight supports life systems and daily activity, reminding people of sustained provision.',
    quranicPerspective:
        'The Qur’an points to light and heat patterns as signs that invite gratitude and recognition of dependence.',
    reflectiveTakeaway:
        'What feels ordinary can still be a daily mercy when consciously noticed.',
    practicalTakeaway:
        'Begin one daylight activity each day with a brief gratitude statement for provision.',
    keyConcepts: ['provision', 'light', 'dependence'],
    reflectionPrompt:
        'What daily gift feels ordinary to you but is actually foundational?',
    observationPrompt:
        'During morning light, note how quickly life activity increases in your surroundings.',
    relatedLessonIds: [
      'plants-crops-labor-provision',
      'water-rain-mercy-revival',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Psalms creation praise themes',
        themeSummary:
            'Sun and light are frequently treated as signs of order and sustaining care.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'celestial-stars-guidance-humility',
    themeId: 'heavens-sky-celestial-signs',
    subcategoryId: 'celestial-stars-sky-order',
    title: 'Stars, Guidance, and Humility',
    subtitle: 'Vastness that reduces arrogance.',
    overview:
        'The night sky can reframe human concerns by placing them within a much larger reality.',
    quranicPerspective:
        'Qur’anic references to stars include guidance and signs for those who think deeply.',
    reflectiveTakeaway:
        'Wonder can calm ego and make the heart more teachable.',
    practicalTakeaway:
        'Spend one night monthly away from screens to observe the sky in silence.',
    keyConcepts: ['guidance', 'vastness', 'humility'],
    reflectionPrompt:
        'How does cosmic scale change your perception of personal stress?',
    observationPrompt:
        'Find a low-light location and observe the sky for 10 quiet minutes.',
    relatedLessonIds: [
      'celestial-sky-order-awe',
      'travel-observe-patterns-signs',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Wisdom and patriarchal sky-observation motifs',
        themeSummary:
            'Starlit reflection appears in earlier traditions as a source of awe and trust in divine order.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'celestial-sky-order-awe',
    themeId: 'heavens-sky-celestial-signs',
    subcategoryId: 'celestial-stars-sky-order',
    title: 'Sky Order and Balanced Measure',
    subtitle: 'Order in creation as a call to inner order.',
    overview:
        'Patterns in sky movement and proportion invite reflection on balance and restraint in human life.',
    quranicPerspective:
        'The Qur’anic framing of measured creation encourages careful observation and gratitude rather than heedlessness.',
    reflectiveTakeaway: 'A world with measure invites a life with measure.',
    practicalTakeaway:
        'Apply “measure” to one area of life: speech, spending, or screen time.',
    keyConcepts: ['measure', 'balance', 'order'],
    reflectionPrompt: 'Where does your life currently lack healthy proportion?',
    observationPrompt: null,
    relatedLessonIds: [
      'time-night-day-alternation',
      'time-lifespan-urgency-gratitude',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Wisdom tradition on order in creation',
        themeSummary:
            'Created order is often linked to moral order and disciplined living.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'water-rain-mercy-revival',
    themeId: 'water-rain-oceans',
    subcategoryId: 'water-rain-revival',
    title: 'Rain as Mercy and Revival',
    subtitle: 'Dry earth restored as a recurring sign.',
    overview:
        'Rain revives soil, crops, and ecosystems, repeatedly reminding people of dependence and renewal.',
    quranicPerspective:
        'Qur’anic imagery links rain with mercy and revival, including inner spiritual revival after hardness.',
    reflectiveTakeaway:
        'Revival after dryness is both environmental and spiritual language.',
    practicalTakeaway:
        'When rain falls, pause for gratitude and one practical act of mercy.',
    keyConcepts: ['mercy', 'revival', 'dependence'],
    reflectionPrompt:
        'Where in your life do you most need revival after dryness?',
    observationPrompt:
        'After rainfall, observe one visible change in soil, plants, or air quality.',
    relatedLessonIds: [
      'plants-seeds-hidden-growth',
      'time-lifespan-urgency-gratitude',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Psalms and prophetic rain imagery',
        themeSummary:
            'Rain often symbolizes mercy, sustenance, and renewal in earlier scripture traditions.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'water-clouds-wind-patterns',
    themeId: 'water-rain-oceans',
    subcategoryId: 'water-rain-revival',
    title: 'Clouds, Wind, and Changing Weather',
    subtitle: 'Movement in the sky as a sign of process.',
    overview:
        'Cloud and wind patterns show that provision arrives through unfolding processes.',
    quranicPerspective:
        'The Qur’an points to wind and clouds as signs for those who observe and think.',
    reflectiveTakeaway:
        'Not every mercy arrives instantly; many arrive through stages.',
    practicalTakeaway:
        'During shifting weather, practice patience and notice gradual transitions.',
    keyConcepts: ['process', 'transition', 'patience'],
    reflectionPrompt:
        'What ongoing process in your life needs more patient trust?',
    observationPrompt:
        'Watch cloud movement for five minutes and note direction, pace, and density changes.',
    relatedLessonIds: [
      'travel-observe-patterns-signs',
      'water-rain-mercy-revival',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Wisdom and poetic weather reflections',
        themeSummary:
            'Wind and storm imagery are used to teach humility before divine power and process.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'water-rivers-provision-settlement',
    themeId: 'water-rain-oceans',
    subcategoryId: 'water-rivers-seas',
    title: 'Rivers and Human Settlement',
    subtitle: 'Flowing water and the shaping of daily life.',
    overview:
        'Rivers support agriculture, movement, and settlement, making provision visible in geography.',
    quranicPerspective:
        'Qur’anic references to rivers often pair physical provision with gratitude and moral responsibility.',
    reflectiveTakeaway:
        'Provision has geography; gratitude should include stewardship of what sustains life.',
    practicalTakeaway:
        'Support one local water-conservation or cleanliness habit this month.',
    keyConcepts: ['provision', 'stewardship', 'flow'],
    reflectionPrompt:
        'How can gratitude for water become visible in your behavior?',
    observationPrompt:
        'Observe a river, stream, or drainage path and note how it shapes nearby life.',
    relatedLessonIds: [
      'earth-settlement-gratitude-stewardship',
      'water-seas-vastness-boundary',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Torah and Psalm river motifs',
        themeSummary:
            'Flowing water is often associated with sustenance, flourishing, and divine care.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'water-seas-vastness-boundary',
    themeId: 'water-rain-oceans',
    subcategoryId: 'water-rivers-seas',
    title: 'Seas, Vastness, and Boundaries',
    subtitle: 'Immensity that teaches humility and limits.',
    overview:
        'The sea communicates both beauty and power, inviting awe alongside caution.',
    quranicPerspective:
        'Qur’anic language about seas highlights signs in scale, movement, and provision.',
    reflectiveTakeaway:
        'Vastness can heal ego by reminding us of human limits.',
    practicalTakeaway:
        'When near large landscapes, practice short silent reflection before speaking or photographing.',
    keyConcepts: ['vastness', 'limits', 'awe'],
    reflectionPrompt:
        'What does the idea of boundary protect in your own life?',
    observationPrompt:
        'At a shoreline or large body of water, observe repeating wave patterns for two minutes.',
    relatedLessonIds: [
      'celestial-stars-guidance-humility',
      'earth-mountains-stability-reflection',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Biblical sea imagery traditions',
        themeSummary:
            'Sea imagery often carries themes of power, dependence, and reverence for divine order.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'earth-mountains-stability-reflection',
    themeId: 'earth-land-landscapes',
    subcategoryId: 'earth-mountains-terrain',
    title: 'Mountains and Stability',
    subtitle: 'Elevation as perspective and groundedness.',
    overview:
        'Mountains draw attention to scale, endurance, and the limits of human control.',
    quranicPerspective:
        'Qur’anic references to mountains emphasize signs of power, stability, and perspective.',
    reflectiveTakeaway:
        'Steadiness in nature can inspire steadiness in character.',
    practicalTakeaway:
        'Use one difficult day to practice “mountain patience”: calm speech, slow reaction, clear intention.',
    keyConcepts: ['steadiness', 'scale', 'patience'],
    reflectionPrompt: 'Where do you need groundedness instead of reactivity?',
    observationPrompt:
        'On a walk or drive, observe terrain elevation changes and how perspective shifts with height.',
    relatedLessonIds: [
      'time-seasons-change-reflection',
      'earth-valleys-plains-contrast',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Psalms mountain imagery',
        themeSummary:
            'Mountains are often portrayed as symbols of majesty, protection, and perspective.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'earth-valleys-plains-contrast',
    themeId: 'earth-land-landscapes',
    subcategoryId: 'earth-mountains-terrain',
    title: 'Valleys, Plains, and Contrast',
    subtitle: 'Different terrains, different lessons.',
    overview:
        'Contrast in topography can train the eye to notice variety and purpose in creation.',
    quranicPerspective:
        'Qur’anic observation invites attention to varied lands as signs, not random scenery.',
    reflectiveTakeaway:
        'Difference in landscapes can normalize difference in life conditions.',
    practicalTakeaway:
        'In moments of personal contrast, practice comparison-free gratitude.',
    keyConcepts: ['contrast', 'variety', 'gratitude'],
    reflectionPrompt:
        'How do you respond to difference when it is not in your favor?',
    observationPrompt:
        'Notice one high and one low landscape area and compare how each supports life.',
    relatedLessonIds: [
      'plants-fruits-variety-sign',
      'earth-mountains-stability-reflection',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Wisdom literature nature contrasts',
        themeSummary:
            'Natural contrasts are often used to teach discernment and humility.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'earth-pathways-travel-guidance',
    themeId: 'earth-land-landscapes',
    subcategoryId: 'earth-pathways-settlement',
    title: 'Paths, Roads, and Guidance',
    subtitle: 'Physical paths as mirrors of moral direction.',
    overview:
        'Roads and pathways make movement possible and symbolize chosen direction.',
    quranicPerspective:
        'Qur’anic language around paths often combines physical travel with spiritual guidance.',
    reflectiveTakeaway:
        'Everyday routes can become reminders to choose clear and ethical paths.',
    practicalTakeaway:
        'Pick one habitual route and use it as a cue for a short intention reset.',
    keyConcepts: ['path', 'direction', 'guidance'],
    reflectionPrompt: 'What repeated choice is quietly becoming your path?',
    observationPrompt:
        'During travel, observe how road signs, lanes, and markers prevent confusion; reflect on guidance in life.',
    relatedLessonIds: [
      'travel-observe-patterns-signs',
      'travel-history-accountability',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Wisdom “way/path” traditions',
        themeSummary:
            'Path imagery is commonly used for moral direction and disciplined living.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'earth-settlement-gratitude-stewardship',
    themeId: 'earth-land-landscapes',
    subcategoryId: 'earth-pathways-settlement',
    title: 'Settlement, Shelter, and Stewardship',
    subtitle: 'Living spaces as trust, not entitlement.',
    overview:
        'Homes and settlements are blessings that carry social and environmental responsibility.',
    quranicPerspective:
        'Qur’anic ethics ties provision with accountability, including how people inhabit and use land.',
    reflectiveTakeaway:
        'Belonging in a place should increase care for that place.',
    practicalTakeaway:
        'Adopt one neighborhood care act: cleanup, kindness to neighbors, or waste reduction.',
    keyConcepts: ['stewardship', 'settlement', 'responsibility'],
    reflectionPrompt:
        'How can your presence make your local environment more dignified?',
    observationPrompt: null,
    relatedLessonIds: [
      'earth-pathways-travel-guidance',
      'water-rivers-provision-settlement',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Stewardship themes in Abrahamic ethics',
        themeSummary:
            'Land and provision are often treated as entrusted gifts with moral obligations.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'plants-seeds-hidden-growth',
    themeId: 'plants-trees-growth',
    subcategoryId: 'plants-seeds-crops',
    title: 'Seeds and Hidden Growth',
    subtitle: 'Small beginnings and patient unfolding.',
    overview: 'Seeds model how unseen stages often precede visible outcomes.',
    quranicPerspective:
        'Qur’anic references to growth from small beginnings reinforce trust in gradual divine processes.',
    reflectiveTakeaway: 'Not all meaningful growth is immediately visible.',
    practicalTakeaway:
        'Track one small habit for 30 days before judging outcomes.',
    keyConcepts: ['gradual growth', 'patience', 'trust in process'],
    reflectionPrompt:
        'What small practice in your life needs more time before evaluation?',
    observationPrompt:
        'Observe a seed, sprout, or small plant through several days and note subtle changes.',
    relatedLessonIds: [
      'water-rain-mercy-revival',
      'time-seasons-change-reflection',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Parable traditions about seed growth',
        themeSummary:
            'Seed imagery often teaches patience, hidden development, and faithful effort.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'plants-crops-labor-provision',
    themeId: 'plants-trees-growth',
    subcategoryId: 'plants-seeds-crops',
    title: 'Crops, Labor, and Provision',
    subtitle: 'Effort, reliance, and gratitude together.',
    overview:
        'Food systems combine human labor with factors beyond human control.',
    quranicPerspective:
        'The Qur’an frames crop growth as a sign that balances effort with humble reliance on الله.',
    reflectiveTakeaway:
        'Provision teaches cooperation between action and dependence.',
    practicalTakeaway:
        'Before meals, include a brief gratitude pause for labor, land, and mercy.',
    keyConcepts: ['provision', 'labor', 'reliance'],
    reflectionPrompt:
        'Which part of provision do you usually overlook: effort or mercy?',
    observationPrompt:
        'Visit a market or garden and reflect on the chain of labor behind one fruit or grain.',
    relatedLessonIds: [
      'plants-seeds-hidden-growth',
      'water-rain-mercy-revival',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Agrarian wisdom traditions',
        themeSummary:
            'Harvest imagery frequently links diligence, gratitude, and dependence on divine favor.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'plants-fruits-variety-sign',
    themeId: 'plants-trees-growth',
    subcategoryId: 'plants-fruits-gardens',
    title: 'Fruits and Variety as Signs',
    subtitle: 'Diversity in nourishment and beauty.',
    overview:
        'Variation in color, taste, and texture points to richness and intentional diversity in creation.',
    quranicPerspective:
        'Qur’anic references to fruits and varied produce invite gratitude and reflection on provision diversity.',
    reflectiveTakeaway:
        'Diversity in creation can reduce narrowness in perspective.',
    practicalTakeaway:
        'Practice gratitude by intentionally noticing variety in daily provision.',
    keyConcepts: ['diversity', 'nourishment', 'gratitude'],
    reflectionPrompt: 'What created variety have you stopped noticing?',
    observationPrompt:
        'Compare two fruits by color, texture, and taste; reflect on diversity with shared purpose.',
    relatedLessonIds: [
      'plants-gardens-beauty-responsibility',
      'time-night-day-alternation',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Garden and vine imagery traditions',
        themeSummary:
            'Fruit-bearing imagery often signifies blessing, responsibility, and moral fruitfulness.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'plants-gardens-beauty-responsibility',
    themeId: 'plants-trees-growth',
    subcategoryId: 'plants-fruits-gardens',
    title: 'Gardens, Beauty, and Responsibility',
    subtitle: 'Beauty calls for stewardship, not waste.',
    overview:
        'Natural beauty can nourish the heart while calling people to protect what they enjoy.',
    quranicPerspective:
        'Qur’anic garden imagery combines delight with accountability and remembrance of the Giver.',
    reflectiveTakeaway: 'Beauty should increase humility, gratitude, and care.',
    practicalTakeaway:
        'Protect one local green space through simple regular care or advocacy.',
    keyConcepts: ['beauty', 'care', 'stewardship'],
    reflectionPrompt:
        'How can admiration become action in your relationship with nature?',
    observationPrompt:
        'During a walk, identify one place where beauty is protected and one where it is neglected.',
    relatedLessonIds: [
      'earth-settlement-gratitude-stewardship',
      'plants-fruits-variety-sign',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Wisdom and Eden/garden motifs',
        themeSummary:
            'Gardens often symbolize provision, trust, and moral responsibility in sacred narratives.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'animals-bee-order-benefit',
    themeId: 'animals-birds-insects',
    subcategoryId: 'animals-bees-insects',
    title: 'Bees: Order, Benefit, and Service',
    subtitle: 'Small creatures with outsized lessons.',
    overview:
        'Bees illustrate patterned behavior, cooperation, and beneficial output.',
    quranicPerspective:
        'Qur’anic mention of the bee invites reflection on purposeful instinct and benefit emerging from small creatures.',
    reflectiveTakeaway:
        'Quiet, consistent contribution can be deeply impactful.',
    practicalTakeaway:
        'Choose one steady, small beneficial act rather than waiting for large opportunities.',
    keyConcepts: ['order', 'benefit', 'consistency'],
    reflectionPrompt:
        'What small consistent service could you begin this week?',
    observationPrompt:
        'If safe and possible, observe pollinators around flowers and notice repeated patterns.',
    relatedLessonIds: [
      'animals-small-creatures-humility',
      'plants-crops-labor-provision',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Wisdom reflections on industrious creatures',
        themeSummary:
            'Small creatures are often used to teach diligence, order, and practical wisdom.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'animals-small-creatures-humility',
    themeId: 'animals-birds-insects',
    subcategoryId: 'animals-bees-insects',
    title: 'Small Creatures and Humility',
    subtitle: 'Great lessons from what is easily ignored.',
    overview:
        'Small beings can challenge assumptions about importance and significance.',
    quranicPerspective:
        'Qur’anic pedagogy includes signs in both grand and small creation, calling people away from arrogance.',
    reflectiveTakeaway:
        'Humility grows when we stop ranking signs only by size.',
    practicalTakeaway:
        'Practice careful attention to one “overlooked” aspect of your environment each day.',
    keyConcepts: ['attention', 'humility', 'significance'],
    reflectionPrompt: 'What do you usually ignore that may carry a lesson?',
    observationPrompt:
        'Observe an insect trail or pattern from a respectful distance for a short period.',
    relatedLessonIds: [
      'celestial-stars-guidance-humility',
      'time-night-day-alternation',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Parabolic and wisdom traditions',
        themeSummary:
            'Small examples are frequently used to expose large truths about character and awareness.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'animals-birds-motion-trust',
    themeId: 'animals-birds-insects',
    subcategoryId: 'animals-birds-livestock',
    title: 'Birds in Motion and Dependence',
    subtitle: 'Movement, vulnerability, and reliance.',
    overview:
        'Bird life combines freedom of motion with dependence on provision and conditions.',
    quranicPerspective:
        'Qur’anic signs in birds point to sustained care, ordered motion, and attentive observation.',
    reflectiveTakeaway:
        'Motion and trust can coexist; action does not cancel reliance on الله.',
    practicalTakeaway:
        'During travel, use bird observation as a cue for brief trust-focused dua.',
    keyConcepts: ['motion', 'reliance', 'attentiveness'],
    reflectionPrompt: 'Where do you need both movement and trust right now?',
    observationPrompt:
        'Watch birds landing and taking off; note rhythm, caution, and adaptation.',
    relatedLessonIds: [
      'travel-observe-patterns-signs',
      'water-seas-vastness-boundary',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Gospel and wisdom bird imagery',
        themeSummary:
            'Birds are often used to teach trust, dependence, and freedom from anxious excess.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'animals-livestock-care-thankfulness',
    themeId: 'animals-birds-insects',
    subcategoryId: 'animals-birds-livestock',
    title: 'Livestock, Care, and Thankfulness',
    subtitle: 'Benefit carries responsibility.',
    overview:
        'Human benefit from animals includes ethical treatment, gratitude, and restraint from abuse.',
    quranicPerspective:
        'Qur’anic guidance links animal benefit to gratitude and responsible use, not entitlement.',
    reflectiveTakeaway:
        'Receiving benefit should increase compassion, not hardness.',
    practicalTakeaway:
        'Reflect on consumption choices and reduce waste connected to animal-derived resources.',
    keyConcepts: ['benefit', 'responsibility', 'compassion'],
    reflectionPrompt:
        'How can your choices better reflect gratitude and mercy toward creatures?',
    observationPrompt: null,
    relatedLessonIds: [
      'plants-crops-labor-provision',
      'animals-birds-motion-trust',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Stewardship motifs in Abrahamic legal-moral traditions',
        themeSummary:
            'Animal use is commonly paired with accountability, restraint, and humane concern.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'travel-observe-patterns-signs',
    themeId: 'travel-reflection-signs',
    subcategoryId: 'travel-observe-earth',
    title: 'Travel to Observe Patterns and Signs',
    subtitle: 'Movement as a school of reflection.',
    overview:
        'Travel expands observation range and interrupts habitual inattentiveness.',
    quranicPerspective:
        'The Qur’an invites people to travel and observe outcomes in the world as part of moral learning.',
    reflectiveTakeaway: 'A changed view can reshape a fixed heart.',
    practicalTakeaway:
        'On each trip, choose one deliberate observation goal tied to gratitude or humility.',
    keyConcepts: ['travel', 'attention', 'learning'],
    reflectionPrompt:
        'What does travel reveal that routine usually hides from you?',
    observationPrompt:
        'During travel, note one pattern in land, one in weather, and one in human settlement.',
    relatedLessonIds: [
      'earth-pathways-travel-guidance',
      'travel-history-accountability',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Pilgrimage and journey motifs',
        themeSummary:
            'Travel has long been used in sacred traditions for humility, learning, and return with insight.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'travel-walk-reflect-remember',
    themeId: 'travel-reflection-signs',
    subcategoryId: 'travel-observe-earth',
    title: 'Walking, Reflection, and Remembrance',
    subtitle: 'Short journeys can still be spiritually deep.',
    overview:
        'Meaningful observation does not require distant travel; even local walks can become reflective practice.',
    quranicPerspective:
        'Qur’anic reflection is tied to attentive seeing and remembering, not only to grand experiences.',
    reflectiveTakeaway: 'Depth often comes from attention, not distance.',
    practicalTakeaway:
        'Take one weekly reflection walk without audio distraction.',
    keyConcepts: ['presence', 'attention', 'remembrance'],
    reflectionPrompt:
        'How often do you move through places without truly seeing them?',
    observationPrompt:
        'During your next walk, notice three overlooked signs and write one line about each.',
    relatedLessonIds: [
      'travel-observe-patterns-signs',
      'time-dawn-sunset-heart-rhythm',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Monastic and contemplative walking traditions',
        themeSummary:
            'Walking with intentional silence is often used to cultivate awareness and gratitude.',
      ),
    ],
    order: 2,
  ),
  WorldLesson(
    id: 'travel-ruins-humility-lesson',
    themeId: 'travel-reflection-signs',
    subcategoryId: 'travel-history-remains',
    title: 'Ruins and Lessons in Humility',
    subtitle: 'What remains after power fades.',
    overview:
        'Historical remains can teach fragility of status and permanence of accountability.',
    quranicPerspective:
        'Qur’anic calls to observe past peoples are warnings against arrogance and moral decline.',
    reflectiveTakeaway:
        'Legacy depends more on justice and sincerity than on scale of power.',
    practicalTakeaway:
        'When visiting historical sites, ask what moral pattern led to endurance or decline.',
    keyConcepts: ['humility', 'history', 'accountability'],
    reflectionPrompt:
        'What kind of legacy are your daily habits currently building?',
    observationPrompt:
        'If visiting an old site, spend one minute in silence before reading placards or taking photos.',
    relatedLessonIds: [
      'travel-history-accountability',
      'time-lifespan-urgency-gratitude',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Prophetic historical warnings',
        themeSummary:
            'Earlier scriptures also use historical rise and decline to teach moral responsibility.',
      ),
    ],
    order: 1,
  ),
  WorldLesson(
    id: 'travel-history-accountability',
    themeId: 'travel-reflection-signs',
    subcategoryId: 'travel-history-remains',
    title: 'History, Consequence, and Accountability',
    subtitle: 'Patterns repeat when lessons are ignored.',
    overview:
        'World history reveals repeated links between ethics, social trust, and collective outcomes.',
    quranicPerspective:
        'Qur’anic narrative memory frames history as a mirror for present choices and future consequences.',
    reflectiveTakeaway:
        'Reflection on history should produce humility and reform, not superiority.',
    practicalTakeaway:
        'Choose one historical lesson and translate it into a personal behavior change this month.',
    keyConcepts: ['consequence', 'memory', 'reform'],
    reflectionPrompt:
        'Which repeated mistake in human history appears in smaller form in your own life?',
    observationPrompt: null,
    relatedLessonIds: [
      'travel-ruins-humility-lesson',
      'earth-settlement-gratitude-stewardship',
    ],
    comparativeInsights: [
      WorldComparativeInsight(
        tradition: 'Wisdom and prophetic memory traditions',
        themeSummary:
            'Historical memory is commonly used to call communities toward justice and repentance.',
      ),
    ],
    order: 2,
  ),
];

WorldTheme? worldThemeById(String id) {
  for (final item in worldCurriculum.themes) {
    if (item.id == id) return item;
  }
  return null;
}

WorldSubcategory? worldSubcategoryById(String id) {
  for (final item in worldCurriculum.subcategories) {
    if (item.id == id) return item;
  }
  return null;
}

WorldLesson? worldLessonById(String id) {
  for (final item in worldCurriculum.lessons) {
    if (item.id == id) return item;
  }
  return null;
}

List<WorldSubcategory> worldSubcategoriesForTheme(String themeId) {
  return worldCurriculum.subcategories
      .where((item) => item.themeId == themeId)
      .toList()
    ..sort((a, b) => a.order.compareTo(b.order));
}

List<WorldLesson> worldLessonsForSubcategory(String subcategoryId) {
  return worldCurriculum.lessons
      .where((item) => item.subcategoryId == subcategoryId)
      .toList()
    ..sort((a, b) => a.order.compareTo(b.order));
}

List<WorldTheme> worldThemesInSuggestedOrder() {
  final out = <WorldTheme>[];
  for (final id in worldCurriculum.suggestedThemeOrder) {
    final theme = worldThemeById(id);
    if (theme != null) out.add(theme);
  }
  return out;
}
