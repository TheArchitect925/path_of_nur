# Codex Task: Free Access to All Learning Content

## Context

The Learn hub currently has:
1. Your Path (guided learning — user-chosen path)
2. Explore (5 pillars)
3. Utilities (Quizzes, Notes, Saved)
4. All Learning Content card (legacy/temporary triage card at bottom)

The product requirement is: **all learning content must be accessible at any
time, independent of any learning path.** The guided path is a helpful guide,
not a gatekeeper. A user who has chosen "New to Islam" must still be able to
freely browse Hadith, Qur'anic Arabic, Prophets, Quizzes, or any other content
without it being locked behind their path stage.

This task has two parts:
1. Make the Explore section a full, always-accessible content library.
2. Rename and reframe the "All Learning Content" legacy card to reflect that
   it is a permanent free-browse section, not a temporary triage card.

---

## STEP 0 — BACKUP

```bash
BACKUP_DIR="backups/free_access_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

cp lib/features/learn/presentation/pages/learning_section_landing_page.dart \
   "$BACKUP_DIR/learning_section_landing_page.dart.bak"
cp lib/features/learn/presentation/widgets/learn_legacy_content_card.dart \
   "$BACKUP_DIR/learn_legacy_content_card.dart.bak"
cp lib/features/learn/presentation/widgets/learn_explore_pillars_widget.dart \
   "$BACKUP_DIR/learn_explore_pillars_widget.dart.bak"

echo "Backup complete → $BACKUP_DIR"
```

Do not proceed until the backup exists.

---

## STEP 1 — UPDATE THE EXPLORE PILLARS SECTION

### 1a — Make the section heading clearer

In `learn_explore_pillars_widget.dart`, change the section heading from
"Explore" to "Browse all topics" (or use the localization key
`learnHubBrowseAllTopicsTitle` — add it to the ARB file).

This label change signals to the user that this is a free library, not a
curated selection tied to their path.

### 1b — Add a subtle subheading below the section title

Add one line of muted text beneath the heading:
"All content is available to you anytime — no need to follow your path."

Use localization key `learnHubBrowseAllSubtitle`. Add it to the ARB file.

Keep the subheading short and muted (12px, `color: theme secondary text`).
Do not add it as a banner or call-to-action — just a quiet reassurance line.

### 1c — Ensure pillar cards have no locked/disabled state

Confirm that none of the 5 pillar cards in `learn_explore_pillars_widget.dart`
have any conditional `enabled`, `opacity`, or `isLocked` logic tied to the
user's current path state or path progress.

If any such logic exists, remove it entirely. Every pillar card must always
be fully tappable regardless of whether the user has a path set, what path
they chose, or how far along they are.

### 1d — Add "Browse freely" affordance to the Your Path card

In `learn_your_path_card.dart`, below the "Continue" button, add a small
secondary text link:

  "Not now — browse freely ↓"

This is a `TextButton` (or `GestureDetector` with styled text) that simply
scrolls the parent page down to the "Browse all topics" section. Use a
`ScrollController` passed from the parent page, or emit a callback
`onBrowseFreelyTapped` that the parent handles.

The label uses localization key `learnHubPathCardBrowseFreelyAction`.

This link must also appear on the `LearnPathPickerWidget` — beneath the two
path option cards — so users who haven't picked a path yet can still skip
straight to browsing. Same label, same behaviour.

---

## STEP 2 — RENAME AND REFRAME THE LEGACY CONTENT CARD

The card currently named "All Learning Content" with a "Temporary" badge needs
to be reframed. It is not temporary — it is a permanent free-browse section
for content not yet assigned to a pillar.

### 2a — Rename the widget file

Rename `learn_legacy_content_card.dart` to `learn_free_browse_card.dart`.
Update the class name from `LearnLegacyContentCard` to `LearnFreeBrowseCard`.
Update the import and usage in `learning_section_landing_page.dart`.

### 2b — Update the card header

Change:
- Title: from "All Learning Content" to "More to explore"
- Subtitle: from "Legacy content — tap to browse while we organise these
  sections" to "Browse all learning material freely — organised sections
  coming soon"
- Remove the amber "Temporary" badge entirely
- Replace it with no badge (clean header)

The card remains collapsible (collapsed by default). The chevron behaviour
is unchanged.

Update localization keys:
- `learnFreeBrowseCardTitle`: "More to explore"
- `learnFreeBrowseCardSubtitle`: "Browse all learning material freely — organised sections coming soon"

Remove the old keys `learnLegacyCardTitle`, `learnLegacyCardSubtitle`,
`learnLegacyCardBadge` from `app_en.arb` only if they are not referenced
anywhere else in the codebase. If they are referenced elsewhere, leave them
and add a `// TODO: remove after all callers updated` comment.

### 2c — Add a section heading above the card

Above `LearnFreeBrowseCard` in the landing page scroll view, add a small
section heading: "More to explore" at the same visual weight as the
"Browse all topics" and "Your path" headings above it.

Use localization key `learnHubMoreToExploreSectionTitle`.

---

## STEP 3 — REMOVE ANY PATH-GATING FROM DOMAIN HUB PAGES

This is a read-and-flag step, not a change step.

Open each of these files and check whether any content, tab, or section is
conditionally hidden, disabled, or locked based on the user's active learning
path or path progress state:

- `lib/features/learn/hadith/presentation/hadith_landing_page.dart`
- `lib/features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart`
- `lib/features/learn/world/presentation/world_landing_page.dart`
- `lib/features/learn/presentation/pages/quran_app_hub_page.dart`
- `lib/features/learn/presentation/pages/learn_quizzes_hub_page.dart`

For each file:
- If you find path-gating logic (e.g. `if (userPath == null) return locked`,
  or `isLocked: pathProgress < threshold`): add a comment
  `// TODO: path-gating found here — review and remove per free-access policy`
  and do NOT remove it in this task (leave it for a dedicated follow-up).
- If you find no path-gating: add a one-line comment at the top of the file:
  `// FREE ACCESS: no path-gating — all content accessible ✓`

Output the result of this audit in your deliverable summary.

---

## STEP 4 — UPDATE THE LANDING PAGE SECTION ORDER

The landing page scroll order should now be:

1. Your Path card (or path picker if no path chosen)
   — with "browse freely" link beneath it
2. "Browse all topics" section heading + subtitle
3. 5 pillar cards grid
4. Utilities row (Quizzes, Notes, Saved)
5. "More to explore" section heading
6. LearnFreeBrowseCard (collapsed by default)

This makes it visually clear that the page has two modes: guided (top) and
free browse (everywhere below). Update the scroll view widget tree in
`learning_section_landing_page.dart` to match this order if it doesn't already.

---

## STEP 5 — UPDATE LOCALIZATION

Add all new keys to `lib/l10n/app_en.arb`:

```json
"learnHubBrowseAllTopicsTitle": "Browse all topics",
"learnHubBrowseAllSubtitle": "All content is available to you anytime — no need to follow your path.",
"learnHubPathCardBrowseFreelyAction": "Not now — browse freely",
"learnHubMoreToExploreSectionTitle": "More to explore",
"learnFreeBrowseCardTitle": "More to explore",
"learnFreeBrowseCardSubtitle": "Browse all learning material freely — organised sections coming soon"
```

Run `flutter gen-l10n` after updating the ARB file.

---

## STEP 6 — VERIFY

```bash
flutter analyze
flutter test
```

Fix any analysis errors introduced by this task only.
Do not touch pre-existing failing tests.

---

## CONSTRAINTS

- Do not add any path-gating, locking, or access control logic anywhere.
  This entire task is about removing barriers, not adding them.
- Do not modify any route definitions.
- Do not modify any provider or state management files beyond reading from
  existing providers.
- Do not rename or restructure any domain hub pages.
- The kids profile guard (`specialModeProvider.isKids`) must remain — kids
  profiles still see `KidsLearnHome` only, and the free browse card must
  remain hidden from kids profiles.
- Match existing widget patterns, padding, and theme tokens exactly.
- Never hardcode colours — use the app's theme tokens.
- All user-facing strings must use localization keys.

---

## DELIVERABLE SUMMARY

Output:
1. Files modified (one-line description each)
2. Files renamed
3. New localization keys added
4. Path-gating audit results (one line per domain hub file)
5. Any TODOs left for follow-up
6. Backup directory path
