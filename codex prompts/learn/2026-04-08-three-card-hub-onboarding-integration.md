# Codex Task: Learn Hub — 3-Card Adult / 2-Card Kids Layout with Onboarding Integration

## Overview

This task restructures the Learn hub landing page into a clean card-based
layout and wires it properly to the onboarding carousel selections already
stored in the user's profile. It also adds path completion detection and
"what's next" messaging.

**Adult layout (3 cards):**
1. Learning Path
2. Self Learning
3. Kids Learning (preview card for adults)

**Kids layout (2 cards, when `specialModeProvider.isKids` is true):**
1. Learning Path
2. Self Learning

Every card opens a dedicated full page. The landing page itself becomes very
simple — just the greeting header and three (or two) large cards.

---

## STEP 0 — BACKUP

```bash
BACKUP_DIR="backups/three_card_hub_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Core files being changed
cp lib/features/learn/presentation/pages/learning_section_landing_page.dart \
   "$BACKUP_DIR/learning_section_landing_page.dart.bak"

# Widgets from previous tasks that will be reorganised
cp lib/features/learn/presentation/widgets/learn_path_picker_widget.dart \
   "$BACKUP_DIR/learn_path_picker_widget.dart.bak" 2>/dev/null || true
cp lib/features/learn/presentation/widgets/learn_your_path_card.dart \
   "$BACKUP_DIR/learn_your_path_card.dart.bak" 2>/dev/null || true
cp lib/features/learn/presentation/widgets/learn_explore_pillars_widget.dart \
   "$BACKUP_DIR/learn_explore_pillars_widget.dart.bak" 2>/dev/null || true
cp lib/features/learn/presentation/widgets/kids_learn_home.dart \
   "$BACKUP_DIR/kids_learn_home.dart.bak" 2>/dev/null || true
cp lib/features/learn/presentation/widgets/learn_free_browse_card.dart \
   "$BACKUP_DIR/learn_free_browse_card.dart.bak" 2>/dev/null || true

echo "Backup complete → $BACKUP_DIR"
```

---

## STEP 1 — READ BEFORE WRITING (mandatory)

Before writing any code, read these files to understand existing patterns:

1. Find and read the onboarding carousel file(s). Search for files matching:
   - `*onboarding*`, `*carousel*`, `*welcome*` under `lib/features/`
   - Look for where onboarding answers are saved to the user profile/settings

2. Find and read the profile/settings model. Search for:
   - The model that stores `isNewMuslim`, `knowledgeLevel`, `learningGoal`,
     or equivalent fields set during onboarding
   - The provider that exposes these values (likely under
     `lib/features/profile/` or `lib/core/`)

3. Read `lib/features/learn/presentation/widgets/learn_path_picker_widget.dart`
   to understand the current path-picker flow.

4. Read `lib/features/learn/presentation/widgets/kids_learn_home.dart`
   to understand the current kids home structure.

Document what you find at the top of your deliverable summary:
- The onboarding fields that are saved and their exact Dart type/enum names
- The provider name that exposes them
- Whether a `knowledgeLevel` or equivalent enum already exists

Do not guess field names. Read the actual files first.

---

## STEP 2 — REBUILD `learning_section_landing_page.dart` AS A 3-CARD HUB

### The page structure

The new landing page is minimal. It contains:

**Header:** A short greeting (e.g. "Assalamu Alaikum, [name]" or the app's
existing greeting pattern — match whatever is used elsewhere).

**Card grid:** Three large tappable cards stacked vertically (full width,
not a grid). Each card navigates to its own dedicated page.

**No other content on this page.** The pillars, path picker, free browse
card, utilities row — all of those move inside the dedicated pages below.
The landing page itself is just the three cards.

### Adult card 1 — Learning Path

- Title: "Learning Path"
- Subtitle: Show the user's current path name if one is set, or "Find your
  guided path" if none is set yet
- Show a small progress indicator (e.g. "Stage 3 of 8") if a path is active
- Leading icon: use existing app icon pattern (SVG asset or `Icons.*`)
- Taps to: `LearnLearningPathPage` (new page, created in Step 3)

### Adult card 2 — Self Learning

- Title: "Self Learning"
- Subtitle: "Browse all topics freely"
- Leading icon: matching app icon pattern
- Taps to: `LearnSelfLearningPage` (new page, created in Step 4)

### Adult card 3 — Kids Learning

- Title: "Kids Learning"
- Subtitle: "See what's available for younger learners"
- Add a small muted note beneath the subtitle:
  "This is what children on this device will see"
- Leading icon: matching app icon pattern
- Taps to: `LearnKidsPreviewPage` (new page, created in Step 5)
- This card is always visible to adults — it lets them preview and understand
  the kids experience before handing a device to a child

### Kids layout (when `specialModeProvider.isKids` is true)

Show only 2 cards:
1. Learning Path (same as adult card 1 but with kid-appropriate path content)
2. Self Learning (same as adult card 2 but filtered to kids content only)

Do NOT show the Kids Learning card to kids profiles.

### Card visual design

Match the exact visual style of existing large cards in the app. Do not
invent a new card style. Find an existing `Card`, `InkWell`-wrapped
`Container`, or equivalent large card widget already used in the codebase
and follow that exact pattern for all three cards.

---

## STEP 3 — CREATE `learn_learning_path_page.dart`

Path: `lib/features/learn/presentation/pages/learn_learning_path_page.dart`

This page is a full `Scaffold` with its own `AppBar` titled "Learning Path".

### Section A — Path level selector (first-run or on demand)

**On first run** (no path set in `learn.path.state.v1`):

Show an inline card at the top of the page with:

- Heading: "Choose your learning level"
- Subheading: "We've pre-selected based on your profile — change it anytime"
- The level selector (see below)
- A "What's included" expandable section per level option

**The default level** must be pre-selected from the onboarding answer you
found in Step 1. Read the onboarding-derived profile field (e.g.
`isNewMuslim`, `knowledgeLevel`, or equivalent) and map it to the
appropriate default:

```
// Example mapping — use actual field names found in Step 1:
// onboarding answer "new to islam" → default to Foundations level
// onboarding answer "practising muslim" → default to Growing level  
// onboarding answer "knowledgeable" → default to Deep Dive level
// If no onboarding answer found → default to Foundations
```

**Level options** (show all three so the user can switch):

**Foundations** — "New to Islam or just getting started"
- Best for: New Muslims, curious non-Muslims, children new to learning
- Covers: The 5 pillars, basic beliefs, salah, wudu, short duas, Prophet
  Muhammad ﷺ introduction
- Paths available at this level: New Muslim Journey, Islam Foundations,
  Daily Routines

**Growing** — "I practise Islam and want to learn more"
- Best for: Practising Muslims deepening their knowledge
- Covers: Hadith themes, Seerah in depth, Qur'anic Arabic basics, character
  and adab, worship refinement
- Paths available at this level: Hadith Deep Dive, Seerah Journey, Character
  & Adab, Qur'an Arabic Basics

**Deep Dive** — "I want advanced Islamic knowledge"
- Best for: Those ready for detailed study
- Covers: Qur'anic Arabic advanced, detailed Fiqh, Tajweed, Islamic history
  timeline, scholarly topics
- Paths available at this level: Qur'anic Arabic Advanced, Tajweed Basics,
  Fiqh Basics, Islamic History Timeline

Each level option is a selectable card (radio-button style, using the app's
existing selection pattern). Tapping one saves the selection to the profile/
settings using the same provider/persistence layer already used for
onboarding answers.

Add a "What's included" `ExpansionTile` (or equivalent expandable widget
already used in the codebase) beneath each option showing the bullet points
above. Keep it collapsed by default.

**After first run** (path is set):

Show the level selector as a compact, editable row at the top:
"Learning level: Growing · Change"
Tapping "Change" expands the full selector inline.

### Section B — Active path card

Below the level selector, show the user's active path (if one is chosen):
- Path name
- Current stage title
- Stage progress (e.g. "Stage 3 of 8")
- `LinearProgressIndicator`
- "Continue" primary button → routes to the current journey stage

If no path is chosen yet (but level is set), show:
- "Choose a path to get started"
- A list of path cards for the selected level (see Section C)

### Section C — Available paths for the selected level

Below the active path card, show all paths available at the user's selected
level as a scrollable list of compact cards. Each shows:
- Path name
- Short description (1 sentence)
- Number of stages
- "Start" or "Continue" button depending on whether it has been started

These map directly to existing journey/island routes. Use the existing
`learningJourneyHome` or path-specific routes — do not create new routes.

### Section D — Path completion handling

When a path's `stagesCompleted == totalStages` (i.e. the path is 100%
complete):

Show a **completion banner** at the top of the active path card:
- A calm success colour (use app's existing success/green token)
- Icon: checkmark or equivalent
- Title: "Masha'Allah — you've completed [Path Name]!"
- Subtitle: "May Allah bless your learning. Here's what we suggest next:"
- Below the banner: show 2–3 "suggested next" path cards from the same
  or next level up, using the existing recommendation logic if it exists,
  or a static mapping if not:
  ```
  // Example static next-path mapping:
  // New Muslim Journey complete → suggest: Islam Foundations, Daily Routines
  // Hadith Deep Dive complete → suggest: Seerah Journey, Character & Adab
  // Qur'an Arabic Basics complete → suggest: Qur'anic Arabic Advanced, Tajweed
  ```
- A secondary link: "Browse all paths" → scrolls to Section C

Do NOT auto-reset the path. The completed state persists. The user can
start a new path by tapping "Start" on any card in Section C.

---

## STEP 4 — CREATE `learn_self_learning_page.dart`

Path: `lib/features/learn/presentation/pages/learn_self_learning_page.dart`

This page is a full `Scaffold` with `AppBar` titled "Self Learning".

### For adult profiles:

Move the following content from the previous landing page into this page:

1. The 5 explore pillar cards grid (from `learn_explore_pillars_widget.dart`)
   — keep the widget, just render it here instead of the landing page

2. The utilities row (Quizzes & Games, Notes, Saved)

3. The `LearnFreeBrowseCard` ("More to explore") collapsible card

Add a short subtitle beneath the AppBar title:
"All content is available freely — no path required"
(use localization key `learnSelfLearningSubtitle`)

### For kids profiles (`specialModeProvider.isKids`):

Show ONLY content appropriate for kids:
- Kids pillar cards (Prophet Stories, Quran Basics, Duas I Know, Arabic
  Letters) — the same grid from the existing `KidsLearnHome` widget
- Kids games and activities section
- Do NOT show adult pillars, adult free browse card, or adult utilities

---

## STEP 5 — CREATE `learn_kids_preview_page.dart`

Path: `lib/features/learn/presentation/pages/learn_kids_preview_page.dart`

This page is for ADULTS ONLY. It is never shown to kids profiles.

`Scaffold` with `AppBar` titled "Kids Learning".

Content:
- A brief explanation card at the top:
  Title: "What children see in the app"
  Body: "When a child profile is active, the app shows age-appropriate
  Islamic content. Here's a preview of their learning experience."
  (Use localization keys — do not hardcode.)

- Below that, render the `KidsLearnHome` widget (already built) in
  **read-only / preview mode**. Pass a `previewMode: true` parameter to
  `KidsLearnHome`. In preview mode, tapping any card shows a brief
  tooltip or snackbar: "Switch to a child profile to access this content"
  instead of navigating.

- Add a section below titled "Managing child profiles":
  A single row linking to the profile/settings page where child profiles
  are created and managed. Use the existing profile settings route.
  Label: "Manage child profiles →"

If `specialModeProvider.isKids` is somehow true when this page loads
(which should not happen since the card is hidden from kids), navigate
back immediately with `context.pop()`.

---

## STEP 6 — WIRE ONBOARDING → PROFILE → LEARNING LEVEL

This is the most important integration step.

### 6a — Read onboarding answers

Using the fields you identified in Step 1, read the onboarding-derived
knowledge level from the profile provider.

### 6b — Save level selection back to profile

When the user changes their level on `LearnLearningPathPage`, save it to
the same profile/settings store that onboarding uses. This ensures the
two are always in sync.

Use the **existing** persistence mechanism (SharedPreferences, SQLite, or
the profile model — whichever onboarding already uses). Do not introduce
a new storage layer.

### 6c — Add "Learning level" to Settings

Find the existing settings/profile page in the app. Add a single new row:

  "Learning level · [Current level] · Change →"

Tapping "Change →" navigates to `LearnLearningPathPage` (the level
selector at the top). This gives users a second entry point to change
their level from settings, not just from the Learn hub.

If the settings page is complex and adding this row risks breaking other
things, add a `// TODO: add learning level row to settings` comment in
the relevant settings file and note it in the deliverable summary instead
of forcing a risky change.

---

## STEP 7 — UPDATE ROUTES

Add routes for the three new pages to the appropriate router file
(`learn_core_routes.dart` or equivalent):

```dart
// New routes — add to the learn route family:
GoRoute(
  path: 'learning-path',         // → /learn/learning-path
  name: 'learnLearningPath',
  builder: (context, state) => const LearnLearningPathPage(),
),
GoRoute(
  path: 'self-learning',         // → /learn/self-learning
  name: 'learnSelfLearning',
  builder: (context, state) => const LearnSelfLearningPage(),
),
GoRoute(
  path: 'kids-preview',          // → /learn/kids-preview
  name: 'learnKidsPreview',
  builder: (context, state) => const LearnKidsPreviewPage(),
),
```

Match the exact GoRouter pattern already used in the file. Do not change
the parent route structure.

---

## STEP 8 — LOCALIZATION

Add these keys to `lib/l10n/app_en.arb`:

```json
"learnHubLearningPathCardTitle": "Learning Path",
"learnHubLearningPathCardSubtitleNoPath": "Find your guided path",
"learnHubSelfLearningCardTitle": "Self Learning",
"learnHubSelfLearningCardSubtitle": "Browse all topics freely",
"learnHubKidsCardTitle": "Kids Learning",
"learnHubKidsCardSubtitle": "See what's available for younger learners",
"learnHubKidsCardNote": "This is what children on this device will see",
"learnPathPageTitle": "Learning Path",
"learnPathChooseLevelHeading": "Choose your learning level",
"learnPathChooseLevelSubheading": "We've pre-selected based on your profile — change it anytime",
"learnPathLevelFoundationsTitle": "Foundations",
"learnPathLevelFoundationsSubtitle": "New to Islam or just getting started",
"learnPathLevelGrowingTitle": "Growing",
"learnPathLevelGrowingSubtitle": "I practise Islam and want to learn more",
"learnPathLevelDeepDiveTitle": "Deep Dive",
"learnPathLevelDeepDiveSubtitle": "I want advanced Islamic knowledge",
"learnPathLevelWhatsIncluded": "What's included",
"learnPathCompletionTitle": "Masha'Allah — you've completed {pathName}!",
"learnPathCompletionSubtitle": "May Allah bless your learning. Here's what we suggest next:",
"learnPathCompletionBrowseAll": "Browse all paths",
"learnSelfLearningPageTitle": "Self Learning",
"learnSelfLearningSubtitle": "All content is available freely — no path required",
"learnKidsPreviewPageTitle": "Kids Learning",
"learnKidsPreviewExplainerTitle": "What children see in the app",
"learnKidsPreviewExplainerBody": "When a child profile is active, the app shows age-appropriate Islamic content. Here's a preview of their learning experience.",
"learnKidsPreviewManageTitle": "Managing child profiles",
"learnKidsPreviewManageAction": "Manage child profiles",
"learnKidsPreviewTapHint": "Switch to a child profile to access this content"
```

Run `flutter gen-l10n` after updating the ARB file.

---

## STEP 9 — VERIFY

```bash
flutter analyze
flutter test
```

Fix analysis errors introduced by this task only.
Do not touch pre-existing failing tests.

---

## CONSTRAINTS

- Do not modify any domain hub pages (hadith, life, world, quran, quizzes).
- Do not modify the `specialModeProvider` or any existing provider logic —
  only read from them and write via their existing notifier/write methods.
- Do not introduce new state management patterns — use Riverpod as already
  used throughout the app.
- Do not hardcode any user-facing strings — use `AppLocalizations`.
- Do not hardcode colours — use the app's existing theme tokens.
- Match existing widget patterns exactly — card style, padding, typography,
  button style.
- The `KidsLearnHome` widget must remain usable both standalone (for the
  kids profile) and in preview mode (for `LearnKidsPreviewPage`). Add the
  `previewMode` parameter carefully without breaking the existing usage.
- Do not modify global theme or core architecture (per AGENTS.md).
- Do not modify Qur'an text or Islamic content in any form.
- Save this prompt to:
  `codex prompts/learn/2026-04-08-three-card-hub-onboarding-integration.md`
- Save enhancement ideas to:
  `docs/learn_three_card_hub_enhancements_2026-04-08.md`

---

## DELIVERABLE SUMMARY

Output:
1. **Onboarding audit findings** — exact field names, types, and provider
   name found in Step 1
2. **Files created** (path + one-line description each)
3. **Files modified** (path + one-line description each)
4. **Routes added**
5. **Localization keys added**
6. **Settings integration** — done or TODO with reason
7. **Path completion mapping** — the static next-path suggestions used
8. **Any TODOs left** with clear explanations
9. **Backup directory path**
