import '../domain/learn_content_page_data.dart';
import '../domain/learn_topic_category.dart';

const Map<LearnTopicCategory, List<LearnContentPageData>>
learnContentByCategory = {
  LearnTopicCategory.life: _lifeTopics,
  LearnTopicCategory.world: _worldTopics,
  LearnTopicCategory.hadith: _hadithTopics,
};

const List<LearnContentPageData> _lifeTopics = [
  LearnContentPageData(
    id: 'marriage',
    category: LearnTopicCategory.life,
    title: 'Marriage',
    subtitle: 'Compassion, trust, and shared purpose.',
    overview:
        'A staged learning page on mercy, responsibility, and character in marriage.',
    keyThemes: [
      'Mercy and tranquility',
      'Mutual rights',
      'Patience in communication',
    ],
    referencePlaceholders: [
      'Qur’an reference placeholder',
      'Hadith reference placeholder',
    ],
    reflectionPrompt:
        'How can you increase mercy and gentleness in daily interactions?',
    relatedTopics: [
      RelatedTopic(topicId: 'character', title: 'Character'),
      RelatedTopic(topicId: 'patience', title: 'Patience'),
    ],
    nextTopicId: 'parents',
  ),
  LearnContentPageData(
    id: 'parents',
    category: LearnTopicCategory.life,
    title: 'Parents',
    subtitle: 'Respect, gratitude, and service.',
    overview: 'A staged guide to honoring parents with humility and kindness.',
    keyThemes: ['Respectful speech', 'Care and service', 'Dua for parents'],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt:
        'What is one practical action you can take to honor your parents this week?',
    relatedTopics: [RelatedTopic(topicId: 'gratitude', title: 'Gratitude')],
    nextTopicId: 'children',
  ),
  LearnContentPageData(
    id: 'children',
    category: LearnTopicCategory.life,
    title: 'Children',
    subtitle: 'Trust, teaching, and gentle guidance.',
    overview:
        'A staged page for nurturing faith, trust, and emotional safety for children.',
    keyThemes: [
      'Gentle correction',
      'Consistent example',
      'Dua and protection',
    ],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt: 'How can your example teach before your words do?',
    relatedTopics: [RelatedTopic(topicId: 'character', title: 'Character')],
    nextTopicId: 'wealth',
  ),
  LearnContentPageData(
    id: 'wealth',
    category: LearnTopicCategory.life,
    title: 'Wealth',
    subtitle: 'Provision with responsibility.',
    overview: 'A staged reminder that wealth is both trust and test.',
    keyThemes: ['Halal earning', 'Moderation', 'Charity and accountability'],
    referencePlaceholders: [
      'Qur’an reference placeholder',
      'Zakat placeholder',
    ],
    reflectionPrompt:
        'Does your spending reflect your priorities and intention?',
    relatedTopics: [RelatedTopic(topicId: 'justice', title: 'Justice')],
    nextTopicId: 'patience',
  ),
  LearnContentPageData(
    id: 'patience',
    category: LearnTopicCategory.life,
    title: 'Patience',
    subtitle: 'Steadiness through ease and trial.',
    overview:
        'A staged reflection on patience in worship, hardship, and relationships.',
    keyThemes: ['Steadfast worship', 'Emotional restraint', 'Hope in الله'],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt:
        'Where do you need sabr today: action, speech, or expectation?',
    relatedTopics: [
      RelatedTopic(topicId: 'gratitude', title: 'Gratitude'),
      RelatedTopic(topicId: 'justice', title: 'Justice'),
    ],
    nextTopicId: 'justice',
  ),
  LearnContentPageData(
    id: 'justice',
    category: LearnTopicCategory.life,
    title: 'Justice',
    subtitle: 'Fairness with integrity.',
    overview:
        'A staged page on fairness in judgment, speech, and daily conduct.',
    keyThemes: ['Truthfulness', 'Avoiding bias', 'Fulfilling trusts'],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt:
        'Where can you be more fair, especially when it is difficult?',
    relatedTopics: [RelatedTopic(topicId: 'character', title: 'Character')],
    nextTopicId: 'character',
  ),
  LearnContentPageData(
    id: 'character',
    category: LearnTopicCategory.life,
    title: 'Character',
    subtitle: 'Adab, sincerity, and restraint.',
    overview:
        'A staged page around manners, intention, and consistent behavior.',
    keyThemes: ['Humility', 'Kind speech', 'Consistency'],
    referencePlaceholders: ['Hadith reference placeholder'],
    reflectionPrompt:
        'Which one trait should you focus on improving this month?',
    relatedTopics: [
      RelatedTopic(topicId: 'gratitude', title: 'Gratitude'),
      RelatedTopic(topicId: 'patience', title: 'Patience'),
    ],
    nextTopicId: 'gratitude',
  ),
  LearnContentPageData(
    id: 'gratitude',
    category: LearnTopicCategory.life,
    title: 'Gratitude',
    subtitle: 'Seeing blessings with awareness.',
    overview:
        'A staged reflection on gratitude in words, actions, and priorities.',
    keyThemes: ['Remembrance', 'Contentment', 'Serving with thanks'],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt:
        'List three blessings today and one action of thanks for each.',
    relatedTopics: [RelatedTopic(topicId: 'patience', title: 'Patience')],
  ),
  LearnContentPageData(
    id: 'disclaimer-community-first',
    category: LearnTopicCategory.life,
    title: 'Companion App Disclaimer',
    subtitle: 'A helpful guide, not a replacement for mosque and scholars.',
    overview:
        'Path of Nur is a companion for learning and consistency. It does not replace local scholars, mosque community, or personal mentorship.',
    keyThemes: [
      'Keep connection with your local mosque',
      'Seek reliable teachers for rulings',
      'Use digital tools as support, not authority',
    ],
    referencePlaceholders: ['General Islamic guidance'],
    reflectionPrompt:
        'Which local people or spaces (imam, mosque, trusted family) will remain central in your growth?',
    relatedTopics: [
      RelatedTopic(topicId: 'new-muslim-path', title: 'New Muslim Path'),
      RelatedTopic(topicId: 'revert-support-growth', title: 'Revert Support'),
    ],
    nextTopicId: 'new-muslim-path',
  ),
  LearnContentPageData(
    id: 'new-muslim-path',
    category: LearnTopicCategory.life,
    title: 'New Muslim Path',
    subtitle: 'Foundational steps for someone entering Islam.',
    overview:
        'Start with essentials: shahadah, prayer basics, trusted local support, and steady learning pace.',
    keyThemes: [
      'Foundations first',
      'Consistent salah learning',
      'Healthy community ties',
    ],
    referencePlaceholders: ['Qur’an and Sunnah foundations'],
    reflectionPrompt:
        'What is the one next step that feels realistic this week?',
    relatedTopics: [
      RelatedTopic(
        topicId: 'salah-learning-track',
        title: 'Salah Learning Track',
      ),
      RelatedTopic(topicId: 'revert-support-growth', title: 'Revert Support'),
    ],
    nextTopicId: 'revert-support-growth',
  ),
  LearnContentPageData(
    id: 'revert-support-growth',
    category: LearnTopicCategory.life,
    title: 'Revert Muslim Support',
    subtitle: 'Gentle growth, forgiveness, and supportive routines.',
    overview:
        'Reverts may carry emotional and social pressure. This guide centers mercy, gradual progress, and support networks.',
    keyThemes: [
      'Mercy over perfectionism',
      'Community belonging',
      'Practical repentance and renewal',
    ],
    referencePlaceholders: ['Repentance and hope themes'],
    reflectionPrompt:
        'Where do you need encouragement instead of self-criticism today?',
    relatedTopics: [
      RelatedTopic(topicId: 'new-muslim-path', title: 'New Muslim Path'),
      RelatedTopic(
        topicId: 'salah-learning-track',
        title: 'Salah Learning Track',
      ),
    ],
    nextTopicId: 'hajj-full-journey',
  ),
  LearnContentPageData(
    id: 'hajj-full-journey',
    category: LearnTopicCategory.life,
    title: 'Hajj: Booking to Returning Home',
    subtitle: 'A staged roadmap from planning to post-Hajj habits.',
    overview:
        'A practical flow covering intentions, planning, documents, physical preparation, rites, and post-return consistency.',
    keyThemes: [
      'Preparation with intention',
      'Learning rites before travel',
      'Post-Hajj consistency',
    ],
    referencePlaceholders: ['Hajj rites framework'],
    reflectionPrompt:
        'If you were preparing now, what three things would you start first?',
    relatedTopics: [
      RelatedTopic(topicId: 'umrah-full-journey', title: 'Umrah Journey'),
      RelatedTopic(
        topicId: 'islamic-dos-donts',
        title: 'Islamic Do\'s & Don\'ts',
      ),
    ],
    nextTopicId: 'umrah-full-journey',
  ),
  LearnContentPageData(
    id: 'umrah-full-journey',
    category: LearnTopicCategory.life,
    title: 'Umrah: Preparation to Life After',
    subtitle: 'A calm guide for planning and performing Umrah.',
    overview:
        'Covers intention, travel preparation, ihram awareness, practical etiquette, and habits to preserve after returning home.',
    keyThemes: [
      'Clear intention',
      'Step-by-step readiness',
      'After-Umrah consistency',
    ],
    referencePlaceholders: ['Umrah rites framework'],
    reflectionPrompt:
        'What practice can help keep your heart connected after travel?',
    relatedTopics: [
      RelatedTopic(topicId: 'hajj-full-journey', title: 'Hajj Journey'),
      RelatedTopic(
        topicId: 'itikaaf-dos-donts',
        title: 'I\'tikaf Do\'s & Don\'ts',
      ),
    ],
    nextTopicId: 'salah-learning-track',
  ),
  LearnContentPageData(
    id: 'salah-learning-track',
    category: LearnTopicCategory.life,
    title: 'Salah Learning Track',
    subtitle: 'Niyyah, wudu, posture, recitation, and consistency.',
    overview:
        'A full beginner-to-intermediate learning path for prayer: purification, intention, recitation flow, and common mistakes.',
    keyThemes: [
      'Learn with practice',
      'Correct slowly, not harshly',
      'Consistency over volume',
    ],
    referencePlaceholders: ['Prayer essentials'],
    reflectionPrompt:
        'Which part of prayer do you want to improve first: focus, recitation, or structure?',
    relatedTopics: [
      RelatedTopic(topicId: 'new-muslim-path', title: 'New Muslim Path'),
      RelatedTopic(topicId: 'itikaaf-basics', title: 'I\'tikaf Basics'),
    ],
    nextTopicId: 'itikaaf-basics',
  ),
  LearnContentPageData(
    id: 'itikaaf-basics',
    category: LearnTopicCategory.life,
    title: 'I\'tikaf Basics',
    subtitle: 'Purpose, preparation, and balanced worship focus.',
    overview:
        'I\'tikaf is spiritual retreat in the mosque with focused worship, reduced distractions, and sincere intention.',
    keyThemes: [
      'Retreat with intention',
      'Simple worship plan',
      'Respect mosque etiquette',
    ],
    referencePlaceholders: ['I\'tikaf practice themes'],
    reflectionPrompt:
        'If you were to do i\'tikaf, what would your simple daily worship plan be?',
    relatedTopics: [
      RelatedTopic(
        topicId: 'itikaaf-dos-donts',
        title: 'I\'tikaf Do\'s & Don\'ts',
      ),
      RelatedTopic(
        topicId: 'salah-learning-track',
        title: 'Salah Learning Track',
      ),
    ],
    nextTopicId: 'itikaaf-dos-donts',
  ),
  LearnContentPageData(
    id: 'itikaaf-dos-donts',
    category: LearnTopicCategory.life,
    title: 'I\'tikaf Do\'s & Don\'ts',
    subtitle: 'Practical boundaries and beneficial routines.',
    overview:
        'Practical behaviors that protect sincerity: reduce idle talk, avoid distractions, keep intention clear, and stay considerate.',
    keyThemes: ['Adab in mosque spaces', 'Time protection', 'Heart focus'],
    referencePlaceholders: ['I\'tikaf etiquette'],
    reflectionPrompt: 'Which habit most distracts you from focused worship?',
    relatedTopics: [
      RelatedTopic(topicId: 'itikaaf-basics', title: 'I\'tikaf Basics'),
      RelatedTopic(
        topicId: 'islamic-dos-donts',
        title: 'Islamic Do\'s & Don\'ts',
      ),
    ],
    nextTopicId: 'islamic-dos-donts',
  ),
  LearnContentPageData(
    id: 'islamic-dos-donts',
    category: LearnTopicCategory.life,
    title: 'Islamic Do\'s & Don\'ts',
    subtitle: 'Everyday guardrails for speech, conduct, and worship.',
    overview:
        'A practical checklist for daily life with emphasis on sincerity, honesty, modesty, rights of others, and discipline.',
    keyThemes: [
      'Do beneficial actions first',
      'Avoid harm in speech/behavior',
      'Review intention daily',
    ],
    referencePlaceholders: ['General adab and fiqh reminders'],
    reflectionPrompt:
        'Which one “don’t” is currently affecting your peace most?',
    relatedTopics: [
      RelatedTopic(
        topicId: 'salah-learning-track',
        title: 'Salah Learning Track',
      ),
      RelatedTopic(
        topicId: 'brothers-respect-sisters',
        title: 'Brothers & Respect',
      ),
    ],
    nextTopicId: 'women-honor-roles',
  ),
  LearnContentPageData(
    id: 'women-honor-roles',
    category: LearnTopicCategory.life,
    title: 'Honor and Roles of Women in Islam',
    subtitle: 'Dignity, rights, contribution, and respect.',
    overview:
        'A respectful overview of women’s dignity, spiritual equality, social rights, and meaningful roles in family and society.',
    keyThemes: [
      'Dignity and justice',
      'Rights and responsibilities',
      'Respectful leadership and support',
    ],
    referencePlaceholders: ['Qur’anic and prophetic values'],
    reflectionPrompt:
        'How can your home or community better honor women’s dignity and contribution?',
    relatedTopics: [
      RelatedTopic(
        topicId: 'brothers-respect-sisters',
        title: 'Brothers & Respect',
      ),
      RelatedTopic(topicId: 'sisters-guidance', title: 'Sisters Guidance'),
    ],
    nextTopicId: 'brothers-respect-sisters',
  ),
  LearnContentPageData(
    id: 'brothers-respect-sisters',
    category: LearnTopicCategory.life,
    title: 'What Brothers Should Know',
    subtitle: 'Respect, adab, safety, and responsibility toward sisters.',
    overview:
        'Guidance for brothers on respectful communication, protection from harm, dignity, boundaries, and emotional intelligence.',
    keyThemes: [
      'Lower harm and increase dignity',
      'Protect trust',
      'Speak with respect and fairness',
    ],
    referencePlaceholders: ['Ethics of conduct and modesty'],
    reflectionPrompt:
        'In your speech and behavior, where can you be more respectful and protective of dignity?',
    relatedTopics: [
      RelatedTopic(topicId: 'women-honor-roles', title: 'Women in Islam'),
      RelatedTopic(topicId: 'sisters-guidance', title: 'Sisters Guidance'),
    ],
    nextTopicId: 'sisters-guidance',
  ),
  LearnContentPageData(
    id: 'sisters-guidance',
    category: LearnTopicCategory.life,
    title: 'Sisters Guidance',
    subtitle: 'Cycle-aware worship guidance and supportive learning topics.',
    overview:
        'A dedicated section for sisters: cycle-aware worship pauses, dhikr alternatives, emotional care, and practical faith continuity.',
    keyThemes: [
      'Mercy in worship rhythm',
      'Cycle-aware guidance',
      'Steady connection through alternatives',
    ],
    referencePlaceholders: ['Women-specific worship guidance'],
    reflectionPrompt:
        'Which gentle worship practices help you stay spiritually connected during pause days?',
    relatedTopics: [
      RelatedTopic(topicId: 'women-honor-roles', title: 'Women in Islam'),
      RelatedTopic(
        topicId: 'brothers-respect-sisters',
        title: 'Brothers & Respect',
      ),
    ],
    nextTopicId: 'disclaimer-community-first',
  ),
  LearnContentPageData(
    id: 'jealousy-heart-purification',
    category: LearnTopicCategory.life,
    title: 'Stay Away from Jealousy',
    subtitle: 'Purify the heart from envy and harmful comparison.',
    overview:
        'The source lesson emphasizes avoiding envy and selfish comparison. Spiritual growth increases when you ask الله for good without resenting others.',
    keyThemes: [
      'Heart purification',
      'Contentment and gratitude',
      'Dua over comparison',
    ],
    referencePlaceholders: ['4:32 thematic reminder'],
    reflectionPrompt:
        'Where does comparison steal your peace, and how can gratitude replace it?',
    relatedTopics: [
      RelatedTopic(topicId: 'gratitude', title: 'Gratitude'),
      RelatedTopic(
        topicId: 'women-honor-roles',
        title: 'Honor and Roles of Women',
      ),
    ],
    nextTopicId: 'gossip-idle-talk-ethics',
  ),
  LearnContentPageData(
    id: 'gossip-idle-talk-ethics',
    category: LearnTopicCategory.life,
    title: 'Avoid Gossip and Idle Talk',
    subtitle: 'Protect community trust through clean speech.',
    overview:
        'The source repeatedly warns against idle talk and harmful gossip. Speech should be truthful, useful, and dignified.',
    keyThemes: [
      'Guarding the tongue',
      'Community trust',
      'Constructive speech',
    ],
    referencePlaceholders: ['Speech ethics themes'],
    reflectionPrompt:
        'What conversation habit can you remove this week to protect hearts?',
    relatedTopics: [
      RelatedTopic(
        topicId: 'islamic-dos-donts',
        title: 'Islamic Do\'s & Don\'ts',
      ),
      RelatedTopic(
        topicId: 'brothers-respect-sisters',
        title: 'Brothers & Respect',
      ),
    ],
    nextTopicId: 'conflict-resolution-adab',
  ),
  LearnContentPageData(
    id: 'conflict-resolution-adab',
    category: LearnTopicCategory.life,
    title: 'Conflict Resolution with Justice',
    subtitle: 'Resolve disputes through fairness, not ego.',
    overview:
        'The source frames conflict as normal but warns against personalized hostility. Resolve matters with clear principles and justice.',
    keyThemes: [
      'Justice in disagreement',
      'Detach from ego',
      'Process over emotion',
    ],
    referencePlaceholders: ['38:26 thematic reminder'],
    reflectionPrompt: 'When conflict appears, what rule helps you stay fair?',
    relatedTopics: [
      RelatedTopic(topicId: 'justice', title: 'Justice'),
      RelatedTopic(
        topicId: 'community-neighbor-rights',
        title: 'Neighbor Rights',
      ),
    ],
    nextTopicId: 'networking-community-benefit',
  ),
  LearnContentPageData(
    id: 'networking-community-benefit',
    category: LearnTopicCategory.life,
    title: 'Networking for Benefit',
    subtitle: 'Build healthy circles for growth and service.',
    overview:
        'The source encourages social connection and purposeful networking as a means of support, shared growth, and community service.',
    keyThemes: ['Healthy circles', 'Mutual support', 'Community service'],
    referencePlaceholders: ['Community and companionship themes'],
    reflectionPrompt:
        'Which relationships in your life increase your faith and responsibility?',
    relatedTopics: [
      RelatedTopic(topicId: 'new-muslim-path', title: 'New Muslim Path'),
      RelatedTopic(topicId: 'revert-support-growth', title: 'Revert Support'),
    ],
    nextTopicId: 'workplace-ethics-safety',
  ),
  LearnContentPageData(
    id: 'workplace-ethics-safety',
    category: LearnTopicCategory.life,
    title: 'Workplace Ethics and Safety',
    subtitle: 'Respect boundaries, dignity, and trust at work.',
    overview:
        'The source includes workplace safety and harassment concerns. Islamic ethics demand dignity, safety, and accountability in professional spaces.',
    keyThemes: [
      'Dignity and boundaries',
      'Respectful conduct',
      'Safe workplaces',
    ],
    referencePlaceholders: ['Workplace adab guidance'],
    reflectionPrompt:
        'How can you help create a safer, more respectful work environment?',
    relatedTopics: [
      RelatedTopic(topicId: 'women-honor-roles', title: 'Women in Islam'),
      RelatedTopic(
        topicId: 'islamic-dos-donts',
        title: 'Islamic Do\'s & Don\'ts',
      ),
    ],
    nextTopicId: 'health-body-mind-trust',
  ),
  LearnContentPageData(
    id: 'health-body-mind-trust',
    category: LearnTopicCategory.life,
    title: 'Health as a Trust',
    subtitle: 'Protect physical and mental wellness with intention.',
    overview:
        'One source lesson highlights preserving physical and mental health. The body and mind are trusts that support worship, work, and service.',
    keyThemes: ['Body as amanah', 'Mental steadiness', 'Balanced routines'],
    referencePlaceholders: ['Wellness and moderation themes'],
    reflectionPrompt:
        'What one habit this month will improve your energy and focus for worship?',
    relatedTopics: [
      RelatedTopic(
        topicId: 'salah-learning-track',
        title: 'Salah Learning Track',
      ),
      RelatedTopic(topicId: 'time-mindful-use', title: 'Mindful Time Use'),
    ],
    nextTopicId: 'time-mindful-use',
  ),
  LearnContentPageData(
    id: 'time-mindful-use',
    category: LearnTopicCategory.life,
    title: 'Be Mindful of Time',
    subtitle: 'Treat time as a sacred opportunity.',
    overview:
        'The source closes by emphasizing mindful time and thoughtful independence. Use time deliberately and think with responsibility.',
    keyThemes: [
      'Time stewardship',
      'Thoughtful decision-making',
      'Purposeful routines',
    ],
    referencePlaceholders: ['Time accountability themes'],
    reflectionPrompt:
        'Which daily hour is currently wasted and how will you reclaim it?',
    relatedTopics: [
      RelatedTopic(topicId: 'patience', title: 'Patience'),
      RelatedTopic(topicId: 'new-muslim-path', title: 'New Muslim Path'),
    ],
    nextTopicId: 'disclaimer-community-first',
  ),
];

const List<LearnContentPageData> _worldTopics = [
  LearnContentPageData(
    id: 'moon',
    category: LearnTopicCategory.world,
    title: 'Moon',
    subtitle: 'Signs in cycles and timing.',
    overview:
        'A staged page on observation and reflection through lunar signs.',
    keyThemes: ['Cycles of worship', 'Time awareness', 'Creation as sign'],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt: 'How can natural cycles improve your worship rhythm?',
    relatedTopics: [RelatedTopic(topicId: 'night-day', title: 'Night & Day')],
    nextTopicId: 'bees',
  ),
  LearnContentPageData(
    id: 'bees',
    category: LearnTopicCategory.world,
    title: 'Bees',
    subtitle: 'Discipline and benefit in creation.',
    overview:
        'A staged page on order, contribution, and benefit in الله’s creation.',
    keyThemes: ['Purposeful effort', 'Service', 'Order'],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt:
        'How can your daily habits become more purposeful and beneficial?',
    relatedTopics: [RelatedTopic(topicId: 'plants', title: 'Plants')],
    nextTopicId: 'mountains',
  ),
  LearnContentPageData(
    id: 'mountains',
    category: LearnTopicCategory.world,
    title: 'Mountains',
    subtitle: 'Stability and strength.',
    overview: 'A staged page on stability, humility, and perspective.',
    keyThemes: ['Firmness', 'Perspective', 'Humility'],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt: 'What anchors your faith when life feels unstable?',
    relatedTopics: [RelatedTopic(topicId: 'oceans', title: 'Oceans')],
    nextTopicId: 'rain',
  ),
  LearnContentPageData(
    id: 'rain',
    category: LearnTopicCategory.world,
    title: 'Rain',
    subtitle: 'Mercy, revival, and sustenance.',
    overview: 'A staged reflection on revival and mercy through rain.',
    keyThemes: ['Revival after dryness', 'Sustenance', 'Hope'],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt: 'Where in your life do you need spiritual renewal?',
    relatedTopics: [RelatedTopic(topicId: 'plants', title: 'Plants')],
    nextTopicId: 'oceans',
  ),
  LearnContentPageData(
    id: 'oceans',
    category: LearnTopicCategory.world,
    title: 'Oceans',
    subtitle: 'Depth, power, and boundaries.',
    overview:
        'A staged page on contemplating magnitude and limits in creation.',
    keyThemes: ['Depth and scale', 'Boundaries', 'Humility'],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt:
        'How can reflection on creation increase awe and gratitude?',
    relatedTopics: [RelatedTopic(topicId: 'mountains', title: 'Mountains')],
    nextTopicId: 'animals',
  ),
  LearnContentPageData(
    id: 'animals',
    category: LearnTopicCategory.world,
    title: 'Animals',
    subtitle: 'Mercy and responsibility.',
    overview: 'A staged page on stewardship, compassion, and observation.',
    keyThemes: ['Stewardship', 'Compassion', 'Interdependence'],
    referencePlaceholders: [
      'Qur’an reference placeholder',
      'Hadith reference placeholder',
    ],
    reflectionPrompt:
        'How do you show mercy toward living creation in daily life?',
    relatedTopics: [RelatedTopic(topicId: 'plants', title: 'Plants')],
    nextTopicId: 'plants',
  ),
  LearnContentPageData(
    id: 'plants',
    category: LearnTopicCategory.world,
    title: 'Plants',
    subtitle: 'Growth and nourishment.',
    overview: 'A staged page on growth, nourishment, and signs of mercy.',
    keyThemes: ['Growth over time', 'Sustenance', 'Steady care'],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt:
        'What spiritual habit needs steady nourishment right now?',
    relatedTopics: [RelatedTopic(topicId: 'rain', title: 'Rain')],
    nextTopicId: 'night-day',
  ),
  LearnContentPageData(
    id: 'night-day',
    category: LearnTopicCategory.world,
    title: 'Night & Day',
    subtitle: 'Balance, rest, and effort.',
    overview: 'A staged reflection on rhythm between rest and action.',
    keyThemes: ['Balance', 'Rest and productivity', 'Time discipline'],
    referencePlaceholders: ['Qur’an reference placeholder'],
    reflectionPrompt:
        'How can you improve your daily rhythm for worship and wellbeing?',
    relatedTopics: [RelatedTopic(topicId: 'moon', title: 'Moon')],
  ),
];

const List<LearnContentPageData> _hadithTopics = [
  LearnContentPageData(
    id: 'life-lessons',
    category: LearnTopicCategory.hadith,
    title: 'Life Lessons of Hadith',
    subtitle: 'Foundational guidance for everyday life.',
    overview: 'A staged hadith-learning page with practical life themes.',
    keyThemes: ['Intentions', 'Consistency', 'Mercy in action'],
    referencePlaceholders: ['Hadith reference placeholder'],
    reflectionPrompt: 'Which teaching can you apply practically this week?',
    relatedTopics: [
      RelatedTopic(topicId: 'character-manners', title: 'Character & Manners'),
    ],
    nextTopicId: 'world-lessons',
  ),
  LearnContentPageData(
    id: 'world-lessons',
    category: LearnTopicCategory.hadith,
    title: 'World Lessons through Hadith',
    subtitle: 'Prophetic perspective on worldly affairs.',
    overview:
        'A staged page for balancing worldly effort with spiritual intent.',
    keyThemes: ['Balance', 'Responsibility', 'Perspective'],
    referencePlaceholders: ['Hadith reference placeholder'],
    reflectionPrompt:
        'Where do you need better balance between dunya and akhirah?',
    relatedTopics: [
      RelatedTopic(topicId: 'worship-intention', title: 'Worship & Intention'),
    ],
    nextTopicId: 'character-manners',
  ),
  LearnContentPageData(
    id: 'character-manners',
    category: LearnTopicCategory.hadith,
    title: 'Character & Manners',
    subtitle: 'Adab, humility, and conduct.',
    overview: 'A staged page on prophetic manners in speech and behavior.',
    keyThemes: ['Adab', 'Honesty', 'Gentleness'],
    referencePlaceholders: ['Hadith reference placeholder'],
    reflectionPrompt:
        'Which manner should be your focus in coming conversations?',
    relatedTopics: [
      RelatedTopic(topicId: 'family-society', title: 'Family & Society'),
    ],
    nextTopicId: 'worship-intention',
  ),
  LearnContentPageData(
    id: 'worship-intention',
    category: LearnTopicCategory.hadith,
    title: 'Worship & Intention',
    subtitle: 'Actions grounded in sincerity.',
    overview: 'A staged page to revisit sincerity and quality in worship.',
    keyThemes: ['Niyyah', 'Presence', 'Consistency'],
    referencePlaceholders: ['Hadith reference placeholder'],
    reflectionPrompt:
        'How can you renew intention before your next act of worship?',
    relatedTopics: [
      RelatedTopic(topicId: 'life-lessons', title: 'Life Lessons of Hadith'),
    ],
    nextTopicId: 'family-society',
  ),
  LearnContentPageData(
    id: 'family-society',
    category: LearnTopicCategory.hadith,
    title: 'Family & Society',
    subtitle: 'Rights, compassion, and social trust.',
    overview: 'A staged page on prophetic ethics in family and community life.',
    keyThemes: ['Rights and duties', 'Compassion', 'Community trust'],
    referencePlaceholders: ['Hadith reference placeholder'],
    reflectionPrompt:
        'What can you do this week to strengthen one relationship?',
    relatedTopics: [
      RelatedTopic(topicId: 'character-manners', title: 'Character & Manners'),
    ],
  ),
];

List<LearnContentPageData> topicsForCategory(LearnTopicCategory category) {
  return learnContentByCategory[category] ?? const [];
}

LearnContentPageData? topicById(LearnTopicCategory category, String topicId) {
  final topics = topicsForCategory(category);
  for (final topic in topics) {
    if (topic.id == topicId) return topic;
  }
  return null;
}
