import '../domain/quran_ayah_explanation_models.dart';

const List<QuranAyahExplanationSourceRef>
_trustedTafsirSources = <QuranAyahExplanationSourceRef>[
  QuranAyahExplanationSourceRef(
    type: QuranAyahExplanationSourceType.classicalTafsir,
    title: 'Tafsir al-Tabari',
    group: 'mainstream_sunni_tafsir',
  ),
  QuranAyahExplanationSourceRef(
    type: QuranAyahExplanationSourceType.classicalTafsir,
    title: 'Tafsir Ibn Kathir',
    group: 'mainstream_sunni_tafsir',
  ),
  QuranAyahExplanationSourceRef(
    type: QuranAyahExplanationSourceType.classicalTafsir,
    title: 'Tafsir al-Sa‘di',
    group: 'mainstream_sunni_tafsir',
  ),
  QuranAyahExplanationSourceRef(
    type: QuranAyahExplanationSourceType.simplifiedSummary,
    title: 'Path of Nur editorial simplification',
    note:
        'Paraphrased beginner-friendly summary grounded in reviewed tafsir meaning.',
    group: 'path_of_nur_editorial',
  ),
  QuranAyahExplanationSourceRef(
    type: QuranAyahExplanationSourceType.kidsSimplification,
    title: 'Path of Nur kids simplification',
    note:
        'Child-friendly wording derived from the same reviewed tafsir meaning.',
    group: 'path_of_nur_editorial',
  ),
];

QuranAyahExplanationEntry _entry({
  required int surahNumber,
  required int ayahNumber,
  required String simpleSummary,
  required String standardExplanation,
  String? deepExplanation,
  String? kidsExplanation,
  List<String> keyLessons = const <String>[],
  String? reflectionPrompt,
  QuranAyahExplanationRolloutPack? rolloutPack,
  QuranAyahExplanationReviewStatus? reviewStatus,
}) {
  return QuranAyahExplanationEntry(
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    simpleSummary: simpleSummary,
    standardExplanation: standardExplanation,
    deepExplanation: deepExplanation,
    kidsExplanation: kidsExplanation,
    keyLessons: keyLessons,
    reflectionPrompt: reflectionPrompt,
    sourceRefs: _trustedTafsirSources,
    rolloutPack: rolloutPack ?? _defaultRolloutPackForAyah(surahNumber),
    reviewStatus: reviewStatus ?? _defaultReviewStatusForAyah(surahNumber),
  );
}

QuranAyahExplanationRolloutPack _defaultRolloutPackForAyah(int surahNumber) {
  return switch (surahNumber) {
    1 || 2 => QuranAyahExplanationRolloutPack.foundations,
    93 || 94 || 97 || 103 => QuranAyahExplanationRolloutPack.reflectionComfort,
    105 ||
    106 ||
    107 ||
    108 ||
    109 ||
    110 ||
    111 ||
    112 ||
    113 ||
    114 => QuranAyahExplanationRolloutPack.commonSalahSurahs,
    _ => QuranAyahExplanationRolloutPack.beginnerCoreAyahs,
  };
}

QuranAyahExplanationReviewStatus _defaultReviewStatusForAyah(int surahNumber) {
  return switch (surahNumber) {
    1 || 2 || 112 || 113 || 114 => QuranAyahExplanationReviewStatus.verified,
    105 ||
    106 ||
    107 ||
    108 ||
    109 ||
    110 ||
    111 ||
    93 ||
    94 ||
    97 ||
    103 => QuranAyahExplanationReviewStatus.reviewed,
    _ => QuranAyahExplanationReviewStatus.needsExpansion,
  };
}

final List<QuranAyahExplanationEntry>
seededQuranAyahExplanations = <QuranAyahExplanationEntry>[
  _entry(
    surahNumber: 1,
    ayahNumber: 1,
    simpleSummary: 'We begin with Allah\'s name and remember His wide mercy.',
    standardExplanation:
        'This opening teaches us to begin in Allah\'s name and to remember that His mercy surrounds His creation. It sets the tone of worship with praise, dependence, and hope.',
    deepExplanation:
        'Classical tafsir explains that opening with Allah\'s name seeks His help and blessing, while mentioning both names of mercy teaches the servant to turn back to Allah with hope in His compassion.',
    kidsExplanation:
        'We start with Allah because He is kind and caring. Remembering Him helps our hearts trust Him.',
    keyLessons: <String>['Begin with Allah', 'Allah is full of mercy'],
    reflectionPrompt:
        'What would change if I started this moment by remembering Allah first?',
  ),
  _entry(
    surahNumber: 1,
    ayahNumber: 2,
    simpleSummary:
        'All praise belongs to Allah, the Lord who cares for every world.',
    standardExplanation:
        'Allah alone deserves complete praise because He created, sustains, and guides everything. The verse teaches gratitude and reminds us that every blessing traces back to Him.',
    deepExplanation:
        'The scholars explain that "Lord of the worlds" includes creating, owning, nurturing, and directing every realm. Praise belongs to Allah not only for what He gives, but for who He is in perfect majesty and wisdom.',
    kidsExplanation:
        'Allah made us, cares for us, and gives us so many blessings. That is why we thank Him.',
    keyLessons: <String>[
      'Thank Allah often',
      'Allah takes care of all creation',
    ],
    reflectionPrompt:
        'Which blessing today should lead me to fresh gratitude to Allah?',
  ),
  _entry(
    surahNumber: 1,
    ayahNumber: 3,
    simpleSummary:
        'Allah repeats His mercy so our hearts approach Him with hope.',
    standardExplanation:
        'The repetition of Allah\'s mercy is a reminder that His care is constant and near. Worship is not built on fear alone; it is also built on hope in the mercy of our Lord.',
    kidsExplanation:
        'Allah is very, very merciful. He loves when we turn back to Him.',
    keyLessons: <String>['Hope in Allah\'s mercy', 'Do not despair'],
    reflectionPrompt:
        'When I feel weak, how can this verse help me return to Allah with hope?',
  ),
  _entry(
    surahNumber: 1,
    ayahNumber: 4,
    simpleSummary:
        'Allah alone owns the Day when everyone will be judged fairly.',
    standardExplanation:
        'This verse reminds us that every person will return to Allah and answer for what they did. It places accountability beside mercy so the believer worships with both humility and seriousness.',
    deepExplanation:
        'Tafsir highlights that Allah is the sole Master of the Day of Recompense, when all borrowed power disappears and every deed is made clear. Remembering that day corrects pride and gives meaning to obedience.',
    kidsExplanation:
        'One day everyone will stand before Allah, and Allah will judge with perfect fairness.',
    keyLessons: <String>['Remember the Hereafter', 'Allah judges fairly'],
    reflectionPrompt:
        'How should remembering the Day of Judgment change one choice I make today?',
  ),
  _entry(
    surahNumber: 1,
    ayahNumber: 5,
    simpleSummary: 'We worship Allah alone, and we ask Him alone for help.',
    standardExplanation:
        'This verse is the heart of Surah al-Fatihah. It joins pure worship with dependence, teaching that sincerity and trust belong together: we obey Allah alone and seek strength from Him alone.',
    deepExplanation:
        'The order in the verse teaches adab: worship comes first, then asking for help, because the servant approaches Allah through devotion and then seeks support to continue. It is a concise summary of tawhid in worship and reliance.',
    kidsExplanation:
        'We pray to Allah only, and we ask Allah to help us do what is right.',
    keyLessons: <String>['Worship Allah alone', 'Ask Allah for help'],
    reflectionPrompt:
        'In what part of life do I most need to renew both sincerity and reliance on Allah?',
  ),
  _entry(
    surahNumber: 1,
    ayahNumber: 6,
    simpleSummary: 'We ask Allah to keep us on the straight path.',
    standardExplanation:
        'Guidance is not a one-time gift; we need it again and again. This verse teaches us to ask Allah for correct belief, right action, and steadiness until the end.',
    kidsExplanation: 'We ask Allah to help us stay on the good path every day.',
    keyLessons: <String>[
      'Keep asking for guidance',
      'Staying guided needs Allah\'s help',
    ],
    reflectionPrompt:
        'What part of my life most needs Allah\'s guidance right now?',
  ),
  _entry(
    surahNumber: 1,
    ayahNumber: 7,
    simpleSummary:
        'The straight path is the path of Allah\'s favor, not the path of rebellion or going astray.',
    standardExplanation:
        'Allah teaches us that guidance is known by following the people He favored with truth and obedience. We also ask to be protected from knowing the truth and rejecting it, or losing the truth through heedlessness.',
    deepExplanation:
        'Classical tafsir often describes two dangers here: corrupt action despite knowledge, and misguidance through ignorance. The believer asks for the blessed middle way of knowledge, sincerity, and obedience together.',
    kidsExplanation:
        'We ask Allah to help us follow the way of good people who listened to Him and obeyed Him.',
    keyLessons: <String>[
      'Follow truth with action',
      'Ask protection from misguidance',
    ],
    reflectionPrompt:
        'Am I asking Allah only to know the truth, or also to live by it?',
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 255,
    simpleSummary:
        'Ayat al-Kursi teaches Allah\'s perfect life, knowledge, power, and protection.',
    standardExplanation:
        'This ayah declares Allah\'s absolute oneness and perfection. He is ever-living, never overcome by sleep or tiredness, owns everything in the heavens and earth, and surrounds all things with knowledge and authority.',
    deepExplanation:
        'The ayah gathers major meanings of tawhid together: Allah\'s perfect life, complete self-sufficiency, unrestricted ownership, permission over intercession, total knowledge of past and future, and His supreme exaltedness. It gives the servant security by teaching that Allah\'s care never weakens and His dominion is never challenged.',
    kidsExplanation:
        'Allah is always alive, always watching with perfect knowledge, and always able to protect us. Nothing is too hard for Him.',
    keyLessons: <String>[
      'Allah never becomes weak',
      'Allah knows and controls all things',
      'Trust Allah\'s protection',
    ],
    reflectionPrompt:
        'How can remembering Allah\'s perfect care calm a fear I am carrying?',
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 1,
    simpleSummary:
        'These opening letters are part of the Qur\'an\'s revealed miracle, and Allah knows their fullest wisdom.',
    standardExplanation:
        'The surah opens with disjointed letters that remind us this Qur\'an is made of familiar letters, yet no one can produce anything like it. Their full meaning is with Allah, so they also teach humility before revelation.',
    deepExplanation:
        'Classical tafsir treats these letters as part of the Qur\'an\'s miraculous opening and a reminder that this revelation is composed of the same letters people know, yet they cannot match it. The believer receives them with reverence, knowing that some divine wisdoms are made clear while others remain with Allah.',
    kidsExplanation:
        'Allah opened this surah with special letters from His Book. They remind us that the Qur\'an is amazing and full of wisdom.',
    keyLessons: <String>[
      'Honor what Allah revealed',
      'Some wisdoms remain with Allah',
    ],
    reflectionPrompt:
        'How can this opening help me read the Qur\'an with more humility?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 2,
    simpleSummary:
        'This Qur\'an is sure guidance for people who want to live with taqwa.',
    standardExplanation:
        'Allah describes the Qur\'an as a book without doubt in its truth and guidance. Its benefit is greatest for those whose hearts want to fear Allah, obey Him, and stay away from what displeases Him.',
    deepExplanation:
        'Tafsir explains that the Qur\'an itself is true and free of doubt, while the people who benefit most from it are the people of taqwa. This shows that guidance is not only about evidence being present, but also about the heart being ready to receive and follow that evidence.',
    kidsExplanation:
        'The Qur\'an is Allah\'s true book, and it helps people who want to please Him.',
    keyLessons: <String>[
      'The Qur\'an gives real guidance',
      'A careful heart benefits most',
    ],
    reflectionPrompt:
        'What would it look like to approach the Qur\'an as guidance for my real life?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 3,
    simpleSummary:
        'The guided people believe in the unseen, establish prayer, and spend from what Allah gave them.',
    standardExplanation:
        'Allah begins to describe the qualities of the people who benefit from His guidance. They trust what Allah revealed beyond what they can see, remain faithful in prayer, and share from His provision instead of living selfishly.',
    deepExplanation:
        'This verse gathers three major signs of living faith: belief in the unseen, a steady relationship with Allah through prayer, and generosity toward creation through spending. The order is meaningful: sound belief shapes worship, and true worship then appears in mercy, responsibility, and giving.',
    kidsExplanation:
        'Good believers trust Allah, pray, and share the blessings Allah gave them.',
    keyLessons: <String>[
      'Faith shows in prayer',
      'Allah loves generous hearts',
    ],
    reflectionPrompt:
        'Which quality in this verse needs more care in my life right now?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 4,
    simpleSummary:
        'The guided believers accept all of Allah\'s revelation and stay certain about the Hereafter.',
    standardExplanation:
        'True guidance includes believing in what Allah revealed to Muhammad ﷺ and what He revealed before him. It also includes firm certainty that this life ends in return, judgment, and meeting Allah.',
    deepExplanation:
        'This verse shows that real faith is broad and connected: believers do not honor one revelation while rejecting another, and they do not live as if this world is all there is. Certainty about the Hereafter gives seriousness, patience, and direction to everything else in life.',
    kidsExplanation:
        'Good believers trust all of Allah\'s messages and remember that they will return to Him.',
    keyLessons: <String>[
      'Believe in all Allah\'s revelations',
      'Remember the next life',
    ],
    reflectionPrompt:
        'How does remembering the Hereafter change the way I see today?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 5,
    simpleSummary:
        'These are the people truly upon Allah\'s guidance, and they are the successful ones.',
    standardExplanation:
        'After describing their qualities, Allah confirms that these believers stand on real guidance from Him. Their success is not only worldly ease, but salvation, acceptance, and a good ending with Allah.',
    deepExplanation:
        'The verse closes the opening portrait of the believers by connecting guidance to success. Tafsir points out that success here includes gaining what truly benefits and being saved from what destroys, which means the Qur\'an\'s guidance is not partial or temporary but leads to full well-being in this life and the next.',
    kidsExplanation:
        'People who live with these qualities are on the right path, and Allah calls them successful.',
    keyLessons: <String>['Real success comes from Allah\'s guidance'],
    reflectionPrompt: 'Am I measuring success by what Allah calls success?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 183,
    simpleSummary:
        'Allah made fasting an obligation so believers can grow in taqwa.',
    standardExplanation:
        'Fasting in Ramadan is not only about leaving food and drink. Allah teaches that it is a path to taqwa, where the heart learns self-control, obedience, and greater awareness of Him.',
    deepExplanation:
        'Classical tafsir explains that fasting was prescribed for this ummah just as it was for earlier communities, showing it is a noble path of worship rather than a burden placed on one people alone. Its great aim is taqwa: training the soul to leave even permitted things for Allah\'s sake so it becomes stronger against sin and more ready for obedience.',
    kidsExplanation:
        'Allah taught believers to fast so their hearts can become more careful and close to Him.',
    keyLessons: <String>['Fasting teaches self-control', 'The goal is taqwa'],
    reflectionPrompt:
        'How can I treat fasting as heart-training and not only hunger?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 184,
    simpleSummary:
        'Allah set fasting for known days and gave mercy-based allowances to those with real difficulty.',
    standardExplanation:
        'This verse shows that Allah\'s commands come with wisdom and mercy. Fasting is set for specific days, and those who face genuine hardship are not ignored; Allah also opens lawful ease and compensation.',
    deepExplanation:
        'Tafsir highlights that even in an obligation like fasting, Allah teaches discipline together with mercy. The verse reflects a pattern in the religion: worship is serious, but Allah does not close the door of compassion for the sick, the weak, and those facing conditions that make the command genuinely hard.',
    kidsExplanation:
        'Allah made fasting for special days, and He is gentle with people who truly have difficulty.',
    keyLessons: <String>[
      'Allah\'s law includes mercy',
      'Worship has wisdom and balance',
    ],
    reflectionPrompt:
        'How does this verse help me see mercy inside Allah\'s commands?',
    rolloutPack: QuranAyahExplanationRolloutPack.beginnerCoreAyahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 185,
    simpleSummary:
        'Ramadan is honored because the Qur\'an was sent down in it as guidance for people.',
    standardExplanation:
        'Allah connects fasting in Ramadan to the Qur\'an itself. This month is not only about restraint, but also about returning to revelation, seeking guidance, and thanking Allah for making His path clear.',
    deepExplanation:
        'This verse places the Qur\'an at the center of Ramadan. Tafsir explains that the month is honored by the descent of revelation that distinguishes truth from falsehood, and that fasting and takbir at the close of the month are part of responding to that gift with obedience, gratitude, and magnifying Allah.',
    kidsExplanation:
        'Ramadan is special because Allah sent the Qur\'an as guidance and light for people.',
    keyLessons: <String>[
      'Ramadan and the Qur\'an belong together',
      'Thank Allah for guidance',
    ],
    reflectionPrompt:
        'How can I make my Ramadan more connected to the Qur\'an itself?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 186,
    simpleSummary:
        'Allah is near and answers the prayer of the caller when they call upon Him.',
    standardExplanation:
        'Right in the middle of the fasting passage, Allah teaches closeness and dua. He is not distant from His servants; He calls them to respond to Him with faith and obedience while trusting that He hears them.',
    deepExplanation:
        'The placement of this verse in the fasting passage is meaningful: worship, hunger, and restraint should lead the servant into deeper dua, not dryness. Mainstream tafsir explains that Allah\'s nearness here is a nearness of knowledge, mercy, and response, and that the servant is called to answer Allah through faith and obedience while hoping in His answer.',
    kidsExplanation:
        'Allah is near to us, and He hears us when we make dua to Him.',
    keyLessons: <String>['Make dua often', 'Allah is near and hears'],
    reflectionPrompt:
        'What would change if I truly believed Allah hears this dua right now?',
    rolloutPack: QuranAyahExplanationRolloutPack.reflectionComfort,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 187,
    simpleSummary:
        'Allah clarified the fasting rules with honesty, ease, and protection from going beyond His limits.',
    standardExplanation:
        'This verse explains what is permitted during the nights of Ramadan and when the fast begins and ends. It also teaches that marriage is a place of closeness and protection, and that Allah\'s limits are made clear for our good.',
    deepExplanation:
        'Classical tafsir explains that this verse brought relief after earlier hardship and clarified the lawful boundaries of the fasting day and night. Its wording about spouses being a garment for one another points to intimacy, protection, and closeness, while the ending reminds believers that clear limits are a mercy and should not be approached carelessly.',
    kidsExplanation:
        'Allah clearly taught believers how to fast, and His rules are good and wise for us.',
    keyLessons: <String>[
      'Allah clarifies what is lawful',
      'His limits protect us',
    ],
    reflectionPrompt:
        'Do I see Allah\'s limits as a burden, or as guidance and protection?',
    rolloutPack: QuranAyahExplanationRolloutPack.beginnerCoreAyahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 284,
    simpleSummary:
        'Everything belongs to Allah, and nothing in us is hidden from His knowledge and judgment.',
    standardExplanation:
        'This verse reminds us that Allah owns the heavens and the earth and knows what is open and concealed. It humbles the heart and prepares the believer to turn to Allah with honesty, repentance, and dependence.',
    deepExplanation:
        'Tafsir explains that this verse deeply affected the companions because it emphasized Allah\'s knowledge of what lies within the soul. The closing verses that follow show that Allah did not intend unbearable hardship, but rather truthful accountability that leads the servant into humility, repentance, and reliance on His mercy.',
    kidsExplanation:
        'Allah knows everything, even what we hide inside our hearts, so we should be truthful with Him.',
    keyLessons: <String>['Allah knows what is hidden', 'Turn to Him honestly'],
    reflectionPrompt:
        'What hidden matter in my heart most needs honesty before Allah?',
    rolloutPack: QuranAyahExplanationRolloutPack.reflectionComfort,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 285,
    simpleSummary:
        'The Messenger and the believers accept all that Allah revealed and submit to Him together.',
    standardExplanation:
        'This verse gathers the core of faith: belief in Allah, His angels, His books, and His messengers without rejecting some and accepting others. It also shows the believer\'s attitude of hearing, obeying, and asking Allah for forgiveness.',
    deepExplanation:
        'Mainstream tafsir presents this verse as a beautiful summary of complete iman and humble submission. The believers do not divide Allah\'s messengers, and their response to revelation is not argument or pride but obedience, repentance, and awareness that they are returning to Allah in the end.',
    kidsExplanation:
        'The Prophet and the believers trusted all that Allah revealed and said, "We hear and obey."',
    keyLessons: <String>[
      'Accept Allah\'s revelation fully',
      'Answer with obedience and repentance',
    ],
    reflectionPrompt:
        'Does my heart meet Allah\'s commands with surrender or resistance?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.verified,
  ),
  _entry(
    surahNumber: 2,
    ayahNumber: 286,
    simpleSummary:
        'Allah does not burden a soul beyond its ability and teaches believers to ask Him for pardon, help, and mercy.',
    standardExplanation:
        'This verse closes the surah with relief and dua. Allah is just and merciful, and He teaches His servants to seek forgiveness, ease, and victory while trusting that His commands are never beyond what they can truly bear.',
    deepExplanation:
        'Classical tafsir explains this verse as a mercy-filled closing that answered the fear raised by the previous ayah. It teaches both principle and prayer: Allah does not wrong His servants with impossible burdens, and the believer should constantly ask for pardon, forgiveness, mercy, and divine help while living under that promise.',
    kidsExplanation:
        'Allah is merciful and does not ask us to carry what we truly cannot bear. He teaches us to ask Him for help and forgiveness.',
    keyLessons: <String>[
      'Allah is merciful in His commands',
      'Ask for pardon and help',
    ],
    reflectionPrompt:
        'How can this promise help me trust Allah in a responsibility that feels heavy?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.verified,
  ),
  _entry(
    surahNumber: 3,
    ayahNumber: 8,
    simpleSummary:
        'Believers ask Allah to keep their hearts firm after guiding them and to grant them mercy.',
    standardExplanation:
        'This dua teaches that guidance is a gift we must keep asking Allah to preserve. Even after receiving truth, the believer stays humble and asks for firmness, mercy, and safety from deviation.',
    deepExplanation:
        'The verse is one of the clearest prayers for steadfastness in the Qur\'an. Tafsir highlights that people of knowledge and faith do not become proud of their understanding; instead, they fear hearts turning after guidance and keep asking Allah, the Constant Bestower, to hold them firm by His mercy.',
    kidsExplanation:
        'We ask Allah to keep our hearts on the right path and to be merciful to us.',
    keyLessons: <String>[
      'Keep asking for steadfastness',
      'Guidance needs Allah\'s mercy',
    ],
    reflectionPrompt:
        'How often do I ask Allah not just for guidance, but for firmness upon it?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 3,
    ayahNumber: 18,
    simpleSummary:
        'Allah Himself testifies to His oneness, and the angels and people of knowledge testify with truth as well.',
    standardExplanation:
        'This verse declares Allah\'s oneness with immense honor and clarity. It also raises the rank of true knowledge, because the people of knowledge are mentioned among the witnesses to the truth of tawhid and Allah\'s perfect justice.',
    deepExplanation:
        'Mainstream tafsir explains that this is one of the greatest testimonies in the Qur\'an: Allah bears witness to His own oneness, then joins the testimony of the angels and the people of knowledge. The verse also links tawhid to justice, showing that Allah\'s perfect rule and perfect oneness belong together, and that sound knowledge should lead to reverence and truthfulness.',
    kidsExplanation:
        'Allah teaches that He alone deserves worship, and the angels and truthful people know this too.',
    keyLessons: <String>[
      'Allah alone deserves worship',
      'True knowledge leads to tawhid',
    ],
    reflectionPrompt:
        'Does my learning about Allah deepen my worship of Him alone?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 3,
    ayahNumber: 19,
    simpleSummary:
        'The religion accepted by Allah is submission to Him in truth.',
    standardExplanation:
        'This verse teaches that the path accepted by Allah is Islam: surrendering to Him with faith and obedience. It also shows that division comes when people turn away after knowledge reaches them.',
    deepExplanation:
        'Tafsir explains that Islam here means yielding to Allah alone as all the prophets called people to do, while the final revealed law is the law brought by Muhammad ﷺ. The verse also warns that disagreement after clear knowledge is not a small matter, because truth should unite hearts in humble submission rather than being pushed aside for pride or rivalry.',
    kidsExplanation:
        'Allah loves the way of submitting to Him, obeying Him, and following His truth.',
    keyLessons: <String>[
      'Islam is submission to Allah',
      'Do not turn away after knowing truth',
    ],
    reflectionPrompt:
        'Do I treat Islam as identity only, or as sincere submission to Allah?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 3,
    ayahNumber: 26,
    simpleSummary:
        'Allah alone gives and takes worldly power, honor, and provision according to His wisdom.',
    standardExplanation:
        'This verse teaches that control belongs to Allah, not to people, status, or kingdoms. He gives authority, removes it, honors whom He wills, and humbles whom He wills, so the believer\'s heart stays attached to Him rather than to appearances.',
    deepExplanation:
        'Classical tafsir presents this verse as a correction of false ideas about who truly controls the world. Rule, honor, humiliation, and provision are all in Allah\'s hand, which teaches the believer not to be deceived by temporary power nor to despair when worldly conditions change, because Allah remains the true Owner and Disposer of affairs.',
    kidsExplanation:
        'Allah is the One who gives people strength, honor, and blessings, and He controls all things with wisdom.',
    keyLessons: <String>[
      'Real power belongs to Allah',
      'Do not depend on worldly status',
    ],
    reflectionPrompt:
        'What worldly thing have I been tempted to treat as more powerful than Allah\'s decree?',
    rolloutPack: QuranAyahExplanationRolloutPack.beginnerCoreAyahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 12,
    ayahNumber: 87,
    simpleSummary:
        'Ya\'qub told his sons not to despair of Allah\'s mercy, because only those cut off from faith lose hope in Him.',
    standardExplanation:
        'This verse teaches that even after long pain and uncertainty, a believer does not give up on Allah. Hope in His mercy is part of faith, and despair is not the way of hearts that truly know Him.',
    deepExplanation:
        'In the story of Yusuf, this verse comes from a father carrying deep sorrow, yet still speaking with trust in Allah. Tafsir shows its great lesson clearly: hardship may be long and the road unclear, but a believer does not shut the door of hope, because Allah\'s mercy and unseen relief are greater than what the eye can currently see.',
    kidsExplanation:
        'Never lose hope in Allah\'s mercy. Allah can bring relief even after a long hard time.',
    keyLessons: <String>['Do not despair of Allah', 'Hope is part of faith'],
    reflectionPrompt:
        'Where do I most need to replace quiet despair with hope in Allah?',
    rolloutPack: QuranAyahExplanationRolloutPack.reflectionComfort,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 93,
    ayahNumber: 1,
    simpleSummary: 'Allah swears by the brightness of the morning.',
    standardExplanation:
        'Allah begins this surah with the light of morning to prepare the heart for comfort and reassurance. It reminds us that darkness does not last forever.',
    kidsExplanation:
        'Allah mentions the bright morning to bring comfort and hope.',
    keyLessons: <String>['Allah brings light after difficulty'],
  ),
  _entry(
    surahNumber: 93,
    ayahNumber: 2,
    simpleSummary: 'Allah also swears by the stillness of the night.',
    standardExplanation:
        'The quiet of the night is mentioned beside the morning as part of Allah\'s wise order. Both brightness and stillness are signs of His care and control.',
    kidsExplanation:
        'Allah also mentions the calm night, because both day and night are His signs.',
    keyLessons: <String>['Allah controls every moment'],
  ),
  _entry(
    surahNumber: 93,
    ayahNumber: 3,
    simpleSummary: 'Allah had not left the Prophet or hated him.',
    standardExplanation:
        'This verse comforted the Prophet when revelation paused and false claims were made about him. Allah reassured him that he was neither abandoned nor disliked.',
    deepExplanation:
        'Mainstream tafsir explains this as a direct answer to the hurt caused by the pause in revelation and by the mockery of the disbelievers. Allah Himself reassured His Messenger that divine care had not been withdrawn.',
    kidsExplanation:
        'Allah told the Prophet that He had not left him and did not dislike him.',
    keyLessons: <String>[
      'Allah does not forget His servants',
      'Do not believe hopeless thoughts',
    ],
    reflectionPrompt:
        'When I feel low, how can this verse help me think better about Allah?',
  ),
  _entry(
    surahNumber: 93,
    ayahNumber: 4,
    simpleSummary:
        'What comes later for the Prophet is better than what came before.',
    standardExplanation:
        'Allah promises the Prophet that what lies ahead for him is better than what has already passed. The verse teaches hope in Allah\'s unfolding mercy and wisdom.',
    kidsExplanation:
        'Allah promised the Prophet that what was coming would be even better.',
    keyLessons: <String>['Hope in Allah\'s promise'],
  ),
  _entry(
    surahNumber: 93,
    ayahNumber: 5,
    simpleSummary: 'Allah will keep giving until the Prophet is pleased.',
    standardExplanation:
        'Allah promises continued favor to His Messenger in this life and the next. This shows the great rank of the Prophet and the vast generosity of Allah.',
    kidsExplanation:
        'Allah promised to keep giving the Prophet good until he is pleased.',
    keyLessons: <String>['Allah is generous to His Messenger'],
  ),
  _entry(
    surahNumber: 93,
    ayahNumber: 6,
    simpleSummary: 'Allah found the Prophet an orphan and cared for him.',
    standardExplanation:
        'Allah reminds the Prophet of earlier mercy in his life, beginning with His care for him as an orphan. Remembering past help strengthens trust in Allah\'s future help.',
    kidsExplanation: 'The Prophet was an orphan, and Allah cared for him.',
    keyLessons: <String>['Remember Allah\'s past care'],
  ),
  _entry(
    surahNumber: 93,
    ayahNumber: 7,
    simpleSummary: 'Allah guided the Prophet.',
    standardExplanation:
        'Allah guided His Messenger to truth and revelation. The verse reminds us that guidance is one of Allah\'s greatest gifts.',
    kidsExplanation: 'Allah guided the Prophet to the truth.',
    keyLessons: <String>['Guidance is a gift from Allah'],
  ),
  _entry(
    surahNumber: 93,
    ayahNumber: 8,
    simpleSummary: 'Allah found the Prophet in need and enriched him.',
    standardExplanation:
        'Allah reminds His Messenger that He provided for him after need. The verse teaches gratitude and trust that provision comes from Allah.',
    kidsExplanation: 'Allah gave the Prophet what he needed.',
    keyLessons: <String>['Provision comes from Allah'],
  ),
  _entry(
    surahNumber: 93,
    ayahNumber: 9,
    simpleSummary: 'So do not be harsh with the orphan.',
    standardExplanation:
        'Because Allah cared for the Prophet when he was vulnerable, he was commanded to show mercy to orphans. Gratitude to Allah should shape how we treat weak people.',
    kidsExplanation: 'So be kind to orphans and do not treat them harshly.',
    keyLessons: <String>['Show mercy to orphans'],
  ),
  _entry(
    surahNumber: 93,
    ayahNumber: 10,
    simpleSummary: 'Do not turn away the one who asks.',
    standardExplanation:
        'This includes treating those who ask with dignity, whether they ask for help or for guidance. Faith should make us gentler, not dismissive.',
    kidsExplanation: 'Do not push away someone who comes asking for help.',
    keyLessons: <String>['Be gentle with people in need'],
  ),
  _entry(
    surahNumber: 93,
    ayahNumber: 11,
    simpleSummary: 'Speak about the blessings of your Lord.',
    standardExplanation:
        'The surah closes by calling the servant to speak gratefully about Allah\'s favors. Blessings should be remembered with gratitude, not arrogance.',
    kidsExplanation:
        'Remember Allah\'s blessings and speak about them with thanks.',
    keyLessons: <String>['Thank Allah for His blessings'],
    reflectionPrompt:
        'Which blessing from Allah should I remember more often with gratitude?',
  ),
  _entry(
    surahNumber: 94,
    ayahNumber: 1,
    simpleSummary: 'Allah expanded the Prophet\'s chest.',
    standardExplanation:
        'Allah reminds His Messenger of the inner ease, strength, and reassurance He granted him. This is part of Allah\'s care for the burden of prophethood.',
    kidsExplanation: 'Allah gave the Prophet inner ease and strength.',
    keyLessons: <String>['Allah gives strength to carry hard things'],
  ),
  _entry(
    surahNumber: 94,
    ayahNumber: 2,
    simpleSummary: 'Allah removed the burden from him.',
    standardExplanation:
        'Allah lightened what had weighed heavily on the Prophet. The verse teaches that relief from burdens comes from Allah.',
    kidsExplanation: 'Allah lifted the heavy burden from the Prophet.',
    keyLessons: <String>['Allah can lighten burdens'],
  ),
  _entry(
    surahNumber: 94,
    ayahNumber: 3,
    simpleSummary: 'It was a burden that weighed on his back.',
    standardExplanation:
        'This describes how heavy that burden felt before Allah eased it. The verse deepens the believer\'s awareness that Allah knows the true weight of what we carry.',
    kidsExplanation:
        'It was something very heavy to carry, and Allah knew that.',
    keyLessons: <String>['Allah knows our burdens'],
  ),
  _entry(
    surahNumber: 94,
    ayahNumber: 4,
    simpleSummary: 'Allah raised the Prophet\'s mention.',
    standardExplanation:
        'Allah honored His Messenger by making his mention high and beloved among the believers. It reminds us that true honor comes from Allah alone.',
    kidsExplanation: 'Allah gave the Prophet great honor.',
    keyLessons: <String>['True honor comes from Allah'],
  ),
  _entry(
    surahNumber: 94,
    ayahNumber: 5,
    simpleSummary: 'With hardship comes ease.',
    standardExplanation:
        'Allah teaches that difficulty is not the end of the story; ease is placed alongside it. The verse gives the believer patience and hope.',
    kidsExplanation: 'When things are hard, Allah can bring ease with them.',
    keyLessons: <String>['Stay hopeful in hardship'],
  ),
  _entry(
    surahNumber: 94,
    ayahNumber: 6,
    simpleSummary: 'Again Allah says that with hardship comes ease.',
    standardExplanation:
        'The repetition strengthens the promise and helps the heart trust it more deeply. Hardship should not make the believer despair of Allah\'s relief.',
    kidsExplanation: 'Allah repeats this promise so we really believe it.',
    keyLessons: <String>['Do not despair of relief'],
    reflectionPrompt:
        'How can this promise help me stay patient in something difficult right now?',
  ),
  _entry(
    surahNumber: 94,
    ayahNumber: 7,
    simpleSummary: 'When one task is done, keep striving in worship.',
    standardExplanation:
        'The believer is taught not to become empty after finishing one responsibility, but to turn with fresh effort to what pleases Allah next. This builds a life of steady devotion.',
    kidsExplanation:
        'When you finish one good thing, keep turning to the next good thing.',
    keyLessons: <String>['Keep moving toward what pleases Allah'],
  ),
  _entry(
    surahNumber: 94,
    ayahNumber: 8,
    simpleSummary: 'Turn your longing and hope to your Lord alone.',
    standardExplanation:
        'The surah closes by directing the heart completely to Allah. After effort, need, and hope, the servant keeps turning to the Lord alone.',
    kidsExplanation: 'Keep turning your heart to Allah and hoping in Him.',
    keyLessons: <String>['Hope in Allah alone'],
  ),
  _entry(
    surahNumber: 97,
    ayahNumber: 1,
    simpleSummary: 'Allah sent the Qur\'an down on the Night of Decree.',
    standardExplanation:
        'This verse honors the night in which the Qur\'an began to descend. It teaches the greatness of revelation and the special rank of that night.',
    kidsExplanation: 'The Qur\'an began to come down on a very special night.',
    keyLessons: <String>['The Qur\'an is a great gift'],
  ),
  _entry(
    surahNumber: 97,
    ayahNumber: 2,
    simpleSummary: 'The Prophet is told how great that night is.',
    standardExplanation:
        'Allah asks this to magnify the night in the mind and heart of the listener. Some things are so great that only Allah can fully teach their value.',
    kidsExplanation: 'Allah is showing us how amazing that night is.',
    keyLessons: <String>['Some blessings are greater than we first realize'],
  ),
  _entry(
    surahNumber: 97,
    ayahNumber: 3,
    simpleSummary: 'The Night of Decree is better than a thousand months.',
    standardExplanation:
        'Worship on this night is better than worship across a very long span of time. The verse encourages believers to seek this night with devotion and hope.',
    deepExplanation:
        'Mainstream tafsir explains that Allah gave this ummah a night of immense worth, making acts of worship in it weightier than a thousand months without it. This shows Allah\'s generosity in multiplying reward.',
    kidsExplanation:
        'This night is better than many, many months because Allah made it so special.',
    keyLessons: <String>['Seek special times of worship'],
  ),
  _entry(
    surahNumber: 97,
    ayahNumber: 4,
    simpleSummary:
        'The angels and the Spirit come down on that night by Allah\'s permission.',
    standardExplanation:
        'The descent of the angels on that night shows its blessing and greatness. Everything happens by Allah\'s command and permission.',
    kidsExplanation:
        'The angels come down on that special night because Allah allows it.',
    keyLessons: <String>['The night is full of blessing'],
  ),
  _entry(
    surahNumber: 97,
    ayahNumber: 5,
    simpleSummary: 'That night is peace until the break of dawn.',
    standardExplanation:
        'Allah describes the night as one of peace, blessing, and safety until morning. It is a night to fill with worship, dua, and hope.',
    kidsExplanation: 'It is a peaceful and blessed night until morning comes.',
    keyLessons: <String>['Worship in blessed times with peace and hope'],
    reflectionPrompt:
        'How can I honor the Qur\'an more deeply when blessed times arrive?',
  ),
  _entry(
    surahNumber: 103,
    ayahNumber: 1,
    simpleSummary:
        'Allah swears by time to show that our days are serious and precious.',
    standardExplanation:
        'By swearing by time, Allah draws attention to how quickly life passes and how much is at stake in what we do with it. Our days are limited, and they should not be wasted.',
    kidsExplanation:
        'Time matters. Every day is a chance to do something pleasing to Allah.',
    keyLessons: <String>['Time is valuable', 'Use your days well'],
    reflectionPrompt: 'What part of my time am I most in danger of wasting?',
  ),
  _entry(
    surahNumber: 103,
    ayahNumber: 2,
    simpleSummary:
        'People lose out when life passes without faith and righteous action.',
    standardExplanation:
        'Human beings are naturally heading toward loss unless Allah grants them a better path. Loss here is not just worldly failure, but losing what truly matters before Allah.',
    kidsExplanation:
        'If we ignore Allah and waste our lives, we lose what is most important.',
    keyLessons: <String>[
      'Real loss is spiritual loss',
      'Do not live carelessly',
    ],
    reflectionPrompt:
        'What does this verse teach me about the difference between worldly success and true success?',
  ),
  _entry(
    surahNumber: 103,
    ayahNumber: 3,
    simpleSummary:
        'The way out of loss is faith, good deeds, truth, and patience.',
    standardExplanation:
        'Allah names four foundations of salvation: true belief, righteous action, encouraging one another toward truth, and helping one another remain patient upon it. Guidance is personal and communal at the same time.',
    deepExplanation:
        'The scholars note that the surah gathers the religion into inward belief, outward action, conveying truth to others, and perseverance through hardship. This is why it is small in size but immense in meaning.',
    kidsExplanation:
        'To succeed, believe in Allah, do good, speak the truth, and stay patient.',
    keyLessons: <String>[
      'Faith needs action',
      'Help others toward truth',
      'Be patient on the right path',
    ],
    reflectionPrompt:
        'Which of these four foundations needs the most attention in my life right now?',
  ),
  _entry(
    surahNumber: 105,
    ayahNumber: 1,
    simpleSummary:
        'Allah reminds the Quraysh how He dealt with the people of the elephant.',
    standardExplanation:
        'Allah calls attention to a well-known event in which He protected His Sacred House from the army that came to destroy it. The verse teaches that Allah is fully able to defend His religion and His sanctuary.',
    kidsExplanation:
        'Allah protected the Ka\'bah when a powerful army came against it.',
    keyLessons: <String>[
      'Allah protects what He wills',
      'Power belongs to Allah',
    ],
  ),
  _entry(
    surahNumber: 105,
    ayahNumber: 2,
    simpleSummary: 'Allah made their harmful plan fail.',
    standardExplanation:
        'Their strategy, strength, and preparation did not help them against Allah\'s decree. The verse teaches that a plan built on wrongdoing cannot escape Allah\'s power.',
    kidsExplanation: 'Their bad plan did not succeed because Allah stopped it.',
    keyLessons: <String>['Wrongdoing does not defeat Allah\'s will'],
  ),
  _entry(
    surahNumber: 105,
    ayahNumber: 3,
    simpleSummary: 'Allah sent birds against them in groups.',
    standardExplanation:
        'Allah sent birds in flocks as part of the punishment upon that army. The verse shows that Allah can use even small creatures as means for a great outcome.',
    kidsExplanation: 'Allah sent birds in groups as part of His protection.',
    keyLessons: <String>['Allah can use any part of creation for His command'],
  ),
  _entry(
    surahNumber: 105,
    ayahNumber: 4,
    simpleSummary: 'The birds struck them with stones of baked clay.',
    standardExplanation:
        'The punishment came exactly as Allah willed, in a way no one could resist. This verse continues the reminder that no army can stand against Allah when He decides a matter.',
    kidsExplanation: 'Allah punished the attacking army in the way He chose.',
    keyLessons: <String>['Nothing can resist Allah when He judges'],
  ),
  _entry(
    surahNumber: 105,
    ayahNumber: 5,
    simpleSummary: 'Allah left them ruined like eaten straw.',
    standardExplanation:
        'Their end was complete humiliation and destruction after all their pride and power. The verse warns against arrogance and reminds people that safety comes only from Allah.',
    deepExplanation:
        'Classical tafsir highlights the contrast between the army\'s apparent strength and its final state of utter ruin. Allah turned a feared force into a sign of humiliation so people would know that the protection of the Sacred House came from Him alone.',
    kidsExplanation:
        'The army that looked strong became weak and ruined when Allah judged them.',
    keyLessons: <String>[
      'Do not be proud of worldly power',
      'Allah alone gives protection',
    ],
    reflectionPrompt:
        'What does this surah teach me about trusting Allah more than worldly power?',
  ),
  _entry(
    surahNumber: 106,
    ayahNumber: 1,
    simpleSummary:
        'Allah reminds Quraysh of the security and familiarity they enjoyed.',
    standardExplanation:
        'This surah begins by reminding Quraysh of the settled trade and safety they had become used to. These comforts were blessings from Allah, not achievements independent of Him.',
    kidsExplanation:
        'Allah gave Quraysh ease and stability that they had become used to.',
    keyLessons: <String>['Comfort is a blessing from Allah'],
  ),
  _entry(
    surahNumber: 106,
    ayahNumber: 2,
    simpleSummary: 'Their winter and summer journeys were made easy for them.',
    standardExplanation:
        'Allah provided them with regular journeys for trade and livelihood. The verse teaches that provision and ease in travel are favors from Allah that call for gratitude.',
    kidsExplanation:
        'Allah made their journeys for trade easier in different seasons.',
    keyLessons: <String>[
      'Provision comes from Allah',
      'Thank Allah for daily ease',
    ],
  ),
  _entry(
    surahNumber: 106,
    ayahNumber: 3,
    simpleSummary:
        'Because of these blessings, they should worship the Lord of this House.',
    standardExplanation:
        'Since Allah gave them security and provision, they were commanded to worship the Lord of the Ka\'bah alone. Blessings should lead to tawhid and grateful worship, not heedlessness.',
    deepExplanation:
        'The surah connects visible blessings to their true purpose: worship. Classical explanation emphasizes that the Lord who protected the House and sustained Quraysh is the One who deserves their obedience, not the idols placed around the sanctuary.',
    kidsExplanation:
        'Because Allah gave them so much, they should worship Him alone.',
    keyLessons: <String>[
      'Blessings should lead to worship',
      'The Lord of the Ka\'bah alone deserves worship',
    ],
    reflectionPrompt:
        'Do Allah\'s blessings make me more thankful and obedient, or only more comfortable?',
  ),
  _entry(
    surahNumber: 106,
    ayahNumber: 4,
    simpleSummary:
        'Allah fed them when they were hungry and gave them safety from fear.',
    standardExplanation:
        'Allah names two great blessings people deeply need: food and safety. The verse reminds us that both livelihood and security are gifts from Him and should increase our gratitude and worship.',
    kidsExplanation:
        'Allah gave them food when they were hungry and safety when they were afraid.',
    keyLessons: <String>[
      'Food and safety are gifts from Allah',
      'Be grateful for everyday blessings',
    ],
    reflectionPrompt:
        'Which blessings of provision and safety have I taken for granted lately?',
  ),
  _entry(
    surahNumber: 107,
    ayahNumber: 1,
    simpleSummary: 'Allah points to the one who denies the Day of Judgment.',
    standardExplanation:
        'The surah begins by exposing the kind of behavior that grows from denying the Hereafter. When people stop believing they will answer to Allah, their character and worship become corrupted.',
    kidsExplanation:
        'If someone forgets that they will answer to Allah, their actions can become hard and careless.',
    keyLessons: <String>['Belief in the Hereafter shapes character'],
  ),
  _entry(
    surahNumber: 107,
    ayahNumber: 2,
    simpleSummary: 'That person pushes away the orphan.',
    standardExplanation:
        'A sign of that denial is harsh treatment of the weak, especially the orphan who deserves mercy and protection. The verse shows that real faith appears in how we treat vulnerable people.',
    kidsExplanation: 'A hard heart shows itself by being cruel to an orphan.',
    keyLessons: <String>['Care for orphans', 'Faith should soften the heart'],
  ),
  _entry(
    surahNumber: 107,
    ayahNumber: 3,
    simpleSummary: 'They do not encourage feeding the poor.',
    standardExplanation:
        'Their selfishness is so deep that they do not even urge others to help those in need. The verse teaches that faith should move us toward generosity and concern for the poor.',
    kidsExplanation:
        'A person with a hard heart does not care about feeding poor people.',
    keyLessons: <String>['Care about the poor', 'Encourage good in others too'],
  ),
  _entry(
    surahNumber: 107,
    ayahNumber: 4,
    simpleSummary:
        'Warning belongs to those who pray without sincerity and care.',
    standardExplanation:
        'The surah now turns to people who perform prayer outwardly but whose worship is empty and corrupted. This warns that prayer must shape the heart, not become a hollow habit.',
    kidsExplanation:
        'Prayer should not be empty or careless. We should pray with honesty.',
    keyLessons: <String>['Prayer needs sincerity'],
  ),
  _entry(
    surahNumber: 107,
    ayahNumber: 5,
    simpleSummary: 'They are heedless about their prayer.',
    standardExplanation:
        'They neglect prayer, delay it, or treat it without proper concern. The verse warns against being careless with one of the greatest acts of worship.',
    kidsExplanation: 'They do not treat prayer as something important.',
    keyLessons: <String>['Do not be careless with salah'],
  ),
  _entry(
    surahNumber: 107,
    ayahNumber: 6,
    simpleSummary: 'They show off in worship.',
    standardExplanation:
        'Their worship is done to be seen by people instead of sincerely for Allah. This verse warns against riya\' and teaches that Allah looks at the truth of the heart.',
    deepExplanation:
        'Classical tafsir links these verses to people whose prayer lost sincerity and moral impact. The warning is not only about outward action, but about worship becoming a performance instead of a true act of devotion to Allah.',
    kidsExplanation:
        'They want people to notice them instead of praying for Allah alone.',
    keyLessons: <String>['Keep worship for Allah alone', 'Do not show off'],
    reflectionPrompt:
        'Is there any act of worship in my life that needs cleaner intention for Allah alone?',
  ),
  _entry(
    surahNumber: 107,
    ayahNumber: 7,
    simpleSummary: 'They even withhold small acts of help.',
    standardExplanation:
        'Their selfishness reaches even the little things people usually lend or share. The verse teaches that true faith appears in everyday helpfulness, not only in big public actions.',
    kidsExplanation: 'They do not even like helping with small things.',
    keyLessons: <String>[
      'Small acts of help matter',
      'Faith should make us useful to others',
    ],
    reflectionPrompt:
        'What simple act of help can I offer more freely for Allah\'s sake?',
  ),
  _entry(
    surahNumber: 111,
    ayahNumber: 1,
    simpleSummary: 'Abu Lahab\'s hands are ruined, and he himself is ruined.',
    standardExplanation:
        'Allah declares loss and destruction for Abu Lahab because of his stubborn hostility to the Messenger of Allah. The verse shows that close family ties do not benefit a person who rejects truth.',
    kidsExplanation:
        'Abu Lahab fought against the Prophet, and Allah declared his loss.',
    keyLessons: <String>['Opposing truth leads to loss'],
  ),
  _entry(
    surahNumber: 111,
    ayahNumber: 2,
    simpleSummary: 'His wealth and gains will not save him.',
    standardExplanation:
        'The things he relied on in worldly life could not protect him from Allah\'s judgment. Wealth without faith and obedience cannot rescue a person in the Hereafter.',
    kidsExplanation:
        'Money and status could not save him from Allah\'s judgment.',
    keyLessons: <String>['Wealth does not replace faith'],
  ),
  _entry(
    surahNumber: 111,
    ayahNumber: 3,
    simpleSummary: 'He will enter a blazing Fire.',
    standardExplanation:
        'Allah states the punishment awaiting him because of disbelief and hostility to revelation. The verse is a stern warning against prideful rejection of the truth.',
    kidsExplanation:
        'Allah warns that those who stubbornly reject the truth face severe punishment.',
    keyLessons: <String>['Rejecting truth has consequences'],
  ),
  _entry(
    surahNumber: 111,
    ayahNumber: 4,
    simpleSummary: 'His wife too carried harm and hostility.',
    standardExplanation:
        'His wife shared in hostility and harm against the Prophet, so she is mentioned with him in blame. The verse shows that helping evil is itself a serious sin.',
    kidsExplanation:
        'His wife also helped in harm and hostility against the Prophet.',
    keyLessons: <String>['Helping wrongdoing is also blameworthy'],
  ),
  _entry(
    surahNumber: 111,
    ayahNumber: 5,
    simpleSummary: 'She will have a rope of twisted fiber around her neck.',
    standardExplanation:
        'This verse completes the image of humiliation and punishment for her in the Hereafter. It is a warning that those who carry harm and hostility for the truth will meet disgrace before Allah.',
    deepExplanation:
        'The surah closes with an image of humiliation that matches the harm she carried in this life. Mainstream tafsir treats it as a real warning and a sign that supporting opposition to the Prophet brings disgrace, not honor.',
    kidsExplanation:
        'Allah warns that people who carry harm and hatred for the truth will face disgrace.',
    keyLessons: <String>[
      'Do not carry harm toward people of truth',
      'Honor comes from obedience, not hostility',
    ],
    reflectionPrompt:
        'What does this surah teach me about relying on family, wealth, or status instead of turning to Allah?',
  ),
  _entry(
    surahNumber: 108,
    ayahNumber: 1,
    simpleSummary: 'Allah has given the Prophet abundant goodness.',
    standardExplanation:
        'Allah comforts His Messenger by reminding him of the abundant gifts already granted to him in this world and the next. The verse teaches us to see Allah\'s generosity even when opponents speak with cruelty.',
    kidsExplanation:
        'Allah gave the Prophet many beautiful gifts and great honor.',
    keyLessons: <String>['Notice Allah\'s gifts', 'Allah honors His Messenger'],
    reflectionPrompt:
        'How can gratitude protect the heart when people speak harshly?',
  ),
  _entry(
    surahNumber: 108,
    ayahNumber: 2,
    simpleSummary: 'Thank Allah through prayer and sincere sacrifice.',
    standardExplanation:
        'Since Allah gives so much, the response is worship done for Him alone. The verse joins prayer and sacrifice to teach visible gratitude, sincerity, and obedience.',
    kidsExplanation:
        'When Allah gives us blessings, we thank Him by worshipping Him sincerely.',
    keyLessons: <String>[
      'Respond to blessings with worship',
      'Keep worship sincere',
    ],
    reflectionPrompt:
        'What blessing should move me toward more sincere worship today?',
  ),
  _entry(
    surahNumber: 108,
    ayahNumber: 3,
    simpleSummary: 'Those who hate the Prophet are the ones truly cut off.',
    standardExplanation:
        'Allah overturns the insults of the Prophet\'s enemies and declares that real loss belongs to the one cut off from goodness and honor. It reassures believers that truth is not diminished by mockery.',
    kidsExplanation:
        'People who mocked the Prophet did not take away the honor Allah gave him.',
    keyLessons: <String>[
      'Truth is not harmed by insults',
      'Allah defends His Messenger',
    ],
    reflectionPrompt:
        'How does this verse teach calm confidence when truth is mocked?',
  ),
  _entry(
    surahNumber: 109,
    ayahNumber: 1,
    simpleSummary: 'The Prophet is told to speak clearly to the disbelievers.',
    standardExplanation:
        'Allah instructs His Messenger to address the disbelievers openly and directly. The verse begins a firm declaration that faith cannot be mixed with false worship.',
    kidsExplanation:
        'Allah teaches the Prophet to be clear and honest about the truth.',
    keyLessons: <String>[
      'Be clear about faith',
      'Truth should be spoken with honesty',
    ],
  ),
  _entry(
    surahNumber: 109,
    ayahNumber: 2,
    simpleSummary: 'The Prophet will never worship what they worship.',
    standardExplanation:
        'This verse rejects compromise in worship. The Prophet does not share in false devotion because worship belongs to Allah alone.',
    kidsExplanation: 'We only worship Allah. We do not pray to anyone else.',
    keyLessons: <String>['Worship belongs to Allah alone'],
  ),
  _entry(
    surahNumber: 109,
    ayahNumber: 3,
    simpleSummary:
        'Those who reject faith are not worshipping Allah in the true way.',
    standardExplanation:
        'Their worship is not accepted worship of Allah because it is mixed with shirk and falsehood. The verse draws a clear line between tawhid and corrupted worship.',
    kidsExplanation:
        'Worship must be done the way Allah taught, not in made-up ways.',
    keyLessons: <String>['Correct worship follows revelation'],
  ),
  _entry(
    surahNumber: 109,
    ayahNumber: 4,
    simpleSummary:
        'The Prophet repeats that he will not worship what they worship.',
    standardExplanation:
        'The repetition strengthens the separation between truth and falsehood. Faith stays firm even when pressure is repeated.',
    kidsExplanation:
        'Sometimes we repeat the truth because it is important to stay firm.',
    keyLessons: <String>['Stay firm when pressured'],
  ),
  _entry(
    surahNumber: 109,
    ayahNumber: 5,
    simpleSummary:
        'They will not become worshippers in the way taught by the Prophet.',
    standardExplanation:
        'The verse confirms that false worship and true worship are not the same path. Guidance requires leaving shirk and following what Allah revealed.',
    kidsExplanation:
        'The path of Allah is different from paths that ignore His guidance.',
    keyLessons: <String>['Truth and falsehood are not the same'],
  ),
  _entry(
    surahNumber: 109,
    ayahNumber: 6,
    simpleSummary:
        'There is a final separation between their religion and Islam.',
    standardExplanation:
        'This closing rejects compromise while remaining clear and dignified. It is not approval of false worship; it is a firm statement that Islam stands apart from it.',
    deepExplanation:
        'The scholars explain that this verse closes the door to religious mixing while maintaining truthful clarity. Islam is a complete path whose worship and belief belong fully to Allah alone.',
    kidsExplanation:
        'Our religion teaches us to stay true to Allah, even when others choose a different way.',
    keyLessons: <String>[
      'Do not mix truth with false worship',
      'Stay gentle but firm',
    ],
    reflectionPrompt:
        'Where do I need clearer loyalty to Allah without becoming harsh or arrogant?',
  ),
  _entry(
    surahNumber: 110,
    ayahNumber: 1,
    simpleSummary: 'Allah\'s help and victory come from Him alone.',
    standardExplanation:
        'When success comes, the believer remembers that it is Allah\'s support, not personal greatness. This verse points to divine opening and the spread of truth by Allah\'s permission.',
    kidsExplanation:
        'When something good happens, we remember Allah is the One who helped.',
    keyLessons: <String>['Success comes from Allah'],
  ),
  _entry(
    surahNumber: 110,
    ayahNumber: 2,
    simpleSummary:
        'People entering Islam in groups shows Allah\'s religion becoming clear.',
    standardExplanation:
        'The verse describes a moment when the truth became widely visible and people entered Islam in numbers. It teaches that guidance of hearts belongs to Allah.',
    kidsExplanation:
        'Many people accepted Islam when Allah made the truth clear to them.',
    keyLessons: <String>['Allah guides hearts'],
  ),
  _entry(
    surahNumber: 110,
    ayahNumber: 3,
    simpleSummary:
        'When victory comes, answer with praise, gratitude, and seeking forgiveness.',
    standardExplanation:
        'Allah teaches His Messenger that moments of success should lead to tasbih, praise, and repentance, not pride. Even after a victory, the heart stays humble before Allah.',
    deepExplanation:
        'The scholars note the refinement in this command: victory does not end worship, it deepens it. Praise recognizes Allah\'s favor, and seeking forgiveness protects the servant from hidden pride and shortcomings.',
    kidsExplanation:
        'When Allah gives a win, say alhamdulillah and ask Him to forgive you. Good moments should make us humble.',
    keyLessons: <String>[
      'Do not become proud in success',
      'Praise Allah and seek forgiveness',
    ],
    reflectionPrompt:
        'When good things happen for me, do they make me more humble or more proud?',
  ),
  _entry(
    surahNumber: 112,
    ayahNumber: 1,
    simpleSummary: 'Allah is One, unique, and without partner.',
    standardExplanation:
        'The surah begins with the clearest statement of Allah\'s oneness. He is one in His lordship, worship, names, and attributes, with no equal beside Him.',
    deepExplanation:
        'This opening rejects every form of shirk by affirming Allah\'s absolute uniqueness. Classical tafsir treats the surah as a concise summary of pure tawhid.',
    kidsExplanation:
        'Allah is One. We love Him, worship Him, and never give His place to anyone else.',
    keyLessons: <String>['Allah is One', 'Do not give Allah partners'],
    reflectionPrompt:
        'How does this verse purify the way I think about Allah and worship Him?',
  ),
  _entry(
    surahNumber: 112,
    ayahNumber: 2,
    simpleSummary:
        'Allah is the One everyone depends on while He depends on no one.',
    standardExplanation:
        'Allah is the One to whom creation turns in every need, while He is perfect and free of every need. The verse teaches complete reliance on Him.',
    kidsExplanation: 'Everyone needs Allah, but Allah does not need anyone.',
    keyLessons: <String>['Depend on Allah', 'Allah needs nothing'],
  ),
  _entry(
    surahNumber: 112,
    ayahNumber: 3,
    simpleSummary: 'Allah has no child and no parent.',
    standardExplanation:
        'This verse clears Allah of human qualities and family relations that do not fit His majesty. It rejects false claims made about Him and protects pure belief.',
    kidsExplanation:
        'Allah is not like people. He was not born, and He does not have children.',
    keyLessons: <String>['Allah is unlike creation'],
  ),
  _entry(
    surahNumber: 112,
    ayahNumber: 4,
    simpleSummary: 'Nothing and no one is equal to Allah.',
    standardExplanation:
        'The surah closes by denying every comparison between Allah and creation. Nothing resembles Him in His essence, power, knowledge, or perfection.',
    deepExplanation:
        'This final verse protects the heart from both idol worship and subtler comparisons that shrink Allah to created categories. True knowledge of Allah joins affirmation with transcendence: He is known by His revealed names and attributes, yet nothing is like Him.',
    kidsExplanation: 'No one is like Allah. He is perfect in every way.',
    keyLessons: <String>['Allah has no equal'],
    reflectionPrompt:
        'How can this verse help me honor Allah more deeply in worship and dua?',
  ),
  _entry(
    surahNumber: 113,
    ayahNumber: 1,
    simpleSummary: 'Allah teaches us to seek refuge in the Lord of daybreak.',
    standardExplanation:
        'The verse opens by teaching the servant to actively seek Allah\'s protection. Mentioning daybreak points to His power to bring light after darkness and relief after fear.',
    kidsExplanation:
        'When we feel scared, we ask Allah to protect us because He brings light after darkness.',
    keyLessons: <String>['Seek Allah\'s protection', 'Allah brings relief'],
  ),
  _entry(
    surahNumber: 113,
    ayahNumber: 2,
    simpleSummary:
        'We ask Allah to protect us from the harm of what He created.',
    standardExplanation:
        'Creation contains benefit and also things that can harm, so the believer turns to Allah for safety. Protection is sought from created harms, not from Allah Himself.',
    kidsExplanation:
        'Some things in the world can hurt us, so we ask Allah to keep us safe.',
    keyLessons: <String>['Safety comes from Allah'],
  ),
  _entry(
    surahNumber: 113,
    ayahNumber: 3,
    simpleSummary: 'We seek refuge from the harms that spread in darkness.',
    standardExplanation:
        'Night can carry fear, hidden harm, and vulnerability, so Allah teaches us to turn to Him when we cannot fully see what surrounds us. The verse teaches trust in unseen moments.',
    kidsExplanation:
        'When the night feels dark or scary, we remember Allah is protecting us.',
    keyLessons: <String>['Turn to Allah in fearful moments'],
  ),
  _entry(
    surahNumber: 113,
    ayahNumber: 4,
    simpleSummary: 'We seek refuge from harmful sorcery and evil actions.',
    standardExplanation:
        'This verse teaches believers to seek Allah\'s protection from acts of sorcery and other hidden harms carried out by evil people. It acknowledges real harm while directing the heart to Allah, not superstition.',
    kidsExplanation:
        'If people try to do evil in hidden ways, Allah can still protect us.',
    keyLessons: <String>['Do not fear hidden harm more than Allah'],
  ),
  _entry(
    surahNumber: 113,
    ayahNumber: 5,
    simpleSummary: 'We seek refuge from envy when it turns into harm.',
    standardExplanation:
        'Envy becomes dangerous when someone resents a blessing and wants it removed. The verse teaches us to seek Allah\'s protection from the evil that envy can produce.',
    kidsExplanation:
        'If someone feels jealous in a bad way, we ask Allah to keep us safe and to clean our own hearts too.',
    keyLessons: <String>[
      'Seek protection from envy',
      'Do not let jealousy grow in your own heart',
    ],
    reflectionPrompt:
        'Do I ask Allah to protect me from envy while also asking Him to remove envy from my own heart?',
  ),
  _entry(
    surahNumber: 114,
    ayahNumber: 1,
    simpleSummary: 'We seek refuge in the Lord who nurtures people.',
    standardExplanation:
        'Allah teaches us to seek protection by remembering His care and lordship over humanity. He is the One who created people, sustains them, and guides them.',
    kidsExplanation:
        'Allah made people and takes care of them, so we run to Him for help.',
    keyLessons: <String>['Allah cares for people'],
  ),
  _entry(
    surahNumber: 114,
    ayahNumber: 2,
    simpleSummary: 'Allah is the true King over all people.',
    standardExplanation:
        'Calling Allah the King reminds us that every power belongs under His rule. No inner fear or outside enemy escapes His authority.',
    kidsExplanation: 'Allah is the real King over everyone.',
    keyLessons: <String>['Allah rules over all'],
  ),
  _entry(
    surahNumber: 114,
    ayahNumber: 3,
    simpleSummary:
        'Allah alone is the God of people and the One worthy of worship.',
    standardExplanation:
        'After mentioning Allah\'s lordship and kingship, the surah brings the heart to its goal: worship. The One who created and rules is also the only One who deserves devotion.',
    kidsExplanation:
        'Because Allah made us and rules over us, we worship Him only.',
    keyLessons: <String>['Worship Allah alone'],
  ),
  _entry(
    surahNumber: 114,
    ayahNumber: 4,
    simpleSummary:
        'We seek refuge from the whisperer who retreats and returns.',
    standardExplanation:
        'This verse points to the devil who whispers harmful thoughts, then retreats when Allah is remembered. It teaches believers to stay alert to harmful whispering and to increase remembrance of Allah.',
    kidsExplanation:
        'Bad whispers can come into our minds, but they become weaker when we remember Allah.',
    keyLessons: <String>['Dhikr weakens whispers'],
  ),
  _entry(
    surahNumber: 114,
    ayahNumber: 5,
    simpleSummary: 'These whispers try to enter the hearts of people.',
    standardExplanation:
        'The danger is not only outside us; whispers aim for the heart where intentions and choices are shaped. This verse trains us to guard the heart through dhikr, dua, and obedience.',
    kidsExplanation:
        'Bad ideas can try to stay in the heart, so we ask Allah to guard our hearts.',
    keyLessons: <String>['Protect the heart'],
  ),
  _entry(
    surahNumber: 114,
    ayahNumber: 6,
    simpleSummary: 'Whispers can come from jinn and from human beings.',
    standardExplanation:
        'The surah ends by teaching that harmful whispering may come from unseen devils and from people who invite others toward wrong. Protection is found in Allah through awareness, remembrance, and good company.',
    deepExplanation:
        'Classical tafsir broadens the believer\'s vigilance here: whispering can come from jinn and from people. Seeking refuge in Allah includes guarding what we listen to and whose influence we follow.',
    kidsExplanation:
        'Sometimes bad whispers come from shaytan, and sometimes from people who push us toward wrong. Allah can protect us from both.',
    keyLessons: <String>[
      'Choose company carefully',
      'Ask Allah for protection from all harmful whispers',
    ],
    reflectionPrompt:
        'What voices most influence my heart, and do they bring me closer to Allah or further away?',
  ),
  _entry(
    surahNumber: 95,
    ayahNumber: 1,
    simpleSummary:
        'Allah swears by the fig and the olive, drawing attention to signs of His wisdom and blessing.',
    standardExplanation:
        'This opening oath points to places and signs tied to Allah\'s revelation and care. It prepares the heart to listen carefully to the message that follows.',
    kidsExplanation:
        'Allah begins with special signs from His creation to help us pay attention.',
    keyLessons: <String>['Notice Allah\'s signs'],
    rolloutPack: QuranAyahExplanationRolloutPack.kidsStarter,
    reviewStatus: QuranAyahExplanationReviewStatus.kidsReviewed,
  ),
  _entry(
    surahNumber: 95,
    ayahNumber: 2,
    simpleSummary:
        'Allah also swears by Mount Sinai, a place connected to revelation.',
    standardExplanation:
        'Mount Sinai reminds us of Allah\'s guidance to His prophets. The verse ties this surah to the long chain of revelation that leads people back to truth.',
    kidsExplanation:
        'Allah mentions a mountain where He gave guidance, so we remember His messages are a gift.',
    keyLessons: <String>['Guidance is a gift from Allah'],
    rolloutPack: QuranAyahExplanationRolloutPack.kidsStarter,
    reviewStatus: QuranAyahExplanationReviewStatus.kidsReviewed,
  ),
  _entry(
    surahNumber: 95,
    ayahNumber: 3,
    simpleSummary:
        'Allah swears by this secure city, the sacred city of Makkah.',
    standardExplanation:
        'The secure city points to Makkah, the place of the Sacred House. The verse reminds people of Allah\'s protection, sacred signs, and the honor of places He chooses.',
    kidsExplanation:
        'Allah mentions Makkah, the blessed city He made special and safe.',
    keyLessons: <String>['Honor what Allah made sacred'],
    rolloutPack: QuranAyahExplanationRolloutPack.kidsStarter,
    reviewStatus: QuranAyahExplanationReviewStatus.kidsReviewed,
  ),
  _entry(
    surahNumber: 95,
    ayahNumber: 4,
    simpleSummary:
        'Allah created human beings in a beautiful and upright form.',
    standardExplanation:
        'Allah made the human being with dignity, balance, and the ability to know truth and choose what is right. The verse calls us to honor that gift by living in obedience to Him.',
    deepExplanation:
        'Classical tafsir highlights the special form and capacity Allah gave the human being compared with much of creation. This honor is not for pride, but for grateful obedience and responsible living.',
    kidsExplanation:
        'Allah made people in a noble way and gave us the ability to choose good.',
    keyLessons: <String>[
      'Allah gave human beings dignity',
      'Use your gifts for good',
    ],
    reflectionPrompt:
        'How can I use the abilities Allah gave me in a way that pleases Him?',
    rolloutPack: QuranAyahExplanationRolloutPack.kidsStarter,
    reviewStatus: QuranAyahExplanationReviewStatus.kidsReviewed,
  ),
  _entry(
    surahNumber: 95,
    ayahNumber: 5,
    simpleSummary:
        'Then some people are reduced to the lowest state when they reject Allah and waste that gift.',
    standardExplanation:
        'After being honored, a person can fall very low by turning away from faith and obedience. The verse warns that human dignity is not preserved through pride, but through staying near to Allah.',
    deepExplanation:
        'Mainstream tafsir explains this lowering as the fate of those who reject the truth after being given the ability to know and follow it. The warning shows how serious it is to misuse the gifts Allah gave.',
    kidsExplanation:
        'If people turn away from Allah, they can fall from the honor Allah gave them.',
    keyLessons: <String>[
      'Do not waste the gifts Allah gave',
      'Real honor comes from obedience',
    ],
    rolloutPack: QuranAyahExplanationRolloutPack.kidsStarter,
    reviewStatus: QuranAyahExplanationReviewStatus.kidsReviewed,
  ),
  _entry(
    surahNumber: 95,
    ayahNumber: 6,
    simpleSummary:
        'Believers who do good deeds are excepted and will have an unending reward.',
    standardExplanation:
        'Allah makes clear that faith and righteous action lift a person and protect them from loss. Those who believe and do good are promised a reward that does not end.',
    kidsExplanation:
        'People who believe in Allah and do good will have a lasting reward with Him.',
    keyLessons: <String>[
      'Faith and good deeds protect us from loss',
      'Allah\'s reward lasts',
    ],
    rolloutPack: QuranAyahExplanationRolloutPack.kidsStarter,
    reviewStatus: QuranAyahExplanationReviewStatus.kidsReviewed,
  ),
  _entry(
    surahNumber: 95,
    ayahNumber: 7,
    simpleSummary:
        'After these signs, what still makes a person deny the Day of Recompense?',
    standardExplanation:
        'When Allah\'s signs, revelation, and the reality of human life are all clear, denial of the final judgment becomes even less excusable. The verse calls the heart to honesty about accountability.',
    kidsExplanation:
        'After all these signs, why would someone still deny that they will answer to Allah?',
    keyLessons: <String>['Remember accountability'],
    rolloutPack: QuranAyahExplanationRolloutPack.kidsStarter,
    reviewStatus: QuranAyahExplanationReviewStatus.kidsReviewed,
  ),
  _entry(
    surahNumber: 95,
    ayahNumber: 8,
    simpleSummary: 'Is Allah not the most just of all judges?',
    standardExplanation:
        'The surah closes by reminding us that Allah judges with perfect justice. No deed is lost, no truth is confused, and no injustice is done before Him.',
    kidsExplanation:
        'Allah is the fairest and wisest Judge, and He never does wrong.',
    keyLessons: <String>['Allah judges with perfect justice'],
    reflectionPrompt:
        'How does remembering Allah\'s perfect justice help me trust Him more?',
    rolloutPack: QuranAyahExplanationRolloutPack.kidsStarter,
    reviewStatus: QuranAyahExplanationReviewStatus.kidsReviewed,
  ),
  _entry(
    surahNumber: 96,
    ayahNumber: 1,
    simpleSummary: 'Read in the name of your Lord who created all things.',
    standardExplanation:
        'The first revealed command begins with knowledge tied to Allah, not separated from Him. Learning becomes a worshipful act when it starts in the name of the Lord who created.',
    deepExplanation:
        'Classical tafsir treats this opening as the beginning of revelation and a sign that sacred knowledge starts with Allah\'s name, help, and authority. It joins reading with worship and reminds us that true knowledge should lead back to the Creator.',
    kidsExplanation:
        'Allah taught us that learning should begin by remembering Him.',
    keyLessons: <String>[
      'Begin learning with Allah',
      'Knowledge should lead to worship',
    ],
    reflectionPrompt:
        'Do I connect learning and reading back to Allah, or treat them as separate from Him?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 96,
    ayahNumber: 2,
    simpleSummary: 'Allah created the human being from a clinging substance.',
    standardExplanation:
        'This verse reminds the human being of humble beginnings. Remembering how Allah created us protects the heart from arrogance and makes us more grateful to Him.',
    kidsExplanation:
        'Allah created us from a tiny beginning, so we should stay humble and thankful.',
    keyLessons: <String>['Stay humble before Allah'],
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 96,
    ayahNumber: 3,
    simpleSummary: 'Read, for your Lord is the Most Generous.',
    standardExplanation:
        'Allah repeats the command to read and joins it to His generosity. This teaches that knowledge, understanding, and guidance are gifts from a generous Lord.',
    kidsExplanation:
        'Allah is generous, and one of His great gifts is teaching us.',
    keyLessons: <String>['Knowledge is a gift from Allah'],
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 96,
    ayahNumber: 4,
    simpleSummary: 'Allah taught by the pen.',
    standardExplanation:
        'Allah gave people the means to write, preserve, and pass knowledge from one generation to the next. The verse honors learning and the tools that help truth remain clear.',
    kidsExplanation:
        'Allah taught people how to write so knowledge could be kept and shared.',
    keyLessons: <String>['Writing can serve truth and learning'],
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 96,
    ayahNumber: 5,
    simpleSummary: 'Allah taught the human being what they did not know.',
    standardExplanation:
        'Everything we truly know comes first from Allah\'s permission and teaching. The verse teaches humility, gratitude, and a love of beneficial knowledge.',
    kidsExplanation:
        'Whatever good knowledge we have is something Allah helped us learn.',
    keyLessons: <String>[
      'Be grateful for knowledge',
      'Allah is the true Teacher',
    ],
    reflectionPrompt:
        'How can I seek knowledge with more humility and gratitude to Allah?',
    rolloutPack: QuranAyahExplanationRolloutPack.foundations,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 99,
    ayahNumber: 1,
    simpleSummary:
        'When the earth is shaken with its great final shaking, a new stage begins.',
    standardExplanation:
        'This surah opens with the mighty earthquake of the Last Day. It reminds us that the world as we know it will end by Allah\'s command and that accountability is real.',
    kidsExplanation:
        'One day Allah will shake the earth in a huge way, because the Last Day is real.',
    keyLessons: <String>['Remember the Last Day'],
    rolloutPack: QuranAyahExplanationRolloutPack.reflectionComfort,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 99,
    ayahNumber: 2,
    simpleSummary: 'The earth will bring out what is inside it.',
    standardExplanation:
        'The earth will release its burdens and hidden contents by Allah\'s command. The verse deepens the sense that nothing remains concealed when the Hereafter begins.',
    kidsExplanation:
        'The earth will bring out what was hidden inside it because Allah commands it.',
    keyLessons: <String>['Nothing stays hidden from Allah'],
    rolloutPack: QuranAyahExplanationRolloutPack.reflectionComfort,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 99,
    ayahNumber: 3,
    simpleSummary: 'People will ask in shock what is happening to the earth.',
    standardExplanation:
        'Human beings will be stunned by the events of that day. The verse captures the fear and amazement of seeing creation changed by Allah\'s command.',
    kidsExplanation:
        'People will be shocked and wonder what is happening when the earth changes.',
    keyLessons: <String>['The Last Day will be overwhelming'],
    rolloutPack: QuranAyahExplanationRolloutPack.reflectionComfort,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 99,
    ayahNumber: 4,
    simpleSummary: 'That day the earth will tell its news.',
    standardExplanation:
        'Allah will allow the earth to speak of what happened upon it. This teaches that creation itself can become a witness by Allah\'s permission.',
    deepExplanation:
        'Mainstream tafsir explains that the earth will report what people did upon it because Allah wills it to bear witness. The verse strengthens the believer\'s awareness that deeds are not forgotten.',
    kidsExplanation:
        'Allah can make the earth speak about what happened on it.',
    keyLessons: <String>['Your deeds are witnessed'],
    rolloutPack: QuranAyahExplanationRolloutPack.reflectionComfort,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 99,
    ayahNumber: 5,
    simpleSummary: 'It will do this because your Lord commanded it.',
    standardExplanation:
        'The earth does not act on its own; it obeys Allah completely. This verse brings the heart back to the true center of the scene: Allah\'s command and authority over all creation.',
    kidsExplanation: 'The earth will do this only because Allah tells it to.',
    keyLessons: <String>['Everything obeys Allah\'s command'],
    rolloutPack: QuranAyahExplanationRolloutPack.reflectionComfort,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 99,
    ayahNumber: 6,
    simpleSummary:
        'On that day people will come forward in separate groups to see their deeds.',
    standardExplanation:
        'Humanity will stand in ordered groups to be shown the reality of what they did. The verse reminds us that every person will face their own record before Allah.',
    kidsExplanation:
        'People will come in groups to see what they did in their lives.',
    keyLessons: <String>['Everyone will answer for their deeds'],
    rolloutPack: QuranAyahExplanationRolloutPack.reflectionComfort,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 99,
    ayahNumber: 7,
    simpleSummary: 'Whoever does even the smallest amount of good will see it.',
    standardExplanation:
        'No act of goodness is lost with Allah, even when it seems tiny to us. The verse encourages sincerity in every small good deed.',
    kidsExplanation:
        'Even a very small good deed matters to Allah, and He will not forget it.',
    keyLessons: <String>['Small good deeds matter'],
    rolloutPack: QuranAyahExplanationRolloutPack.reflectionComfort,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 99,
    ayahNumber: 8,
    simpleSummary:
        'Whoever does even the smallest amount of evil will see it too.',
    standardExplanation:
        'Just as no good is lost, no evil is ignored. The verse teaches carefulness, repentance, and the importance of taking even small sins seriously.',
    kidsExplanation:
        'Even small wrongs matter, so we should turn back to Allah and try to do what is right.',
    keyLessons: <String>[
      'Small sins should not be ignored',
      'Turn back to Allah quickly',
    ],
    reflectionPrompt:
        'What small good can I increase, and what small wrong should I stop overlooking?',
    rolloutPack: QuranAyahExplanationRolloutPack.reflectionComfort,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 101,
    ayahNumber: 1,
    simpleSummary: 'The Striking Calamity is coming.',
    standardExplanation:
        'This name points to the overwhelming event of the Day of Judgment. It strikes hearts with seriousness and prepares the listener for what follows.',
    kidsExplanation:
        'Allah tells us about a very great and serious day that will surely come.',
    keyLessons: <String>['The Day of Judgment is real'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 101,
    ayahNumber: 2,
    simpleSummary: 'What is the Striking Calamity?',
    standardExplanation:
        'Allah asks this to magnify the event in our minds. Some realities are so immense that the question itself makes the heart pause.',
    kidsExplanation:
        'Allah asks this question to show how huge that day will be.',
    keyLessons: <String>['Some warnings should make us pause deeply'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 101,
    ayahNumber: 3,
    simpleSummary: 'And what can make you know what the Striking Calamity is?',
    standardExplanation:
        'The second question increases the sense of awe and reminds us that Allah alone can teach us the true reality of the Hereafter. Human imagination cannot fully contain it.',
    kidsExplanation: 'Only Allah can truly tell us how serious that day is.',
    keyLessons: <String>['The Hereafter is greater than we imagine'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 101,
    ayahNumber: 4,
    simpleSummary: 'On that day people will be scattered like moths.',
    standardExplanation:
        'Human beings will move in confusion and fear, like creatures scattering in every direction. The verse shows how powerless people will feel before the events of that day.',
    kidsExplanation:
        'People will be moving in fear and confusion because that day will be overwhelming.',
    keyLessons: <String>['The Last Day will remove worldly pride'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 101,
    ayahNumber: 5,
    simpleSummary: 'The mountains will become like fluffed wool.',
    standardExplanation:
        'Even the strongest parts of the earth will lose their firmness on that day. The verse reminds us that if mountains are shaken, then human power is even less able to stand on its own.',
    kidsExplanation:
        'Even mountains will become light and scattered when Allah changes the world.',
    keyLessons: <String>['Only Allah is truly strong'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 101,
    ayahNumber: 6,
    simpleSummary: 'The one whose scales are heavy with good will succeed.',
    standardExplanation:
        'Allah teaches that deeds will matter and be weighed with justice. A heavy scale means a life filled with faith, sincerity, and righteous action.',
    kidsExplanation:
        'If a person\'s good deeds are weighty, that is a sign of success with Allah.',
    keyLessons: <String>['Good deeds have weight with Allah'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 101,
    ayahNumber: 7,
    simpleSummary: 'That person will be in a pleasing and happy life.',
    standardExplanation:
        'The result of success is a life of joy and contentment in the Hereafter. The verse gives hope that obedience to Allah leads to lasting peace.',
    kidsExplanation:
        'The one who succeeds will have a happy life in the Hereafter.',
    keyLessons: <String>['True success leads to lasting happiness'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 101,
    ayahNumber: 8,
    simpleSummary: 'The one whose scales are light will be in loss.',
    standardExplanation:
        'A light scale means a person came with little real goodness before Allah. The verse warns us not to rely on appearances while neglecting faith and righteous deeds.',
    kidsExplanation:
        'If someone comes with very little good, that is a sign of great loss.',
    keyLessons: <String>['Do not come empty before Allah'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 101,
    ayahNumber: 9,
    simpleSummary: 'Their refuge will be the abyss.',
    standardExplanation:
        'This is a severe image of downfall and punishment for the one who failed before Allah. The verse is meant to wake the heart before that day comes.',
    kidsExplanation:
        'Allah warns of a terrible end for the one who turns away and comes with loss.',
    keyLessons: <String>['Take Allah\'s warnings seriously'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 101,
    ayahNumber: 10,
    simpleSummary: 'And what can make you know what that is?',
    standardExplanation:
        'Allah asks again to magnify the seriousness of the punishment. The question prepares the heart for a warning that should not be treated lightly.',
    kidsExplanation:
        'Allah asks this to show that the warning is very serious.',
    keyLessons: <String>['Do not treat the Hereafter lightly'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 101,
    ayahNumber: 11,
    simpleSummary: 'It is a blazing fire.',
    standardExplanation:
        'The surah closes with a direct warning about the Fire. This ending calls the believer to repentance, seriousness, and preparation before meeting Allah.',
    deepExplanation:
        'Classical explanation reads the ending as a plain and forceful warning, not a symbolic softening of judgment. The short surah moves quickly so the heart remembers that deeds truly lead somewhere.',
    kidsExplanation:
        'Allah warns us clearly so we turn back to Him before it is too late.',
    keyLessons: <String>[
      'Warnings are meant to guide us back to Allah',
      'Repent before it is too late',
    ],
    reflectionPrompt:
        'What should I prepare more seriously before I stand before Allah?',
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 102,
    ayahNumber: 1,
    simpleSummary: 'Rivalry in piling up worldly things distracts people.',
    standardExplanation:
        'This surah warns against being consumed by competition for more wealth, status, and numbers. When the heart is distracted by worldly increase, it forgets what matters most before Allah.',
    kidsExplanation:
        'Wanting more and more can distract people from remembering Allah.',
    keyLessons: <String>['Do not let dunya distract the heart'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 102,
    ayahNumber: 2,
    simpleSummary: 'That distraction continues until people reach the graves.',
    standardExplanation:
        'Many remain busy with worldly competition until death comes. The verse warns us not to delay turning back to Allah until life ends.',
    kidsExplanation:
        'Some people stay distracted by the world until their life is over.',
    keyLessons: <String>['Do not delay returning to Allah'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 102,
    ayahNumber: 3,
    simpleSummary: 'Soon you will come to know the truth.',
    standardExplanation:
        'Allah warns that people will soon discover the reality they ignored. The tone is a wake-up call before regret becomes useless.',
    kidsExplanation: 'One day people will clearly see the truth they ignored.',
    keyLessons: <String>['Wake up before regret comes'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 102,
    ayahNumber: 4,
    simpleSummary: 'Again Allah says: soon you will know.',
    standardExplanation:
        'The repeated warning presses the lesson more deeply into the heart. Repetition here is mercy, because Allah is warning before the final meeting.',
    kidsExplanation:
        'Allah repeats the warning so people will stop and think seriously.',
    keyLessons: <String>['Allah warns us before judgment comes'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 102,
    ayahNumber: 5,
    simpleSummary:
        'If only you knew with certain knowledge, you would live differently.',
    standardExplanation:
        'True certainty about the Hereafter changes priorities, ambitions, and daily choices. The verse implies that shallow certainty is part of what lets distraction continue.',
    kidsExplanation:
        'If people truly remembered the Hereafter, they would not stay so distracted.',
    keyLessons: <String>['Certainty should change how we live'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 102,
    ayahNumber: 6,
    simpleSummary: 'You will surely see the Fire.',
    standardExplanation:
        'Allah gives a direct warning of the reality of punishment in the Hereafter. The purpose of the warning is not despair, but urgent repentance and seriousness.',
    kidsExplanation:
        'Allah warns people clearly so they turn back to Him before judgment comes.',
    keyLessons: <String>['Take Allah\'s warning seriously'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 102,
    ayahNumber: 7,
    simpleSummary: 'Then you will see it with the eye of certainty.',
    standardExplanation:
        'What people denied or treated lightly will become undeniable on that day. The verse warns us not to wait for forced certainty when willing faith is still possible now.',
    kidsExplanation:
        'On that day the truth will be seen clearly, with no doubt left.',
    keyLessons: <String>['Do not wait for the truth to be forced on you'],
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
  _entry(
    surahNumber: 102,
    ayahNumber: 8,
    simpleSummary: 'Then you will be asked about the blessings you enjoyed.',
    standardExplanation:
        'The surah ends by reminding us that blessings are not only gifts; they are also a trust. We will be asked how we used health, time, provision, and comfort before Allah.',
    deepExplanation:
        'Classical tafsir explains that people will be questioned about the favors Allah gave them and whether those blessings led to gratitude and obedience. The warning does not deny blessing; it teaches responsible gratitude.',
    kidsExplanation:
        'Allah will ask how we used the good things He gave us, so we should be thankful and use them well.',
    keyLessons: <String>[
      'Blessings are a trust',
      'Be grateful and use blessings well',
    ],
    reflectionPrompt:
        'Which blessing in my life most needs more gratitude and better use?',
    rolloutPack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
    reviewStatus: QuranAyahExplanationReviewStatus.reviewed,
  ),
];
