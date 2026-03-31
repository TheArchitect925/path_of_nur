# PHASE THEME PROMPT — MIDNIGHT MANUSCRIPT THEME OPTION

PRIMARY OBJECTIVE === BUILDING A NEW SELECTABLE APP THEME: MIDNIGHT MANUSCRIPT

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready theming pass.
Do not create a one-off page theme.
Do not hardcode page-level colors into individual screens where a reusable theme/token system should be used.
Do not break existing light theme behavior, current glass container treatment, accessibility, theme switching, localization, or page consistency.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing anything.
- Do not remove or break the existing theme system.
- Do not go haywire and remove/delete records, theme files, settings, or shared UI logic for no reason.
- Preserve the current Path of Nūr glass card/container look, transparency treatment, and structural card language.
- This new theme should change colors/tones/typography emphasis, not the app’s core component architecture.
- At the very end, run a full audit and provide one clean implementation summary.

PRODUCT GOAL
We want to add a new selectable visual theme to Path of Nūr.

Working theme name:
MIDNIGHT MANUSCRIPT

This theme should be inspired by the supplied Quran summary reference, but adapted across Path of Nūr in a reusable and controlled way.

IMPORTANT DESIGN INTENT
Keep:
- current Path of Nūr glass card/container look
- current transparency style
- current rounded corners
- current shell/page structure
- current reusable container language

Change/adapt:
- background colors
- text colors
- accent colors
- border tones
- chip/badge styling
- section/header atmospherics
- Quran-specific emphasis styling where appropriate

This should feel like:
Path of Nūr + elegant night manuscript palette
NOT like a separate app

A. AUDIT FIRST
Before making any changes, audit the existing theming system and identify:
- where the main app theme definitions currently live
- how light/dark/theme selection currently works
- whether there is already a theme enum, theme mode selector, or settings persistence for user theme preference
- what ThemeExtension or token systems already exist
- what current shared glass/card components depend on
- whether page backgrounds are centrally controlled or still partially hardcoded
- which components would automatically inherit a new theme correctly
- which components/pages currently bypass theme tokens and use hardcoded colors that would conflict with this pass

Before coding, identify:
- target files to modify
- new theme/token files to add
- whether the theme selector/settings screen needs updating
- what theme persistence logic already exists
- what components likely need cleanup to properly consume the new theme

B. CREATE A NEW SELECTABLE THEME VARIANT
Add a new user-selectable theme option called:
Midnight Manuscript

If the app uses an enum or theme setting model, add this as a first-class option.
Do not hack it in as a page-only toggle.

The new theme must:
- appear in the app’s theme/settings selector
- persist correctly like other theme choices
- restore correctly on app restart
- apply consistently across the app

C. THEME PALETTE DIRECTION
Use the supplied reference as inspiration for the palette.

Core palette direction:
- page background / deep ink: #0D1117
- rich dark surface: #111418
- elevated dark control surface: #161B22
- gold accent: #C9A84C
- warm cream primary text: #E8DCC8
- muted bronze secondary text: #8A7A5A
- subtle dark gold border: #2A2210
- deeper border/separator tone: #3A2A0A
- muted footer/support text: #6A5C3A
- subdued tertiary text: #4A4030
- Madani accent / muted jade: #7EB5A6

Do NOT blindly copy these everywhere.
Adapt them through the app’s existing theme architecture.

D. KEEP THE GLASS CONTAINER LANGUAGE
This is critical.

Do NOT redesign the app into flat opaque cards.
Do NOT replace the current Path of Nūr container look.

Preserve:
- glass effect
- transparency behavior
- blur behavior if present
- card shape language
- current shared containers/surfaces

Instead, adapt the glass system so it harmonizes with Midnight Manuscript:
- darker translucent fills
- refined gold-tinted borders where appropriate
- warm text on dark surfaces
- subtle manuscript-like atmosphere
- carefully controlled contrast

Goal:
The app still looks like Path of Nūr, just with a richer night manuscript mood.

E. FORMALIZE THEME TOKENS
Introduce or extend theme tokens cleanly.

Suggested categories:
- app background
- alternate background
- elevated glass fill
- base glass fill
- card stroke/border
- highlight border
- primary text
- secondary text
- muted text
- accent gold
- accent soft gold
- Quran Arabic emphasis color
- success/confirmation tone adapted to theme
- Makki chip tone
- Madani chip tone
- divider tone
- input background tone
- selected chip background
- unselected chip background

Use ThemeExtension or the app’s established token system.
Do not scatter hardcoded theme colors across pages.

F. ADD QURAN-OPTIMIZED TYPOGRAPHY COLOR EMPHASIS
This theme should be especially strong in Qur’an-related surfaces.

Without changing the global font architecture recklessly:
- make Arabic headings feel richer and more luminous
- make gold accents feel elegant, not loud
- keep English body text highly readable
- preserve accessibility/contrast

If the app already has Arabic font rules, reuse them.
Do not randomly swap fonts app-wide unless the current architecture supports it cleanly.

G. APPLY THE THEME ACROSS THE APP SAFELY
Ensure Midnight Manuscript works across the app, not only in the Qur’an pages.

At minimum validate styling for:
- Home
- Worship
- Qur’an
- Learn
- Journey
- Settings/Profile
- common app bars
- navigation shell
- dialogs/sheets
- search fields
- chips/tabs
- buttons
- section headers
- cards/lists
- empty states

The Qur’an section can feel especially premium in this theme, but the rest of the app must still look coherent.

H. QURAN-SPECIFIC ENHANCEMENT LAYER
Where the app already has a Qur’an-specific theme extension or shared Qur’an design tokens, adapt them for Midnight Manuscript.

Specifically support:
- richer header gradients
- gold-accented section titles
- strong Arabic title treatment
- elegant Makki / Madani chips
- warm metadata text
- subtle sacred/editorial atmosphere

This should enhance the Qur’an section without making the rest of the app look out of place.

I. SETTINGS / THEME PICKER UPDATE
Update the settings/theme picker so the user can choose the new theme.

Requirements:
- label shown as “Midnight Manuscript”
- preview swatch/tile if the app already has theme previews
- selection state should be clear
- save and restore preference correctly
- do not regress current theme options

If there is already a compact theme preview card system, add Midnight Manuscript to it cleanly.

J. KEEP ACCESSIBILITY STRONG
The new theme must remain readable and usable.

Requirements:
- maintain strong text contrast
- ensure secondary text is still readable
- ensure chips/buttons are not too faint
- preserve visible focus/selection states
- preserve readability on glass surfaces
- support text scaling
- support reduced transparency / reduced motion if already available
- ensure important actions remain visually clear

Do not sacrifice usability for mood.

K. CLEAN UP HARDCODED COLORS THAT CONFLICT
As part of this pass, identify and safely refactor pages/components still using hardcoded colors that would break or look wrong under Midnight Manuscript.

Important:
- only refactor where needed
- do not trigger a giant unrelated redesign
- prioritize active/shared surfaces first
- preserve current appearance in existing themes too

L. OPTIONAL ATMOSPHERIC LAYER — VERY SUBTLE
If the architecture allows cleanly, add a restrained atmospheric enhancement for Midnight Manuscript such as:
- subtle radial gold glow in some headers
- very soft dark gradient page backing
- elegant divider treatment
- faint manuscript warmth in section headers

Do NOT:
- add busy wallpaper textures
- reduce readability
- create performance-heavy backgrounds
- over-ornament the UI

M. LOCALIZATION / LABELS
Any new user-facing theme name or theme picker labels must be localization-ready.

Likely new keys:
- Midnight Manuscript
- Theme preview description if needed
- current selection labels if needed

At the end, report:
- new localization keys added
- locale resources updated

N. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify the new theme appears in settings
- verify theme switching works
- verify selected theme persists after restart
- verify app navigation shell still looks correct
- verify Qur’an pages especially benefit visually
- verify glass containers remain intact
- verify light and existing themes are not regressed
- verify no unreadable text on dark surfaces
- verify chips/buttons/search fields remain usable
- verify accessibility and text scaling remain coherent

O. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Theme architecture touched
3. New theme enum/setting added
4. Theme tokens/palette introduced
5. How glass containers were preserved
6. Which shared components were updated
7. Which pages/components needed hardcoded color cleanup
8. Settings/theme picker updates
9. Localization keys added
10. Analyzer/test results
11. Follow-up recommendations

DESIGN SUMMARY
This theme should feel like:
- deep ink night
- warm gold manuscript accents
- cream text
- elegant sacred editorial tone
- premium Qur’an-friendly atmosphere
- still unmistakably Path of Nūr

It should NOT feel like:
- generic dark mode
- a fully flat redesign
- a sepia antique theme
- a separate mini-app inside Path of Nūr

IMPORTANT
Build this as a real reusable theme option.
Do not make it page-specific only.
Do not break the current theme system.
Do not remove the existing glass container identity.
At the very end, run a final audit and provide one complete implementation summary.
===== END PHASE THEME PROMPT =====

My recommendation:
	•	Theme display name: Midnight Manuscript
	•	Internal enum/id: midnightManuscript
	•	Qur’an accent mode inside it: stronger gold + jade chips
