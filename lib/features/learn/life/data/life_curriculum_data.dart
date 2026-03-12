import '../domain/life_models.dart';

const lifeCurriculum = LifeCurriculum(
  themes: _themes,
  subcategories: _subcategories,
  lessons: _lessons,
  suggestedThemeOrder: [
    'family',
    'character',
    'gratitude-reflection',
    'work-time-discipline',
    'community-relationships',
    'wealth-responsibility',
    'justice-moral-conduct',
    'mercy-forgiveness-compassion',
    'hardship-patience',
    'loss-death-remembrance',
  ],
  featuredLessonId: 'family-parents-honor-care',
);

const _themes = <LifeTheme>[
  LifeTheme(
    id: 'family',
    title: 'Family',
    summary: 'Home, kinship, trust, and everyday care.',
    whyItMatters:
        'Family is where values become daily habits. Qur’anic guidance on mercy, rights, and responsibility is first practiced at home.',
    subcategoryIds: ['family-parents', 'family-marriage'],
    relatedThemeIds: ['character', 'community-relationships'],
    order: 1,
  ),
  LifeTheme(
    id: 'character',
    title: 'Character',
    summary: 'Intention, honesty, humility, and self-discipline.',
    whyItMatters:
        'Character is the bridge between belief and behavior. The Qur’an repeatedly links sincerity with trustworthy conduct.',
    subcategoryIds: ['character-intention', 'character-speech-conduct'],
    relatedThemeIds: ['family', 'justice-moral-conduct'],
    order: 2,
  ),
  LifeTheme(
    id: 'wealth-responsibility',
    title: 'Wealth & Responsibility',
    summary: 'Earning, spending, generosity, and accountability.',
    whyItMatters:
        'Material resources are described as trust and test. The goal is lawful provision with service, fairness, and restraint.',
    subcategoryIds: ['wealth-earning-spending', 'wealth-generosity-trust'],
    relatedThemeIds: ['justice-moral-conduct', 'community-relationships'],
    order: 6,
  ),
  LifeTheme(
    id: 'hardship-patience',
    title: 'Hardship & Patience',
    summary: 'Sabr, resilience, and hope under pressure.',
    whyItMatters:
        'Trials are part of life. Qur’anic framing of patience is active, hopeful, and tied to ethical action.',
    subcategoryIds: ['hardship-inner-resilience', 'hardship-prayer-trust'],
    relatedThemeIds: ['loss-death-remembrance', 'gratitude-reflection'],
    order: 9,
  ),
  LifeTheme(
    id: 'community-relationships',
    title: 'Community & Relationships',
    summary: 'Neighborly ethics, friendship, and social trust.',
    whyItMatters:
        'Belief is social as well as personal. Communities strengthen when speech, promises, and differences are handled with adab.',
    subcategoryIds: ['community-friendship-neighbors', 'community-disagreement-promises'],
    relatedThemeIds: ['justice-moral-conduct', 'mercy-forgiveness-compassion'],
    order: 5,
  ),
  LifeTheme(
    id: 'work-time-discipline',
    title: 'Work, Time & Discipline',
    summary: 'Steady effort, order, and stewardship of time.',
    whyItMatters:
        'Spiritual growth needs rhythms. Qur’anic emphasis on accountability and balance supports productive, ethical routines.',
    subcategoryIds: ['work-intention-excellence', 'time-routine-balance'],
    relatedThemeIds: ['character', 'gratitude-reflection'],
    order: 4,
  ),
  LifeTheme(
    id: 'gratitude-reflection',
    title: 'Gratitude & Reflection',
    summary: 'Awareness of blessings and daily muhasabah.',
    whyItMatters:
        'Gratitude protects the heart from entitlement. Reflection turns events into lessons and keeps intention alive.',
    subcategoryIds: ['gratitude-blessings-contentment', 'reflection-self-accountability'],
    relatedThemeIds: ['character', 'hardship-patience'],
    order: 3,
  ),
  LifeTheme(
    id: 'justice-moral-conduct',
    title: 'Justice & Moral Conduct',
    summary: 'Fairness, truthfulness, and moral courage.',
    whyItMatters:
        'The Qur’an binds justice to worship. Moral conduct requires fairness even when it is costly or socially difficult.',
    subcategoryIds: ['justice-fairness-truth', 'justice-power-responsibility'],
    relatedThemeIds: ['wealth-responsibility', 'community-relationships'],
    order: 7,
  ),
  LifeTheme(
    id: 'mercy-forgiveness-compassion',
    title: 'Mercy, Forgiveness & Compassion',
    summary: 'Rahmah in conflict, weakness, and service.',
    whyItMatters:
        'Mercy softens justice without erasing responsibility. Forgiveness heals hearts and keeps community life from hardening.',
    subcategoryIds: ['mercy-interpersonal', 'forgiveness-reconciliation'],
    relatedThemeIds: ['family', 'community-relationships'],
    order: 8,
  ),
  LifeTheme(
    id: 'loss-death-remembrance',
    title: 'Loss, Death & Remembrance',
    summary: 'Grief, mortality, and preparing the heart.',
    whyItMatters:
        'Remembering mortality gives clarity to priorities. The Qur’anic lens encourages sabr, dua, and meaningful action after loss.',
    subcategoryIds: ['loss-grief-support', 'death-accountability-legacy'],
    relatedThemeIds: ['hardship-patience', 'gratitude-reflection'],
    order: 10,
  ),
];

const _subcategories = <LifeSubcategory>[
  LifeSubcategory(
    id: 'family-parents',
    themeId: 'family',
    title: 'Parents, Elders & Family Care',
    summary: 'Respect, service, and wise disagreement.',
    lessonIds: [
      'family-parents-honor-care',
      'family-parents-respectful-disagreement',
    ],
    order: 1,
  ),
  LifeSubcategory(
    id: 'family-marriage',
    themeId: 'family',
    title: 'Marriage, Children & Household Mercy',
    summary: 'Companionship, responsibility, and emotional safety.',
    lessonIds: [
      'family-marriage-mercy',
      'family-children-tarbiyah',
    ],
    order: 2,
  ),
  LifeSubcategory(
    id: 'character-intention',
    themeId: 'character',
    title: 'Intention, Integrity & Inner Work',
    summary: 'Niyyah and consistency between private and public life.',
    lessonIds: [
      'character-intention-sincerity',
      'character-integrity-consistency',
    ],
    order: 1,
  ),
  LifeSubcategory(
    id: 'character-speech-conduct',
    themeId: 'character',
    title: 'Speech, Modesty & Self-Discipline',
    summary: 'How words and habits shape spiritual maturity.',
    lessonIds: [
      'character-speech-truth-gentleness',
      'character-modesty-self-control',
    ],
    order: 2,
  ),
  LifeSubcategory(
    id: 'wealth-earning-spending',
    themeId: 'wealth-responsibility',
    title: 'Lawful Earning & Responsible Spending',
    summary: 'Ethical income, moderation, and priorities.',
    lessonIds: [
      'wealth-halal-earning',
      'wealth-spending-balance',
    ],
    order: 1,
  ),
  LifeSubcategory(
    id: 'wealth-generosity-trust',
    themeId: 'wealth-responsibility',
    title: 'Generosity, Trust & Accountability',
    summary: 'From charity to amanah in financial dealings.',
    lessonIds: [
      'wealth-generosity-ihsan',
      'wealth-trust-accountability',
    ],
    order: 2,
  ),
  LifeSubcategory(
    id: 'hardship-inner-resilience',
    themeId: 'hardship-patience',
    title: 'Inner Resilience in Trials',
    summary: 'Emotional steadiness and disciplined response.',
    lessonIds: [
      'hardship-sabr-active',
      'hardship-hope-resilience',
    ],
    order: 1,
  ),
  LifeSubcategory(
    id: 'hardship-prayer-trust',
    themeId: 'hardship-patience',
    title: 'Prayer, Dua & Trust in الله',
    summary: 'Turning pain into worship and action.',
    lessonIds: [
      'hardship-prayer-anchor',
      'hardship-tawakkul-action',
    ],
    order: 2,
  ),
  LifeSubcategory(
    id: 'community-friendship-neighbors',
    themeId: 'community-relationships',
    title: 'Friendship, Neighbors & Belonging',
    summary: 'Daily ethics of belonging and care.',
    lessonIds: [
      'community-friendship-character',
      'community-neighbor-rights',
    ],
    order: 1,
  ),
  LifeSubcategory(
    id: 'community-disagreement-promises',
    themeId: 'community-relationships',
    title: 'Promises, Conflict & Respectful Difference',
    summary: 'Trustworthy communication in disagreement.',
    lessonIds: [
      'community-keeping-promises',
      'community-respectful-disagreement',
    ],
    order: 2,
  ),
  LifeSubcategory(
    id: 'work-intention-excellence',
    themeId: 'work-time-discipline',
    title: 'Work Ethic, Intention & Excellence',
    summary: 'Productive work grounded in sincerity.',
    lessonIds: [
      'work-intention-service',
      'work-excellence-amanah',
    ],
    order: 1,
  ),
  LifeSubcategory(
    id: 'time-routine-balance',
    themeId: 'work-time-discipline',
    title: 'Time Stewardship & Balanced Routine',
    summary: 'Protecting priorities and avoiding drift.',
    lessonIds: [
      'time-priority-management',
      'time-rest-worship-balance',
    ],
    order: 2,
  ),
  LifeSubcategory(
    id: 'gratitude-blessings-contentment',
    themeId: 'gratitude-reflection',
    title: 'Gratitude, Blessings & Contentment',
    summary: 'Seeing blessings clearly and responding well.',
    lessonIds: [
      'gratitude-daily-awareness',
      'gratitude-contentment-vs-envy',
    ],
    order: 1,
  ),
  LifeSubcategory(
    id: 'reflection-self-accountability',
    themeId: 'gratitude-reflection',
    title: 'Reflection & Self-Accountability',
    summary: 'Muhasabah and course-correction habits.',
    lessonIds: [
      'reflection-evening-review',
      'reflection-repentance-renewal',
    ],
    order: 2,
  ),
  LifeSubcategory(
    id: 'justice-fairness-truth',
    themeId: 'justice-moral-conduct',
    title: 'Fairness, Truth & Moral Clarity',
    summary: 'Justice in speech, testimony, and decisions.',
    lessonIds: [
      'justice-truthful-testimony',
      'justice-fairness-with-opponents',
    ],
    order: 1,
  ),
  LifeSubcategory(
    id: 'justice-power-responsibility',
    themeId: 'justice-moral-conduct',
    title: 'Power, Leadership & Accountability',
    summary: 'Ethical use of influence and authority.',
    lessonIds: [
      'justice-leadership-trust',
      'justice-accountability-transparency',
    ],
    order: 2,
  ),
  LifeSubcategory(
    id: 'mercy-interpersonal',
    themeId: 'mercy-forgiveness-compassion',
    title: 'Mercy in Everyday Relationships',
    summary: 'Kindness under stress and emotional restraint.',
    lessonIds: [
      'mercy-softening-speech',
      'mercy-serving-vulnerable',
    ],
    order: 1,
  ),
  LifeSubcategory(
    id: 'forgiveness-reconciliation',
    themeId: 'mercy-forgiveness-compassion',
    title: 'Forgiveness & Reconciliation',
    summary: 'Repairing trust while keeping boundaries.',
    lessonIds: [
      'forgiveness-releasing-resentment',
      'forgiveness-reconciliation-steps',
    ],
    order: 2,
  ),
  LifeSubcategory(
    id: 'loss-grief-support',
    themeId: 'loss-death-remembrance',
    title: 'Grief, Support & Patience',
    summary: 'Facing loss with truth, prayer, and care.',
    lessonIds: [
      'loss-grief-with-faith',
      'loss-supporting-others',
    ],
    order: 1,
  ),
  LifeSubcategory(
    id: 'death-accountability-legacy',
    themeId: 'loss-death-remembrance',
    title: 'Mortality, Accountability & Legacy',
    summary: 'Living with akhirah-awareness and purpose.',
    lessonIds: [
      'death-remembering-accountability',
      'death-legacy-good-deeds',
    ],
    order: 2,
  ),
];

const _lessons = <LifeLesson>[
  LifeLesson(
    id: 'family-parents-honor-care',
    themeId: 'family',
    subcategoryId: 'family-parents',
    title: 'Honoring Parents Through Service',
    subtitle: 'Respect is shown in action, not only words.',
    overview:
        'This lesson focuses on daily service, gentle tone, and practical support for parents and elders.',
    quranicPerspective:
        'Qur’anic ethics pair worship of الله with excellence toward parents. The emphasis is gratitude, respectful speech, and care over time.',
    practicalTakeaway:
        'Schedule one weekly act of service, one check-in call, and one dua habit for your parents or elders.',
    keyConcepts: ['gratitude', 'service', 'respectful speech'],
    reflectionPrompt:
        'What one recurring act of care can you sustain even during busy weeks?',
    relatedLessonIds: ['family-parents-respectful-disagreement', 'mercy-serving-vulnerable'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Hebrew Bible / Wisdom tradition',
        themeSummary:
            'Family honor and care for elders are presented as covenantal responsibilities, not optional courtesy.',
        referenceNote: 'Theme overlap summary',
      ),
      LifeComparativeInsight(
        tradition: 'New Testament ethics',
        themeSummary:
            'Filial respect is linked with moral maturity and social stability in household teachings.',
        referenceNote: 'Theme overlap summary',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'family-parents-respectful-disagreement',
    themeId: 'family',
    subcategoryId: 'family-parents',
    title: 'Respectful Disagreement With Parents',
    subtitle: 'Truth with adab and calm boundaries.',
    overview:
        'This lesson addresses conflict without disrespect, especially when values or life choices differ.',
    quranicPerspective:
        'Qur’anic guidance models firmness in faith with gentle companionship, avoiding cruelty or humiliation.',
    practicalTakeaway:
        'Use calm phrasing, reduce reactive language, and return to shared values before difficult topics.',
    keyConcepts: ['adab', 'firmness with gentleness', 'boundaries'],
    reflectionPrompt:
        'How can you protect both principle and relationship in one difficult conversation?',
    relatedLessonIds: ['character-speech-truth-gentleness', 'community-respectful-disagreement'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Biblical wisdom literature',
        themeSummary:
            'Gentle answers and restraint in speech are repeatedly tied to preserving relationships during conflict.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'family-marriage-mercy',
    themeId: 'family',
    subcategoryId: 'family-marriage',
    title: 'Mercy and Emotional Safety in Marriage',
    subtitle: 'Companionship grows through everyday gentleness.',
    overview:
        'A practical framework for reducing emotional harm and increasing trust between spouses.',
    quranicPerspective:
        'Marriage is framed around tranquility, affection, and mercy. Rights and responsibilities are meant to protect dignity.',
    practicalTakeaway:
        'Adopt a weekly repair ritual: apology, appreciation, and one concrete improvement commitment.',
    keyConcepts: ['tranquility', 'mercy', 'trust repair'],
    reflectionPrompt: 'What habit most improves emotional safety in your home?',
    relatedLessonIds: ['character-intention-sincerity', 'forgiveness-reconciliation-steps'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'New Testament household ethics',
        themeSummary:
            'Mutual care, sacrificial concern, and covenant faithfulness are central themes in marital instruction.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'family-children-tarbiyah',
    themeId: 'family',
    subcategoryId: 'family-marriage',
    title: 'Raising Children With Tarbiyah',
    subtitle: 'Teaching by example before instruction.',
    overview:
        'Children learn most from the emotional climate and routine practices they observe.',
    quranicPerspective:
        'Qur’anic narratives highlight parental counsel, prayer for children, and moral formation through wisdom.',
    practicalTakeaway:
        'Choose one shared household worship/values routine and sustain it consistently.',
    keyConcepts: ['example', 'consistency', 'gentle correction'],
    reflectionPrompt:
        'Which home routine currently teaches your values most clearly?',
    relatedLessonIds: ['gratitude-daily-awareness', 'work-time-priority-management'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Torah/Deuteronomic family teaching tradition',
        themeSummary:
            'Intergenerational teaching is woven into daily life rhythms, not reserved for occasional events.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'character-intention-sincerity',
    themeId: 'character',
    subcategoryId: 'character-intention',
    title: 'Intention and Sincerity',
    subtitle: 'Why begins before what.',
    overview:
        'This lesson helps users audit motives and reconnect actions to sincere worship.',
    quranicPerspective:
        'Qur’anic ethics prioritizes inner truthfulness; outward acts lose value when driven by showing off or ego.',
    practicalTakeaway:
        'Before major actions, pause for a 10-second intention reset and name your purpose.',
    keyConcepts: ['niyyah', 'ikhlas', 'motive audit'],
    reflectionPrompt:
        'Which recurring action needs an intention reset this week?',
    relatedLessonIds: ['character-integrity-consistency', 'work-intention-service'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Sermon-on-the-Mount moral teaching tradition',
        themeSummary:
            'Hidden intention is emphasized over public performance in devotion and charity.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'character-integrity-consistency',
    themeId: 'character',
    subcategoryId: 'character-intention',
    title: 'Integrity in Private and Public',
    subtitle: 'Consistency builds trust with الله and people.',
    overview:
        'Integrity means aligning private choices with stated values and promises.',
    quranicPerspective:
        'Believers are called to honesty and covenant faithfulness; hypocrisy is repeatedly warned against.',
    practicalTakeaway:
        'Track one integrity metric for seven days: promises kept, deadlines met, or truthfulness in speech.',
    keyConcepts: ['truthfulness', 'promise-keeping', 'self-accountability'],
    reflectionPrompt: 'Where is your private behavior drifting from your public values?',
    relatedLessonIds: ['community-keeping-promises', 'justice-truthful-testimony'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Proverbs / wisdom ethics',
        themeSummary:
            'Integrity and upright conduct are linked with long-term trust and social reliability.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'character-speech-truth-gentleness',
    themeId: 'character',
    subcategoryId: 'character-speech-conduct',
    title: 'Truthful and Gentle Speech',
    subtitle: 'Clarity without harshness.',
    overview:
        'This lesson addresses tone, timing, and truth in difficult conversations.',
    quranicPerspective:
        'Qur’anic guidance repeatedly joins truthful speech with wise, dignified expression.',
    practicalTakeaway:
        'Use the pause-rule: verify facts, remove insults, and reduce volume before responding.',
    keyConcepts: ['truth', 'gentleness', 'restraint'],
    reflectionPrompt:
        'Which conversation this week needs truthful but softer wording?',
    relatedLessonIds: ['community-respectful-disagreement', 'forgiveness-releasing-resentment'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Biblical wisdom sayings',
        themeSummary:
            'Gentle answers and guarded speech are treated as protective tools for relationships.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'character-modesty-self-control',
    themeId: 'character',
    subcategoryId: 'character-speech-conduct',
    title: 'Modesty and Self-Control',
    subtitle: 'Dignity through disciplined choices.',
    overview:
        'Modesty includes behavior, attention, and digital habits, not clothing alone.',
    quranicPerspective:
        'Qur’anic morality links modesty and restraint to heart protection and social dignity.',
    practicalTakeaway:
        'Choose one boundary for the next week: screen hygiene, gaze discipline, or reaction control.',
    keyConcepts: ['haya', 'restraint', 'discipline'],
    reflectionPrompt:
        'Which boundary would most protect your heart right now?',
    relatedLessonIds: ['time-priority-management', 'hardship-sabr-active'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Monastic and wisdom traditions',
        themeSummary:
            'Disciplined habits and guardrails are often presented as pathways to inner clarity.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'wealth-halal-earning',
    themeId: 'wealth-responsibility',
    subcategoryId: 'wealth-earning-spending',
    title: 'Lawful Earning and Ethical Work',
    subtitle: 'Income with integrity.',
    overview:
        'Explores ethical earning, avoiding exploitation, and aligning career choices with conscience.',
    quranicPerspective:
        'Provision is from الله, but people are accountable for how they seek and earn it.',
    practicalTakeaway:
        'Audit your income stream for fairness, honesty, and harm reduction.',
    keyConcepts: ['halal earning', 'fair dealing', 'accountability'],
    reflectionPrompt: 'Which part of your work life most needs ethical refinement?',
    relatedLessonIds: ['work-excellence-amanah', 'justice-accountability-transparency'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Hebrew prophetic ethics',
        themeSummary:
            'Economic fairness and honest scales are recurring themes in justice-focused teachings.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'wealth-spending-balance',
    themeId: 'wealth-responsibility',
    subcategoryId: 'wealth-earning-spending',
    title: 'Balanced Spending',
    subtitle: 'Neither wastefulness nor miserliness.',
    overview:
        'Practical spending decisions that preserve dignity, family needs, and charitable intent.',
    quranicPerspective:
        'Qur’anic spending ethics emphasizes moderation, responsibility, and avoiding arrogance in consumption.',
    practicalTakeaway:
        'Use a simple three-part budget: essentials, future needs, and giving.',
    keyConcepts: ['moderation', 'budgeting', 'priority clarity'],
    reflectionPrompt: 'Where does your spending drift away from your values?',
    relatedLessonIds: ['gratitude-contentment-vs-envy', 'wealth-generosity-ihsan'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Wisdom literature (Proverbs tradition)',
        themeSummary:
            'Prudence, foresight, and restraint are portrayed as core to stable living.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'wealth-generosity-ihsan',
    themeId: 'wealth-responsibility',
    subcategoryId: 'wealth-generosity-trust',
    title: 'Generosity as Ihsan',
    subtitle: 'Giving that protects dignity.',
    overview:
        'Moves beyond occasional charity into consistent, dignified support of others.',
    quranicPerspective:
        'Charity is tied to purification, solidarity, and trust in الله’s replacement of what is spent for good.',
    practicalTakeaway:
        'Set a recurring giving habit and include non-monetary service.',
    keyConcepts: ['charity', 'dignity', 'consistency'],
    reflectionPrompt:
        'How can your giving become regular rather than reactive?',
    relatedLessonIds: ['community-neighbor-rights', 'mercy-serving-vulnerable'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'New Testament mercy teachings',
        themeSummary:
            'Care for the poor and vulnerable is framed as central moral responsibility.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'wealth-trust-accountability',
    themeId: 'wealth-responsibility',
    subcategoryId: 'wealth-generosity-trust',
    title: 'Financial Trust and Accountability',
    subtitle: 'Amanah in contracts and stewardship.',
    overview:
        'Financial promises, debts, and entrusted resources require transparent handling.',
    quranicPerspective:
        'Qur’anic legal ethics promotes clear agreements, documented obligations, and fairness in exchange.',
    practicalTakeaway:
        'Write down commitments, deadlines, and repayment plans to prevent injustice.',
    keyConcepts: ['amanah', 'contracts', 'transparency'],
    reflectionPrompt: 'What financial promise should you clarify this week?',
    relatedLessonIds: ['community-keeping-promises', 'justice-truthful-testimony'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Torah legal tradition',
        themeSummary:
            'Covenantal responsibility includes clear obligations and protection of the vulnerable in economic matters.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'hardship-sabr-active',
    themeId: 'hardship-patience',
    subcategoryId: 'hardship-inner-resilience',
    title: 'Active Patience (Sabr)',
    subtitle: 'Steadiness with effort, not passivity.',
    overview:
        'Sabr is shown through disciplined choices under stress, not emotional denial.',
    quranicPerspective:
        'Qur’anic patience includes restraint, perseverance, and continued obedience during hardship.',
    practicalTakeaway:
        'When stressed, use a three-step response: pause, pray, and choose one constructive action.',
    keyConcepts: ['sabr', 'restraint', 'constructive action'],
    reflectionPrompt: 'What does active patience look like in your current trial?',
    relatedLessonIds: ['hardship-hope-resilience', 'loss-grief-with-faith'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Epistles / endurance themes',
        themeSummary:
            'Endurance under trial is linked to character formation and mature hope.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'hardship-hope-resilience',
    themeId: 'hardship-patience',
    subcategoryId: 'hardship-inner-resilience',
    title: 'Hope and Emotional Resilience',
    subtitle: 'Hope as a discipline, not mood.',
    overview:
        'Builds routines that prevent despair and preserve direction during prolonged difficulty.',
    quranicPerspective:
        'Qur’anic hope is grounded in divine mercy while still requiring effort, repentance, and repair.',
    practicalTakeaway:
        'Keep a weekly hope log: one answered dua, one lesson learned, one next step.',
    keyConcepts: ['hope', 'resilience', 'meaning-making'],
    reflectionPrompt: 'Which sign of mercy have you overlooked this month?',
    relatedLessonIds: ['gratitude-daily-awareness', 'reflection-repentance-renewal'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Psalms lament tradition',
        themeSummary:
            'Honest grief is often coupled with remembered trust and renewed hope.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'hardship-prayer-anchor',
    themeId: 'hardship-patience',
    subcategoryId: 'hardship-prayer-trust',
    title: 'Prayer as an Anchor in Hardship',
    subtitle: 'Returning to salah under pressure.',
    overview:
        'Focuses on keeping prayer stable when life feels unstable.',
    quranicPerspective:
        'Prayer is repeatedly presented as support in difficulty, strengthening orientation and restraint.',
    practicalTakeaway:
        'Protect the first and last prayer windows of your day as non-negotiable anchors.',
    keyConcepts: ['salah anchor', 'focus', 'discipline'],
    reflectionPrompt: 'Which prayer is currently hardest to guard, and why?',
    relatedLessonIds: ['time-priority-management', 'hardship-tawakkul-action'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Monastic and liturgical traditions',
        themeSummary:
            'Fixed prayer rhythms are widely used to stabilize life under uncertainty.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'hardship-tawakkul-action',
    themeId: 'hardship-patience',
    subcategoryId: 'hardship-prayer-trust',
    title: 'Tawakkul With Action',
    subtitle: 'Trusting الله while taking means.',
    overview:
        'Clarifies the difference between trust and avoidance of responsibility.',
    quranicPerspective:
        'Qur’anic reliance includes planning, effort, and surrendering results to الله.',
    practicalTakeaway:
        'For each major worry, write one dua and one practical step.',
    keyConcepts: ['tawakkul', 'effort', 'surrender of outcomes'],
    reflectionPrompt: 'Where do you need more action, and where do you need more surrender?',
    relatedLessonIds: ['work-intention-service', 'reflection-evening-review'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Wisdom and epistle traditions',
        themeSummary:
            'Faith and responsible effort are frequently paired rather than separated.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'community-friendship-character',
    themeId: 'community-relationships',
    subcategoryId: 'community-friendship-neighbors',
    title: 'Friendship and Character Influence',
    subtitle: 'Companionship shapes direction.',
    overview:
        'Evaluates how close relationships affect values, habits, and emotional tone.',
    quranicPerspective:
        'Qur’anic guidance values righteous companionship and warns against harmful influence.',
    practicalTakeaway:
        'Map your closest influences and set one boundary with a harmful pattern.',
    keyConcepts: ['companionship', 'influence', 'boundaries'],
    reflectionPrompt: 'Which friendship most helps your growth, and why?',
    relatedLessonIds: ['community-neighbor-rights', 'character-integrity-consistency'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Proverbs friendship wisdom',
        themeSummary:
            'Companions are repeatedly portrayed as shaping moral trajectory.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'community-neighbor-rights',
    themeId: 'community-relationships',
    subcategoryId: 'community-friendship-neighbors',
    title: 'Neighbor Rights and Everyday Care',
    subtitle: 'Faith seen in nearby relationships.',
    overview:
        'Teaches practical neighbor ethics: courtesy, help, discretion, and reliability.',
    quranicPerspective:
        'Qur’anic social ethics includes family, neighbors, and wayfarers as circles of responsibility.',
    practicalTakeaway:
        'Practice one neighborly act weekly: check-in, assistance, or respectful protection of space.',
    keyConcepts: ['proximity ethics', 'reliability', 'service'],
    reflectionPrompt: 'How can your immediate surroundings feel safer because of you?',
    relatedLessonIds: ['wealth-generosity-ihsan', 'mercy-serving-vulnerable'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Gospel moral tradition',
        themeSummary:
            'Love of neighbor is treated as a core moral axis of faithful living.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'community-keeping-promises',
    themeId: 'community-relationships',
    subcategoryId: 'community-disagreement-promises',
    title: 'Keeping Promises and Covenants',
    subtitle: 'Trust is built by follow-through.',
    overview:
        'Promises in family, work, and community are moral commitments, not convenience tools.',
    quranicPerspective:
        'Believers are commanded to fulfill covenants and avoid betrayal in commitments.',
    practicalTakeaway:
        'Reduce over-promising; commit to fewer items and complete them reliably.',
    keyConcepts: ['covenant', 'trustworthiness', 'reliability'],
    reflectionPrompt: 'Which unfulfilled promise needs immediate repair?',
    relatedLessonIds: ['wealth-trust-accountability', 'justice-accountability-transparency'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Torah covenantal ethics',
        themeSummary:
            'Faithfulness to commitments is presented as a social and spiritual duty.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'community-respectful-disagreement',
    themeId: 'community-relationships',
    subcategoryId: 'community-disagreement-promises',
    title: 'Respectful Disagreement',
    subtitle: 'Difference without contempt.',
    overview:
        'Builds skills for discussing difficult issues while preserving dignity and truthfulness.',
    quranicPerspective:
        'Qur’anic discourse ethics emphasizes wisdom, good counsel, and restraint from mockery.',
    practicalTakeaway:
        'Use a disagreement template: clarify intent, state concern, propose next step.',
    keyConcepts: ['adab in difference', 'listening', 'clarity'],
    reflectionPrompt: 'When do you confuse winning an argument with serving truth?',
    relatedLessonIds: ['character-speech-truth-gentleness', 'justice-fairness-with-opponents'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Pauline community ethics',
        themeSummary:
            'Communal correction is linked to humility, patience, and preserving unity.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'work-intention-service',
    themeId: 'work-time-discipline',
    subcategoryId: 'work-intention-excellence',
    title: 'Work as Service and Amanah',
    subtitle: 'Purposeful work with ethical intent.',
    overview:
        'Transforms routine work into meaningful service by clarifying intention and benefit.',
    quranicPerspective:
        'Qur’anic worldview treats effort as accountable stewardship, not ego-driven self-display.',
    practicalTakeaway:
        'Define one service outcome your work should create for others each week.',
    keyConcepts: ['service', 'amanah', 'purposeful labor'],
    reflectionPrompt: 'Who benefits from your work when done with ihsan?',
    relatedLessonIds: ['wealth-halal-earning', 'hardship-tawakkul-action'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Wisdom and vocation traditions',
        themeSummary:
            'Diligent work and service-oriented labor are often framed as moral calling.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'work-excellence-amanah',
    themeId: 'work-time-discipline',
    subcategoryId: 'work-intention-excellence',
    title: 'Excellence Without Perfectionism',
    subtitle: 'Reliable quality with healthy limits.',
    overview:
        'Encourages ihsan and quality while avoiding burnout and ego-driven overreach.',
    quranicPerspective:
        'Excellence is tied to sincerity and accountability, not showmanship or unhealthy self-worth.',
    practicalTakeaway:
        'Set a quality standard, deadline, and rest boundary for key weekly tasks.',
    keyConcepts: ['ihsan', 'quality', 'balance'],
    reflectionPrompt: 'Where has perfectionism reduced your sincerity or consistency?',
    relatedLessonIds: ['time-rest-worship-balance', 'character-intention-sincerity'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Monastic craft and discipline traditions',
        themeSummary:
            'Faithful, consistent craftsmanship is valued over sporadic intensity.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'time-priority-management',
    themeId: 'work-time-discipline',
    subcategoryId: 'time-routine-balance',
    title: 'Priority-Based Time Management',
    subtitle: 'Guard what matters first.',
    overview:
        'Teaches users to align calendars with values instead of reacting to urgency alone.',
    quranicPerspective:
        'Time is a trust; accountability includes how moments are invested and what is repeatedly neglected.',
    practicalTakeaway:
        'Plan day blocks around prayers, responsibilities, learning, and rest.',
    keyConcepts: ['priorities', 'planning', 'stewardship'],
    reflectionPrompt: 'Which priority is consistently pushed out by low-value urgency?',
    relatedLessonIds: ['hardship-prayer-anchor', 'reflection-evening-review'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Wisdom tradition on diligence',
        themeSummary:
            'Intentional planning and disciplined effort are contrasted with drift and negligence.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'time-rest-worship-balance',
    themeId: 'work-time-discipline',
    subcategoryId: 'time-routine-balance',
    title: 'Rest, Worship, and Sustainable Rhythm',
    subtitle: 'Consistency through balanced routines.',
    overview:
        'Focuses on recovery, sleep, and sustainable devotion for long-term consistency.',
    quranicPerspective:
        'Human life is patterned with cycles; healthy rhythm supports obedience, reflection, and service.',
    practicalTakeaway:
        'Create an evening wind-down routine that protects Fajr readiness.',
    keyConcepts: ['rhythm', 'rest', 'consistency'],
    reflectionPrompt: 'What one evening habit most harms your next day worship?',
    relatedLessonIds: ['work-excellence-amanah', 'hardship-hope-resilience'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Sabbath/rest traditions',
        themeSummary:
            'Sacred rhythm and rest are used to re-order life around worship and meaning.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'gratitude-daily-awareness',
    themeId: 'gratitude-reflection',
    subcategoryId: 'gratitude-blessings-contentment',
    title: 'Daily Gratitude Awareness',
    subtitle: 'Naming blessings protects the heart.',
    overview:
        'Shifts gratitude from emotion to daily practice using structured noticing.',
    quranicPerspective:
        'Qur’anic gratitude links recognition of blessings to obedience and humility.',
    practicalTakeaway:
        'Record three blessings daily and pair each with one action of thanks.',
    keyConcepts: ['shukr', 'awareness', 'action'],
    reflectionPrompt: 'Which blessing do you use often but thank for rarely?',
    relatedLessonIds: ['gratitude-contentment-vs-envy', 'reflection-evening-review'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Psalms and thanksgiving traditions',
        themeSummary:
            'Gratitude is practiced through regular remembrance, not occasional mood.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'gratitude-contentment-vs-envy',
    themeId: 'gratitude-reflection',
    subcategoryId: 'gratitude-blessings-contentment',
    title: 'Contentment Versus Envy',
    subtitle: 'Freedom from comparison-driven anxiety.',
    overview:
        'Examines how envy distorts priorities and weakens gratitude-based living.',
    quranicPerspective:
        'Qur’anic guidance directs believers away from coveting and toward trust, effort, and gratitude.',
    practicalTakeaway:
        'Limit comparison triggers and replace them with service-oriented goals.',
    keyConcepts: ['contentment', 'envy control', 'trust'],
    reflectionPrompt: 'Which comparison habit most drains your peace?',
    relatedLessonIds: ['wealth-spending-balance', 'character-intention-sincerity'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Wisdom literature on envy',
        themeSummary:
            'Envy is often depicted as corrosive to inner peace and relationships.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'reflection-evening-review',
    themeId: 'gratitude-reflection',
    subcategoryId: 'reflection-self-accountability',
    title: 'Evening Self-Review (Muhasabah)',
    subtitle: 'Small daily audits prevent major drift.',
    overview:
        'A structured nightly review model for intention, conduct, and repair.',
    quranicPerspective:
        'Qur’anic accountability framing encourages conscious self-examination before reckoning in the hereafter.',
    practicalTakeaway:
        'Ask nightly: What did I do well, where did I fail, what is my next correction?',
    keyConcepts: ['muhasabah', 'course correction', 'consistency'],
    reflectionPrompt: 'What pattern keeps repeating because it is never reviewed?',
    relatedLessonIds: ['reflection-repentance-renewal', 'time-priority-management'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Examen-like devotional review traditions',
        themeSummary:
            'Daily review and gratitude checks are used to realign intention and behavior.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'reflection-repentance-renewal',
    themeId: 'gratitude-reflection',
    subcategoryId: 'reflection-self-accountability',
    title: 'Repentance and Renewal',
    subtitle: 'Turning mistakes into transformation.',
    overview:
        'Repentance is framed as honest return, repair, and renewed discipline.',
    quranicPerspective:
        'Qur’anic repentance includes regret, stopping harm, seeking forgiveness, and making amends where possible.',
    practicalTakeaway:
        'For one recurring mistake, write a repentance plan with triggers and alternatives.',
    keyConcepts: ['tawbah', 'repair', 'renewal'],
    reflectionPrompt: 'What concrete repair step proves your repentance is real?',
    relatedLessonIds: ['hardship-hope-resilience', 'forgiveness-releasing-resentment'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Prophetic repentance motifs in Abrahamic traditions',
        themeSummary:
            'Return to God is repeatedly portrayed as possible through humility and reform.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'justice-truthful-testimony',
    themeId: 'justice-moral-conduct',
    subcategoryId: 'justice-fairness-truth',
    title: 'Truthful Testimony and Fair Judgment',
    subtitle: 'Justice begins with honest witness.',
    overview:
        'Addresses truthfulness in reporting, mediation, and informal judgment.',
    quranicPerspective:
        'Qur’anic justice commands truthful testimony even when personally uncomfortable.',
    practicalTakeaway:
        'Avoid rumor-based judgments; confirm facts before endorsing claims.',
    keyConcepts: ['testimony', 'truth', 'due process'],
    reflectionPrompt: 'Where are you tempted to accept narrative over verified truth?',
    relatedLessonIds: ['community-respectful-disagreement', 'justice-fairness-with-opponents'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Torah legal ethics',
        themeSummary:
            'False witness is treated as socially destructive and morally serious.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'justice-fairness-with-opponents',
    themeId: 'justice-moral-conduct',
    subcategoryId: 'justice-fairness-truth',
    title: 'Fairness With Opponents',
    subtitle: 'Principle over group bias.',
    overview:
        'Explores justice beyond tribal loyalty, including restraint in conflict situations.',
    quranicPerspective:
        'Qur’anic morality warns against letting hostility push believers into injustice.',
    practicalTakeaway:
        'Before judgments, ask: would I apply the same standard to my own side?',
    keyConcepts: ['impartiality', 'moral courage', 'bias control'],
    reflectionPrompt: 'Which bias most distorts your fairness?',
    relatedLessonIds: ['character-speech-truth-gentleness', 'community-keeping-promises'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Prophetic justice traditions',
        themeSummary:
            'Justice is often framed as binding even against one’s own preferences or faction.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'justice-leadership-trust',
    themeId: 'justice-moral-conduct',
    subcategoryId: 'justice-power-responsibility',
    title: 'Leadership as Trust',
    subtitle: 'Authority is service, not entitlement.',
    overview:
        'A leadership ethic focused on accountability, consultation, and protection of the vulnerable.',
    quranicPerspective:
        'Qur’anic governance ethics emphasizes trust, consultation, and upright dealings.',
    practicalTakeaway:
        'If you lead any team, publish expectations and feedback channels clearly.',
    keyConcepts: ['amanah', 'shura', 'service leadership'],
    reflectionPrompt: 'How does your influence currently affect weaker people in your circle?',
    relatedLessonIds: ['justice-accountability-transparency', 'wealth-trust-accountability'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Biblical shepherd-leadership motifs',
        themeSummary:
            'Leaders are judged by how they protect and serve rather than dominate.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'justice-accountability-transparency',
    themeId: 'justice-moral-conduct',
    subcategoryId: 'justice-power-responsibility',
    title: 'Accountability and Transparency',
    subtitle: 'Power needs visible checks.',
    overview:
        'Discusses practical checks against abuse in family, work, and community authority.',
    quranicPerspective:
        'Qur’anic responsibility language implies answerability for decisions, rights, and entrusted resources.',
    practicalTakeaway:
        'Create traceable decision logs for responsibilities that affect other people.',
    keyConcepts: ['accountability', 'transparency', 'rights protection'],
    reflectionPrompt: 'What decision process in your role currently lacks healthy oversight?',
    relatedLessonIds: ['community-keeping-promises', 'wealth-trust-accountability'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Wisdom and prophetic critique traditions',
        themeSummary:
            'Corruption warnings repeatedly focus on hidden injustice and unaccountable power.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'mercy-softening-speech',
    themeId: 'mercy-forgiveness-compassion',
    subcategoryId: 'mercy-interpersonal',
    title: 'Mercy Through Softened Speech',
    subtitle: 'Words can wound or heal.',
    overview:
        'Shows how mercy appears first in tone, choice of words, and restraint during tension.',
    quranicPerspective:
        'Qur’anic ethics links noble speech to heart-consciousness and social peace.',
    practicalTakeaway:
        'Replace one recurring harsh phrase with a calmer alternative this week.',
    keyConcepts: ['rahmah', 'tone discipline', 'de-escalation'],
    reflectionPrompt: 'Which relationship would change most if your tone softened?',
    relatedLessonIds: ['character-speech-truth-gentleness', 'forgiveness-releasing-resentment'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Proverbs speech wisdom',
        themeSummary:
            'Mild speech is frequently linked to calming conflict and preserving dignity.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'mercy-serving-vulnerable',
    themeId: 'mercy-forgiveness-compassion',
    subcategoryId: 'mercy-interpersonal',
    title: 'Serving the Vulnerable',
    subtitle: 'Compassion measured by care.',
    overview:
        'Mercy is operationalized through service to those with limited power or support.',
    quranicPerspective:
        'Qur’anic social responsibility repeatedly highlights care for vulnerable groups and dignified support.',
    practicalTakeaway:
        'Choose one local service action and commit to a monthly cadence.',
    keyConcepts: ['compassion', 'service', 'dignity'],
    reflectionPrompt: 'Who in your circle is overlooked but most needs consistent support?',
    relatedLessonIds: ['community-neighbor-rights', 'wealth-generosity-ihsan'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Gospel mercy traditions',
        themeSummary:
            'Care for the poor, sick, and marginalized is treated as core moral fidelity.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'forgiveness-releasing-resentment',
    themeId: 'mercy-forgiveness-compassion',
    subcategoryId: 'forgiveness-reconciliation',
    title: 'Releasing Resentment',
    subtitle: 'Forgiveness as inner freedom.',
    overview:
        'Addresses anger loops and how forgiveness can coexist with healthy boundaries.',
    quranicPerspective:
        'Qur’anic virtue ethics praises pardon while still affirming justice and wise boundaries.',
    practicalTakeaway:
        'Name one grievance and move it through dua, journaling, and boundary planning.',
    keyConcepts: ['forgiveness', 'boundaries', 'healing'],
    reflectionPrompt: 'What resentment is silently shaping your mood and decisions?',
    relatedLessonIds: ['reflection-repentance-renewal', 'mercy-softening-speech'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'New Testament forgiveness teaching',
        themeSummary:
            'Forgiveness is framed as moral release from cycles of retaliation.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'forgiveness-reconciliation-steps',
    themeId: 'mercy-forgiveness-compassion',
    subcategoryId: 'forgiveness-reconciliation',
    title: 'Steps Toward Reconciliation',
    subtitle: 'Repair with wisdom, not naivety.',
    overview:
        'Guides users through apology, restitution, and boundary-aware reconciliation.',
    quranicPerspective:
        'Qur’anic social healing encourages reconciliation where possible while preserving justice and safety.',
    practicalTakeaway:
        'Use a reconciliation checklist: acknowledge harm, offer repair, define future boundaries.',
    keyConcepts: ['repair', 'restitution', 'safe reconciliation'],
    reflectionPrompt: 'What repair is needed before trust can realistically return?',
    relatedLessonIds: ['family-marriage-mercy', 'community-respectful-disagreement'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Reconciliation motifs in Abrahamic ethics',
        themeSummary:
            'Confession, restitution, and restored relationship are common restorative themes.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'loss-grief-with-faith',
    themeId: 'loss-death-remembrance',
    subcategoryId: 'loss-grief-support',
    title: 'Grieving With Faith',
    subtitle: 'Sorrow without despair.',
    overview:
        'Normalizes grief and provides a framework for spiritual processing without suppression.',
    quranicPerspective:
        'Qur’anic framing allows tears and sorrow while anchoring the heart in patience and divine wisdom.',
    practicalTakeaway:
        'Set a grief routine: dua, trusted conversation, gentle movement, and remembrance.',
    keyConcepts: ['grief', 'sabr', 'remembrance'],
    reflectionPrompt: 'What support do you need to grieve without isolation?',
    relatedLessonIds: ['loss-supporting-others', 'hardship-sabr-active'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Psalms lament and mourning traditions',
        themeSummary:
            'Grief is expressed honestly while maintaining prayerful orientation toward God.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'loss-supporting-others',
    themeId: 'loss-death-remembrance',
    subcategoryId: 'loss-grief-support',
    title: 'Supporting Others in Grief',
    subtitle: 'Presence over perfect words.',
    overview:
        'Teaches practical compassion for people carrying fresh loss.',
    quranicPerspective:
        'Mercy-centered conduct includes standing with people in pain and avoiding harmful speech.',
    practicalTakeaway:
        'Offer practical support (meals, transport, listening) before advice.',
    keyConcepts: ['companioning grief', 'presence', 'practical care'],
    reflectionPrompt: 'How can you become safer to approach for someone grieving?',
    relatedLessonIds: ['mercy-serving-vulnerable', 'community-neighbor-rights'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Pastoral care traditions',
        themeSummary:
            'Comfort is often framed as companionship, listening, and concrete support.',
      ),
    ],
    order: 2,
  ),
  LifeLesson(
    id: 'death-remembering-accountability',
    themeId: 'loss-death-remembrance',
    subcategoryId: 'death-accountability-legacy',
    title: 'Remembering Death With Accountability',
    subtitle: 'Mortality as moral clarity.',
    overview:
        'This lesson reframes mortality awareness as a tool for better priorities and sincerity.',
    quranicPerspective:
        'Qur’anic reminders of death call people to repentance, justice, and purposeful living.',
    practicalTakeaway:
        'Review one weekly decision through this lens: what would matter most at life’s end?',
    keyConcepts: ['mortality awareness', 'accountability', 'priority reset'],
    reflectionPrompt: 'What would you stop delaying if you remembered death more consciously?',
    relatedLessonIds: ['reflection-evening-review', 'death-legacy-good-deeds'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Memento mori traditions',
        themeSummary:
            'Remembering mortality is widely used to correct ego and recover moral seriousness.',
      ),
    ],
    order: 1,
  ),
  LifeLesson(
    id: 'death-legacy-good-deeds',
    themeId: 'loss-death-remembrance',
    subcategoryId: 'death-accountability-legacy',
    title: 'Legacy of Good Deeds',
    subtitle: 'Live what you want to leave behind.',
    overview:
        'Focuses on ongoing benefit through knowledge, service, and character impact.',
    quranicPerspective:
        'Qur’anic moral logic encourages deeds with lasting benefit and sincere intention beyond recognition.',
    practicalTakeaway:
        'Choose one long-horizon contribution: teaching, mentoring, or recurring service.',
    keyConcepts: ['legacy', 'continuing benefit', 'sincere impact'],
    reflectionPrompt: 'What trace of goodness do you hope remains after you?',
    relatedLessonIds: ['wealth-generosity-ihsan', 'work-intention-service'],
    comparativeInsights: [
      LifeComparativeInsight(
        tradition: 'Wisdom and legacy traditions across Abrahamic literature',
        themeSummary:
            'Lasting moral influence is often treated as greater than temporary status.',
      ),
    ],
    order: 2,
  ),
];

LifeTheme? lifeThemeById(String id) {
  for (final item in lifeCurriculum.themes) {
    if (item.id == id) return item;
  }
  return null;
}

LifeSubcategory? lifeSubcategoryById(String id) {
  for (final item in lifeCurriculum.subcategories) {
    if (item.id == id) return item;
  }
  return null;
}

LifeLesson? lifeLessonById(String id) {
  for (final item in lifeCurriculum.lessons) {
    if (item.id == id) return item;
  }
  return null;
}

List<LifeSubcategory> lifeSubcategoriesForTheme(String themeId) {
  return lifeCurriculum.subcategories
      .where((item) => item.themeId == themeId)
      .toList()
    ..sort((a, b) => a.order.compareTo(b.order));
}

List<LifeLesson> lifeLessonsForSubcategory(String subcategoryId) {
  return lifeCurriculum.lessons
      .where((item) => item.subcategoryId == subcategoryId)
      .toList()
    ..sort((a, b) => a.order.compareTo(b.order));
}

List<LifeTheme> lifeThemesInSuggestedOrder() {
  final out = <LifeTheme>[];
  for (final id in lifeCurriculum.suggestedThemeOrder) {
    final theme = lifeThemeById(id);
    if (theme != null) out.add(theme);
  }
  return out;
}
