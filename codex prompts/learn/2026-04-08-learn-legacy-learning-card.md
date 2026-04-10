# Codex Task: Add Legacy Learning Card to Learn Hub

## Context

The Learn hub was recently restructured into a clean 3-section layout:
1. Your Path (guided learning)
2. Explore (5 pillars)
3. Utilities (Quizzes, Notes, Saved)

A large amount of existing learning content (journeys, islands, quizzes hub,
divine life lessons, Arabic modules, Qur'an universe, baby names, character
companions, seerah, daily wisdom, and more) was removed from the landing page
during that restructure. That content still exists in the app and its routes
are still live — it just has no visible entry point on the landing page anymore.

The goal of this task is to add a clearly labelled, collapsible
"All Learning Content" card at the bottom of the landing page that links to
all of that legacy content. The owner will review it and decide what to keep,
where to move things, and what to retire — but for now nothing should be
silently inaccessible.

---

## STEP 0 — BACKUP

Before touching any files, back up the files this task will modify:

```bash
BACKUP_DIR="backups/legacy_card_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

cp lib/features/learn/presentation/pages/learning_section_landing_page.dart \
   "$BACKUP_DIR/learning_section_landing_page.dart.bak"

echo "Backup complete → $BACKUP_DIR"
```

Do not proceed until the backup exists.

---

## STEP 1 — CREATE `learn_legacy_content_card.dart`

Create this file:
`lib/features/learn/presentation/widgets/learn_legacy_content_card.dart`

This is a `ConsumerStatefulWidget` (Riverpod) with a single bool `_expanded`
in its state, defaulting to `false`.

### Visual structure

When **collapsed** (default), render:
- A full-width card with a slightly muted border
- Left side: a small label badge that says "Temporary" (amber/warning colour
  using the app's theme tokens — match existing badge patterns in the codebase)
- Title: "All Learning Content"
- Subtitle: "Legacy content — tap to browse while we organise these sections"
- Right side: a chevron-down icon
- The whole card is tappable and toggles `_expanded`

When **expanded**, render the same header row (now with chevron-up), followed
by a scrollable list of section groups. Each group has:
- A small section heading (12px, muted)
- A column of tappable rows, each with an arrow icon and the content name

### Content groups and their routes

Use the route constants already defined in the app's router. If a constant name
is uncertain, add a `// TODO: confirm route name` comment and use a clearly
named string placeholder — do not guess or hardcode paths blindly.

**Group: Journeys & Islands**
- Learning Journey Home → `AppRoutes.learningJourneyHome` (or `/learn/journey-home`)
- Journey Islands → `AppRoutes.learningJourney` (or `/learn/learning-journey`)
- Games Island → `AppRoutes.gamesIsland` (or closest existing games route)

**Group: Qur'an Learning**
- Qur'an Learning Hub → existing `learnQuranHub` route (the older hub, not the main Qur'an tab)
- Qur'an Insights Browse → existing insights browse route
- Qur'an Knowledge Search → existing knowledge search route
- Qur'an Summaries → existing summaries route
- Qur'an Learning Paths → existing Qur'an learning paths route
- Qur'anic Arabic Modules → existing Arabic modules route
- Qur'an Universe → existing universe/constellation route
- Daily Companion → existing daily companion route

**Group: Deep Dive Learning**
- Divine Life Lessons → `AppRoutes.learnLifeLanding` (already in pillars but show here too)
- Character & Seerah → existing character/seerah route
- Daily Wisdom Companion → existing daily wisdom route
- Prophets Hub → existing prophets page route
- Baby Names → existing baby names route

**Group: Quizzes & Games**
- Quizzes Hub → existing `learnQuizzesHub` route
- Trivia → existing trivia route
- Daily Knowledge Quiz → existing daily knowledge quiz route
- Crossword → existing crossword route
- Word Search → existing word search route
- Matching Game → existing matching game route
- Ayah Completion → existing ayah completion route
- Hadith Reflection Quiz → existing hadith reflection quiz route

**Group: Kids Learning (full list)**
- Kids Games → existing kids games route
- Kids Qur'an → existing kids Qur'an route
- Kids Hadith → existing kids hadith route
- Prophet Stories (Kids) → existing kids prophet stories route
- Fun Learning → existing fun learning route
- Kids Arabic → existing kids Arabic route
- Bedtime Stories → existing bedtime stories route
- Seerah Journeys (Kids) → existing kids seerah route
- Kids Dua → existing kids dua route

**Group: Reference & Tools**
- Islamic Guides → `AppRoutes.islamicGuides`
- Qur'an Lessons Mapping → `AppRoutes.quranLessonsMapping`
- FAQ → existing FAQ route
- Glossary → existing glossary route if present
- Islamic History → existing history route if present

### Navigation behaviour

Each row calls `context.go(route)` using the same navigation pattern the rest
of the app uses. If a route is uncertain, wrap the `onTap` with:
```dart
// TODO: confirm route — using placeholder
```
and leave the row visible but non-navigating (just show a snackbar:
`ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Route TBD')))`).

Do not crash or throw — every row must be tappable without error.

---

## STEP 2 — ADD THE CARD TO THE LANDING PAGE

In `learning_section_landing_page.dart`, add `LearnLegacyContentCard()` as
the **last item** in the page's scroll view, after the utilities row.

Add a small top margin (16px) before it for spacing.

Do not change any other part of the landing page. The three existing sections
(Your Path, Explore pillars, Utilities) must remain exactly as they are.

The card must also be hidden when `specialModeProvider.isKids` is true —
kids profiles should never see it.

---

## STEP 3 — ADD LOCALIZATION KEYS

Add these keys to `lib/l10n/app_en.arb`:

```json
"learnLegacyCardTitle": "All Learning Content",
"learnLegacyCardSubtitle": "Legacy content — tap to browse while we organise these sections",
"learnLegacyCardBadge": "Temporary",
"learnLegacyGroupJourneys": "Journeys & Islands",
"learnLegacyGroupQuranLearning": "Qur'an Learning",
"learnLegacyGroupDeepDive": "Deep Dive Learning",
"learnLegacyGroupQuizzes": "Quizzes & Games",
"learnLegacyGroupKids": "Kids Learning",
"learnLegacyGroupReference": "Reference & Tools"
```

Run `flutter gen-l10n` after updating the ARB file.

Use these keys in the widget. For any content item labels (route names), use
existing localization keys where they already exist, or inline English strings
with a `// TODO: add l10n key` comment.

---

## STEP 4 — VERIFY

```bash
flutter analyze
flutter test
```

Fix any analysis errors introduced by this task only.
Pre-existing failing tests must not be touched.

---

## CONSTRAINTS

- Do not modify any route definitions — only navigate to existing routes.
- Do not modify any provider or state management files.
- Do not remove or reorganize any existing routes or pages.
- Do not add the legacy card to the kids experience (`isKids` guard).
- The card must be purely presentational — no state other than `_expanded`.
- Match existing widget patterns, padding, and theme tokens exactly.
- The "Temporary" badge must use the app's existing warning/amber colour tokens,
  not hardcoded hex values.
- The card must never throw — if a route is unknown, handle it gracefully with
  a snackbar and a TODO comment.

---

## DELIVERABLE SUMMARY

Output a short list of:
1. File created
2. File modified
3. Any routes left as TODO placeholders (list the content item name and why)
4. Backup directory path
