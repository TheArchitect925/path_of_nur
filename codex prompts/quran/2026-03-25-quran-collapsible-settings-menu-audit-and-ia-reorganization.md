===== PHASE X PROMPT — QURAN COLLAPSIBLE SETTINGS MENU AUDIT + IA REORGANIZATION =====

PRIMARY OBJECTIVE === BUILDING QURAN SETTINGS MENU IMPROVEMENT

You are working inside the existing Flutter codebase for Path of Nūr.

This phase is an audit-first information architecture and usability improvement pass for the Qur’an collapsible settings menu and related settings surfaces.

We want the Qur’an settings experience to feel:
- cleaner
- calmer
- easier to scan
- easier to use with one hand
- more logically grouped
- less cluttered
- more premium
- more reader-first

This is NOT a blind redesign.
Audit first, then reorganize with minimal disruption to the canonical runtime and existing settings contracts.

==================================================
CRITICAL RULES
==================================================

1. AUDIT FIRST before changing the structure.
2. DO NOT break the canonical Qur’an player/runtime architecture.
3. DO NOT break existing settings persistence unless a safe migration is explicitly implemented.
4. DO NOT delete settings casually.
5. DO NOT create duplicate settings surfaces for the same function.
6. DO NOT mix low-frequency advanced controls with high-frequency reading controls unless clearly justified.
7. Keep this production-ready, not a mock redesign.
8. End with a full Codex audit summary.

==================================================
AUDIT OBJECTIVE
==================================================

Audit the current Qur’an collapsible settings menu and any connected settings surfaces to determine:

1. what settings currently exist
2. where they are surfaced
3. how they are grouped today
4. which ones are high-frequency vs low-frequency
5. which are confusing, duplicated, buried, or poorly named
6. which belong in quick access vs collapsible sections vs separate flows
7. whether the current layout is too long, too dense, or too inconsistent
8. whether some settings should move to:
   - a cleaner grouped accordion
   - a bottom sheet
   - a dedicated sub-sheet
   - a separate advanced section
9. whether any current controls are visually noisy or interaction-heavy

==================================================
AUDIT SCOPE
==================================================

Inspect all relevant Qur’an settings surfaces, including but not limited to:
- quran_reader_page.dart
- any current collapsible settings menu widget(s)
- quran_reader_playback_presentation.dart
- quran_playback_controls_card.dart
- quran_expanded_player_sheet.dart
- Focus Recitation Mode surfaces if they expose related settings
- quran_providers.dart
- any settings models/state objects tied to Qur’an reading/playback preferences
- localization keys related to Qur’an settings labels

Also inspect whether settings are duplicated across:
- reader page
- full player
- mini player
- focus mode
- overflow menus
- collapsible panel(s)

==================================================
REQUIRED AUDIT OUTPUT
==================================================

Produce a structured audit that clearly identifies:

1. CURRENT SETTINGS INVENTORY
For each current setting/control:
- label
- purpose
- where it appears
- how often a typical user may use it
- whether it is reader-focused, playback-focused, offline-focused, or advanced

2. CURRENT UX / IA PROBLEMS
Examples:
- duplicated settings
- weak grouping
- too many toggles in one section
- poor labels
- settings that are too hidden
- settings that are too prominent
- settings that interrupt reading flow
- collapsible sections that are too long or hard to scan

3. RECOMMENDED INFORMATION ARCHITECTURE
Propose a better grouped structure.

Strongly consider grouping into sections such as:
- Reading & Display
- Audio & Playback
- Navigation & Follow Behavior
- Downloads & Offline
- Advanced

But choose the best structure based on what actually exists.

4. QUICK ACCESS VS DEEP SETTINGS
Recommend which settings should stay immediately accessible and which should move deeper.

For example:
Quick access candidates:
- translation
- transliteration
- font size
- reciter
- follow ayah mode

Deeper settings candidates:
- playback speed
- repeat behavior
- download removal
- experimental toggles
- advanced diagnostics hooks

5. LABEL / COPY IMPROVEMENTS
Recommend cleaner user-facing names for settings where current labels are too technical or unclear.

==================================================
REORGANIZATION GOAL
==================================================

After the audit, reorganize the settings menu into a more usable structure.

The improved settings experience should:
- reduce clutter
- improve scanability
- group related controls together
- make high-frequency actions easier to reach
- keep low-frequency settings available but less noisy
- preserve calm visual design
- avoid giant walls of toggles

==================================================
REORGANIZATION REQUIREMENTS
==================================================

Implement a cleaner grouped structure.

Preferred direction:
- use clear sections/cards/groups
- use dividers/headers sparingly but meaningfully
- preserve the collapsible nature if that still makes sense
- if the current collapsible container is the right pattern, keep it and improve the internal grouping
- if nested sections or segmented grouping is better, do that cleanly

Do not overcomplicate.
Do not create a settings labyrinth.

==================================================
LIKELY TARGET GROUPING
==================================================

Use the audit to decide the final structure, but a strong default is:

1. READING & DISPLAY
Examples:
- translation on/off
- transliteration on/off
- Arabic text size
- reading appearance
- contrast / readability options if they exist

2. AUDIO & PLAYBACK
Examples:
- reciter
- play/pause related options
- playback speed
- repeat current ayah / repeat settings
- focus recitation mode entry if appropriate
- continue listening preferences if surfaced here

3. FOLLOW & NAVIGATION
Examples:
- Follow Ayah Mode
- auto-follow behavior
- ayah highlight behavior
- jump behavior
- resume preferences

4. DOWNLOADS & OFFLINE
Examples:
- download current surah
- remove download
- local/offline status
- repair/health hooks later if present

5. ADVANCED
Examples:
- lesser-used toggles
- experimental / diagnostic / technical settings
- anything not appropriate for most users

Only use this structure if it fits the real inventory.

==================================================
USABILITY IMPROVEMENT RULES
==================================================

1. High-frequency settings should be near the top.
2. Reading-related options should be easy to find and not buried under playback controls.
3. Audio-related options should not dominate the reading menu if they are better suited to the player.
4. Avoid mixing destructive actions like remove download beside harmless display toggles.
5. Use labels that normal users understand.
6. Keep one source of truth per setting.
7. If some settings belong better in the full player or Focus Mode instead of the reader settings menu, move them there cleanly.
8. Keep the Qur’an reading flow uninterrupted.

==================================================
VISUAL / INTERACTION GUIDELINES
==================================================

The menu should feel:
- calm
- lightweight
- readable
- premium
- organized

Avoid:
- giant unbroken lists
- too many nested accordions
- repeated subtitles everywhere
- overly technical controls in the primary view
- cluttered rows with too many icons

Prefer:
- concise section headings
- compact but readable row spacing
- clear switch/toggle placement
- thoughtful separation between sections
- visible hierarchy

==================================================
PERSISTENCE / CONTRACT SAFETY
==================================================

Preserve existing settings behavior and storage contracts unless there is a safe reason to refactor them.

If a settings structure needs refactoring:
- migrate carefully
- preserve existing values where possible
- do not silently reset user preferences

Confirm any affected settings keys or model contracts remain intact or are migrated safely.

==================================================
LOCALIZATION
==================================================

Audit current labels and improve them where needed.

If changing labels or adding section headers:
- update localization keys cleanly
- keep labels short and user-friendly
- avoid internal/dev terminology

Run localization generation if needed.

==================================================
TESTING REQUIREMENTS
==================================================

Add or update focused tests for:
1. settings menu still opens/closes correctly
2. reorganized sections render correctly
3. key settings remain functional after reorganization
4. no settings state is lost
5. moved controls still dispatch to the correct canonical state/provider
6. duplicated settings are removed if consolidated
7. reading-critical controls remain easy to access
8. no regression in player/reader behavior caused by the reorganization

Run:
- flutter gen-l10n if needed
- focused flutter analyze
- focused widget tests around the Qur’an settings surface

==================================================
FILES TO PRIORITIZE
==================================================

Start with the actual settings surface/widget(s), then inspect supporting state/models/providers.

Likely touch points include:
- quran_reader_page.dart
- current collapsible settings widget(s)
- quran_providers.dart
- reader/player presentation widgets
- localization files under lib/l10n

Only touch playback controllers if a moved setting truly requires it.
This phase is primarily UX/IA cleanup, not playback logic work.

==================================================
DELIVERABLES
==================================================

At the end provide:

1. AUDIT FINDINGS
- current settings inventory
- key usability problems
- duplication findings
- confusing labels
- grouping issues

2. NEW INFORMATION ARCHITECTURE
- final section structure
- what moved where
- what stayed in quick access
- what moved deeper

3. FILES CHANGED
- added
- modified
- removed

4. SETTINGS BEHAVIOR STATUS
- what remained unchanged functionally
- what was reorganized
- whether any settings were migrated

5. LOCALIZATION REPORT
- new keys
- updated keys
- anything left translation-ready

6. VALIDATION
- tests run
- analyze run
- gen-l10n run if applicable

7. FINAL CODEX AUDIT
End with:
- what was improved
- what still feels crowded if anything
- what future settings cleanup or separation may still be useful

IMPORTANT PRODUCT INTENT
The Qur’an settings menu should feel like:
- a calm companion
- easy to scan
- easy to understand
- organized by user intent
- not a dumping ground for every possible toggle
