import '../domain/world_creation_models.dart';

const _translationSource = 'Sahih International';

VerseContent _v(int surah, String surahName, int start, [int? end]) {
  return VerseContent(
    surahNumber: surah,
    surahName: surahName,
    ayahStart: start,
    ayahEnd: end ?? start,
    translationSource: _translationSource,
  );
}

ScienceLensContent _science({
  required String title,
  required String summary,
  required String explanation,
  required String caution,
  required String diagramHint,
  required List<ScienceTimelinePoint> timeline,
}) {
  return ScienceLensContent(
    title: title,
    summary: summary,
    explanation: explanation,
    timelinePoints: timeline,
    cautionNote: caution,
    diagramHint: diagramHint,
    sourceLabels: const ['Mainstream scientific consensus summaries'],
  );
}

final worldCreationLessons = <WorldCreationLesson>[
  WorldCreationLesson(
    id: 'wc_creation_universe',
    title: 'Creation of the Universe',
    slug: 'creation-of-the-universe',
    category: WorldCreationCategoryId.universeSpace,
    summary:
        'The Qur’an points people toward the heavens as signs that invite careful reflection and study.',
    quranVerses: [_v(21, 'Al-Anbiya', 30), _v(41, 'Fussilat', 53)],
    quranObservation:
        'The verse calls attention to the origin and order of the cosmos, inviting humans to observe rather than speculate carelessly.',
    scienceLens: _science(
      title: 'Cosmology and Cosmic Origins',
      summary:
          'Modern cosmology studies early-universe expansion and structure formation through observation and mathematical modeling.',
      explanation:
          'Evidence from cosmic background radiation, galaxy distribution, and expansion measurements supports a dynamic early universe followed by large-scale structure formation.',
      caution:
          'This section does not claim the Qur’an is a modern physics textbook; it highlights reflection and scientific inquiry as complementary modes of understanding.',
      diagramHint: 'cosmic-expansion',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Classical astronomy foundations',
          period: '8th–15th centuries',
          note:
              'Systematic observation and mathematical astronomy developed in many civilizations, including Muslim scholarship.',
        ),
        ScienceTimelinePoint(
          title: 'General relativity era',
          period: '20th century',
          note: 'Theoretical frameworks enabled modern cosmological models.',
        ),
        ScienceTimelinePoint(
          title: 'Precision cosmology',
          period: 'Late 20th–21st centuries',
          note:
              'Satellite and telescope data improved measurements of expansion and large-scale structure.',
        ),
      ],
    ),
    reflection:
        'When the sky feels immense, the self feels smaller and responsibility feels clearer.',
    observationPrompt:
        'Step outside tonight, look upward for two minutes in silence, and write one thought about scale and humility.',
    tags: const ['universe', 'cosmos', 'origins', 'reflection'],
    visualAssetKey: 'world_universe_hero',
    depth: WorldCreationDepth.intermediate,
    relatedLessonIds: const ['wc_expanding_heavens', 'wc_vastness_creation'],
    featured: true,
    sortOrder: 1,
  ),
  WorldCreationLesson(
    id: 'wc_expanding_heavens',
    title: 'The Expanding Heavens',
    slug: 'expanding-heavens',
    category: WorldCreationCategoryId.universeSpace,
    summary:
        'The Qur’an references the heavens with language that invites deep observation.',
    quranVerses: [_v(51, 'Adh-Dhariyat', 47)],
    quranObservation:
        'The verse draws attention to divine power in the heavens and encourages reflection on cosmic scale and order.',
    scienceLens: _science(
      title: 'Observed Cosmic Expansion',
      summary:
          'Galactic redshift observations are interpreted within expansion models of space-time.',
      explanation:
          'Distant galaxies exhibit redshift patterns consistent with an expanding universe model; this remains an active field with refined measurements.',
      caution:
          'Interpretive humility is essential. The app avoids overclaiming one-to-one equivalence between scripture wording and technical cosmology terms.',
      diagramHint: 'redshift-distance',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Redshift observations',
          period: 'Early 20th century',
          note:
              'Systematic extragalactic observations linked distance and recession indicators.',
        ),
        ScienceTimelinePoint(
          title: 'Expansion models refined',
          period: '20th–21st centuries',
          note:
              'Improved instruments increased accuracy of expansion rate estimates.',
        ),
      ],
    ),
    reflection: 'Wonder grows when certainty is paired with humility.',
    observationPrompt:
        'Use a sky app or star chart once this week and reflect on how little we occupy within the cosmic whole.',
    tags: const ['heavens', 'expansion', 'cosmology'],
    visualAssetKey: 'world_cosmic_grid',
    depth: WorldCreationDepth.deep,
    relatedLessonIds: const ['wc_creation_universe', 'wc_orbits'],
    featured: true,
    sortOrder: 2,
  ),
  WorldCreationLesson(
    id: 'wc_moon_phases',
    title: 'The Moon and Its Phases',
    slug: 'moon-phases',
    category: WorldCreationCategoryId.timeCycles,
    summary: 'Lunar phases support time awareness and recurring reflection.',
    quranVerses: [_v(36, 'Ya-Sin', 39)],
    quranObservation:
        'The verse points to an ordered, repeating cycle visible to every observer.',
    scienceLens: _science(
      title: 'Lunar Orbital Cycles',
      summary:
          'Moon phases arise from orbital geometry between Sun, Earth, and Moon.',
      explanation:
          'The visible illuminated fraction changes through predictable positions in the lunar orbit, supporting natural timekeeping.',
      caution:
          'This is presented as observation-linked learning, not as a reduction of revelation to astronomy alone.',
      diagramHint: 'moon-phases-wheel',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Lunar calendars',
          period: 'Ancient to present',
          note:
              'Many societies tracked lunar cycles for worship, agriculture, and civic life.',
        ),
      ],
    ),
    reflection:
        'Regular cycles can stabilize the heart in seasons of personal unpredictability.',
    observationPrompt:
        'Observe the moon on three nights this week and note visible shape changes.',
    tags: const ['moon', 'time', 'cycles'],
    visualAssetKey: 'world_moon_cycle',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_night_day', 'wc_months_timekeeping'],
    featured: true,
    sortOrder: 1,
  ),
  WorldCreationLesson(
    id: 'wc_night_day',
    title: 'Night and Day in Succession',
    slug: 'night-day-succession',
    category: WorldCreationCategoryId.timeCycles,
    summary:
        'Alternation of light and darkness shapes life rhythms and worship rhythms.',
    quranVerses: [_v(25, 'Al-Furqan', 62)],
    quranObservation:
        'The verse frames alternating time windows as opportunities for remembrance and gratitude.',
    scienceLens: _science(
      title: 'Earth Rotation and Biological Rhythms',
      summary:
          'Day-night cycles derive from Earth’s rotation and influence circadian systems.',
      explanation:
          'Light cues synchronize biological cycles in humans and other organisms, affecting sleep, hormones, and behavior.',
      caution:
          'Scientific mechanisms do not replace spiritual meaning; they can deepen appreciation of created order.',
      diagramHint: 'earth-rotation-day-night',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Circadian biology',
          period: '20th century onward',
          note:
              'Research clarified biological timing systems responsive to light cues.',
        ),
      ],
    ),
    reflection: 'Time is not empty; it is structured mercy and responsibility.',
    observationPrompt:
        'At sunset today, pause one minute and mark one gratitude before screens or tasks.',
    tags: const ['night', 'day', 'time'],
    visualAssetKey: 'world_day_night',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_moon_phases', 'wc_seasons_change'],
    featured: true,
    sortOrder: 2,
  ),
  WorldCreationLesson(
    id: 'wc_water_origin_life',
    title: 'Water as Origin of Life',
    slug: 'water-origin-of-life',
    category: WorldCreationCategoryId.oceansWater,
    summary: 'The Qur’an repeatedly links water with life, mercy, and revival.',
    quranVerses: [_v(21, 'Al-Anbiya', 30)],
    quranObservation:
        'The verse directs attention to water as a foundational sign embedded in living systems.',
    scienceLens: _science(
      title: 'Biological Dependence on Water',
      summary:
          'Known life processes rely on water for chemistry, transport, and regulation.',
      explanation:
          'Cells, metabolism, nutrient transport, and ecological systems all depend on water availability and cycling.',
      caution:
          'The lesson highlights converging observation; it does not claim to settle all origin-of-life debates.',
      diagramHint: 'cell-water-balance',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Cell theory and biochemistry',
          period: '19th–20th centuries',
          note:
              'Scientific advances clarified water’s central role in living systems.',
        ),
      ],
    ),
    reflection:
        'Daily water use can become a remembrance of dependence, provision, and stewardship.',
    observationPrompt:
        'During wudu or drinking water, pause and reflect on dependence rather than habit.',
    tags: const ['water', 'life', 'mercy'],
    visualAssetKey: 'world_water_life',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_rain_mercy', 'wc_two_seas'],
    featured: true,
    sortOrder: 1,
  ),
  WorldCreationLesson(
    id: 'wc_deep_ocean_darkness',
    title: 'Depths of the Ocean',
    slug: 'depths-of-ocean',
    category: WorldCreationCategoryId.oceansWater,
    summary:
        'Deep ocean environments illustrate layered darkness and complex physical conditions.',
    quranVerses: [_v(24, 'An-Nur', 40)],
    quranObservation:
        'The verse evokes stacked darkness and layered waters, inviting contemplation of environments beyond casual human perception.',
    scienceLens: _science(
      title: 'Ocean Depth Zones',
      summary:
          'Light penetration, pressure, temperature, and ecosystems change dramatically with depth.',
      explanation:
          'Sunlight rapidly decreases with depth; deep zones exhibit unique ecological adaptations and physical constraints.',
      caution:
          'The point is reflective humility before complexity, not sensational claims beyond evidence.',
      diagramHint: 'ocean-depth-zones',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Modern deep-sea exploration',
          period: '20th century onward',
          note:
              'Submersibles and sensors expanded understanding of deep ocean layers.',
        ),
      ],
    ),
    reflection: 'Much of creation is real even when unseen by ordinary sight.',
    observationPrompt:
        'Visit a body of water and reflect on what remains hidden beneath the surface.',
    tags: const ['ocean', 'depth', 'darkness'],
    visualAssetKey: 'world_deep_ocean',
    depth: WorldCreationDepth.intermediate,
    relatedLessonIds: const ['wc_water_origin_life', 'wc_rain_mercy'],
    featured: true,
    sortOrder: 2,
  ),
  WorldCreationLesson(
    id: 'wc_two_seas',
    title: 'The Two Seas',
    slug: 'the-two-seas',
    category: WorldCreationCategoryId.oceansWater,
    summary: 'The Qur’an references adjacent waters with distinct properties.',
    quranVerses: [_v(55, 'Ar-Rahman', 19, 20)],
    quranObservation:
        'The verse points to natural boundaries and transitions in water systems.',
    scienceLens: _science(
      title: 'Water Mass Boundaries',
      summary:
          'Salinity, temperature, and density gradients can produce transitional boundary layers in marine systems.',
      explanation:
          'Oceanography studies how distinct water masses interact through mixing zones while retaining measurable differences over ranges.',
      caution:
          'This is not a claim of absolute non-mixing barriers; real systems show gradients and dynamic interaction.',
      diagramHint: 'halocline-thermocline',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Physical oceanography growth',
          period: '19th–21st centuries',
          note:
              'Instruments improved mapping of salinity and temperature structures.',
        ),
      ],
    ),
    reflection:
        'Boundaries in creation often carry wisdom, order, and restraint.',
    observationPrompt:
        'If near a shore or river mouth, observe color, current, and movement transitions.',
    tags: const ['seas', 'boundaries', 'oceanography'],
    visualAssetKey: 'world_two_seas',
    depth: WorldCreationDepth.deep,
    relatedLessonIds: const ['wc_deep_ocean_darkness', 'wc_water_origin_life'],
    featured: true,
    sortOrder: 3,
  ),
  WorldCreationLesson(
    id: 'wc_animals_communities',
    title: 'Animals as Communities',
    slug: 'animals-as-communities',
    category: WorldCreationCategoryId.animalsLiving,
    summary:
        'Animal life shows social order, communication, and interdependence.',
    quranVerses: [_v(6, 'Al-An’am', 38)],
    quranObservation:
        'The verse directs attention to organized life among creatures, not random chaos.',
    scienceLens: _science(
      title: 'Behavioral Ecology',
      summary:
          'Many species display social structures, signaling systems, and group behavior.',
      explanation:
          'Field studies document cooperation, hierarchy, migration patterns, and adaptive social behavior across diverse species.',
      caution:
          'Human social concepts should not be simplistically imposed on animals; analogies must remain careful.',
      diagramHint: 'animal-social-patterns',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Modern ethology',
          period: '20th century onward',
          note:
              'Systematic behavioral observation transformed understanding of animal societies.',
        ),
      ],
    ),
    reflection:
        'Respect for living creatures grows when we observe their complexity.',
    observationPrompt:
        'Spend five minutes quietly observing birds or insects without interruption.',
    tags: const ['animals', 'communities', 'ecology'],
    visualAssetKey: 'world_animals',
    depth: WorldCreationDepth.intermediate,
    relatedLessonIds: const ['wc_bee', 'wc_birds_flight'],
    featured: true,
    sortOrder: 1,
  ),
  WorldCreationLesson(
    id: 'wc_bee',
    title: 'The Bee',
    slug: 'the-bee',
    category: WorldCreationCategoryId.animalsLiving,
    summary:
        'The Qur’an highlights bees as signs of ordered benefit in creation.',
    quranVerses: [_v(16, 'An-Nahl', 68, 69)],
    quranObservation:
        'The verse points toward directed patterns, habitats, and beneficial products in the life of bees.',
    scienceLens: _science(
      title: 'Pollination and Hive Systems',
      summary:
          'Bees contribute to pollination networks and show coordinated colony behavior.',
      explanation:
          'Bee populations influence ecosystems and agriculture through pollination; hives involve specialized roles and communication behaviors.',
      caution:
          'The lesson emphasizes reflection through established biology, avoiding speculative overreading.',
      diagramHint: 'pollination-network',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Pollination science development',
          period: '18th century onward',
          note:
              'Botany and ecology clarified pollinator roles in food systems.',
        ),
      ],
    ),
    reflection: 'Small creatures can carry vast benefit beyond human notice.',
    observationPrompt:
        'Find flowering plants and observe pollinator movement patterns for two minutes.',
    tags: const ['bee', 'pollination', 'benefit'],
    visualAssetKey: 'world_bee',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_animals_communities', 'wc_plants_growth'],
    featured: true,
    sortOrder: 2,
  ),
  WorldCreationLesson(
    id: 'wc_human_stages',
    title: 'Stages of Human Development',
    slug: 'stages-human-development',
    category: WorldCreationCategoryId.humanCreation,
    summary:
        'The Qur’an invites reflection on human development and dependence.',
    quranVerses: [_v(23, 'Al-Mu’minun', 12, 14)],
    quranObservation:
        'The verses draw attention to developmental stages and human fragility.',
    scienceLens: _science(
      title: 'Embryological Development',
      summary:
          'Developmental biology studies sequential stages from fertilization through organ development and growth.',
      explanation:
          'Scientific frameworks map complex cellular differentiation and staged growth with high precision.',
      caution:
          'Language across centuries differs in style and purpose; careful interpretation avoids forcing technical equivalence.',
      diagramHint: 'development-stages',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Microscopy and embryology',
          period: '17th–20th centuries',
          note:
              'Observational methods progressively improved detail of developmental stages.',
        ),
      ],
    ),
    reflection: 'Human strength begins in dependence and remains dependent.',
    observationPrompt:
        'Reflect on your own growth history and write one gratitude for body, mind, or care received.',
    tags: const ['human', 'development', 'dependence'],
    visualAssetKey: 'world_human_development',
    depth: WorldCreationDepth.intermediate,
    relatedLessonIds: const ['wc_signs_within_ourselves'],
    featured: true,
    sortOrder: 1,
  ),
  WorldCreationLesson(
    id: 'wc_signs_within_ourselves',
    title: 'Signs Within Ourselves',
    slug: 'signs-within-ourselves',
    category: WorldCreationCategoryId.humanCreation,
    summary:
        'The Qur’an links outward observation with inward self-reflection.',
    quranVerses: [_v(41, 'Fussilat', 53)],
    quranObservation:
        'The verse pairs horizons and inner selves as complementary domains of signs.',
    scienceLens: _science(
      title: 'Mind-Body and Self-Awareness',
      summary:
          'Human cognition, perception, and physiology are deeply interlinked and studied through multiple disciplines.',
      explanation:
          'Neuroscience, psychology, and physiology together show how perception, memory, and bodily systems interact.',
      caution:
          'Scientific models describe mechanisms; spiritual self-knowledge concerns purpose and moral orientation as well.',
      diagramHint: 'mind-body-system',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Cognitive science expansion',
          period: '20th century onward',
          note:
              'Interdisciplinary research broadened understanding of perception and awareness.',
        ),
      ],
    ),
    reflection:
        'The path to insight often begins with honest inward observation.',
    observationPrompt:
        'Take one silent minute today to observe breath, thoughts, and intention without judgment.',
    tags: const ['self', 'reflection', 'awareness'],
    visualAssetKey: 'world_self_signs',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_human_stages', 'wc_reflection_horizons'],
    featured: true,
    sortOrder: 2,
  ),
  WorldCreationLesson(
    id: 'wc_winds_clouds_rain',
    title: 'Winds, Clouds, and Rain',
    slug: 'winds-clouds-rain',
    category: WorldCreationCategoryId.weatherPhenomena,
    summary: 'Weather systems are signs of provision, motion, and dependence.',
    quranVerses: [_v(30, 'Ar-Rum', 48)],
    quranObservation:
        'The verse points to staged weather processes and resulting mercy in rainfall.',
    scienceLens: _science(
      title: 'Atmospheric Dynamics and Precipitation',
      summary:
          'Wind patterns, condensation, and pressure systems drive rainfall processes.',
      explanation:
          'Meteorology studies cloud formation, humidity gradients, and temperature dynamics that influence precipitation events.',
      caution:
          'Weather science explains mechanisms while revelation frames meaning, dependence, and gratitude.',
      diagramHint: 'water-cycle-weather',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Modern meteorology',
          period: '19th century onward',
          note: 'Instrumentation and models increased forecasting accuracy.',
        ),
      ],
    ),
    reflection: 'Rain can retrain the heart from entitlement to gratitude.',
    observationPrompt:
        'Observe cloud movement for five minutes before rain or after rainfall.',
    tags: const ['weather', 'rain', 'clouds', 'wind'],
    visualAssetKey: 'world_weather',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const [
      'wc_atmosphere_protection',
      'wc_water_origin_life',
    ],
    featured: true,
    sortOrder: 1,
  ),
  WorldCreationLesson(
    id: 'wc_atmosphere_protection',
    title: 'Atmosphere as Protection',
    slug: 'atmosphere-protection',
    category: WorldCreationCategoryId.weatherPhenomena,
    summary:
        'The sky is described as a protected canopy, inviting scientific and spiritual reflection.',
    quranVerses: [_v(21, 'Al-Anbiya', 32)],
    quranObservation:
        'The verse highlights protective qualities in the sky that people often overlook.',
    scienceLens: _science(
      title: 'Atmospheric Shielding Functions',
      summary:
          'Earth’s atmosphere moderates temperature, filters radiation, and supports breathable conditions.',
      explanation:
          'Multiple layers contribute differently to shielding, thermal balance, and weather processes that sustain life.',
      caution:
          'Scientific detail enriches appreciation; it should not be weaponized into simplistic proof slogans.',
      diagramHint: 'atmosphere-layers',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Atmospheric physics development',
          period: '19th–21st centuries',
          note:
              'Balloon, satellite, and spectroscopic research advanced understanding of atmospheric layers.',
        ),
      ],
    ),
    reflection: 'Protection is easiest to forget when it is constant.',
    observationPrompt:
        'At midday, look at the sky and reflect on unseen protections in daily life.',
    tags: const ['atmosphere', 'sky', 'protection'],
    visualAssetKey: 'world_atmosphere',
    depth: WorldCreationDepth.intermediate,
    relatedLessonIds: const ['wc_winds_clouds_rain'],
    featured: true,
    sortOrder: 2,
  ),
  WorldCreationLesson(
    id: 'wc_mountains_sign',
    title: 'Mountains in the Qur’an',
    slug: 'mountains-in-quran',
    category: WorldCreationCategoryId.mountainsGeography,
    summary:
        'Mountains are presented as signs of scale, stability, and perspective.',
    quranVerses: [_v(88, 'Al-Ghashiyah', 19)],
    quranObservation:
        'The verse invites direct visual observation of landforms and their significance.',
    scienceLens: _science(
      title: 'Geology and Mountain Formation',
      summary:
          'Mountain ranges form through tectonic forces, uplift, erosion, and long geological timelines.',
      explanation:
          'Geology studies plate boundaries, crustal deformation, and surface shaping over extended timescales.',
      caution:
          'The app avoids simplistic claims that reduce scripture to technical geology vocabulary.',
      diagramHint: 'tectonic-uplift',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Plate tectonics framework',
          period: '20th century',
          note:
              'A unifying model explained mountain formation and crustal movement.',
        ),
      ],
    ),
    reflection: 'Mountains teach both firmness and scale humility.',
    observationPrompt:
        'If possible, view a hill or mountain horizon and note texture, layers, and contrast.',
    tags: const ['mountains', 'geology', 'landscape'],
    visualAssetKey: 'world_mountains',
    depth: WorldCreationDepth.intermediate,
    relatedLessonIds: const ['wc_travel_land', 'wc_earth_signs_land'],
    featured: true,
    sortOrder: 1,
  ),
  WorldCreationLesson(
    id: 'wc_travel_land',
    title: 'Travel Through the Land',
    slug: 'travel-through-the-land',
    category: WorldCreationCategoryId.mountainsGeography,
    summary:
        'Travel and observation are recurring Qur’anic invitations to learn from creation and history.',
    quranVerses: [_v(29, 'Al-Ankabut', 20)],
    quranObservation:
        'The verse connects movement through the earth with reflective understanding.',
    scienceLens: _science(
      title: 'Field Observation as Method',
      summary:
          'Many sciences progress through direct observation, travel, sampling, and comparison across environments.',
      explanation:
          'Geography, ecology, and earth sciences rely heavily on local observation and field evidence.',
      caution:
          'Not every observed pattern carries immediate conclusion; disciplined inquiry requires patience and method.',
      diagramHint: 'field-observation-loop',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Field sciences expansion',
          period: '18th century onward',
          note:
              'Systematic surveying and natural history shaped modern earth and life sciences.',
        ),
      ],
    ),
    reflection: 'Travel can awaken lessons that routine hides.',
    observationPrompt:
        'During your next walk, observe one natural detail and one historical detail you usually miss.',
    tags: const ['travel', 'observation', 'earth'],
    visualAssetKey: 'world_travel',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_mountains_sign', 'wc_reflection_why_observe'],
    featured: false,
    sortOrder: 2,
  ),
  WorldCreationLesson(
    id: 'wc_plants_growth',
    title: 'Seeds and Growth',
    slug: 'seeds-and-growth',
    category: WorldCreationCategoryId.plantsSustenance,
    summary: 'Plant growth reflects process, patience, and provision.',
    quranVerses: [_v(30, 'Ar-Rum', 48), _v(21, 'Al-Anbiya', 30)],
    quranObservation:
        'Revelation repeatedly points to revived land and crops as visible signs of mercy and power.',
    scienceLens: _science(
      title: 'Plant Growth Systems',
      summary:
          'Seeds germinate through suitable moisture, temperature, and nutrient conditions.',
      explanation:
          'Plant biology studies photosynthesis, root systems, growth cycles, and environmental dependence.',
      caution:
          'Scientific process descriptions support reflection; they do not exhaust the spiritual meaning of provision.',
      diagramHint: 'seed-to-plant',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Botany and plant physiology',
          period: '17th century onward',
          note: 'Observation and experimentation clarified growth processes.',
        ),
      ],
    ),
    reflection: 'Growth is often hidden before it is visible.',
    observationPrompt:
        'Observe a plant for a week and record one subtle change.',
    tags: const ['plants', 'growth', 'sustenance'],
    visualAssetKey: 'world_plants',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_rain_mercy', 'wc_animals_communities'],
    featured: true,
    sortOrder: 1,
  ),
  WorldCreationLesson(
    id: 'wc_rain_mercy',
    title: 'Rain as Mercy',
    slug: 'rain-as-mercy',
    category: WorldCreationCategoryId.plantsSustenance,
    summary: 'Rainfall revives ecosystems and reminds humans of dependence.',
    quranVerses: [_v(30, 'Ar-Rum', 48)],
    quranObservation:
        'The verse links rain to revival and lived experience of mercy.',
    scienceLens: _science(
      title: 'Hydrology and Ecological Revival',
      summary:
          'Rainfall patterns influence soils, crops, groundwater, and ecosystem health.',
      explanation:
          'Hydrology studies precipitation, infiltration, runoff, and distribution across landscapes.',
      caution:
          'Rain variability can include hardship; reflection includes gratitude, stewardship, and responsibility.',
      diagramHint: 'hydrology-cycle',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Hydrological measurement systems',
          period: '19th century onward',
          note:
              'Rain gauges and watershed studies improved understanding of rainfall dynamics.',
        ),
      ],
    ),
    reflection: 'Revived earth reminds the heart that renewal is possible.',
    observationPrompt:
        'After rain, observe scent, soil texture, and plant response.',
    tags: const ['rain', 'water-cycle', 'mercy'],
    visualAssetKey: 'world_rain',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_winds_clouds_rain', 'wc_plants_growth'],
    featured: true,
    sortOrder: 2,
  ),
  WorldCreationLesson(
    id: 'wc_earth_signs_land',
    title: 'The Earth as a Sign',
    slug: 'earth-as-sign',
    category: WorldCreationCategoryId.earthNature,
    summary:
        'The Earth invites observation through diversity of terrain and life.',
    quranVerses: [_v(88, 'Al-Ghashiyah', 20), _v(29, 'Al-Ankabut', 20)],
    quranObservation:
        'The Qur’an directs human attention to land itself as a field of meaningful signs.',
    scienceLens: _science(
      title: 'Earth Systems',
      summary:
          'Climate, geology, hydrology, and ecology form interacting systems.',
      explanation:
          'Earth system science studies connections among atmosphere, lithosphere, hydrosphere, and biosphere.',
      caution:
          'Complex systems require careful interpretation and do not support simplistic certainty claims.',
      diagramHint: 'earth-systems-cycle',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Earth system science',
          period: 'Late 20th century onward',
          note: 'Integrated approaches connected formerly separate subfields.',
        ),
      ],
    ),
    reflection:
        'Land is not inert scenery; it is active evidence of order and provision.',
    observationPrompt:
        'During a walk, note three distinct textures in earth, stone, or vegetation.',
    tags: const ['earth', 'nature', 'systems'],
    visualAssetKey: 'world_earth',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_mountains_sign', 'wc_travel_land'],
    featured: true,
    sortOrder: 1,
  ),
  WorldCreationLesson(
    id: 'wc_balance_nature',
    title: 'Balance in Nature',
    slug: 'balance-in-nature',
    category: WorldCreationCategoryId.earthNature,
    summary:
        'Natural systems demonstrate measured patterns and interdependence.',
    quranVerses: [_v(25, 'Al-Furqan', 62)],
    quranObservation:
        'The Qur’an repeatedly portrays creation as ordered and measured, inviting responsible engagement.',
    scienceLens: _science(
      title: 'Ecological Balance and Feedback',
      summary:
          'Ecosystems rely on interacting balances, feedback loops, and adaptive resilience.',
      explanation:
          'Population shifts, nutrient cycles, and climate interactions influence ecological stability over time.',
      caution:
          'Balance in nature is dynamic rather than static; responsible language avoids oversimplification.',
      diagramHint: 'ecosystem-feedback-loop',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Ecology as a formal discipline',
          period: '19th–20th centuries',
          note:
              'Field and systems models clarified interdependence in living environments.',
        ),
      ],
    ),
    reflection: 'Order in nature can teach order in daily life and priorities.',
    observationPrompt:
        'Observe a small ecosystem (park, garden, water edge) and note interaction between at least three elements.',
    tags: const ['balance', 'ecology', 'interdependence'],
    visualAssetKey: 'world_balance',
    depth: WorldCreationDepth.intermediate,
    relatedLessonIds: const ['wc_earth_signs_land'],
    featured: false,
    sortOrder: 2,
  ),
  WorldCreationLesson(
    id: 'wc_reflection_horizons',
    title: 'Signs in the Horizons',
    slug: 'signs-in-the-horizons',
    category: WorldCreationCategoryId.reflectionSigns,
    summary: 'The Qur’an calls people to look outward and inward for signs.',
    quranVerses: [_v(41, 'Fussilat', 53), _v(3, 'Aal Imran', 190)],
    quranObservation:
        'Verses in this theme combine cognition, attention, and moral orientation through active reflection.',
    scienceLens: _science(
      title: 'Observation as a Human Method',
      summary:
          'Across sciences, observation precedes model-building, testing, and refinement.',
      explanation:
          'Disciplined observation generates questions, data, and eventually more reliable understanding.',
      caution:
          'Reflection is not anti-scientific; nor is science spiritually sufficient on its own.',
      diagramHint: 'observe-question-study-reflect',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Scientific method refinement',
          period: 'Classical to modern eras',
          note:
              'Methodological thinking evolved across civilizations and disciplines.',
        ),
      ],
    ),
    reflection: 'A seeing eye and a remembering heart must travel together.',
    observationPrompt:
        'Choose one ordinary scene today and ask: what did I miss yesterday?',
    tags: const ['reflection', 'horizons', 'signs'],
    visualAssetKey: 'world_reflection',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const [
      'wc_reflection_why_observe',
      'wc_signs_within_ourselves',
    ],
    featured: true,
    sortOrder: 1,
  ),
  WorldCreationLesson(
    id: 'wc_reflection_why_observe',
    title: 'Why the Qur’an Calls Us to Observe',
    slug: 'why-quran-calls-to-observe',
    category: WorldCreationCategoryId.reflectionSigns,
    summary:
        'Observation in revelation is linked to humility, knowledge, and accountability.',
    quranVerses: [_v(29, 'Al-Ankabut', 20), _v(88, 'Al-Ghashiyah', 17, 20)],
    quranObservation:
        'The Qur’an repeatedly directs attention toward tangible reality to awaken reflection and responsibility.',
    scienceLens: _science(
      title: 'Curiosity, Inquiry, and Learning',
      summary:
          'Reliable knowledge grows through curiosity disciplined by method and ethics.',
      explanation:
          'Inquiry thrives when questions are sincere, evidence is respected, and conclusions remain proportionate.',
      caution:
          'Avoiding both naïve skepticism and naïve certainty protects integrity in faith and science learning.',
      diagramHint: 'curiosity-to-wisdom',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Historical inquiry traditions',
          period: 'Across civilizations',
          note:
              'Observational and analytical traditions evolved in theology, philosophy, and science.',
        ),
      ],
    ),
    reflection: 'Observation is a form of gratitude when done with humility.',
    observationPrompt:
        'Write one question about creation this week and pursue a reliable answer with patience.',
    tags: const ['curiosity', 'knowledge', 'reflection'],
    visualAssetKey: 'world_curiosity',
    depth: WorldCreationDepth.intermediate,
    relatedLessonIds: const ['wc_reflection_horizons'],
    featured: true,
    sortOrder: 2,
  ),
  WorldCreationLesson(
    id: 'wc_orbits',
    title: 'Orbits and Measured Motion',
    slug: 'orbits-and-measured-motion',
    category: WorldCreationCategoryId.universeSpace,
    summary: 'Celestial motion reflects measured order in creation.',
    quranVerses: [_v(21, 'Al-Anbiya', 33)],
    quranObservation:
        'The verse highlights moving celestial bodies within ordered patterns.',
    scienceLens: _science(
      title: 'Orbital Mechanics',
      summary:
          'Gravity and inertia shape stable orbital trajectories at multiple scales.',
      explanation:
          'Planetary, lunar, and satellite motions can be modeled with high predictive reliability.',
      caution:
          'Technical models are precise, yet meaning and purpose remain philosophical and spiritual questions as well.',
      diagramHint: 'orbit-paths',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Classical mechanics synthesis',
          period: '17th century onward',
          note:
              'Mathematical frameworks enabled predictive orbital calculations.',
        ),
      ],
    ),
    reflection: 'Order in motion can call the heart toward order in conduct.',
    observationPrompt:
        'Watch moonrise timing over two nights and note predictability.',
    tags: const ['orbits', 'motion', 'space'],
    visualAssetKey: 'world_orbits',
    depth: WorldCreationDepth.intermediate,
    relatedLessonIds: const ['wc_expanding_heavens', 'wc_moon_phases'],
    featured: false,
    sortOrder: 3,
  ),
  WorldCreationLesson(
    id: 'wc_vastness_creation',
    title: 'Vastness of Creation',
    slug: 'vastness-of-creation',
    category: WorldCreationCategoryId.universeSpace,
    summary: 'Immensity of creation can produce awe and moral humility.',
    quranVerses: [_v(3, 'Aal Imran', 190)],
    quranObservation:
        'The verse invites reflective minds to read the heavens and earth as signs, not mere scenery.',
    scienceLens: _science(
      title: 'Scale in Astronomy',
      summary:
          'Distances and sizes in astronomy exceed ordinary human intuition.',
      explanation:
          'Astronomy uses units like astronomical units, light-years, and parsecs to describe cosmic scales.',
      caution:
          'Awe should not become arrogance of knowledge; humility remains central.',
      diagramHint: 'scale-ladder',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Modern distance ladder',
          period: '20th century onward',
          note: 'Multiple methods improved distance and scale estimation.',
        ),
      ],
    ),
    reflection: 'Scale can reduce ego and enlarge gratitude.',
    observationPrompt:
        'At night, compare one nearby object and the night sky to sense relative scale.',
    tags: const ['vastness', 'awe', 'humility'],
    visualAssetKey: 'world_vastness',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_creation_universe', 'wc_reflection_horizons'],
    featured: false,
    sortOrder: 4,
  ),
  WorldCreationLesson(
    id: 'wc_months_timekeeping',
    title: 'Months and Timekeeping',
    slug: 'months-timekeeping',
    category: WorldCreationCategoryId.timeCycles,
    summary:
        'Lunar and solar observations both shaped practical human timekeeping.',
    quranVerses: [_v(10, 'Yunus', 5)],
    quranObservation:
        'The verse points toward measured temporal cycles for orientation and reckoning.',
    scienceLens: _science(
      title: 'Calendrical Systems',
      summary:
          'Calendars use recurring astronomical cycles to structure human life.',
      explanation:
          'Different societies developed lunar, solar, and lunisolar systems for worship, agriculture, and governance.',
      caution:
          'No single calendar erases practical diversity; each system reflects priorities and context.',
      diagramHint: 'calendar-cycles',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Historical calendar reforms',
          period: 'Ancient to modern',
          note:
              'Calendar systems evolved alongside astronomical observation and social needs.',
        ),
      ],
    ),
    reflection:
        'Measured time should deepen intentional living, not rushed living.',
    observationPrompt:
        'Mark one weekly time checkpoint for reflection and one for learning.',
    tags: const ['months', 'calendar', 'timekeeping'],
    visualAssetKey: 'world_calendar',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_moon_phases', 'wc_night_day'],
    featured: false,
    sortOrder: 3,
  ),
  WorldCreationLesson(
    id: 'wc_seasons_change',
    title: 'Seasons and Change',
    slug: 'seasons-and-change',
    category: WorldCreationCategoryId.timeCycles,
    summary: 'Seasonal shifts teach adaptation and patient continuity.',
    quranVerses: [_v(25, 'Al-Furqan', 62)],
    quranObservation:
        'Alternating states in creation normalize change while preserving order.',
    scienceLens: _science(
      title: 'Seasonal Drivers',
      summary: 'Axial tilt and orbital position shape seasonal patterns.',
      explanation:
          'Changing sun angle and daylight length drive seasonal temperature and ecological variation.',
      caution:
          'Local weather variation does not negate broader seasonal or climate patterns.',
      diagramHint: 'earth-tilt-seasons',
      timeline: const [
        ScienceTimelinePoint(
          title: 'Global climate observation networks',
          period: '19th century onward',
          note:
              'Systematic records improved seasonal and climate understanding.',
        ),
      ],
    ),
    reflection: 'Change in season can become training for change in self.',
    observationPrompt:
        'Record one seasonal change in sky, plants, or temperature this week.',
    tags: const ['seasons', 'change', 'cycles'],
    visualAssetKey: 'world_seasons',
    depth: WorldCreationDepth.beginner,
    relatedLessonIds: const ['wc_night_day', 'wc_months_timekeeping'],
    featured: false,
    sortOrder: 4,
  ),
];

final worldCreationCategories = <WorldCreationCategory>[
  WorldCreationCategory(
    id: WorldCreationCategoryId.universeSpace,
    title: 'Universe & Space',
    description:
        'Heavens, cosmic scale, motion, stars, and awe-driven inquiry.',
    featuredVerse: _v(3, 'Aal Imran', 190),
    lessonIds: const [
      'wc_creation_universe',
      'wc_expanding_heavens',
      'wc_orbits',
      'wc_vastness_creation',
    ],
    icon: 'universe',
    sortOrder: 1,
  ),
  WorldCreationCategory(
    id: WorldCreationCategoryId.earthNature,
    title: 'Earth & Nature',
    description: 'Land, ecosystems, order, and signs spread through the earth.',
    featuredVerse: _v(88, 'Al-Ghashiyah', 20),
    lessonIds: const ['wc_earth_signs_land', 'wc_balance_nature'],
    icon: 'earth',
    sortOrder: 2,
  ),
  WorldCreationCategory(
    id: WorldCreationCategoryId.oceansWater,
    title: 'Oceans & Water',
    description: 'Water, rain, seas, depth, boundaries, and revival.',
    featuredVerse: _v(21, 'Al-Anbiya', 30),
    lessonIds: const [
      'wc_water_origin_life',
      'wc_deep_ocean_darkness',
      'wc_two_seas',
    ],
    icon: 'water',
    sortOrder: 3,
  ),
  WorldCreationCategory(
    id: WorldCreationCategoryId.animalsLiving,
    title: 'Animals & Living Creatures',
    description: 'Animal communities, bees, birds, and living systems.',
    featuredVerse: _v(6, 'Al-An’am', 38),
    lessonIds: const ['wc_animals_communities', 'wc_bee'],
    icon: 'animals',
    sortOrder: 4,
  ),
  WorldCreationCategory(
    id: WorldCreationCategoryId.humanCreation,
    title: 'Human Creation',
    description:
        'Development, perception, dependence, and signs within ourselves.',
    featuredVerse: _v(41, 'Fussilat', 53),
    lessonIds: const ['wc_human_stages', 'wc_signs_within_ourselves'],
    icon: 'human',
    sortOrder: 5,
  ),
  WorldCreationCategory(
    id: WorldCreationCategoryId.timeCycles,
    title: 'Time & Cycles',
    description:
        'Night and day, lunar cycles, seasons, and rhythmic awareness.',
    featuredVerse: _v(25, 'Al-Furqan', 62),
    lessonIds: const [
      'wc_moon_phases',
      'wc_night_day',
      'wc_months_timekeeping',
      'wc_seasons_change',
    ],
    icon: 'time',
    sortOrder: 6,
  ),
  WorldCreationCategory(
    id: WorldCreationCategoryId.weatherPhenomena,
    title: 'Weather & Natural Phenomena',
    description: 'Winds, clouds, rain, and atmospheric protection.',
    featuredVerse: _v(30, 'Ar-Rum', 48),
    lessonIds: const ['wc_winds_clouds_rain', 'wc_atmosphere_protection'],
    icon: 'weather',
    sortOrder: 7,
  ),
  WorldCreationCategory(
    id: WorldCreationCategoryId.mountainsGeography,
    title: 'Mountains & Geography',
    description: 'Landforms, travel, and geography as signs.',
    featuredVerse: _v(88, 'Al-Ghashiyah', 19),
    lessonIds: const ['wc_mountains_sign', 'wc_travel_land'],
    icon: 'mountains',
    sortOrder: 8,
  ),
  WorldCreationCategory(
    id: WorldCreationCategoryId.plantsSustenance,
    title: 'Plants & Sustenance',
    description: 'Seeds, growth, gardens, and provision from earth.',
    featuredVerse: _v(30, 'Ar-Rum', 48),
    lessonIds: const ['wc_plants_growth', 'wc_rain_mercy'],
    icon: 'plants',
    sortOrder: 9,
  ),
  WorldCreationCategory(
    id: WorldCreationCategoryId.reflectionSigns,
    title: 'Reflection & Signs',
    description: 'Why the Qur’an calls us to look, observe, and reflect.',
    featuredVerse: _v(41, 'Fussilat', 53),
    lessonIds: const ['wc_reflection_horizons', 'wc_reflection_why_observe'],
    icon: 'reflection',
    sortOrder: 10,
  ),
  WorldCreationCategory(
    id: WorldCreationCategoryId.exploreCreation,
    title: 'Explore Creation',
    description:
        'Observation challenges, capture flow, and personal signs gallery.',
    featuredVerse: _v(29, 'Al-Ankabut', 20),
    lessonIds: const <String>[],
    icon: 'explore',
    sortOrder: 11,
  ),
  WorldCreationCategory(
    id: WorldCreationCategoryId.muslimScientists,
    title: 'Muslim Scientists',
    description:
        'How curiosity, observation, and learning shaped scientific inquiry.',
    featuredVerse: _v(3, 'Aal Imran', 190),
    lessonIds: const <String>[],
    icon: 'scientists',
    sortOrder: 12,
  ),
]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

final worldObservationChallenges = <ObservationChallenge>[
  ObservationChallenge(
    id: 'ch_moon_tonight',
    title: 'Observe the Moon Tonight',
    category: WorldCreationCategoryId.timeCycles,
    prompt:
        'Find the moon, note its phase, and write one sentence about change and continuity.',
    verseReference: _v(36, 'Ya-Sin', 39),
    reflectionPrompt: 'How do recurring cycles stabilize your perspective?',
    xpReward: 14,
    seasonalTag: 'all',
    timeOfDayTag: 'night',
    featured: true,
  ),
  ObservationChallenge(
    id: 'ch_cloud_watch',
    title: 'Cloud Watch',
    category: WorldCreationCategoryId.weatherPhenomena,
    prompt:
        'Observe cloud movement for three minutes and note wind direction and pattern changes.',
    verseReference: _v(30, 'Ar-Rum', 48),
    reflectionPrompt: 'What did this movement teach you about order in change?',
    xpReward: 12,
    seasonalTag: 'all',
    timeOfDayTag: 'day',
    featured: true,
  ),
  ObservationChallenge(
    id: 'ch_bird_dawn',
    title: 'Listen for Birds at Dawn',
    category: WorldCreationCategoryId.animalsLiving,
    prompt: 'Spend two quiet minutes listening to birds in the early morning.',
    verseReference: _v(3, 'Aal Imran', 190),
    reflectionPrompt: 'How does sound shape your awareness of life around you?',
    xpReward: 10,
    seasonalTag: 'spring',
    timeOfDayTag: 'dawn',
    featured: true,
  ),
  ObservationChallenge(
    id: 'ch_rain_earth',
    title: 'Observe Rain and Earth',
    category: WorldCreationCategoryId.plantsSustenance,
    prompt: 'After rain, observe soil, scent, and plant response in one area.',
    verseReference: _v(30, 'Ar-Rum', 48),
    reflectionPrompt: 'Where in your life do you need revival after dryness?',
    xpReward: 16,
    seasonalTag: 'all',
    timeOfDayTag: 'all',
    featured: true,
  ),
  ObservationChallenge(
    id: 'ch_night_sky',
    title: 'Night Sky Reflection',
    category: WorldCreationCategoryId.universeSpace,
    prompt:
        'Look at the night sky and record one thought on scale and humility.',
    verseReference: _v(3, 'Aal Imran', 190),
    reflectionPrompt: 'What feels smaller now, and what feels clearer?',
    xpReward: 15,
    seasonalTag: 'summer',
    timeOfDayTag: 'night',
    featured: true,
  ),
  ObservationChallenge(
    id: 'ch_wind_in_leaves',
    title: 'Notice Wind in Leaves',
    category: WorldCreationCategoryId.weatherPhenomena,
    prompt:
        'Observe leaves or grass movement and infer wind direction and strength shifts.',
    verseReference: _v(30, 'Ar-Rum', 48),
    reflectionPrompt: 'How do unseen forces shape visible outcomes?',
    xpReward: 11,
    seasonalTag: 'autumn',
    timeOfDayTag: 'day',
    featured: false,
  ),
  ObservationChallenge(
    id: 'ch_mountain_texture',
    title: 'Observe Landforms',
    category: WorldCreationCategoryId.mountainsGeography,
    prompt:
        'Observe a hill, mountain, or rocky surface and note layers, texture, and contrast.',
    verseReference: _v(88, 'Al-Ghashiyah', 19),
    reflectionPrompt:
        'What does firmness look like in nature and in character?',
    xpReward: 13,
    seasonalTag: 'all',
    timeOfDayTag: 'day',
    featured: false,
  ),
  ObservationChallenge(
    id: 'ch_water_surface_depth',
    title: 'Surface and Depth',
    category: WorldCreationCategoryId.oceansWater,
    prompt:
        'Observe a water surface and reflect on what remains unseen beneath.',
    verseReference: _v(24, 'An-Nur', 40),
    reflectionPrompt:
        'What parts of life are real but not immediately visible?',
    xpReward: 12,
    seasonalTag: 'all',
    timeOfDayTag: 'all',
    featured: false,
  ),
  ObservationChallenge(
    id: 'ch_seed_growth',
    title: 'Track a Small Plant',
    category: WorldCreationCategoryId.plantsSustenance,
    prompt: 'Track one plant over 5 days and record subtle changes.',
    verseReference: _v(21, 'Al-Anbiya', 30),
    reflectionPrompt: 'How does slow growth reshape your idea of progress?',
    xpReward: 18,
    seasonalTag: 'spring',
    timeOfDayTag: 'day',
    featured: false,
  ),
];

final worldScientistProfiles = <ScientistProfile>[
  const ScientistProfile(
    id: 'ibn_al_haytham',
    name: 'Ibn al-Haytham',
    era: '965–1040 CE',
    discipline: 'Optics and Scientific Method',
    summary:
        'Pioneering scholar of optics known for rigorous experimentation and critical inquiry.',
    contributionHighlights: [
      'Advanced experimental approaches in optics.',
      'Analyzed vision and light with systematic methodology.',
      'Influenced later scientific method traditions.',
    ],
    whyItMatters:
        'His work demonstrates how disciplined observation can convert curiosity into reliable knowledge.',
    relatedTopics: ['Light', 'Observation', 'Method'],
    visualAssetKey: 'scientist_optics',
  ),
  const ScientistProfile(
    id: 'al_biruni',
    name: 'Al-Biruni',
    era: '973–1050 CE',
    discipline: 'Geography, Astronomy, Geodesy',
    summary:
        'Known for precise measurement, comparative study, and broad scientific scholarship.',
    contributionHighlights: [
      'Worked on Earth measurement and geographic methods.',
      'Produced comparative and observational studies.',
      'Integrated mathematics with field observation.',
    ],
    whyItMatters:
        'He embodies patient, careful study of the natural world without overclaiming certainty.',
    relatedTopics: ['Earth', 'Scale', 'Measurement'],
    visualAssetKey: 'scientist_geography',
  ),
  const ScientistProfile(
    id: 'al_khwarizmi',
    name: 'Al-Khwarizmi',
    era: 'c. 780–850 CE',
    discipline: 'Mathematics and Astronomy',
    summary:
        'Major contributor to algebra and computational methods used across sciences.',
    contributionHighlights: [
      'Developed foundational algebraic methods.',
      'Contributed to astronomical tables and calculations.',
      'Influenced scientific computation globally.',
    ],
    whyItMatters:
        'Scientific observation needs mathematical clarity; his work strengthened that bridge.',
    relatedTopics: ['Calculation', 'Orbits', 'Timekeeping'],
    visualAssetKey: 'scientist_math',
  ),
  const ScientistProfile(
    id: 'ibn_sina',
    name: 'Ibn Sina',
    era: '980–1037 CE',
    discipline: 'Medicine and Natural Philosophy',
    summary:
        'Systematized medical knowledge and contributed to broader natural inquiry.',
    contributionHighlights: [
      'Compiled influential medical works.',
      'Integrated logic, observation, and clinical practice.',
      'Shaped medical education for centuries.',
    ],
    whyItMatters:
        'His synthesis of study and practical observation reflects disciplined pursuit of beneficial knowledge.',
    relatedTopics: ['Human creation', 'Physiology', 'Health'],
    visualAssetKey: 'scientist_medicine',
  ),
  const ScientistProfile(
    id: 'jabir_ibn_hayyan',
    name: 'Jabir ibn Hayyan',
    era: '8th century CE',
    discipline: 'Chemistry and Experimental Practice',
    summary:
        'Associated with early experimental approaches in chemical processes.',
    contributionHighlights: [
      'Contributed to laboratory practice and process observation.',
      'Helped structure practical experimentation approaches.',
      'Influenced later chemical inquiry traditions.',
    ],
    whyItMatters:
        'Careful experimentation shows how curiosity can become structured knowledge.',
    relatedTopics: ['Matter', 'Experiment', 'Process'],
    visualAssetKey: 'scientist_chemistry',
  ),
  const ScientistProfile(
    id: 'al_idrisi',
    name: 'Al-Idrisi',
    era: '1100–1165 CE',
    discipline: 'Cartography and Geography',
    summary:
        'Produced detailed geographic mapping informed by travel reports and synthesis.',
    contributionHighlights: [
      'Developed sophisticated medieval world maps.',
      'Synthesized field reports and comparative data.',
      'Contributed to geographic knowledge exchange.',
    ],
    whyItMatters:
        'He demonstrates the Qur’anic spirit of travel-and-observe through disciplined mapping and documentation.',
    relatedTopics: ['Travel', 'Land', 'Observation'],
    visualAssetKey: 'scientist_cartography',
  ),
];

WorldCreationLesson? worldCreationLessonById(String id) {
  for (final lesson in worldCreationLessons) {
    if (lesson.id == id) return lesson;
  }
  return null;
}

WorldCreationCategory? worldCreationCategoryById(WorldCreationCategoryId id) {
  for (final category in worldCreationCategories) {
    if (category.id == id) return category;
  }
  return null;
}

List<WorldCreationLesson> worldCreationLessonsForCategory(
  WorldCreationCategoryId categoryId,
) {
  return worldCreationLessons
      .where((item) => item.category == categoryId)
      .toList(growable: false)
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
}

List<ObservationChallenge> worldChallengesForCategory(
  WorldCreationCategoryId categoryId,
) {
  return worldObservationChallenges
      .where((item) => item.category == categoryId)
      .toList(growable: false);
}
