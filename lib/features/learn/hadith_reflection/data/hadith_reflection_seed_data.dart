import '../domain/hadith_reflection_models.dart';

const List<HadithReflectionScenarioSeed> hadithReflectionScenarioSeeds = [
  HadithReflectionScenarioSeed(
    id: 'kids_smile_welcome',
    hadithId: 'smiling_is_charity',
    mode: HadithReflectionMode.kids,
    category: 'kindness',
    theme: 'kindness',
    difficulty: 8,
    shortTeachingSummary: 'A small act of cheer can become an act of charity.',
    reflectionPrompt: 'How can you make someone feel welcomed today?',
    scenarioTitle: 'Welcoming a new classmate',
    scenarioDescription:
        'A new student looks nervous at the start of class and does not know anyone yet.',
    choices: [
      HadithReflectionChoice(
        id: 'smile_and_sit',
        label: 'Smile, greet them, and offer them a seat beside you.',
        feedbackText:
            'This matches the Hadith well. A warm smile and kind welcome can calm someone who feels alone.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'watch_quietly',
        label: 'Stay quiet because someone else will probably help.',
        feedbackText:
            'You are not being hurtful, but you are missing a chance to show cheerful kindness yourself.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'laugh_with_friends',
        label:
            'Keep joking with your friends and let the new student figure it out.',
        feedbackText:
            'This needs reflection. The Hadith encourages active kindness, not leaving someone feeling unnoticed.',
      ),
    ],
    tags: ['kindness', 'friendship', 'welcome'],
    levelBandMin: 1,
    levelBandMax: 10,
    helpText:
        'Look for the choice that makes another person feel safe and seen.',
    isDailyEligible: true,
    dailyThemes: ['kindness', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'kids_neighbor_sharing',
    hadithId: 'honor_your_neighbor',
    mode: HadithReflectionMode.kids,
    category: 'community',
    theme: 'community',
    difficulty: 9,
    shortTeachingSummary:
        'Good faith is shown through care and respect for neighbors.',
    reflectionPrompt: 'What does being a good neighbor look like for you?',
    scenarioTitle: 'Playing near a neighbor’s home',
    scenarioDescription:
        'You and your friends are playing loudly outside while your elderly neighbor is resting.',
    choices: [
      HadithReflectionChoice(
        id: 'lower_volume',
        label: 'Move farther away and keep your voices lower.',
        feedbackText:
            'This is best aligned. You are enjoying yourself while still respecting your neighbor.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'ignore_once',
        label: 'Keep playing because it is only for a little while.',
        feedbackText:
            'This is understandable but not the strongest response. The Hadith calls for considerate care, not just convenience.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'knock_prank',
        label: 'Ring the bell for fun and run away.',
        feedbackText:
            'This goes against the teaching. A neighbor should feel safe and respected because of you.',
      ),
    ],
    tags: ['neighbors', 'community', 'respect'],
    levelBandMin: 1,
    levelBandMax: 10,
    isDailyEligible: true,
    dailyThemes: ['community', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'kids_home_help',
    hadithId: 'prophet_helped_family_home',
    mode: HadithReflectionMode.kids,
    category: 'family',
    theme: 'family',
    difficulty: 10,
    shortTeachingSummary:
        'Serving your family at home is a noble and prophetic habit.',
    reflectionPrompt: 'Which small jobs can you do before being asked?',
    scenarioTitle: 'Helping after dinner',
    scenarioDescription:
        'Your family is cleaning up after dinner while you are about to start a game.',
    choices: [
      HadithReflectionChoice(
        id: 'help_first',
        label: 'Pause your game and help clear the table first.',
        feedbackText:
            'This is best aligned. Helping at home reflects the example of the Prophet, peace and blessings be upon him.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'only_if_asked',
        label: 'Wait until someone asks you directly.',
        feedbackText:
            'You may still help later, but this misses the beauty of serving willingly and early.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'hide_room',
        label: 'Go to your room quickly so you do not get assigned a chore.',
        feedbackText:
            'This needs reflection. The teaching points us toward service, not avoiding responsibility.',
      ),
    ],
    tags: ['family', 'service', 'home'],
    levelBandMin: 1,
    levelBandMax: 12,
    isDailyEligible: true,
    dailyThemes: ['family', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'kids_mercy_younger',
    hadithId: 'mercy_young_respect_elders',
    mode: HadithReflectionMode.kids,
    category: 'respect',
    theme: 'respect',
    difficulty: 10,
    shortTeachingSummary:
        'Mercy toward the young and respect toward elders are signs of good character.',
    reflectionPrompt:
        'How do kindness and respect show up with people older and younger than you?',
    scenarioTitle: 'A younger child makes a mistake',
    scenarioDescription:
        'A younger child spills some markers while trying to join your activity.',
    choices: [
      HadithReflectionChoice(
        id: 'help_gently',
        label: 'Help clean up and show them how to use the markers gently.',
        feedbackText:
            'This is best aligned. Mercy means guiding gently instead of embarrassing someone.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'tell_teacher_only',
        label: 'Call an adult to fix it without helping yourself.',
        feedbackText:
            'This is not harsh, but it misses a chance to respond with direct mercy and care.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'mock_them',
        label: 'Tell them they are too little and should leave.',
        feedbackText:
            'This conflicts with the Hadith. Mercy and respect are meant to shape our tone and actions.',
      ),
    ],
    tags: ['respect', 'mercy', 'character'],
    levelBandMin: 1,
    levelBandMax: 12,
    isDailyEligible: true,
    dailyThemes: ['respect', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'kids_truth_lost_item',
    hadithId: 'truthfulness_to_righteousness',
    mode: HadithReflectionMode.kids,
    category: 'honesty',
    theme: 'honesty',
    difficulty: 11,
    shortTeachingSummary:
        'Truthfulness leads toward righteousness and strengthens trust.',
    reflectionPrompt: 'Why is honesty important even when it feels hard?',
    scenarioTitle: 'Finding a lost pencil case',
    scenarioDescription:
        'You find a nice pencil case on the floor at school and nobody sees you pick it up.',
    choices: [
      HadithReflectionChoice(
        id: 'turn_in',
        label: 'Take it to the teacher or lost-and-found right away.',
        feedbackText:
            'This is best aligned. Truthfulness includes being trustworthy with other people’s belongings.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'keep_until_asked',
        label: 'Keep it for a while and return it only if someone asks.',
        feedbackText:
            'This is closer to honesty than stealing, but it still weakens trust because it delays doing the right thing.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'use_it_secretly',
        label: 'Use it quietly because maybe nobody will claim it.',
        feedbackText:
            'This needs reflection. The Hadith teaches that honesty should guide us before convenience does.',
      ),
    ],
    tags: ['honesty', 'trust', 'school'],
    levelBandMin: 5,
    levelBandMax: 15,
    helpText: 'The best choice protects trust even when nobody is watching.',
    isDailyEligible: true,
    dailyThemes: ['honesty', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'kids_anger_game',
    hadithId: 'anger_control_strength',
    mode: HadithReflectionMode.kids,
    category: 'anger',
    theme: 'anger',
    difficulty: 12,
    shortTeachingSummary:
        'Real strength includes controlling yourself when upset.',
    reflectionPrompt: 'What helps you slow down before reacting in anger?',
    scenarioTitle: 'Losing a game unfairly',
    scenarioDescription:
        'You feel upset because another child changed the rules and you lost the game.',
    choices: [
      HadithReflectionChoice(
        id: 'step_breathe',
        label: 'Step back, breathe, and explain calmly what upset you.',
        feedbackText:
            'This is best aligned. Strength here means choosing self-control before reacting.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'silent_walk',
        label: 'Walk away without speaking and cool down first.',
        feedbackText:
            'This can be acceptable when it helps you avoid saying something harmful, though calm communication is still important.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'throw_pieces',
        label: 'Knock the game over so everyone knows you are angry.',
        feedbackText:
            'This goes against the teaching. Anger does not become strength just because it is loud.',
      ),
    ],
    tags: ['anger', 'self-control', 'sportsmanship'],
    levelBandMin: 5,
    levelBandMax: 18,
    isDailyEligible: true,
    dailyThemes: ['anger', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'kids_share_snack',
    hadithId: 'love_for_brother',
    mode: HadithReflectionMode.kids,
    category: 'kindness',
    theme: 'kindness',
    difficulty: 9,
    shortTeachingSummary:
        'Faith grows when you want good for others as you want it for yourself.',
    reflectionPrompt:
        'What do you enjoy receiving from others? How can you give that too?',
    scenarioTitle: 'Snack time',
    scenarioDescription:
        'You notice a friend forgot their snack and looks embarrassed while everyone else is eating.',
    choices: [
      HadithReflectionChoice(
        id: 'share_half',
        label: 'Offer to share some of your snack with them.',
        feedbackText:
            'This is best aligned. Wanting ease and care for someone else reflects the Hadith beautifully.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'finish_then_offer',
        label: 'Eat first and offer help only if there is extra left.',
        feedbackText:
            'This is kinder than ignoring them, but it does not reflect the same level of care you would hope to receive.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'pretend_not_see',
        label: 'Pretend not to notice so you do not have to share.',
        feedbackText:
            'This needs reflection. The Hadith calls us to active concern for others, not convenient silence.',
      ),
    ],
    tags: ['kindness', 'sharing', 'friendship'],
    levelBandMin: 1,
    levelBandMax: 12,
    isDailyEligible: true,
    dailyThemes: ['kindness', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'kids_family_charity',
    hadithId: 'charity_toward_family',
    mode: HadithReflectionMode.kids,
    category: 'family',
    theme: 'family',
    difficulty: 11,
    shortTeachingSummary:
        'Goodness shown to your own family still counts as sincere charity and care.',
    reflectionPrompt: 'How can you serve the people closest to you this week?',
    scenarioTitle: 'Helping a sibling study',
    scenarioDescription:
        'Your younger sibling asks for help with homework right before your free time begins.',
    choices: [
      HadithReflectionChoice(
        id: 'help_with_patience',
        label:
            'Help them patiently for a little while before your own activity.',
        feedbackText:
            'This is best aligned. Supporting family with sincerity is valuable in the sight of Allah.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'tell_parent_later',
        label: 'Tell them to wait until a parent is free instead.',
        feedbackText:
            'This may be acceptable if you truly cannot help, but it misses an easy chance to serve your family directly.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'annoyed_ignore',
        label: 'Tell them not to bother you because your time matters more.',
        feedbackText:
            'This needs reflection. The Hadith teaches us not to treat family care as an irritation.',
      ),
    ],
    tags: ['family', 'service', 'charity'],
    levelBandMin: 5,
    levelBandMax: 18,
    isDailyEligible: true,
    dailyThemes: ['family', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'kids_keep_promise',
    hadithId: 'trust_honesty',
    mode: HadithReflectionMode.kids,
    category: 'honesty',
    theme: 'honesty',
    difficulty: 12,
    shortTeachingSummary:
        'Faith is connected to trustworthiness and keeping what is entrusted to you.',
    reflectionPrompt: 'What makes people feel safe trusting you?',
    scenarioTitle: 'Returning a borrowed book',
    scenarioDescription:
        'A friend lent you a book and reminds you they need it back today, but you still want to use it tonight.',
    choices: [
      HadithReflectionChoice(
        id: 'return_on_time',
        label: 'Return it when promised and thank them for trusting you.',
        feedbackText:
            'This is best aligned. Trust grows when you return what belongs to others without excuses.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'ask_extra_day',
        label: 'Ask politely if you may keep it one more day.',
        feedbackText:
            'This can be acceptable because you are honest about the situation, but the best response is still to honor the original trust if possible.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'avoid_friend',
        label: 'Avoid them and hope they forget about it.',
        feedbackText:
            'This weakens trust and does not match the Hadith’s call to honesty and responsibility.',
      ),
    ],
    tags: ['trust', 'honesty', 'friendship'],
    levelBandMin: 5,
    levelBandMax: 18,
    isDailyEligible: true,
    dailyThemes: ['honesty', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'kids_gentle_words',
    hadithId: 'gentleness_all_matters',
    mode: HadithReflectionMode.kids,
    category: 'speech',
    theme: 'speech',
    difficulty: 12,
    shortTeachingSummary:
        'Gentleness brings beauty to a situation, while harshness harms it.',
    reflectionPrompt: 'How can your words make a tense moment softer?',
    scenarioTitle: 'Correcting a friend',
    scenarioDescription:
        'Your friend says something incorrect during group work and you know the right answer.',
    choices: [
      HadithReflectionChoice(
        id: 'gently_correct',
        label: 'Correct them kindly and help the group continue.',
        feedbackText:
            'This is best aligned. Gentleness helps truth be received without hurting hearts.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'say_nothing',
        label: 'Stay silent so they do not feel embarrassed.',
        feedbackText:
            'This may avoid awkwardness, but it also misses a chance to combine truth with gentle adab.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'mock_publicly',
        label: 'Point out the mistake in a way that makes everyone laugh.',
        feedbackText:
            'This conflicts with the teaching. Gentleness is lost when correction becomes humiliation.',
      ),
    ],
    tags: ['speech', 'gentleness', 'adab'],
    levelBandMin: 5,
    levelBandMax: 20,
    isDailyEligible: true,
    dailyThemes: ['speech', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_intentions_service',
    hadithId: 'intentions_core',
    mode: HadithReflectionMode.adult,
    category: 'sincerity',
    theme: 'sincerity',
    difficulty: 28,
    shortTeachingSummary:
        'Actions are judged by intentions, so the heart must be examined alongside the deed.',
    reflectionPrompt:
        'What changes when you check your intention before doing something visibly good?',
    scenarioTitle: 'Public volunteering',
    scenarioDescription:
        'You are invited to help organize a community project that will likely be praised online.',
    choices: [
      HadithReflectionChoice(
        id: 'renew_intention',
        label:
            'Participate, renew your intention for Allah, and keep your heart under review.',
        feedbackText:
            'This is best aligned. The Hadith does not ask you to abandon good deeds, but to purify why you do them.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'decline_fear_showing_off',
        label: 'Refuse every public good deed because praise might happen.',
        feedbackText:
            'This can come from caution, but it is not always the strongest response. Sincerity often requires correction, not withdrawal from all visible good.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'seek_recognition',
        label: 'Join mainly because it will improve how people see you.',
        feedbackText:
            'This needs reflection. The outward act may look good, but the Hadith directs attention to the intention beneath it.',
      ),
    ],
    tags: ['sincerity', 'intentions', 'service'],
    levelBandMin: 20,
    levelBandMax: 40,
    isDailyEligible: true,
    dailyThemes: ['sincerity', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_sincere_advice',
    hadithId: 'religion_sincerity',
    mode: HadithReflectionMode.adult,
    category: 'community',
    theme: 'community',
    difficulty: 30,
    shortTeachingSummary:
        'Sincere concern for Allah, His Book, His Messenger, and the believers includes honest goodwill and advice.',
    reflectionPrompt:
        'How can you advise someone with sincerity instead of ego or irritation?',
    scenarioTitle: 'Private correction',
    scenarioDescription:
        'A friend is making a public mistake online. You want to help, but you also feel frustrated by them.',
    choices: [
      HadithReflectionChoice(
        id: 'private_advice',
        label: 'Reach out privately, advise gently, and make dua for them.',
        feedbackText:
            'This is best aligned. Sincere advice seeks the person’s good, not public victory over them.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'public_correction_polite',
        label: 'Correct them publicly, but try to keep your tone polite.',
        feedbackText:
            'This may sometimes be necessary, but it is not usually the strongest first step when a quieter path can preserve dignity and benefit.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'quote_them_mockingly',
        label: 'Share their mistake so others can see why they are wrong.',
        feedbackText:
            'This needs reflection. The Hadith points toward sincere concern, not public shaming.',
      ),
    ],
    tags: ['community', 'advice', 'sincerity'],
    levelBandMin: 20,
    levelBandMax: 45,
    isDailyEligible: true,
    dailyThemes: ['community', 'speech', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_avoid_doubtful_gain',
    hadithId: 'lawful_unlawful_clear',
    mode: HadithReflectionMode.adult,
    category: 'integrity',
    theme: 'integrity',
    difficulty: 32,
    shortTeachingSummary:
        'Protecting your faith and honor includes stepping away from doubtful matters.',
    reflectionPrompt:
        'When is it wiser to step back from something unclear rather than keep pushing toward it?',
    scenarioTitle: 'Questionable side income',
    scenarioDescription:
        'A profitable side opportunity is offered to you, but the terms are vague and parts of it feel ethically uncertain.',
    choices: [
      HadithReflectionChoice(
        id: 'pause_and_verify',
        label:
            'Pause, ask detailed questions, and step away if the doubt remains.',
        feedbackText:
            'This is best aligned. The Hadith encourages caution when the boundary is unclear and your conscience is unsettled.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'accept_try_later',
        label:
            'Take it for now and promise yourself you will look into it later.',
        feedbackText:
            'This is not the strongest response because it lets urgency overpower clarity in a doubtful matter.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'ignore_concern',
        label:
            'Ignore the discomfort because the money is too useful to question.',
        feedbackText:
            'This needs reflection. The Hadith teaches that uneasy grey areas are not where a believer should settle comfortably.',
      ),
    ],
    tags: ['integrity', 'halal', 'work'],
    levelBandMin: 20,
    levelBandMax: 50,
    isDailyEligible: true,
    dailyThemes: ['integrity', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_leave_whats_not_yours',
    hadithId: 'leave_what_not_concern',
    mode: HadithReflectionMode.adult,
    category: 'focus',
    theme: 'focus',
    difficulty: 28,
    shortTeachingSummary:
        'A sign of good Islam is leaving what does not concern you.',
    reflectionPrompt:
        'How much of your energy is spent on things that do not improve your life or worship?',
    scenarioTitle: 'Private group chat gossip',
    scenarioDescription:
        'A group chat is speculating about someone else’s private problem, and people keep drawing you in.',
    choices: [
      HadithReflectionChoice(
        id: 'exit_redirect',
        label: 'Decline to join in and redirect the conversation or step away.',
        feedbackText:
            'This is best aligned. Leaving what does not concern you protects your heart and your speech.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'read_only',
        label: 'Stay quiet and keep reading the conversation out of curiosity.',
        feedbackText:
            'This avoids adding harm directly, but it still feeds attention into something the Hadith teaches you to leave.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'add_more',
        label:
            'Contribute extra details because everyone already knows enough anyway.',
        feedbackText:
            'This conflicts with the teaching. Curiosity is not the same as concern or benefit.',
      ),
    ],
    tags: ['focus', 'speech', 'gossip'],
    levelBandMin: 15,
    levelBandMax: 40,
    isDailyEligible: true,
    dailyThemes: ['speech', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_speak_good_meeting',
    hadithId: 'speak_good_or_silent_faith',
    mode: HadithReflectionMode.adult,
    category: 'speech',
    theme: 'speech',
    difficulty: 30,
    shortTeachingSummary:
        'Faith should shape the tongue so that speech is beneficial or withheld.',
    reflectionPrompt:
        'What helps you tell the difference between useful speech and reactive speech?',
    scenarioTitle: 'Frustrated meeting comment',
    scenarioDescription:
        'During a tense meeting, you can make a cutting remark that would probably get a laugh.',
    choices: [
      HadithReflectionChoice(
        id: 'measure_words',
        label:
            'Choose either a beneficial comment or silence until you can speak constructively.',
        feedbackText:
            'This is best aligned. The Hadith gives a simple but demanding standard for speech.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'sarcasm_then_apologize',
        label: 'Say it anyway and apologize later if it lands badly.',
        feedbackText:
            'This shows some awareness, but it is not the strongest response because the harm is still being chosen first.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'make_cutting_joke',
        label: 'Say it because honest frustration is better than holding back.',
        feedbackText:
            'This needs reflection. Honesty does not excuse harmful or unnecessary speech.',
      ),
    ],
    tags: ['speech', 'adab', 'anger'],
    levelBandMin: 15,
    levelBandMax: 45,
    isDailyEligible: true,
    dailyThemes: ['speech', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_help_quietly',
    hadithId: 'allah_helps_servant_helps_brother',
    mode: HadithReflectionMode.adult,
    category: 'service',
    theme: 'service',
    difficulty: 29,
    shortTeachingSummary:
        'Allah’s help accompanies the servant who sincerely helps others.',
    reflectionPrompt:
        'How can helping another believer become a habit rather than a rare mood?',
    scenarioTitle: 'A stressed community volunteer',
    scenarioDescription:
        'A volunteer in your masjid is overwhelmed. You notice tasks piling up around them.',
    choices: [
      HadithReflectionChoice(
        id: 'step_in_and_help',
        label: 'Offer concrete help and lighten one or two tasks immediately.',
        feedbackText:
            'This is best aligned. The Hadith encourages practical support, not only kind feelings.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'send_message_later',
        label: 'Send an encouraging message later, but do not help right now.',
        feedbackText:
            'This is better than indifference, but the strongest response is to combine compassion with action when you can.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'criticize_management',
        label: 'Complain that the organizers should have planned better.',
        feedbackText:
            'This needs reflection. Critique without support rarely embodies the help praised in the Hadith.',
      ),
    ],
    tags: ['service', 'community', 'support'],
    levelBandMin: 15,
    levelBandMax: 40,
    isDailyEligible: true,
    dailyThemes: ['community', 'service', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_repentance_after_slip',
    hadithId: 'repentance_joy',
    mode: HadithReflectionMode.adult,
    category: 'repentance',
    theme: 'repentance',
    difficulty: 34,
    shortTeachingSummary:
        'Allah loves repentance and welcomes the servant who turns back sincerely.',
    reflectionPrompt:
        'What stops people from repenting quickly, and how can hope answer that delay?',
    scenarioTitle: 'After a private spiritual slip',
    scenarioDescription:
        'You fall into a sin you were trying to leave and feel ashamed to turn back again.',
    choices: [
      HadithReflectionChoice(
        id: 'repent_now',
        label:
            'Turn back immediately with remorse, dua, and a fresh plan to avoid the sin.',
        feedbackText:
            'This is best aligned. The Hadith strengthens hope and calls you back without delay.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'wait_until_better',
        label:
            'Wait until you feel more spiritually worthy before making tawbah.',
        feedbackText:
            'This is a common feeling, but it is not the strongest path. Repentance is for the moment of need, not after worthiness is manufactured.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'stop_trying',
        label:
            'Assume repeated failure means repentance is no longer sincere for you.',
        feedbackText:
            'This needs reflection. Despair is not what the Hadith teaches; returning again is itself part of sincerity.',
      ),
    ],
    tags: ['repentance', 'hope', 'self-accountability'],
    levelBandMin: 20,
    levelBandMax: 50,
    isDailyEligible: true,
    dailyThemes: ['repentance', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_keep_repenting',
    hadithId: 'allah_accepts_repentance_night_day',
    mode: HadithReflectionMode.adult,
    category: 'repentance',
    theme: 'repentance',
    difficulty: 35,
    shortTeachingSummary:
        'The door of repentance remains open, inviting return day and night.',
    reflectionPrompt:
        'How does remembering Allah’s openness to repentance change your response after mistakes?',
    scenarioTitle: 'Recurring weakness',
    scenarioDescription:
        'A recurring weakness makes you feel spiritually inconsistent and embarrassed before Allah.',
    choices: [
      HadithReflectionChoice(
        id: 'return_without_delay',
        label:
            'Keep returning to Allah and strengthen the practical steps around your tawbah.',
        feedbackText:
            'This is best aligned. The Hadith keeps the servant moving back toward Allah, not away in shame.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'less_dua_out_of_shame',
        label:
            'Reduce your dua because you feel hypocritical asking for help again.',
        feedbackText:
            'This comes from pain, but it is not the strongest response. Shame should lead to humble return, not distance.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'accept_defeat',
        label:
            'Assume this weakness will always define you, so there is no point in trying hard.',
        feedbackText:
            'This needs reflection. The Hadith teaches ongoing access to repentance, not resignation.',
      ),
    ],
    tags: ['repentance', 'hope', 'struggle'],
    levelBandMin: 20,
    levelBandMax: 55,
    isDailyEligible: true,
    dailyThemes: ['repentance', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_household_responsibility',
    hadithId: 'each_shepherd',
    mode: HadithReflectionMode.adult,
    category: 'accountability',
    theme: 'accountability',
    difficulty: 36,
    shortTeachingSummary:
        'Every person has a trust and will be asked about what was placed in their care.',
    reflectionPrompt:
        'What responsibilities in your life are easy to overlook because they seem ordinary?',
    scenarioTitle: 'Neglected responsibilities at home',
    scenarioDescription:
        'Your family responsibilities have started slipping because work and personal habits are taking over your attention.',
    choices: [
      HadithReflectionChoice(
        id: 'review_and_repair',
        label:
            'Acknowledge the trust, review what is slipping, and make a practical plan to repair it.',
        feedbackText:
            'This is best aligned. The Hadith frames responsibility as an amanah that deserves review and care.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'wait_for_complaint',
        label:
            'Keep going until someone clearly complains, then respond if needed.',
        feedbackText:
            'This is reactive rather than responsible. The stronger response is to honor trust before neglect becomes normal.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'say_everyone_busy',
        label:
            'Tell yourself everyone is busy, so this is not a serious issue.',
        feedbackText:
            'This needs reflection. Busyness does not cancel accountability for what has been entrusted to you.',
      ),
    ],
    tags: ['accountability', 'family', 'responsibility'],
    levelBandMin: 25,
    levelBandMax: 60,
    isDailyEligible: true,
    dailyThemes: ['family', 'accountability', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_fair_leadership',
    hadithId: 'just_on_pulpits_of_light',
    mode: HadithReflectionMode.adult,
    category: 'justice',
    theme: 'justice',
    difficulty: 40,
    shortTeachingSummary:
        'Justice is honored greatly by Allah, especially in positions of influence and decision-making.',
    reflectionPrompt:
        'Where do small biases creep into decisions that should be fair?',
    scenarioTitle: 'Choosing between two volunteers',
    scenarioDescription:
        'You are choosing someone for a community responsibility. One person is your friend, but another is more qualified.',
    choices: [
      HadithReflectionChoice(
        id: 'choose_qualified',
        label:
            'Choose the more qualified person and explain the decision fairly.',
        feedbackText:
            'This is best aligned. Justice asks you to separate trust from personal preference.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'choose_friend_with_support',
        label:
            'Choose your friend, but promise yourself you will support them heavily.',
        feedbackText:
            'This may sound compassionate, but it is not the strongest response because the initial choice still bends away from fairness.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'avoid_decision',
        label: 'Delay the decision so you do not have to disappoint anyone.',
        feedbackText:
            'This needs reflection. Avoiding a just decision can still be an injustice when responsibility requires clarity.',
      ),
    ],
    tags: ['justice', 'leadership', 'fairness'],
    levelBandMin: 30,
    levelBandMax: 70,
    isDailyEligible: true,
    dailyThemes: ['justice', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_patience_grief',
    hadithId: 'patience_first_strike',
    mode: HadithReflectionMode.adult,
    category: 'patience',
    theme: 'patience',
    difficulty: 34,
    shortTeachingSummary:
        'The sharpest test of patience is often at the first moment of pain.',
    reflectionPrompt:
        'What helps you remember adab and sabr during the first rush of difficulty?',
    scenarioTitle: 'Bad news arrives suddenly',
    scenarioDescription:
        'You receive upsetting news and feel a strong urge to vent in a way you may later regret.',
    choices: [
      HadithReflectionChoice(
        id: 'pause_turn_to_allah',
        label:
            'Pause, hold your tongue, and turn to Allah before reacting publicly.',
        feedbackText:
            'This is best aligned. The Hadith directs attention to the very first response when the heart is shaken.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'vent_then_regret',
        label:
            'Let it all out immediately and hope to apologize later if needed.',
        feedbackText:
            'This is understandable in pain, but it is not the strongest path because first reactions still shape harm.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'blame_everyone',
        label: 'Use the moment to lash out at whoever is nearby.',
        feedbackText:
            'This needs reflection. Patience is tested most clearly when the first reaction is hardest to control.',
      ),
    ],
    tags: ['patience', 'grief', 'self-control'],
    levelBandMin: 20,
    levelBandMax: 55,
    isDailyEligible: true,
    dailyThemes: ['patience', 'mixed'],
  ),
  HadithReflectionScenarioSeed(
    id: 'adult_strong_believer_balance',
    hadithId: 'strong_believer_patience',
    mode: HadithReflectionMode.adult,
    category: 'resilience',
    theme: 'resilience',
    difficulty: 33,
    shortTeachingSummary:
        'The strong believer seeks what benefits, asks Allah for help, and does not collapse into helpless regret.',
    reflectionPrompt:
        'How do effort, tawakkul, and resilience work together when plans fail?',
    scenarioTitle: 'A missed opportunity',
    scenarioDescription:
        'An important plan falls apart after real effort, and you keep replaying everything that went wrong.',
    choices: [
      HadithReflectionChoice(
        id: 'benefit_and_tawakkul',
        label:
            'Review what is beneficial to learn, seek Allah’s help, and move forward with steadiness.',
        feedbackText:
            'This is best aligned. The Hadith combines effort, reliance, and refusal to sink into unhelpful regret.',
        isBestChoice: true,
      ),
      HadithReflectionChoice(
        id: 'keep_saying_if_only',
        label:
            'Spend days repeating “if only” without taking the next beneficial step.',
        feedbackText:
            'This is not the strongest response because it traps you in regret instead of benefit.',
        isAcceptableChoice: true,
      ),
      HadithReflectionChoice(
        id: 'stop_trying_future',
        label:
            'Assume failure means you should stop trying meaningful things for a while.',
        feedbackText:
            'This needs reflection. The Hadith points toward resilient action with Allah’s help, not defeatism.',
      ),
    ],
    tags: ['resilience', 'tawakkul', 'benefit'],
    levelBandMin: 20,
    levelBandMax: 55,
    isDailyEligible: true,
    dailyThemes: ['patience', 'mixed'],
  ),
];

const List<HadithReflectionPuzzlePack> hadithReflectionPuzzlePacks = [
  HadithReflectionPuzzlePack(
    id: 'hadith_reflection_kids_kindness',
    titleKey: 'hadithReflectionPackKidsKindnessTitle',
    descriptionKey: 'hadithReflectionPackKidsKindnessSubtitle',
    mode: 'kids',
    category: 'kindness',
    minDifficulty: 8,
    maxDifficulty: 12,
    puzzleIds: ['kids_smile_welcome', 'kids_share_snack', 'kids_mercy_younger'],
    tags: ['kids', 'kindness'],
    isDailyEligible: true,
    isFeatured: true,
  ),
  HadithReflectionPuzzlePack(
    id: 'hadith_reflection_honesty_trust',
    titleKey: 'hadithReflectionPackHonestyTitle',
    descriptionKey: 'hadithReflectionPackHonestySubtitle',
    mode: 'mixed',
    category: 'honesty',
    minDifficulty: 9,
    maxDifficulty: 32,
    puzzleIds: [
      'kids_truth_lost_item',
      'kids_keep_promise',
      'adult_avoid_doubtful_gain',
    ],
    tags: ['honesty', 'trust', 'integrity'],
    isDailyEligible: true,
    isFeatured: true,
  ),
  HadithReflectionPuzzlePack(
    id: 'hadith_reflection_patience_gratitude',
    titleKey: 'hadithReflectionPackPatienceTitle',
    descriptionKey: 'hadithReflectionPackPatienceSubtitle',
    mode: 'adult',
    category: 'patience',
    minDifficulty: 33,
    maxDifficulty: 35,
    puzzleIds: ['adult_patience_grief', 'adult_strong_believer_balance'],
    tags: ['patience', 'resilience'],
    isDailyEligible: true,
    isFeatured: true,
  ),
  HadithReflectionPuzzlePack(
    id: 'hadith_reflection_anger_control',
    titleKey: 'hadithReflectionPackAngerTitle',
    descriptionKey: 'hadithReflectionPackAngerSubtitle',
    mode: 'mixed',
    category: 'anger',
    minDifficulty: 12,
    maxDifficulty: 30,
    puzzleIds: ['kids_anger_game', 'adult_speak_good_meeting'],
    tags: ['anger', 'speech', 'self-control'],
    isDailyEligible: true,
    isFeatured: false,
  ),
  HadithReflectionPuzzlePack(
    id: 'hadith_reflection_family_respect',
    titleKey: 'hadithReflectionPackFamilyTitle',
    descriptionKey: 'hadithReflectionPackFamilySubtitle',
    mode: 'mixed',
    category: 'family',
    minDifficulty: 10,
    maxDifficulty: 36,
    puzzleIds: [
      'kids_home_help',
      'kids_family_charity',
      'adult_household_responsibility',
    ],
    tags: ['family', 'respect', 'service'],
    isDailyEligible: true,
    isFeatured: false,
  ),
  HadithReflectionPuzzlePack(
    id: 'hadith_reflection_community_service',
    titleKey: 'hadithReflectionPackCommunityTitle',
    descriptionKey: 'hadithReflectionPackCommunitySubtitle',
    mode: 'adult',
    category: 'community',
    minDifficulty: 29,
    maxDifficulty: 30,
    puzzleIds: ['adult_sincere_advice', 'adult_help_quietly'],
    tags: ['community', 'service', 'advice'],
    isDailyEligible: true,
    isFeatured: false,
  ),
  HadithReflectionPuzzlePack(
    id: 'hadith_reflection_forgiveness_mercy',
    titleKey: 'hadithReflectionPackRepentanceTitle',
    descriptionKey: 'hadithReflectionPackRepentanceSubtitle',
    mode: 'adult',
    category: 'repentance',
    minDifficulty: 34,
    maxDifficulty: 35,
    puzzleIds: ['adult_repentance_after_slip', 'adult_keep_repenting'],
    tags: ['repentance', 'hope', 'mercy'],
    isDailyEligible: true,
    isFeatured: false,
  ),
  HadithReflectionPuzzlePack(
    id: 'hadith_reflection_adab_speech',
    titleKey: 'hadithReflectionPackSpeechTitle',
    descriptionKey: 'hadithReflectionPackSpeechSubtitle',
    mode: 'mixed',
    category: 'speech',
    minDifficulty: 12,
    maxDifficulty: 30,
    puzzleIds: [
      'kids_gentle_words',
      'adult_leave_whats_not_yours',
      'adult_speak_good_meeting',
    ],
    tags: ['speech', 'adab'],
    isDailyEligible: true,
    isFeatured: false,
  ),
  HadithReflectionPuzzlePack(
    id: 'hadith_reflection_daily_mixed',
    titleKey: 'hadithReflectionPackDailyTitle',
    descriptionKey: 'hadithReflectionPackDailySubtitle',
    mode: 'mixed',
    category: 'mixed',
    minDifficulty: 8,
    maxDifficulty: 40,
    puzzleIds: [
      'kids_smile_welcome',
      'kids_neighbor_sharing',
      'kids_home_help',
      'kids_mercy_younger',
      'kids_truth_lost_item',
      'kids_anger_game',
      'kids_share_snack',
      'kids_family_charity',
      'kids_keep_promise',
      'kids_gentle_words',
      'adult_intentions_service',
      'adult_sincere_advice',
      'adult_avoid_doubtful_gain',
      'adult_leave_whats_not_yours',
      'adult_speak_good_meeting',
      'adult_help_quietly',
      'adult_repentance_after_slip',
      'adult_keep_repenting',
      'adult_household_responsibility',
      'adult_fair_leadership',
      'adult_patience_grief',
      'adult_strong_believer_balance',
    ],
    tags: ['daily', 'mixed'],
    isDailyEligible: true,
    isFeatured: false,
  ),
];
