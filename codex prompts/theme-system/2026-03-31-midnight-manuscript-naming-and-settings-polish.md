# PHASE THEME 5 PROMPT — MIDNIGHT MANUSCRIPT NAMING + SETTINGS POLISH

PRIMARY OBJECTIVE === BUILDING MIDNIGHT MANUSCRIPT NAMING + SETTINGS POLISH

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready settings/copy polish pass.
Do not build placeholders.
Do not redesign the theme system.
Do not break existing theme selection, theme persistence, localization, settings layout, previews, accessibility, or current theme behavior.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing anything.
- Do not remove or break existing theme options or theme persistence logic.
- Do not go haywire and remove/delete settings screens, localization files, previews, shared widgets, or existing copy for no reason.
- Preserve the current settings architecture and theme picker behavior.
- This pass is about naming, descriptions, preview labels, and subtle settings polish only.
- At the very end, run a full audit and provide one clean implementation summary.

PHASE CONTEXT
Previous passes introduced:
- Midnight Manuscript as a selectable theme
- palette/token support
- preview behavior
- theme-aware background handling
- shared component polish
- Qur’an-specific Midnight Manuscript refinement

Now this pass should make the theme feel fully intentional in the user-facing settings experience.

PRODUCT GOAL
When a user opens theme settings, Midnight Manuscript should feel:
- premium
- purposeful
- clearly distinct
- easy to understand
- calm and elegant

Users should understand:
- what the theme is called
- what it feels like
- when it is especially suitable
without needing long paragraphs.

A. AUDIT FIRST
Before making changes, audit the current settings/theme picker experience and identify:
- where the theme selector UI currently lives
- how theme labels are currently displayed
- whether descriptions/subtitles/helper text already exist for themes
- whether preview labels or theme cards already support multi-line text
- whether there is an onboarding or appearance area that also references themes
- whether any existing theme names are inconsistent in style/tone
- how localization is currently structured for settings/theme labels
- whether there are any current hardcoded theme names/descriptions that should be centralized

Before coding, identify:
- target files to modify
- localization files to update
- whether the theme picker uses a shared model/config that should hold names/descriptions
- whether any small settings UI tweaks are needed for consistent spacing/layout

B. FINALIZE THE USER-FACING THEME NAME
Use this as the primary user-facing display name:

Midnight Manuscript

Use a clean internal identifier such as:
midnightManuscript

Ensure all theme-related references are consistent:
- settings list
- preview card
- saved selection label if shown anywhere
- onboarding/appearance flows if applicable
- any internal config-to-localized-label mapping

C. ADD A SHORT THEME DESCRIPTION
Add a refined short description for Midnight Manuscript.

Preferred direction:
- Deep ink tones with warm gold accents and a quiet manuscript atmosphere.

Alternative acceptable direction:
- A deep, reflective night theme with warm gold accents and elegant Qur’an styling.

Keep it:
- concise
- premium
- calm
- non-marketing-heavy
- not too technical

Do not write a long paragraph.

D. ADD A LIGHT “BEST FOR” OR CONTEXT HELPER
If the current settings UI supports a subtle helper line, add a short guidance phrase for Midnight Manuscript.

Recommended direction:
- Best for evening reflection and Qur’an study.

Alternative acceptable directions:
- Ideal for quieter reading and reflection.
- Designed for calm night reading and deeper focus.

Requirements:
- keep it short
- do not over-explain
- only include this if it visually fits the settings UI cleanly
- if other themes also need helper lines for consistency, add similarly brief ones to them too

E. ENSURE CONSISTENT THEME NAMING STYLE ACROSS ALL OPTIONS
Audit all theme names currently shown to users and ensure they feel stylistically consistent.

Examples of consistency checks:
- title case usage
- poetic vs technical naming
- too-generic names next to premium names
- subtitle length consistency
- preview label spacing consistency

Do not rename other themes unless needed for consistency and unless it is safe.
If you do adjust other theme labels, keep the changes minimal and premium.

F. POLISH THE THEME PICKER CARD / PREVIEW TEXT LAYOUT
Refine the settings UI so the Midnight Manuscript name and description display cleanly.

Requirements:
- no cramped text
- no awkward wrapping if avoidable
- consistent spacing between preview title, subtitle, and selection indicator
- selection state still obvious
- preview remains visually premium

Only make light layout adjustments if needed.
Do not redesign the entire settings page.

G. OPTIONAL SUBTLE APPEARANCE COPY POLISH
If the settings/appearance page has a section intro or helper line, lightly polish it so the theme picker feels more premium.

Examples of acceptable directions:
- Choose the atmosphere that feels most at home in your journey.
- Select a visual style for reading, reflection, and daily use.

Keep this very short and elegant.
Only do this if the page already supports a helper line and it improves the experience.

H. ENSURE LOCALIZATION IS CLEAN
All new user-facing strings must be localization-ready.

Likely keys:
- themeMidnightManuscript
- themeMidnightManuscriptDescription
- themeMidnightManuscriptBestFor

If the app uses a shared appearance/theme localization structure, follow that pattern exactly.
Do not hardcode strings in widgets.

At the end, report:
- new localization keys added
- locale resources updated

I. PRESERVE ACCESSIBILITY + SETTINGS CLARITY
Requirements:
- text remains readable at larger text scales
- descriptions do not overflow badly
- selection states remain obvious
- the settings page remains uncluttered
- helper text does not reduce clarity

Do not let polish make settings harder to scan.

J. OPTIONAL CONSISTENCY PASS FOR THEME DESCRIPTIONS
If the app already supports theme descriptions and Midnight Manuscript would otherwise be the only theme with a subtitle/helper, consider adding similarly brief descriptions to the other themes for consistency.

Only do this if:
- the UI supports it cleanly
- the copy remains concise
- it improves overall polish

Do not over-expand the settings page.

K. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify Midnight Manuscript name appears correctly everywhere user-facing
- verify description/helper text displays correctly
- verify theme picker layout remains clean
- verify theme selection still works and persists
- verify localization works correctly
- verify large text/accessibility scaling remains coherent
- verify no regressions in settings appearance layout

L. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Naming decisions finalized
3. Description/helper text added
4. Settings/theme picker layout changes
5. Localization keys added
6. Any consistency changes made to other themes
7. Analyzer/test results
8. Follow-up recommendations

COPY DIRECTION SUMMARY
Midnight Manuscript should read like:
- premium
- calm
- reflective
- elegant
- spiritually grounded

It should NOT read like:
- generic dark mode
- technical skin name
- fantasy/gaming theme
- overly poetic and unclear marketing copy

IMPORTANT
Build this as a real user-facing polish pass.
Do not break the current theme system.
Do not clutter the settings UI.
Do not hardcode labels.
At the very end, run a final audit and provide one complete implementation summary.
