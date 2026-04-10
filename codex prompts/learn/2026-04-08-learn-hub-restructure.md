# Codex Task: Learn Hub Restructure — Path of Nūr

## STEP 0 — BACKUP FIRST (do this before touching any files)

Before making any changes, create a timestamped backup of every file you will
modify or delete. Run this shell block at the very start:

```bash
BACKUP_DIR="backups/learn_hub_restructure_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Back up the landing page
cp lib/features/learn/presentation/pages/learning_section_landing_page.dart \
   "$BACKUP_DIR/learning_section_landing_page.dart.bak"

# Back up the taxonomy
cp lib/features/learn/presentation/data/learn_hub_taxonomy.dart \
   "$BACKUP_DIR/learn_hub_taxonomy.dart.bak"

# Back up the tab provider
cp lib/features/learn/application/learn_tab_provider.dart \
   "$BACKUP_DIR/learn_tab_provider.dart.bak"

# Back up the route files
cp lib/app/routes/learn/learn_core_routes.dart \
   "$BACKUP_DIR/learn_core_routes.dart.bak"
cp lib/app/routes/learn/learn_hub_and_quiz_routes.dart \
   "$BACKUP_DIR/learn_hub_and_quiz_routes.dart.bak"
cp lib/app/routes/learn/learn_route_helpers.dart \
   "$BACKUP_DIR/learn_route_helpers.dart.bak"

echo "Backup complete → $BACKUP_DIR"
```

Write a `backups/README.md` with this content:
```
# Learn Hub Restructure Backup
Created by Codex on: <insert current date>
Purpose: Backup before Learn hub IA restructure.
To revert: copy .bak files back to their original paths and run flutter analyze.
```

Do not proceed to Step 1 until the backup directory exists and all .bak files
are confirmed present.

---

## STEP 1 — REBUILD `learning_section_landing_page.dart`

Completely replace the body of `learning_section_landing_page.dart`.

The new page must do exactly these things and nothing else:

### 1a — Profile guard (first thing in the build method)

```dart
// At the very top of the build method, before any scaffold:
final isKids = ref.watch(specialModeProvider).isKids;
if (isKids) {
  return const KidsLearnHome();
}
```

If `specialModeProvider` is not yet exposed via a clean interface, read from
whatever provider currently backs `specialModeProvider.isKids`. Do not change
the provider — just read it.

### 1b — Section 1: Your Path card

Read `learn.path.state.v1` from the existing path state provider.

- **If no path is chosen:** render a `LearnPathPickerWidget` (created in
  Step 3). This widget presents two options: "I am new to Islam" and
  "I am an existing Muslim — choose a focus". Keep it visually simple:
  two tappable cards with a short description each, and a "Get started"
  button per card. Do not add anything else to this widget.

- **If a path is chosen:** render a `LearnYourPathCard` (created in Step 3).
  This card shows: the path name, the current stage title, a linear progress
  indicator (stages completed / total stages), and a single primary CTA
  button labelled "Continue". The button routes to the existing journey stage
  route for the current stage. Nothing else goes on this card.

Label the section with a small heading: "Your path".

### 1c — Section 2: Explore pillars

Below Section 1, render a `LearnExplorePillarsWidget` (created in Step 4).
Label the section with a small heading: "Explore".

### 1d — Section 3: Utilities row

Below Section 2, render a simple horizontal row of three small icon+label
tiles: "Quizzes & Games", "Notes", "Saved". Each routes to its existing
destination. No other utility links.

### 1e — Remove everything that was on the page before

Remove all of the following — do not keep them, do not move them elsewhere
on this page, do not comment them out:
- Personalized next step widget / suggested next widget
- Enrichment / milestones / memories section
- Continue journey section (it is replaced by the Your Path card)
- Daily learning section
- Guided learning paths section (replaced by the path card)
- Visible islands grid
- Kids discovery section (moved to KidsLearnHome)
- Explore all link / explore all button
- Featured item collapsed section
- Recently opened collapsed section
- Overall progress summary widget

---

## STEP 2 — UPDATE `learn_hub_taxonomy.dart`

Reduce the taxonomy from 11 categories to exactly 5 pillars. Replace the
current category list with:

```dart
static const List<LearnPillar> pillars = [
  LearnPillar(
    id: 'life_character',
    label: 'Life & Character',
    description: 'Divine life lessons, reflection, and everyday wisdom',
    route: AppRoutes.learnLifeLanding,        // existing route — do not change
    iconAsset: 'assets/icons/learn_life.svg', // use existing asset if present
  ),
  LearnPillar(
    id: 'world_creation',
    label: 'World & Creation',
    description: 'Signs of Allah in nature, science, and the cosmos',
    route: AppRoutes.learnWorldLanding,
    iconAsset: 'assets/icons/learn_world.svg',
  ),
  LearnPillar(
    id: 'hadith_sunnah',
    label: 'Hadith & Sunnah',
    description: 'Prophetic narrations, themes, and collections',
    route: AppRoutes.learnHadithLanding,
    iconAsset: 'assets/icons/learn_hadith.svg',
  ),
  LearnPillar(
    id: 'prophets_stories',
    label: 'Prophets & Stories',
    description: 'The lives and lessons of the Prophets',
    route: AppRoutes.prophetsPage,            // existing route — do not change
    iconAsset: 'assets/icons/learn_prophets.svg',
  ),
  LearnPillar(
    id: 'worship_practice',
    label: 'Worship & Practice',
    description: 'Salah, wudu, dua, dhikr, and daily devotion',
    route: AppRoutes.worshipHub,              // use closest existing worship route
    iconAsset: 'assets/icons/learn_worship.svg',
  ),
];
```

If a `LearnPillar` model does not exist, create it as a simple immutable class
with `id`, `label`, `description`, `route`, and `iconAsset` fields.

If any icon assets are missing, use a `const Icon(Icons.circle_outlined)` 
placeholder — do not block the build on missing assets.

Do NOT delete the old taxonomy data yet — move it to a comment block labelled
`// LEGACY — safe to remove after v1 launch` so it can be restored if needed.

---

## STEP 3 — CREATE NEW WIDGETS

Create these files. Keep each one focused — no extra features, no extra params.

### `lib/features/learn/presentation/widgets/learn_path_picker_widget.dart`

A stateless widget showing:
- A heading: "Choose your path"
- A short subheading: "We'll guide you to the right place"
- Two `LearnPathOptionCard` widgets side by side (or stacked on narrow screens):
  - Option A: title "New to Islam", description "Start with the foundations.
    We'll guide you step by step.", onTap writes `UserLearnPath.newMuslim`
    to `learn.path.state.v1` via the existing path state notifier.
  - Option B: title "Deepening my faith", description "Explore Quran Arabic,
    Hadith, Seerah, and more.", onTap writes `UserLearnPath.existingMuslim`
    and immediately shows an inline path-focus picker (see below).
- For Option B, after selecting, show a second step inline (not a new screen):
  a list of focus path chips: "Quran & Arabic", "Hadith deep dive",
  "Seerah & Prophets", "Character & Adab". The user picks one, then taps
  "Start this path". This writes the focus selection to the path state and
  dismisses the picker.

Do not navigate anywhere — the parent page will react to the path state change
and replace this widget with `LearnYourPathCard` automatically.

### `lib/features/learn/presentation/widgets/learn_your_path_card.dart`

A stateless widget that accepts:
- `pathName` (String)
- `stageName` (String)
- `stagesCompleted` (int)
- `totalStages` (int)
- `onContinue` (VoidCallback)

Renders:
- Small label: "Your path"
- Path name in medium weight
- Current stage name
- A `LinearProgressIndicator` showing completion ratio
- A prominent "Continue" button that calls `onContinue`

The parent page is responsible for reading the path state and passing the
correct values. This widget is purely presentational.

### `lib/features/learn/presentation/widgets/learn_explore_pillars_widget.dart`

A stateless widget that renders the 5 pillars from `learn_hub_taxonomy.dart`
as a 2-column grid of cards. Each card shows:
- The pillar label (medium weight, 15px)
- The pillar description (12px, muted)
- An icon (from `iconAsset`, or placeholder if missing)

Tapping a card navigates to the pillar's route using `context.go(pillar.route)`
or the app's existing navigation pattern — match whatever `go_router` / GoRouter
pattern the rest of the app uses for internal navigation.

### `lib/features/learn/presentation/widgets/kids_learn_home.dart`

A stateless widget that renders when `specialModeProvider.isKids` is true.
Keep it very simple for now — this is a placeholder with the correct structure:
- A large greeting: "Assalamu Alaikum! 👋" (or the app's localized equivalent
  from `AppLocalizations`)
- Four large tappable cards in a 2×2 grid:
  - "Prophet Stories" → routes to existing prophet stories kids route
  - "Quran Basics" → routes to existing kids Quran route
  - "Duas I Know" → routes to existing kids dua route
  - "Play & Learn" → routes to existing kids games route
- Use large touch targets (minimum 80px height per card) and larger text
  (18px labels) appropriate for children
- Do not show any adult explore content, path picker, or utilities row

---

## STEP 4 — UPDATE `learn_tab_provider.dart`

Remove `quran` from the tab enum if it is currently one of the five tabs
(`quran`, `life`, `world`, `hadith`, `notes`). Quran now has its own top-level
app tab and must not appear as a sub-tab inside Learn.

The resulting Learn tabs should be: `life`, `world`, `hadith`, `notes`.

If removing `quran` from this provider would break other files, add a
`// TODO: remove quran tab references` comment on each affected line and leave
those lines in place — do not fix cascading issues in this task. Just flag them.

---

## STEP 5 — RETIRE LEGACY ROUTES (safe removal)

In `learn_core_routes.dart`, `learn_hub_and_quiz_routes.dart`, and
`learn_route_helpers.dart`:

- Comment out (do not delete) any route that is explicitly marked as `legacy`,
  `alias`, or `compatibility` in its own inline comment.
- Add a comment above each commented-out block:
  `// LEGACY ROUTE — safe to delete after confirming no deep links point here`
- Do not remove any route that does not have an explicit legacy/alias/compat
  label. When in doubt, leave it active.

---

## STEP 6 — VERIFY

After all changes, run:

```bash
flutter analyze
flutter test
```

Fix any analysis errors introduced by this task. If a test fails because a
widget that was removed is referenced in a test, comment out that test and add:
`// TODO: update test after Learn hub restructure — widget removed`

Do not fix pre-existing test failures that existed before this task.

---

## CONSTRAINTS AND GUARDRAILS

- Do not touch any domain hub pages: `hadith_landing_page.dart`,
  `divine_life_lessons_page.dart`, `world_landing_page.dart`,
  `quran_app_hub_page.dart`. These are correct and must not be modified.
- Do not touch any journey stage or journey island page files.
- Do not modify the `specialModeProvider` — only read it.
- Do not modify `learn.path.state.v1` persistence logic — only read/write via
  the existing notifier.
- Do not add any analytics, logging, or tracking calls.
- Do not add any network calls or API integrations.
- Do not add animations or transitions — the existing app theme handles these.
- Use `AppLocalizations` for any user-facing strings — do not hardcode English.
  If a key does not exist yet, add a `// TODO: add l10n key` comment and use a
  const fallback string temporarily.
- Match the existing code style, widget patterns, and Riverpod usage patterns
  exactly. Do not introduce new state management patterns.
- If you are uncertain about a route name, use `// TODO: confirm route name`
  and leave a clearly named placeholder constant — do not guess.

---

## DELIVERABLE SUMMARY

When done, output a short summary listing:
1. Every file modified (with a one-line description of what changed)
2. Every file created (with its path)
3. Every route commented out as legacy
4. Any TODOs left for follow-up
5. The path to the backup directory

That summary is the only console output needed — no further explanation required.
