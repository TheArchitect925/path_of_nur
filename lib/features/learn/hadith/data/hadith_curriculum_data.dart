import '../domain/hadith_models.dart';

const hadithCurriculum = HadithCurriculum(
  themes: [
    HadithTheme(
      id: 'character-manners',
      title: 'Character & Manners',
      summary: 'Adab, self-restraint, dignity, and mercy in everyday conduct.',
      whyItMatters:
          'Character is where faith becomes visible. Prophetic teachings shape habits that protect both the heart and relationships.',
      subcategoryIds: ['char-honesty-integrity', 'char-gentleness-adab'],
      relatedThemeIds: ['speech-honesty-trust', 'gratitude-humility-self-discipline'],
      order: 1,
    ),
    HadithTheme(
      id: 'worship-intention',
      title: 'Worship & Intention',
      summary: 'Sincerity, steady worship, remembrance, and spiritual balance.',
      whyItMatters:
          'Worship loses depth when intention is neglected. These lessons anchor action in sincerity and continuity.',
      subcategoryIds: ['worship-sincerity-niyyah', 'worship-consistency-remembrance'],
      relatedThemeIds: ['gratitude-humility-self-discipline', 'hardship-patience-trials'],
      order: 2,
    ),
    HadithTheme(
      id: 'family-society',
      title: 'Family & Society',
      summary: 'Rights, care, and responsibility from home to neighborhood.',
      whyItMatters:
          'The Prophetic way builds healthy families and compassionate social order through clear rights and shared responsibility.',
      subcategoryIds: ['family-parents-kinship', 'family-marriage-home'],
      relatedThemeIds: ['mercy-compassion-service', 'community-brotherhood-responsibility'],
      order: 3,
    ),
    HadithTheme(
      id: 'speech-honesty-trust',
      title: 'Speech, Honesty & Trust',
      summary: 'Truthful words, fulfilled promises, and safe communication.',
      whyItMatters:
          'Speech can heal or harm quickly. Hadith guidance trains the tongue toward truth, restraint, and reconciliation.',
      subcategoryIds: ['speech-guarding-tongue', 'speech-promises-trust'],
      relatedThemeIds: ['character-manners', 'community-brotherhood-responsibility'],
      order: 4,
    ),
    HadithTheme(
      id: 'mercy-compassion-service',
      title: 'Mercy, Compassion & Service',
      summary: 'Concern for people, generosity, and service to those in need.',
      whyItMatters:
          'Mercy is not sentiment alone; it is practical care. This theme connects spiritual depth with social tenderness.',
      subcategoryIds: ['mercy-vulnerable-care', 'mercy-neighbor-hospitality'],
      relatedThemeIds: ['family-society', 'community-brotherhood-responsibility'],
      order: 5,
    ),
    HadithTheme(
      id: 'hardship-patience-trials',
      title: 'Hardship, Patience & Trials',
      summary: 'Endurance, emotional steadiness, and trust in difficult seasons.',
      whyItMatters:
          'Trials reveal what the heart leans on. Hadith guidance teaches patience with purpose, not passivity.',
      subcategoryIds: ['hardship-sabr-reliance', 'hardship-emotional-resilience'],
      relatedThemeIds: ['worship-intention', 'gratitude-humility-self-discipline'],
      order: 6,
    ),
    HadithTheme(
      id: 'gratitude-humility-self-discipline',
      title: 'Gratitude, Humility & Self-Discipline',
      summary: 'Inner reform through gratitude, modesty, and self-accounting.',
      whyItMatters:
          'Long-term growth requires inner discipline. This theme balances hope, humility, and responsible self-review.',
      subcategoryIds: ['gratitude-contentment', 'humility-self-accounting'],
      relatedThemeIds: ['worship-intention', 'character-manners'],
      order: 7,
    ),
    HadithTheme(
      id: 'community-brotherhood-responsibility',
      title: 'Community, Brotherhood & Responsibility',
      summary: 'Belonging, public ethics, and carrying each other with care.',
      whyItMatters:
          'Faith matures in community. Prophetic teachings strengthen trust, accountability, and communal care.',
      subcategoryIds: ['community-brotherhood-unity', 'community-justice-responsibility'],
      relatedThemeIds: ['family-society', 'speech-honesty-trust'],
      order: 8,
    ),
    HadithTheme(
      id: 'life-and-world-lessons',
      title: 'Life & World Lessons from Hadith',
      summary: 'Wisdom on time, mortality, stewardship, and observing creation.',
      whyItMatters:
          'These lessons connect daily life, mortality, and reflection on the world to sustained God-conscious living.',
      subcategoryIds: ['life-time-mortality', 'world-stewardship-observation'],
      relatedThemeIds: ['hardship-patience-trials', 'worship-intention'],
      order: 9,
    ),
  ],
  subcategories: [
    HadithSubcategory(
      id: 'char-honesty-integrity',
      themeId: 'character-manners',
      title: 'Honesty & Integrity',
      summary: 'Truthfulness in speech, intention, and hidden actions.',
      lessonIds: ['char-honesty-foundation', 'char-integrity-unseen'],
      order: 1,
    ),
    HadithSubcategory(
      id: 'char-gentleness-adab',
      themeId: 'character-manners',
      title: 'Gentleness & Adab',
      summary: 'Strength without harshness and dignified interaction.',
      lessonIds: ['char-gentleness-strength', 'char-adab-correction'],
      order: 2,
    ),
    HadithSubcategory(
      id: 'worship-sincerity-niyyah',
      themeId: 'worship-intention',
      title: 'Sincerity & Niyyah',
      summary: 'Actions are shaped by intention and inward truthfulness.',
      lessonIds: ['worship-intentions-weigh-actions', 'worship-hidden-deeds'],
      order: 1,
    ),
    HadithSubcategory(
      id: 'worship-consistency-remembrance',
      themeId: 'worship-intention',
      title: 'Consistency & Remembrance',
      summary: 'Steady worship and daily remembrance over bursts of intensity.',
      lessonIds: ['worship-consistency-small-deeds', 'worship-dhikr-heart-anchor'],
      order: 2,
    ),
    HadithSubcategory(
      id: 'family-parents-kinship',
      themeId: 'family-society',
      title: 'Parents & Kinship',
      summary: 'Honor, gratitude, and responsibility toward family ties.',
      lessonIds: ['family-honoring-parents', 'family-maintaining-kinship'],
      order: 1,
    ),
    HadithSubcategory(
      id: 'family-marriage-home',
      themeId: 'family-society',
      title: 'Marriage & Home Life',
      summary: 'Mercy, consultation, and trust within the household.',
      lessonIds: ['family-mercy-between-spouses', 'family-rights-responsibilities-home'],
      order: 2,
    ),
    HadithSubcategory(
      id: 'speech-guarding-tongue',
      themeId: 'speech-honesty-trust',
      title: 'Guarding the Tongue',
      summary: 'Speaking good, avoiding harm, and practicing restraint.',
      lessonIds: ['speech-say-good-or-silent', 'speech-avoid-backbiting-harm'],
      order: 1,
    ),
    HadithSubcategory(
      id: 'speech-promises-trust',
      themeId: 'speech-honesty-trust',
      title: 'Promises & Trustworthiness',
      summary: 'Keeping trust, fulfilling commitments, and moral reliability.',
      lessonIds: ['speech-fulfill-promises', 'speech-trust-public-private'],
      order: 2,
    ),
    HadithSubcategory(
      id: 'mercy-vulnerable-care',
      themeId: 'mercy-compassion-service',
      title: 'Care for the Vulnerable',
      summary: 'Mercy toward those in need through practical service.',
      lessonIds: ['mercy-care-for-poor', 'mercy-support-orphans-vulnerable'],
      order: 1,
    ),
    HadithSubcategory(
      id: 'mercy-neighbor-hospitality',
      themeId: 'mercy-compassion-service',
      title: 'Neighbors & Hospitality',
      summary: 'Respecting neighbors and welcoming others with generosity.',
      lessonIds: ['mercy-rights-of-neighbors', 'mercy-hospitality-generosity'],
      order: 2,
    ),
    HadithSubcategory(
      id: 'hardship-sabr-reliance',
      themeId: 'hardship-patience-trials',
      title: 'Patience & Reliance',
      summary: 'Sabr with trust, purposeful endurance, and hope.',
      lessonIds: ['hardship-sabr-with-purpose', 'hardship-tawakkul-with-effort'],
      order: 1,
    ),
    HadithSubcategory(
      id: 'hardship-emotional-resilience',
      themeId: 'hardship-patience-trials',
      title: 'Emotional Resilience',
      summary: 'Managing grief, anger, and fear with prophetic balance.',
      lessonIds: ['hardship-managing-anger', 'hardship-grief-with-hope'],
      order: 2,
    ),
    HadithSubcategory(
      id: 'gratitude-contentment',
      themeId: 'gratitude-humility-self-discipline',
      title: 'Gratitude & Contentment',
      summary: 'Thankfulness in plenty and in limitation.',
      lessonIds: ['gratitude-seeing-blessings-daily', 'gratitude-contentment-over-comparison'],
      order: 1,
    ),
    HadithSubcategory(
      id: 'humility-self-accounting',
      themeId: 'gratitude-humility-self-discipline',
      title: 'Humility & Self-Accounting',
      summary: 'Inner honesty, ego restraint, and regular self-review.',
      lessonIds: ['humility-lowering-ego', 'humility-daily-self-accounting'],
      order: 2,
    ),
    HadithSubcategory(
      id: 'community-brotherhood-unity',
      themeId: 'community-brotherhood-responsibility',
      title: 'Brotherhood & Sisterhood',
      summary: 'Mutual care, sincere advice, and solidarity.',
      lessonIds: ['community-loving-good-for-others', 'community-reconciling-hearts'],
      order: 1,
    ),
    HadithSubcategory(
      id: 'community-justice-responsibility',
      themeId: 'community-brotherhood-responsibility',
      title: 'Justice & Public Responsibility',
      summary: 'Responsible citizenship, fairness, and public trust.',
      lessonIds: ['community-justice-with-mercy', 'community-amr-bil-maruf-wisdom'],
      order: 2,
    ),
    HadithSubcategory(
      id: 'life-time-mortality',
      themeId: 'life-and-world-lessons',
      title: 'Time & Mortality',
      summary: 'Using time well and preparing for accountability.',
      lessonIds: ['life-value-of-time', 'life-remembering-death-balance'],
      order: 1,
    ),
    HadithSubcategory(
      id: 'world-stewardship-observation',
      themeId: 'life-and-world-lessons',
      title: 'Stewardship & Observation',
      summary: 'Mercy to creation and reflective engagement with the world.',
      lessonIds: ['world-kindness-to-animals', 'world-cleanliness-public-space'],
      order: 2,
    ),
  ],
  lessons: [
    HadithLesson(
      id: 'char-honesty-foundation',
      themeId: 'character-manners',
      subcategoryId: 'char-honesty-integrity',
      title: 'Truthfulness as a Foundation',
      subtitle: 'Building trust through consistent honesty',
      overview:
          'Hadith teachings consistently connect truthful speech with moral credibility. Honesty is presented as a daily discipline, not a selective habit.',
      hadithPerspective:
          'The Prophetic model treats truthfulness as a path to righteousness. It includes accuracy, fairness, and refusing convenient distortion even under pressure.',
      quranicConnection:
          'The Qur’anic ethic of being with the truthful and speaking upright words reinforces this hadith emphasis on moral clarity in speech.',
      practicalTakeaway:
          'Before speaking, verify intention and impact. Build a personal rule: no exaggeration for praise, no concealment to avoid accountability.',
      keyConcepts: ['truthful speech', 'moral consistency', 'public trust'],
      reflectionPrompt:
          'Where in your daily speech do you need more precision and honesty?',
      relatedLessonIds: ['speech-say-good-or-silent', 'speech-fulfill-promises'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic guidance repeatedly joins truthfulness with piety and reliable witness, framing honesty as covenantal responsibility.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom in earlier scriptures',
          themeSummary:
              'Biblical wisdom literature frequently presents truthful speech as life-giving and deceit as socially destructive.',
          referenceNote: 'Summary-level comparison; not a direct quotation set.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'char-integrity-unseen',
      themeId: 'character-manners',
      subcategoryId: 'char-honesty-integrity',
      title: 'Integrity When Unseen',
      subtitle: 'Private character and public reliability',
      overview:
          'Hadith learning highlights that character is most tested when no one is watching. Private choices shape public trust over time.',
      hadithPerspective:
          'The Prophetic ethic links sincerity and integrity: faithfulness to God in private protects a person from hypocrisy in public.',
      quranicConnection:
          'Qur’anic accountability themes remind believers that hidden actions are known, urging inward consistency with outward claims.',
      practicalTakeaway:
          'Create one private integrity habit this week: complete a responsibility fully even when no recognition follows.',
      keyConcepts: ['sincerity', 'consistency', 'accountability'],
      reflectionPrompt:
          'Which private habit would most improve your public trustworthiness?',
      relatedLessonIds: ['worship-hidden-deeds', 'humility-daily-self-accounting'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic reminders about hidden deeds cultivate inner vigilance and discourage performative righteousness.',
        ),
        HadithComparativeInsight(
          tradition: 'Related reflections in other traditions',
          themeSummary:
              'Jewish and Christian moral teaching often stresses integrity of heart alongside ethical action.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'char-gentleness-strength',
      themeId: 'character-manners',
      subcategoryId: 'char-gentleness-adab',
      title: 'Gentleness Is Strength',
      subtitle: 'Firmness with mercy in daily conduct',
      overview:
          'Prophetic teaching frames gentleness as moral intelligence. It does not erase boundaries, but it removes needless harshness.',
      hadithPerspective:
          'Hadith narratives describe gentleness as beautifying actions and harshness as diminishing benefit, especially in correction and leadership.',
      quranicConnection:
          'Qur’anic calls to wise and beautiful speech support a model where truth is delivered with dignity and restraint.',
      practicalTakeaway:
          'In your next disagreement, lower volume and slow pace before content. Often tone determines whether advice is received.',
      keyConcepts: ['gentleness', 'adab', 'relational wisdom'],
      reflectionPrompt:
          'How can you preserve firmness while removing harshness from your communication?',
      relatedLessonIds: ['char-adab-correction', 'speech-say-good-or-silent'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic counsel to call with wisdom and good admonition aligns with gentle, purposeful communication.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared ethical teachings',
          themeSummary:
              'Christian pastoral writings often highlight gentle correction as more transformative than aggressive rebuke.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'char-adab-correction',
      themeId: 'character-manners',
      subcategoryId: 'char-gentleness-adab',
      title: 'Adab in Giving Correction',
      subtitle: 'Protecting dignity while advising others',
      overview:
          'Hadith-informed adab stresses that advice should heal, not humiliate. Correctness of content does not justify cruelty of method.',
      hadithPerspective:
          'The Prophetic model often corrected with timing, privacy, and gentleness, preserving dignity and opening a path to change.',
      quranicConnection:
          'Qur’anic ethics around brotherhood and avoiding mockery reinforce respectful correction and sincere concern.',
      practicalTakeaway:
          'Ask permission before advice, keep it specific, and avoid public embarrassment when private counsel can work.',
      keyConcepts: ['nasiha', 'dignity', 'wise timing'],
      reflectionPrompt:
          'When you correct others, do they feel helped or shamed?',
      relatedLessonIds: ['community-reconciling-hearts', 'char-gentleness-strength'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic social ethics discourage ridicule and invite believers to reform one another with sincerity.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom in other traditions',
          themeSummary:
              'Rabbinic and Christian wisdom texts frequently emphasize rebuke that preserves the person while addressing the fault.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'worship-intentions-weigh-actions',
      themeId: 'worship-intention',
      subcategoryId: 'worship-sincerity-niyyah',
      title: 'Intentions Shape Actions',
      subtitle: 'Niyyah as the inner measure of worship',
      overview:
          'One of the most foundational hadith principles is that deeds are judged by intentions. This transforms worship from routine into devotion.',
      hadithPerspective:
          'Hadith learning teaches that outwardly similar actions can differ spiritually based on motive: showing off, habit, gratitude, or love of God.',
      quranicConnection:
          'Qur’anic calls to worship God sincerely and avoid spiritual display support this inward-centered framework.',
      practicalTakeaway:
          'Before acts of worship, pause briefly and name your intention in one sentence.',
      keyConcepts: ['niyyah', 'sincerity', 'inner state'],
      reflectionPrompt:
          'What intention do you most want to purify this week?',
      relatedLessonIds: ['worship-hidden-deeds', 'worship-consistency-small-deeds'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic language of devotion for God alone echoes the hadith stress on purified intention.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared ethical wisdom',
          themeSummary:
              'Many religious traditions distinguish outer ritual from inner devotion, warning against performative piety.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'worship-hidden-deeds',
      themeId: 'worship-intention',
      subcategoryId: 'worship-sincerity-niyyah',
      title: 'The Strength of Hidden Good Deeds',
      subtitle: 'Private worship as protection for sincerity',
      overview:
          'Hidden acts train the heart away from seeking applause. Hadith ethics elevate quiet consistency over visible performance.',
      hadithPerspective:
          'Narrations frequently commend actions done sincerely and quietly, where only God is the witness.',
      quranicConnection:
          'Qur’anic emphasis on God knowing what is hidden supports devotion that is inwardly anchored rather than socially displayed.',
      practicalTakeaway:
          'Choose one regular hidden deed, such as a private supplication or unnoticed charity.',
      keyConcepts: ['ikhlas', 'private worship', 'spiritual protection'],
      reflectionPrompt:
          'Which act can you keep between you and God this month?',
      relatedLessonIds: ['char-integrity-unseen', 'worship-intentions-weigh-actions'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic moral psychology highlights hidden virtue and cautions against spiritual vanity.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom in other traditions',
          themeSummary:
              'Classical spiritual writings across traditions often value quiet acts of devotion that purify motive.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'worship-consistency-small-deeds',
      themeId: 'worship-intention',
      subcategoryId: 'worship-consistency-remembrance',
      title: 'Consistent Small Deeds',
      subtitle: 'Sustainable worship over unsustained intensity',
      overview:
          'Hadith pedagogy favors sustainable practice. Small deeds done regularly can outlast emotional surges and build durable faith.',
      hadithPerspective:
          'Prophetic guidance repeatedly points toward regularity and moderation, protecting believers from burnout and abandonment.',
      quranicConnection:
          'Qur’anic themes of steadfastness and perseverance reinforce a long-view approach to growth.',
      practicalTakeaway:
          'Set one worship anchor you can keep daily even on difficult days.',
      keyConcepts: ['steadiness', 'moderation', 'long-term growth'],
      reflectionPrompt:
          'What small practice could you keep even during a stressful week?',
      relatedLessonIds: ['worship-dhikr-heart-anchor', 'life-value-of-time'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic calls to remain firm encourage regular, resilient practice instead of sporadic effort.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared practical wisdom',
          themeSummary:
              'Monastic and wisdom traditions often frame discipline as daily faithfulness in small commitments.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'worship-dhikr-heart-anchor',
      themeId: 'worship-intention',
      subcategoryId: 'worship-consistency-remembrance',
      title: 'Remembrance as a Heart Anchor',
      subtitle: 'Dhikr for focus, gratitude, and spiritual calm',
      overview:
          'In hadith tradition, remembrance keeps the heart awake amid distraction. It supports worship, ethics, and emotional steadiness.',
      hadithPerspective:
          'Dhikr is framed as nourishment for the soul and protection from spiritual negligence.',
      quranicConnection:
          'The Qur’an repeatedly links remembrance with tranquility, awareness, and gratitude.',
      practicalTakeaway:
          'Attach short dhikr moments to routine transitions: before commuting, after prayer, and before sleep.',
      keyConcepts: ['dhikr', 'heart awareness', 'spiritual focus'],
      reflectionPrompt:
          'Which daily moment could become your most consistent remembrance point?',
      relatedLessonIds: ['worship-consistency-small-deeds', 'gratitude-seeing-blessings-daily'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic remembrance language frames spiritual mindfulness as a source of inner stability.',
        ),
        HadithComparativeInsight(
          tradition: 'Related reflections in other traditions',
          themeSummary:
              'Sacred repetition and contemplative prayer appear in multiple traditions as disciplines of attention and humility.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'family-honoring-parents',
      themeId: 'family-society',
      subcategoryId: 'family-parents-kinship',
      title: 'Honoring Parents with Ihsan',
      subtitle: 'Respect, service, and gratitude across generations',
      overview:
          'Hadith teaching places high value on honoring parents through speech, service, and sustained patience.',
      hadithPerspective:
          'Prophetic guidance treats parental care as a major expression of faith, especially in their vulnerable years.',
      quranicConnection:
          'Qur’anic commands pair devotion to God with excellence toward parents, highlighting this duty as central.',
      practicalTakeaway:
          'Offer one consistent weekly act of care for a parent or elder family member.',
      keyConcepts: ['ihsan', 'filial responsibility', 'gratitude'],
      reflectionPrompt:
          'How can your respect for parents become more practical, not just emotional?',
      relatedLessonIds: ['family-maintaining-kinship', 'mercy-care-for-poor'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic ethics link gratitude to God with gratitude and gentleness toward parents.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared ethical wisdom',
          themeSummary:
              'Biblical teachings frequently elevate honoring father and mother as a foundational social virtue.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'family-maintaining-kinship',
      themeId: 'family-society',
      subcategoryId: 'family-parents-kinship',
      title: 'Maintaining Family Ties',
      subtitle: 'Repairing distance with wisdom and patience',
      overview:
          'Hadith literature encourages preserving kinship even when relationships are imperfect. Connection is a spiritual responsibility.',
      hadithPerspective:
          'True kinship maintenance includes initiating peace, visiting, checking in, and withholding retaliation.',
      quranicConnection:
          'Qur’anic calls to uphold ties and avoid social rupture align with this proactive family ethic.',
      practicalTakeaway:
          'Reach out to one relative you have postponed contacting and begin with a simple, respectful message.',
      keyConcepts: ['silat al-rahim', 'reconciliation', 'patience'],
      reflectionPrompt:
          'Which family tie needs healing, and what is one low-conflict first step?',
      relatedLessonIds: ['community-reconciling-hearts', 'family-honoring-parents'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic social teachings favor maintaining bonds and restraining ego-driven separation.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared moral echoes',
          themeSummary:
              'Wisdom traditions often describe family reconciliation as difficult but morally elevating work.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'family-mercy-between-spouses',
      themeId: 'family-society',
      subcategoryId: 'family-marriage-home',
      title: 'Mercy Between Spouses',
      subtitle: 'Companionship rooted in kindness and respect',
      overview:
          'Hadith guidance on marriage emphasizes mercy, mutual respect, and responsibility rather than dominance and rivalry.',
      hadithPerspective:
          'Prophetic conduct in the home models service, listening, and gentle correction over harsh authority.',
      quranicConnection:
          'Qur’anic marital language of tranquility, affection, and mercy supports this balanced household ethic.',
      practicalTakeaway:
          'Practice one daily mercy habit at home: appreciative speech, attentive listening, or practical help.',
      keyConcepts: ['mercy', 'companionship', 'mutual rights'],
      reflectionPrompt:
          'What home behavior of yours most needs to reflect mercy?',
      relatedLessonIds: ['family-rights-responsibilities-home', 'char-gentleness-strength'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic family values frame marriage as a covenant of calm, mercy, and balanced rights.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom teachings',
          themeSummary:
              'Many traditions describe family health as requiring kindness in speech, patience, and service.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'family-rights-responsibilities-home',
      themeId: 'family-society',
      subcategoryId: 'family-marriage-home',
      title: 'Rights and Responsibilities at Home',
      subtitle: 'Justice, consultation, and reliability in family life',
      overview:
          'Hadith-based family ethics combine compassion with fairness. Love is strengthened when rights are honored.',
      hadithPerspective:
          'The Prophetic method includes fulfilling duties, avoiding oppression, and using consultation in household decisions.',
      quranicConnection:
          'Qur’anic justice principles apply first in close relationships where imbalance can be hidden.',
      practicalTakeaway:
          'List three recurring home responsibilities and define who owns each one clearly.',
      keyConcepts: ['justice', 'consultation', 'duty fulfillment'],
      reflectionPrompt:
          'Where does your household need clearer expectations to reduce conflict?',
      relatedLessonIds: ['speech-fulfill-promises', 'family-mercy-between-spouses'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic emphasis on justice and trust applies to domestic roles and obligations.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared ethical teachings',
          themeSummary:
              'Family ethics in many faith traditions tie love to responsibility, reliability, and fairness.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'speech-say-good-or-silent',
      themeId: 'speech-honesty-trust',
      subcategoryId: 'speech-guarding-tongue',
      title: 'Speak Good or Remain Silent',
      subtitle: 'A discipline for safer speech',
      overview:
          'This famous hadith principle reframes speech as moral action. Silence can be worship when words would harm.',
      hadithPerspective:
          'The Prophetic approach prioritizes beneficial speech: truthful, necessary, and respectful.',
      quranicConnection:
          'Qur’anic guidance to speak upright words aligns with filtering speech through benefit and accountability.',
      practicalTakeaway:
          'Use a three-part check before speaking: Is it true? Is it needed? Is it kind?',
      keyConcepts: ['speech discipline', 'restraint', 'benefit'],
      reflectionPrompt:
          'Which conversation pattern in your life most needs this principle?',
      relatedLessonIds: ['speech-avoid-backbiting-harm', 'char-honesty-foundation'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic speech ethics connect moral language to social healing and accountability.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom in Proverbs-like literature',
          themeSummary:
              'Wisdom traditions frequently contrast disciplined speech with destructive, impulsive talk.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'speech-avoid-backbiting-harm',
      themeId: 'speech-honesty-trust',
      subcategoryId: 'speech-guarding-tongue',
      title: 'Avoiding Backbiting and Harmful Talk',
      subtitle: 'Protecting honor in absent conversation',
      overview:
          'Hadith ethics warn against verbal harm done behind people’s backs. Community trust weakens when honor is violated.',
      hadithPerspective:
          'Protecting people’s dignity is part of faith. Entertainment through others’ faults is spiritually corrosive.',
      quranicConnection:
          'Qur’anic prohibition of backbiting and mockery supports the hadith call to guard others’ honor.',
      practicalTakeaway:
          'When a conversation turns toward ridicule, redirect to facts, compassion, or silence.',
      keyConcepts: ['honor protection', 'gheebah awareness', 'social trust'],
      reflectionPrompt:
          'How do you usually respond when harmful talk begins in your circle?',
      relatedLessonIds: ['community-reconciling-hearts', 'speech-say-good-or-silent'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic social ethics consistently protect dignity and forbid humiliating language.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared ethical teachings',
          themeSummary:
              'Many traditions classify slander and gossip as serious community-damaging sins.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'speech-fulfill-promises',
      themeId: 'speech-honesty-trust',
      subcategoryId: 'speech-promises-trust',
      title: 'Fulfilling Promises',
      subtitle: 'Reliability as a spiritual trait',
      overview:
          'Hadith instruction ties faithfulness in promises to moral credibility. Unkept commitments erode trust.',
      hadithPerspective:
          'Promises are not casual words; they create rights. Responsible believers either fulfill them or communicate honestly about limits.',
      quranicConnection:
          'Qur’anic covenant language underscores that commitments are accountable before God.',
      practicalTakeaway:
          'Reduce overpromising. Commit to fewer things, then deliver with excellence.',
      keyConcepts: ['amanah', 'reliability', 'covenant ethics'],
      reflectionPrompt:
          'Which open promise in your life needs immediate attention?',
      relatedLessonIds: ['speech-trust-public-private', 'family-rights-responsibilities-home'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic commands to honor covenants frame promise-keeping as a spiritual duty.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared moral wisdom',
          themeSummary:
              'Biblical and rabbinic ethics also emphasize truthful vows and faithful commitments.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'speech-trust-public-private',
      themeId: 'speech-honesty-trust',
      subcategoryId: 'speech-promises-trust',
      title: 'Trust in Public and Private',
      subtitle: 'Consistency across visible and hidden roles',
      overview:
          'Trustworthiness is tested in both public tasks and private confidences. Hadith ethics reject selective integrity.',
      hadithPerspective:
          'A trustworthy believer keeps confidences, returns rights, and acts fairly regardless of audience.',
      quranicConnection:
          'Qur’anic trust language extends to property, speech, and judgment, calling for consistency in all settings.',
      practicalTakeaway:
          'Audit one trust domain today: money, information, time, or relationships.',
      keyConcepts: ['trust', 'consistency', 'moral reliability'],
      reflectionPrompt:
          'Where do you need stronger private discipline to match your public values?',
      relatedLessonIds: ['char-integrity-unseen', 'speech-fulfill-promises'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic guidance repeatedly commands believers to render trusts faithfully.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared ethical teachings',
          themeSummary:
              'Across Abrahamic traditions, trustworthiness is a recurring mark of righteous character.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'mercy-care-for-poor',
      themeId: 'mercy-compassion-service',
      subcategoryId: 'mercy-vulnerable-care',
      title: 'Care for the Poor with Dignity',
      subtitle: 'Service that protects honor, not just need',
      overview:
          'Hadith teachings encourage generosity with humility and respect. Aid should relieve hardship without humiliating recipients.',
      hadithPerspective:
          'Compassion includes practical support, gentle speech, and seeing vulnerable people as bearers of dignity.',
      quranicConnection:
          'Qur’anic commands on charity and justice align with serving others while preserving their honor.',
      practicalTakeaway:
          'Choose one recurring service act: food support, discreet giving, or advocacy for someone under strain.',
      keyConcepts: ['rahmah', 'dignity-centered service', 'charity ethics'],
      reflectionPrompt:
          'How can your charity become more relational and less transactional?',
      relatedLessonIds: ['mercy-support-orphans-vulnerable', 'mercy-hospitality-generosity'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic ethics repeatedly pair worship with care for the poor and socially vulnerable.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared moral wisdom',
          themeSummary:
              'Scriptural traditions broadly affirm almsgiving, justice, and compassion for those in need.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'mercy-support-orphans-vulnerable',
      themeId: 'mercy-compassion-service',
      subcategoryId: 'mercy-vulnerable-care',
      title: 'Supporting Orphans and the Vulnerable',
      subtitle: 'Protective care as a measure of mercy',
      overview:
          'Prophetic teachings place special emphasis on those without social protection, including orphans and isolated individuals.',
      hadithPerspective:
          'Care is measured by sustained presence, advocacy, and protection from exploitation, not one-time gestures.',
      quranicConnection:
          'Qur’anic concern for orphans and vulnerable people reflects a justice-oriented spirituality.',
      practicalTakeaway:
          'Support one local channel serving vulnerable families, and pair giving with regular personal check-ins where possible.',
      keyConcepts: ['vulnerability', 'advocacy', 'protective mercy'],
      reflectionPrompt:
          'Who in your wider circle lacks support, and what safe help can you offer?',
      relatedLessonIds: ['community-justice-with-mercy', 'mercy-care-for-poor'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic social law repeatedly safeguards orphan rights and condemns their mistreatment.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared ethical teachings',
          themeSummary:
              'Jewish and Christian moral traditions also prioritize care for widows, orphans, and the marginalized.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'mercy-rights-of-neighbors',
      themeId: 'mercy-compassion-service',
      subcategoryId: 'mercy-neighbor-hospitality',
      title: 'Rights of Neighbors',
      subtitle: 'Living faith through local care',
      overview:
          'Hadith guidance gives neighbors a high ethical status. Faithful living includes making one’s presence safe and beneficial.',
      hadithPerspective:
          'Neighborly duty includes avoiding harm, sharing resources, checking in, and honoring boundaries.',
      quranicConnection:
          'Qur’anic social ethics include kindness to near and far neighbors as part of righteous conduct.',
      practicalTakeaway:
          'Practice one monthly neighbor ritual: greeting, checking in, or offering practical help.',
      keyConcepts: ['neighbor rights', 'local responsibility', 'social trust'],
      reflectionPrompt:
          'If your neighbors described your presence, would they describe safety and care?',
      relatedLessonIds: ['mercy-hospitality-generosity', 'community-loving-good-for-others'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic commands on neighbor kindness support concrete social responsibility close to home.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom traditions',
          themeSummary:
              'Biblical ethics often frame love of neighbor as central to moral life.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'mercy-hospitality-generosity',
      themeId: 'mercy-compassion-service',
      subcategoryId: 'mercy-neighbor-hospitality',
      title: 'Hospitality and Generosity',
      subtitle: 'Welcoming others with dignity and ease',
      overview:
          'Hadith teachings encourage honoring guests and sharing resources without extravagance or showing off.',
      hadithPerspective:
          'Hospitality is a practical form of mercy that builds belonging and eases social loneliness.',
      quranicConnection:
          'Qur’anic narratives and ethics around generosity reinforce service that is humble and purposeful.',
      practicalTakeaway:
          'Plan one simple hospitality act this week: tea, a meal, or assistance offered with sincere welcome.',
      keyConcepts: ['hospitality', 'generosity', 'belonging'],
      reflectionPrompt:
          'How can your home or schedule become more hospitable without becoming overwhelmed?',
      relatedLessonIds: ['mercy-rights-of-neighbors', 'family-mercy-between-spouses'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic encouragement toward giving and kindness aligns with generous hospitality.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared moral echoes',
          themeSummary:
              'Hospitality is a long-standing virtue in Abrahamic moral narratives and communal life.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'hardship-sabr-with-purpose',
      themeId: 'hardship-patience-trials',
      subcategoryId: 'hardship-sabr-reliance',
      title: 'Patience with Purpose',
      subtitle: 'Endurance that remains active and ethical',
      overview:
          'Hadith teachings on patience do not call for passivity. They call for principled endurance while pursuing lawful solutions.',
      hadithPerspective:
          'Sabr includes restraint from harmful reactions, steady worship, and moral clarity during pressure.',
      quranicConnection:
          'Qur’anic patience is linked to prayer, trust, and moral steadfastness, not resignation.',
      practicalTakeaway:
          'Define one hardship response plan: what to avoid, what worship anchor to keep, and who to consult.',
      keyConcepts: ['sabr', 'steadfastness', 'ethical restraint'],
      reflectionPrompt:
          'During stress, what reaction most needs replacing with sabr?',
      relatedLessonIds: ['hardship-tawakkul-with-effort', 'worship-consistency-small-deeds'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic patterns pair patience with active trust and sustained obedience.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom teachings',
          themeSummary:
              'Many sacred traditions frame endurance as moral perseverance, not emotional numbness.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'hardship-tawakkul-with-effort',
      themeId: 'hardship-patience-trials',
      subcategoryId: 'hardship-sabr-reliance',
      title: 'Reliance with Effort',
      subtitle: 'Trusting God while taking responsible means',
      overview:
          'Hadith guidance balances tawakkul and action. Trust in God is strengthened, not replaced, by responsible effort.',
      hadithPerspective:
          'Believers are taught to plan, seek help, and act ethically, then entrust outcomes to God.',
      quranicConnection:
          'Qur’anic trust language often appears alongside struggle, planning, and consultation.',
      practicalTakeaway:
          'For one concern, write two columns: “my responsible effort” and “what I release to God.”',
      keyConcepts: ['tawakkul', 'responsible means', 'emotional balance'],
      reflectionPrompt:
          'Are you leaning toward anxious control or passive waiting, and what is a balanced middle?',
      relatedLessonIds: ['hardship-sabr-with-purpose', 'life-value-of-time'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic narratives often model trust paired with preparation and disciplined action.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared moral wisdom',
          themeSummary:
              'Classical wisdom literature commonly joins trust in God with diligent labor and prudence.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'hardship-managing-anger',
      themeId: 'hardship-patience-trials',
      subcategoryId: 'hardship-emotional-resilience',
      title: 'Managing Anger with Discipline',
      subtitle: 'Power is measured by self-control',
      overview:
          'Hadith instruction recasts strength as the ability to control oneself in anger, not overpower others.',
      hadithPerspective:
          'Prophetic guidance offers practical steps: pause, change posture, seek refuge in God, and avoid harmful speech.',
      quranicConnection:
          'Qur’anic praise for those who restrain anger and pardon others supports this disciplined response.',
      practicalTakeaway:
          'Prepare a personal anger protocol before conflict starts.',
      keyConcepts: ['anger regulation', 'self-mastery', 'restraint'],
      reflectionPrompt:
          'What early sign tells you anger is rising, and what is your first safer response?',
      relatedLessonIds: ['char-gentleness-strength', 'hardship-grief-with-hope'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic ethics esteem anger restraint and forgiveness as marks of mature faith.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom writings',
          themeSummary:
              'Proverbs-style traditions regularly warn against impulsive anger and praise patient restraint.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'hardship-grief-with-hope',
      themeId: 'hardship-patience-trials',
      subcategoryId: 'hardship-emotional-resilience',
      title: 'Grief with Hope',
      subtitle: 'Sorrow without despair',
      overview:
          'Hadith guidance allows grief while steering believers away from hopelessness and destructive reactions.',
      hadithPerspective:
          'The Prophetic model acknowledges tears and pain, yet maintains dignity, prayer, and trust in divine wisdom.',
      quranicConnection:
          'Qur’anic stories of prophets in sorrow show emotional honesty joined with enduring hope.',
      practicalTakeaway:
          'Name your grief before God in du’a, then pair it with one small action that restores function and connection.',
      keyConcepts: ['hope', 'emotional honesty', 'spiritual resilience'],
      reflectionPrompt:
          'What would hopeful patience look like in your current sorrow?',
      relatedLessonIds: ['hardship-sabr-with-purpose', 'life-remembering-death-balance'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic narratives normalize grief while directing hearts toward hope and trust.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared spiritual insights',
          themeSummary:
              'Many scriptural traditions hold lament and hope together as part of faithful endurance.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'gratitude-seeing-blessings-daily',
      themeId: 'gratitude-humility-self-discipline',
      subcategoryId: 'gratitude-contentment',
      title: 'Seeing Blessings Daily',
      subtitle: 'Training the heart toward gratitude',
      overview:
          'Hadith learning encourages active gratitude for ordinary mercies, not only extraordinary events.',
      hadithPerspective:
          'Thankfulness appears in speech, worship, and service. Gratitude is described as a protector against spiritual hardness.',
      quranicConnection:
          'Qur’anic teaching repeatedly links gratitude with increase in awareness, barakah, and stability.',
      practicalTakeaway:
          'End each day with three specific blessings and one response action.',
      keyConcepts: ['shukr', 'awareness', 'spiritual contentment'],
      reflectionPrompt:
          'Which recurring gift in your life have you stopped noticing?',
      relatedLessonIds: ['gratitude-contentment-over-comparison', 'worship-dhikr-heart-anchor'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic remembrance of blessings cultivates humility and responsible use of gifts.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom traditions',
          themeSummary:
              'Psalms and related devotional texts often center gratitude as a path to renewed faith.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'gratitude-contentment-over-comparison',
      themeId: 'gratitude-humility-self-discipline',
      subcategoryId: 'gratitude-contentment',
      title: 'Contentment Over Comparison',
      subtitle: 'Protecting the heart from envy',
      overview:
          'Hadith wisdom cautions against constant comparison, which fuels envy and ingratitude.',
      hadithPerspective:
          'Contentment is not stagnation; it is emotional balance that allows ethical striving without resentment.',
      quranicConnection:
          'Qur’anic ethics discourage envy and invite believers to seek God’s bounty through lawful effort and gratitude.',
      practicalTakeaway:
          'Limit one comparison trigger and replace it with a gratitude action.',
      keyConcepts: ['contentment', 'envy awareness', 'healthy aspiration'],
      reflectionPrompt:
          'What comparison habit is quietly draining your gratitude?',
      relatedLessonIds: ['humility-lowering-ego', 'gratitude-seeing-blessings-daily'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic teachings on envy and gratitude orient believers toward ethical aspiration over rivalry.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared moral wisdom',
          themeSummary:
              'Wisdom literature across traditions often warns that envy corrodes peace and relationships.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'humility-lowering-ego',
      themeId: 'gratitude-humility-self-discipline',
      subcategoryId: 'humility-self-accounting',
      title: 'Lowering the Ego',
      subtitle: 'Humility as protection from spiritual arrogance',
      overview:
          'Hadith ethics repeatedly caution against arrogance and self-exaltation. Humility keeps the heart teachable.',
      hadithPerspective:
          'True humility appears in how we treat others, accept correction, and avoid superiority narratives.',
      quranicConnection:
          'Qur’anic condemnation of arrogance and praise for humble servants supports this core discipline.',
      practicalTakeaway:
          'Practice one humility action: listen without interrupting, apologize quickly, or serve quietly.',
      keyConcepts: ['humility', 'ego restraint', 'teachability'],
      reflectionPrompt:
          'Where does subtle pride show up in your daily interactions?',
      relatedLessonIds: ['humility-daily-self-accounting', 'char-adab-correction'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic portraits of humility center dependence on God and gentleness toward people.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom traditions',
          themeSummary:
              'Classical religious ethics broadly treat humility as a gateway to wisdom.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'humility-daily-self-accounting',
      themeId: 'gratitude-humility-self-discipline',
      subcategoryId: 'humility-self-accounting',
      title: 'Daily Self-Accounting',
      subtitle: 'Reviewing actions before they harden into habit',
      overview:
          'Hadith-centered spirituality encourages regular muhasabah: evaluating one’s speech, duties, and intentions.',
      hadithPerspective:
          'Self-accounting is proactive repentance. It catches patterns early and restores sincerity before damage spreads.',
      quranicConnection:
          'Qur’anic accountability themes support frequent moral review and turning back to God.',
      practicalTakeaway:
          'End each day with a two-column review: what to continue and what to repair tomorrow.',
      keyConcepts: ['muhasabah', 'repentance', 'growth discipline'],
      reflectionPrompt:
          'Which repeated behavior needs structured daily review?',
      relatedLessonIds: ['char-integrity-unseen', 'humility-lowering-ego'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic remembrance of accountability encourages conscious daily moral evaluation.',
        ),
        HadithComparativeInsight(
          tradition: 'Related spiritual writings',
          themeSummary:
              'Many devotional traditions practice evening examen or self-review as a discipline of reform.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'community-loving-good-for-others',
      themeId: 'community-brotherhood-responsibility',
      subcategoryId: 'community-brotherhood-unity',
      title: 'Loving Good for Others',
      subtitle: 'From self-centeredness to sincere concern',
      overview:
          'Hadith teaching elevates sincere goodwill for others as a mark of complete faith.',
      hadithPerspective:
          'Faith-based community grows when believers genuinely want benefit for each other, not only personal advancement.',
      quranicConnection:
          'Qur’anic brotherhood ethics support mutual care, fairness, and collective uplift.',
      practicalTakeaway:
          'Make one intentional du’a and one practical action for someone else’s success today.',
      keyConcepts: ['brotherhood/sisterhood', 'sincere concern', 'collective wellbeing'],
      reflectionPrompt:
          'Whose success is difficult for you to celebrate sincerely, and why?',
      relatedLessonIds: ['community-reconciling-hearts', 'mercy-rights-of-neighbors'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic community language repeatedly emphasizes mutual support and cooperative righteousness.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared ethical teachings',
          themeSummary:
              'The “love your neighbor” ethic in other traditions reflects related social generosity.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'community-reconciling-hearts',
      themeId: 'community-brotherhood-responsibility',
      subcategoryId: 'community-brotherhood-unity',
      title: 'Reconciling Hearts',
      subtitle: 'Repairing fractures before they spread',
      overview:
          'Hadith guidance places high value on peacemaking and restoring relationships within the community.',
      hadithPerspective:
          'Reconciliation requires humility, fair listening, and prioritizing long-term unity over short-term ego victory.',
      quranicConnection:
          'Qur’anic calls to reconcile believers and make peace with justice reinforce this duty.',
      practicalTakeaway:
          'Identify one strained relationship and initiate a respectful, low-intensity step toward repair.',
      keyConcepts: ['reconciliation', 'unity', 'conflict de-escalation'],
      reflectionPrompt:
          'What personal pride is blocking reconciliation in your life?',
      relatedLessonIds: ['char-adab-correction', 'speech-avoid-backbiting-harm'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic justice-and-peace framework supports reconciliation that does not ignore fairness.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom traditions',
          themeSummary:
              'Religious ethical literature often treats peacemaking as a high moral duty.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'community-justice-with-mercy',
      themeId: 'community-brotherhood-responsibility',
      subcategoryId: 'community-justice-responsibility',
      title: 'Justice with Mercy',
      subtitle: 'Fairness that protects dignity',
      overview:
          'Hadith ethics encourage fairness without cruelty and mercy without negligence. Both are needed in public life.',
      hadithPerspective:
          'Justice includes giving rights, avoiding bias, and protecting vulnerable people from misuse of power.',
      quranicConnection:
          'Qur’anic justice commands prohibit oppression and demand principled fairness, even when difficult.',
      practicalTakeaway:
          'In a disagreement, separate facts from emotions before deciding your stance.',
      keyConcepts: ['justice', 'mercy', 'ethical responsibility'],
      reflectionPrompt:
          'Where do you need more fairness, and where do you need more mercy?',
      relatedLessonIds: ['community-amr-bil-maruf-wisdom', 'mercy-support-orphans-vulnerable'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic ethics place justice at the center of moral witness and social order.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared moral wisdom',
          themeSummary:
              'Biblical prophetic tradition likewise condemns oppression and elevates justice with compassion.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'community-amr-bil-maruf-wisdom',
      themeId: 'community-brotherhood-responsibility',
      subcategoryId: 'community-justice-responsibility',
      title: 'Encouraging Good with Wisdom',
      subtitle: 'Responsible moral concern in community life',
      overview:
          'Hadith-informed responsibility includes promoting good and discouraging harm with wisdom, humility, and context awareness.',
      hadithPerspective:
          'Moral counsel is effective when sincere, informed, and proportional; it should not become self-righteous policing.',
      quranicConnection:
          'Qur’anic guidance on inviting to good is paired with wisdom, patience, and moral integrity.',
      practicalTakeaway:
          'When advising, start with relationship, clarify intent, and choose timing that preserves dignity.',
      keyConcepts: ['moral responsibility', 'wisdom', 'proportional counsel'],
      reflectionPrompt:
          'How can you move from reactive criticism to wise, constructive advice?',
      relatedLessonIds: ['char-adab-correction', 'community-justice-with-mercy'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic invitation to good emphasizes wisdom and patience over confrontation for its own sake.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared ethical teachings',
          themeSummary:
              'Other traditions similarly stress corrective counsel that is humble and restorative.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'life-value-of-time',
      themeId: 'life-and-world-lessons',
      subcategoryId: 'life-time-mortality',
      title: 'The Value of Time',
      subtitle: 'Life as trust, not endless extension',
      overview:
          'Hadith teachings urge believers to value health and free time before they pass, treating life as an entrusted opportunity.',
      hadithPerspective:
          'Time is described as a resource tied to accountability; procrastination in good deeds is spiritually risky.',
      quranicConnection:
          'Qur’anic oaths by time and reminders of accountability reinforce urgency with balance.',
      practicalTakeaway:
          'Protect one daily block for meaningful worship, study, or service before low-value scrolling.',
      keyConcepts: ['time stewardship', 'accountability', 'prioritization'],
      reflectionPrompt:
          'Where is your best energy going, and does that match your values?',
      relatedLessonIds: ['worship-consistency-small-deeds', 'life-remembering-death-balance'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic emphasis on fleeting worldly time encourages purposeful, ethical living.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared wisdom literature',
          themeSummary:
              'Wisdom texts across traditions caution against wasting life and urge meaningful stewardship of days.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'life-remembering-death-balance',
      themeId: 'life-and-world-lessons',
      subcategoryId: 'life-time-mortality',
      title: 'Remembering Death with Balance',
      subtitle: 'Awareness that clarifies priorities',
      overview:
          'Hadith teachings on mortality are meant to awaken responsibility, soften the heart, and reduce attachment to ego.',
      hadithPerspective:
          'Remembering death is not meant to produce despair, but moral clarity and sincere repentance.',
      quranicConnection:
          'Qur’anic reminders of return to God support ethical urgency and hopeful accountability.',
      practicalTakeaway:
          'Ask in major decisions: if this were my final year, would this still be a priority?',
      keyConcepts: ['mortality awareness', 'priority clarity', 'repentance'],
      reflectionPrompt:
          'What would you simplify if you lived with healthier awareness of life’s limits?',
      relatedLessonIds: ['hardship-grief-with-hope', 'humility-daily-self-accounting'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic return-to-God themes frame mortality as a call to accountability and mercy-seeking.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared contemplative traditions',
          themeSummary:
              'Many wisdom traditions use mortality reflection to promote humility and purposeful action.',
        ),
      ],
      order: 2,
    ),
    HadithLesson(
      id: 'world-kindness-to-animals',
      themeId: 'life-and-world-lessons',
      subcategoryId: 'world-stewardship-observation',
      title: 'Kindness to Animals',
      subtitle: 'Mercy extends beyond human circles',
      overview:
          'Hadith narratives include strong moral reminders about compassion toward animals and accountability for harm.',
      hadithPerspective:
          'Care for animals is framed as a spiritual responsibility, showing that mercy should shape treatment of all living beings.',
      quranicConnection:
          'Qur’anic descriptions of creatures as communities support a respectful stewardship ethic.',
      practicalTakeaway:
          'Treat animals and natural spaces with deliberate care: avoid harm, provide water, and reduce neglect.',
      keyConcepts: ['stewardship', 'mercy to creation', 'ethical care'],
      reflectionPrompt:
          'How does your daily lifestyle affect animals directly or indirectly?',
      relatedLessonIds: ['world-cleanliness-public-space', 'mercy-care-for-poor'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic creation themes call humans to responsibility, not domination without accountability.',
        ),
        HadithComparativeInsight(
          tradition: 'Related wisdom in other traditions',
          themeSummary:
              'Jewish and Christian ethical streams also contain teachings on humane treatment of animals and stewardship.',
        ),
      ],
      order: 1,
    ),
    HadithLesson(
      id: 'world-cleanliness-public-space',
      themeId: 'life-and-world-lessons',
      subcategoryId: 'world-stewardship-observation',
      title: 'Cleanliness and Public Space',
      subtitle: 'Faith-informed care for shared environments',
      overview:
          'Hadith teaching links cleanliness to faith and includes removing harm from pathways as a virtuous act.',
      hadithPerspective:
          'Public ethics include caring for shared spaces, reducing nuisance, and making environments safer for others.',
      quranicConnection:
          'Qur’anic anti-corruption ethics can be applied to environmental and civic responsibility in daily life.',
      practicalTakeaway:
          'Adopt one local stewardship habit: clean-up walks, waste reduction, or maintaining shared space manners.',
      keyConcepts: ['cleanliness', 'public responsibility', 'environmental adab'],
      reflectionPrompt:
          'What change in your public habits would most benefit your neighborhood?',
      relatedLessonIds: ['mercy-rights-of-neighbors', 'world-kindness-to-animals'],
      comparativeInsights: [
        HadithComparativeInsight(
          tradition: 'Related Qur’anic themes',
          themeSummary:
              'Qur’anic warnings against فساد (corruption/harm) support responsibility for shared social and natural spaces.',
        ),
        HadithComparativeInsight(
          tradition: 'Shared moral wisdom',
          themeSummary:
              'Many faith traditions frame care for common space as service to both people and God.',
        ),
      ],
      order: 2,
    ),
  ],
  suggestedThemeOrder: [
    'character-manners',
    'worship-intention',
    'family-society',
    'speech-honesty-trust',
    'mercy-compassion-service',
    'hardship-patience-trials',
    'gratitude-humility-self-discipline',
    'community-brotherhood-responsibility',
    'life-and-world-lessons',
  ],
  featuredLessonId: 'worship-intentions-weigh-actions',
);

HadithTheme? hadithThemeById(String id) {
  for (final theme in hadithCurriculum.themes) {
    if (theme.id == id) return theme;
  }
  return null;
}

HadithSubcategory? hadithSubcategoryById(String id) {
  for (final subcategory in hadithCurriculum.subcategories) {
    if (subcategory.id == id) return subcategory;
  }
  return null;
}

HadithLesson? hadithLessonById(String id) {
  for (final lesson in hadithCurriculum.lessons) {
    if (lesson.id == id) return lesson;
  }
  return null;
}

List<HadithTheme> hadithThemesInSuggestedOrder() {
  return hadithCurriculum.suggestedThemeOrder
      .map(hadithThemeById)
      .whereType<HadithTheme>()
      .toList();
}

List<HadithSubcategory> hadithSubcategoriesForTheme(String themeId) {
  final items = hadithCurriculum.subcategories
      .where((sub) => sub.themeId == themeId)
      .toList();
  items.sort((a, b) => a.order.compareTo(b.order));
  return items;
}

List<HadithLesson> hadithLessonsForSubcategory(String subcategoryId) {
  final items = hadithCurriculum.lessons
      .where((lesson) => lesson.subcategoryId == subcategoryId)
      .toList();
  items.sort((a, b) => a.order.compareTo(b.order));
  return items;
}
