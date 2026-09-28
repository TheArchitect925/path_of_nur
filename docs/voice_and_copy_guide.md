# Path of Nur — Voice and Copy Guide

Last updated: 2026-09-27

Gentle, calm, kind, Islamic. As rules the copy follows, not words it uses.

This guide is the source of truth for every English string in the app: the ARB
(`lib/l10n/app_en.arb`), the Dart content files under `lib/features/*/data/`,
and the Apple TV, Watch, complication and widget `.strings` tables.
`tools/copy_lint.py` checks the ARB and, through `tools/copy_prose.py`, the
English prose in the Dart files and the history JSON against it;
`test/app/copy_lint_ratchet_test.dart` fails CI when a rule's count rises.

Audit and rationale: the Path of Nur Voice Audit artifact (2026-09-05).
Decisions 1–4 below were made on 2026-09-07, 5 and 6 on 2026-09-27.

## Why

The audit found the copy grammatical and rarely salesy, yet unmistakably
machine-written, for five countable reasons: it named its own tone ("a calm
space for…", 1,300 times), it listed three things in every subtitle (874
times), it shipped design-document sentences to the screen ("boxed into its own
island so the newer journey system can stay clear", 192 times), it padded lines
with tails ("right now", "in one place", 270 times), and it never settled its
Islamic conventions (two apostrophe glyphs, six spellings of one term, ﷺ missing
on 21 mentions). Each rule below closes one of those gaps.

## The rules

1. **Say less.** A subtitle says what the page is in one breath, not what it
   contains. Aim for eight words; 92 characters is the ceiling the header guard
   enforces.
   *A calm knowledge space for short quizzes, daily review, and gentle
   reinforcement.* → *Short quizzes and daily review.*

2. **Be calm; never say calm.** calm, gentle, quiet, steady, soft, peaceful,
   meaningful, intentional, mindful are banned in chrome (titles, subtitles,
   buttons, labels, hints, badges). They stay allowed in lesson prose and when
   literal (a quiet adhan sound, quiet hours).

3. **Speak to one person.** "You", present tense, active voice. No "users", no
   "the app" as an actor, no "we" except in shared worship ("Why we pray"). The
   app names itself at most once per screen, always as *Path of Nur*.

4. **Leave the studio vocabulary in the studio.** Never on screen: surface,
   island, hub, module, flow, layer, system, legacy, migration, parity,
   canonical, scaffold, owner, entry point, enrichment, dataset, route,
   utility. Say what the person sees: a page, a lesson, the reader, search.
   *Secondary tools and utility surfaces live here without replacing the
   journey-first structure.* → *Tools and search.*

5. **Invite rather than instruct.** Buttons are verbs (Read, Listen, Save,
   Continue). Subtitles are nouns or quiet invitations, not commands. No
   "Tap to", no "Get started", no "Unlock".

6. **Kind in failure, honest in emptiness.** An error says what happened and
   what to do, without "Oops", "Please" or apology:
   *Couldn’t load duas. Check your connection and try again.*
   An empty state says what is here and never mentions the roadmap:
   *No lessons here yet.* Never *will appear here as content grows*, never
   *coming soon*, never *placeholder*, never *for now*.

7. **One list, rarely; three, almost never.** A list of three or more nouns in
   chrome needs a reason. If a page has five features, the subtitle names the
   purpose, not the five.

8. **No tails.** Drop "right now", "today", "in one place", "at your own pace",
   "when you want", "with intention" unless the sentence is untrue without them.

9. **Islamic conventions are fixed, not felt.** The glossary below is the source
   of truth: one spelling, one casing, one honorific rule. Du’a, Qur’an and
   hadith translations are never reworded, only repunctuated.

10. **Let the deen carry the warmth.** Where another app would cheer ("Great
    job!"), Path of Nur may say alhamdulillah, masha’Allah, or simply state the
    fact. Praise is quiet and true; it never inflates.
    *Great job - 1 day in a row.* → *One day in a row, masha’Allah.*

11. **Children hear a storyteller.** Kids copy addresses the child as "you", one
    idea per line, dialogue in quotation marks (“Bismillah,” said Mama.),
    "Let’s" and an occasional exclamation mark allowed. Parent-facing rows say
    "your child" and use the adult voice. See also
    `docs/kids_picture_books_authoring_rules.md`.

12. **Mechanics.** US spelling. One apostrophe glyph (’). No em-dash and no
    spaced hyphen in chrome; a period, a comma or a middle dot (·) between
    values. Labels and titles carry no terminal period; sentences carry one.
    Numbers only where they change what the reader does.

## Decisions (2026-09-07)

1. **Gamification: rename, keep the mechanics.** Streaks, XP and badges stay as
   features; the words go. *days in a row* for streak, *light* for XP, the
   thing actually done for a badge ("Ten stories read"). The Watch face
   follows. Drops, the garden and the ocean are the app’s visual metaphors and
   stay. As shipped in V2a (2026-09-27), in one pass across the whole app so a
   number never has two names:

   | Was | Is | de · fr · ar · ur |
   | --- | --- | --- |
   | streak, current streak | days in a row | Tage in Folge · jours d’affilée · أيام متتالية / على التوالي · مسلسل دن |
   | best / longest streak | most days in a row | die meisten Tage in Folge · record de jours d’affilée · أكثر الأيام المتتالية · سب سے زیادہ مسلسل دن |
   | XP, +10 XP | light, +10 light | Licht · lumière · نور · نور |
   | badges (the kids’ progress page) | stickers | Sticker · autocollants · ملصقات · اسٹیکرز |

   Counters that name a number are ICU plurals ("1 day in a row", "3 days in a
   row"); never glue an English "s" onto a word in code.
2. **Sentence case** for buttons, section titles, subtitles, labels, hints and
   badges: *Continue reading*, *Start here*. Page titles keep Title Case (header
   redesign, decision C1, 2026-09-04).
3. **ﷺ after every mention of the Prophet**, including possessives (*the
   Prophet’s ﷺ life*) and *Muhammad ﷺ*. Plain *Allah*, never ﷻ or SWT.
   Companions: *may Allah be pleased with him/her* on first mention per page,
   then the name alone. No "peace be upon him" in English chrome; the kids
   picture books keep it in their first spread by their own rules.
4. **Lesson prose (V3)** is edited for mechanics, studio vocabulary, lists and
   tails. Its substance and scholarship are kept.
5. **Other prophets in English prose**: *(peace be upon him)* after the name at
   its first mention in a passage, then the name alone: *Through Musa (peace be
   upon him), this ayah shows…*. Never عليه السلام inside English. Titles,
   names and labels carry the name alone. Scholars: *(may Allah have mercy on
   him)*, the same way. The picture books keep their own rule.
6. **Lists in V3**: rewritten in the prose people scan (titles, summaries,
   overviews, descriptions, subtitles, themes). Lesson bodies keep their lists
   unless one is plainly filler.

## Glossary

| Use | Not | Note |
| --- | --- | --- |
| Qur’an, Qur’anic | Quran, Qur'an | the glyph is the change |
| salah, du’a, dhikr, hadith, wudu, ayah, surah | Salah, Dua, Dhikr mid-sentence | capital only at sentence start or in a name (Surah Yusuf) |
| ayahs, surahs, duas | ayat, suwar, ad’iyah | English plurals |
| qada | qaza | |
| rakat, rakats | rak’ah | kept: the form the app already uses everywhere |
| Fajr, Dhuhr, Asr, Maghrib, Isha, Jumu’ah, Tarawih, Tahajjud, Witr | Taraweeh, Juma | prayer names are proper names |
| Makkah, Madinah, Seerah | Mecca, Medina, Sirah | |
| Path of Nūr *or* Path of Nur (open, V1) | Noor | the home-screen name is Nūr (`CFBundleDisplayName`), the ARB app title is Nur; 43 strings mix them. Pick one in V1 and the lint will hold it |
| the Prophet ﷺ, Muhammad ﷺ, the Messenger of Allah ﷺ | the Prophet, Prophet Muhammad, PBUH | every mention |
| Allah | God, Allah ﷻ, SWT, الله inside English | Latin script in English copy; the lint rule `allah-in-arabic-script` also reads the Dart content files. Arabic phrases keep it (بسم الله, رضي الله عنه) |
| alhamdulillah, masha’Allah, insha’Allah, bismillah | Alhamdulilah, MashaAllah, InshAllah | lowercase when used as words |
| days in a row · light | streak · XP | decision 1 |
| memorization, color, practice (verb and noun) | memorisation, colour, practise | US spelling |
| Musa (peace be upon him) · Abu Bakr (may Allah be pleased with him) | Musa عليه السلام, Abu Bakr رضي الله عنه | decision 5; Arabic terms are transliterated and glossed: *fasad (corruption)*, *zulm (injustice)* |

## How the lint works

```bash
python3 tools/copy_lint.py                 # counts against the baseline
python3 tools/copy_lint.py --list tone-tail # the offending keys for one rule
python3 tools/copy_lint.py --write-baseline # after a real fix, lock it
python3 tools/prune_dead_l10n_keys.py      # delete keys no Dart file uses
```

Scopes: *chrome* is every key that is not lesson prose (`…Body`,
`…Description`, `…Takeaway1`, …) and not sacred text (`…Translation`,
`…Meaning`, `…Arabic`, …). Tone rules run on chrome only; mechanics run on
everything but sacred text; the apostrophe rule runs on everything.

Outside the ARB, `tools/copy_prose.py` reads every Dart file under `lib/`
(not generated l10n, the Apple TV target, the two sourced datasets or
`*_localized_*` files) and `assets/data/historical_calendar_seed.json`. A
*prose value* is one string of four English words or more whose field is not
sacred or an id (`translation`, `transliteration`, `arabic…`, `meaning`,
hadith and ayah quotations, `source…`, ids and paths are never read). The
`prose-*` rules and `arabic-in-english` count those values; the mechanics
ones are locked at zero, and `prose-studio-vocabulary`, `prose-roadmap`,
`prose-tail` and `prose-list-of-three` are V3's rewrites, counted down.

In prose, studio vocabulary and roadmap talk are counted by *sense*, not by
word: the World lessons' root systems and atmospheric layers, the Hijrah's
migration, a scholar's legacy and "future generations" are English, not
product talk. `prose-studio-vocabulary` counts the words that only mean the
product (hub, module, fallback, payload, canonical, island…) and the
ambiguous ones where they name a page ("the Prophets system", "a practice
surface", "reading routes"); `prose-roadmap` counts promises ("a future
update", "For now", "placeholder"). `prose-tail` counts the tails that add
nothing ("in one place", "at your own pace", "with clarity", a bare "with
intention" or "with presence", "Use this page when you want…"); a closing
"today" or "right now" is the point of a reflection prompt or a practice
("When did your heart feel most awake today?") and is not counted in prose.
Where "intention" meant niyyah or "presence" meant khushu, the rewrite says
niyyah or khushu. The chrome rules keep the plain word
lists. Text nobody reads is out of scope: logs and exceptions, the watch's
validation messages, editorial metadata no widget renders (`notes`,
`mappingNotes`, `coverageNote`, `datasetName`, `editorialNote`) and the
PIN-gated editorial dashboard.

Three things are not counted on purpose. A mode's *name* is not a
description (*Gentle mode*). A settings category subtitle is an index of what
sits inside it (*Profiles, backup, and sync*), the way a phone's own settings
read, so it may list; two lists are the content itself (the platforms the app
runs on, the occasions it dresses up for). And placeholder names (`{xp}`,
`{streak}`) are code, not copy. These live in `MODE_NAME_KEYS` and
`INDEX_LIST_KEYS` in `tools/copy_lint.py`; add a key there only when the same
argument holds. A search hint lists what can be searched (*Search by surah,
number, or phrase*), so `…SearchHint` keys may list too. A surah lesson whose
key ends in the surah's name (`quranSurahInsightLessonAlBaqarah…`) is lesson
prose, not chrome (`CONTENT_KEYS`). So is lesson material inside Learn: a
practice step, a family prompt, a daily-wisdom entry, a lesson’s section
heading. A tone word used literally is a name, not self-praise: a mood you
can pick (*Calm*), a pace (*Steady*), a softer adhan recording, recitation
that is silent by fiqh (*recite it quietly*). Those keys are listed in
`MODE_NAME_KEYS`.

A line that is right as it is opts out of one rule with a trailing comment,
so the exception is visible where it lives:

```dart
subtitle: 'What happens to ال at the beginning.', // copy-lint: allow arabic-in-english
```

The ratchet test fails when a count rises (new drift: fix the string) and when
it falls (lock it: `--write-baseline`). Never raise a baseline by hand.

## Re-translating what you rewrote

When `OPENAI_API_KEY` is not set (the case on the main development Mac), the
rewritten keys are translated by hand for every shipping locale (de, fr, ar,
ur) in the same commit, as V2a did. Read the locale's existing strings for the
same screen first and keep its terms: German writes *Koran*, *Jumu’ah* and
formal *Sie* (including page descriptions for children, which the gate checks);
where the child is spoken to (`kids…` and `bedtime…` keys) German says *du* and
French *tu*, and any key naming `Parent` (or the bedtime family-mode setting)
keeps *Sie* / *vous*; French otherwise writes *Coran* and *vous*; Urdu writes *فقہی مسلک* for madhab, because
*مذہب* means religion.

German, Arabic and Urdu ship, and `tools/localization_gate.py` allows at most
5% of tier-A prose to sit in English. Every rewritten key is re-translated in
the same commit:

```bash
python3 tools/translate_arb.py --source lib/l10n/app_en.arb --outdir lib/l10n \
  --languages de ar ur --changed-since HEAD
```

`--changed-since` translates only the keys whose English changed since that
ref and merges them into the existing locale files; `--keys` and
`--keys-file` select keys by hand; `--dry-run` lists what would be sent.
Then `flutter gen-l10n`, then `python3 tools/localization_gate.py
--release-from-source`.

## The phases

| Phase | What lands |
| --- | --- |
| V0 · Foundation (done 2026-09-07) | this guide, the lint, the ratchet test, dead keys deleted, delta translation |
| V1 · Mechanics | scripted, reviewed diff: apostrophes, terms, casing, honorifics, UK→US, typos, dashes, label periods, duplicate labels, kids dialogue quotes |
| V2a · First run (done 2026-09-27) | notifications, onboarding, home, navigation, settings, profile and page descriptions rewritten; one name for each number app-wide; de/fr/ar/ur translated by hand, and 320 translation errors in those screens fixed |
| V2b-1 · Qur’an (done 2026-09-27) | the Qur’an tab, reader, pathways, first-phrases and short-surah steps, Qur’anic Arabic lessons; *Ayah Insights* renamed *Ayah Lessons*; playback errors say what to do |
| V2b-2 · Learn (done 2026-09-27) | the Learn landing, hubs, learning journeys and areas, the games area, the Seerah companion; *Learning Hub* is *Learn*, *islands* are *learning areas*, *Salah Hub* / *Dua Hub* / *Hadith Hub* take their plain names |
| V2b-3 · Growth and worship (done 2026-09-27) | hadith, du’a, salah, qibla, fasting, wudu, dhikr and khushu, Growth and spiritual growth, garden and ocean, prophets, Arabic learning, guided paths; *gentle return days* are *grace days*; encouragement says the fact, or alhamdulillah |
| V2c · Kids (done 2026-09-27) | Kids home and journeys, kids Qur’an, hadith, Seerah, du’a and Arabic, the bedtime companion and stories, the parent views; cheering becomes *masha’Allah* / *alhamdulillah*; the du’a light stages are *Little seed … Shining star*; German speaks to the child as *du* |
| V2d · Long tail (done 2026-09-27) | the knowledge games (crossword, word search, matching, ayah completion, trivia), circles, journal, family learning, accounts and backup, baby names, history, world and sky; game difficulty reads *Simple / Moderate / Reflective / Deep*. Left as written: the editorial dashboard and content builder (staff tools), narrator biographies, madhhab summaries, glossary definitions |
| V3 · Prose | the content keys and the Dart content files: (a) mechanics, (b) studio vocabulary and roadmap and (c) tails, done 2026-09-27 · (d) lists in cards and summaries |
| V4 · Native | Apple TV, Watch, complications, widgets |
| V5 · Lock | baselines to zero, lint blocks CI on its own step |
