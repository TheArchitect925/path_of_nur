# PHASE THEME 2 PROMPT — MIDNIGHT MANUSCRIPT PREVIEW SYSTEM + THEME-AWARE BACKGROUND/WALLPAPER BEHAVIOR

PRIMARY OBJECTIVE === BUILDING MIDNIGHT MANUSCRIPT THEME PREVIEWS + THEME-AWARE BACKGROUND/WALLPAPER BEHAVIOR

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready theme refinement pass.
Do not build placeholders.
Do not break existing theme selection, theme persistence, glass container behavior, current wallpapers/backgrounds, localization, accessibility, or page consistency.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing anything.
- Do not remove or break the existing theme system or current theme options.
- Do not go haywire and remove/delete settings, assets, records, or shared UI logic for no reason.
- Preserve the current Path of Nūr glass container identity.
- Preserve current background/wallpaper systems unless safely extending them.
- This pass should enhance the Midnight Manuscript experience, not introduce a disconnected parallel styling system.
- At the very end, run a full audit and provide one clean implementation summary.

PHASE CONTEXT
Previous pass introduced:
- new selectable theme option: Midnight Manuscript
- new palette/tokens for deep ink + gold manuscript styling
- preserved glass containers and shared app structure

Now this pass should make the theme feel polished and complete by adding:
1. theme previews in settings/theme picker
2. theme-aware wallpaper/background behavior
3. clean adaptation of global page atmosphere while preserving glass surfaces

PRODUCT GOAL
Midnight Manuscript should not only exist as a theme setting.
It should feel intentional from the moment the user sees it in settings and when they navigate the app.

The user should be able to:
- preview it clearly before selecting
- see a coherent deep-ink manuscript atmosphere across the app
- retain the Path of Nūr glass container look
- enjoy slightly richer Qur’an-specific mood without breaking the rest of the app

A. AUDIT FIRST
Before making any changes, audit the current state and identify:
- where the theme picker/settings UI currently lives
- whether theme previews already exist
- whether wallpapers/backgrounds are globally controlled, page-controlled, or feature-controlled
- whether there is already a wallpaper provider, background asset registry, or themed background helper
- whether Home/Qur’an/Learn/Journey currently use the same background system or have local overrides
- whether any pages still hardcode background behavior that would fight Midnight Manuscript
- whether there are already theme preview assets, swatches, or mock preview cards
- how reduced transparency / accessibility settings currently affect backgrounds
- what the current fallback path is if a theme-specific background is unavailable

Before coding, identify:
- target files to modify
- new theme preview widgets/assets/helpers to add
- whether to use generated previews, live widget previews, or static swatch cards
- whether theme-aware wallpaper behavior should use assets, gradients, or both
- which pages or shells need cleanup to consume central background behavior

B. BUILD A PROPER THEME PREVIEW SYSTEM
Add a polished theme preview experience for all themes, including Midnight Manuscript.

Requirements:
- theme picker should show a clear preview tile/card for each available theme
- Midnight Manuscript preview should communicate:
  - deep ink background
  - warm gold accent
  - cream text
  - preserved glass container feel
- selection state should be obvious
- the preview should look premium, not like a plain color square

Preferred preview content:
- mini card/surface example
- small background sample
- accent/chip sample
- optional title/subtitle snippet
- optional Arabic/English title sample if that fits current design

Do not overbuild an entire live page renderer if a compact preview system is sufficient.
But do make it look real and representative.

C. ADD MIDNIGHT MANUSCRIPT PREVIEW TILE DESIGN
Create a distinct preview tile for Midnight Manuscript.

Visual direction:
- deep ink base
- subtle gold highlight or glow
- glass surface sample over the dark background
- gold/cream text sample
- elegant but restrained

The preview should make the theme feel:
- premium
- scholarly
- spiritual
- calm
- clearly different from default dark/light options

Do not make the preview too noisy or ornate.

D. CREATE THEME-AWARE BACKGROUND / WALLPAPER BEHAVIOR
Extend the app’s background/wallpaper system so Midnight Manuscript can have an intentional atmospheric backing.

Important:
- Preserve the existing glass containers.
- The background layer should support the theme, not overpower it.

Acceptable approaches depending on current architecture:
- theme-specific gradient definitions
- theme-specific background assets
- theme-aware wallpaper overlay treatment
- central background resolver by selected theme

For Midnight Manuscript, the background behavior should lean toward:
- deep ink base
- subtle manuscript-night atmosphere
- restrained gold warmth in selective areas
- soft gradients rather than busy textures
- very controlled contrast so cards remain readable

E. DEFINE CENTRAL BACKGROUND RULES
Implement a clean central background/wallpaper policy for Midnight Manuscript.

Suggested rules:
- app shell / scaffold background uses Midnight Manuscript base tokens
- feature pages may optionally request “theme atmospheric mode” from the central system
- glass cards remain layered above the background
- wallpaper intensity should remain subtle
- if reduced transparency is enabled, fallback to cleaner opaque dark surfaces
- if wallpaper/backgrounds are disabled or unavailable, fallback to tokenized gradients cleanly

Do not let each page invent its own version of Midnight Manuscript.

F. QURAN-SPECIFIC ATMOSPHERIC ENHANCEMENT
The Qur’an section may receive a slightly richer version of the background within Midnight Manuscript.

Examples:
- softer gold radial lift in headers
- deeper manuscript ink backing behind Qur’an hero sections
- slightly richer Arabic title contrast
- elegant top-of-page atmosphere

Important:
- this must still reuse central theme/background logic
- do not create a completely separate theme inside the Qur’an section
- keep it subtle and readable

G. KEEP OTHER APP SECTIONS COHERENT
Ensure Midnight Manuscript background behavior also looks good in:
- Home
- Worship
- Learn
- Journey
- Settings/Profile
- dialogs/sheets where relevant
- search pages
- empty states

These pages should feel consistent with Midnight Manuscript without being too heavy-handed.
The Qur’an section can feel slightly more premium, but the rest of the app must still belong to the same visual world.

H. PRESERVE WALLPAPER / BACKGROUND USER CHOICE IF APPLICABLE
If the app already supports user wallpaper/background customization:
- do not remove that feature
- make Midnight Manuscript compatible with it
- add a clean blending/tint/overlay strategy if needed
- avoid letting custom wallpapers make text unreadable

Possible safe approach:
- theme applies a tint/overlay style to wallpapers
- fallback to theme-native gradients if wallpaper is off
- keep the user’s wallpaper choice intact when possible

Do not break existing wallpaper selection or storage logic.

I. ADD A THEME PREVIEW / DESCRIPTION LAYER IN SETTINGS
If the settings UI supports helper copy, add a short localized description for Midnight Manuscript.

Example direction:
- Deep ink tones with warm gold accents and a quiet manuscript atmosphere.

Keep it brief and premium.
Do not over-explain.

If other themes have no descriptions, either:
- keep all themes consistent by adding brief descriptions to all
or
- keep the Midnight Manuscript description lightweight and visually consistent

J. CLEAN UP ANY BACKGROUND HARDCODING THAT CONFLICTS
Identify and safely refactor active pages/components that hardcode background colors or gradients which look wrong under Midnight Manuscript.

Prioritize:
- active shell backgrounds
- top-level page wrappers
- Qur’an landing/detail pages
- settings/theme picker
- shared page surfaces
- any wallpaper host component

Do not trigger a giant unrelated redesign.
Only clean up what is necessary for theme consistency.

K. ENSURE ACCESSIBILITY + CONTRAST
Midnight Manuscript preview and background behavior must remain readable and accessible.

Requirements:
- strong contrast for primary text
- readable secondary/supporting text
- glass cards still distinct from background
- buttons/chips/tabs remain visible
- no excessive dark-on-dark loss of hierarchy
- reduced transparency mode remains usable
- text scaling remains safe
- theme previews remain understandable even at smaller sizes

Mood must not come at the expense of usability.

L. OPTIONAL SUBTLE MOTION / TRANSITION POLISH
If the app already uses light motion and it fits safely:
- make theme switching feel smooth
- allow gentle background transition/fade
- keep motion minimal and respectful
- honor reduced motion settings if present

Do not add flashy or performance-heavy transitions.

M. LOCALIZATION
Any new user-facing strings must be localization-ready.

Likely keys:
- Midnight Manuscript
- theme description text if added
- preview labels if needed
- wallpaper/background-related labels if exposed in settings

At the end, report:
- new localization keys added
- locale resources updated

N. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify Midnight Manuscript preview appears correctly in theme picker
- verify theme selection still works and persists
- verify backgrounds/wallpapers resolve correctly under Midnight Manuscript
- verify glass containers remain intact and readable
- verify Home/Qur’an/Learn/Journey/Settings all look coherent
- verify current other themes are not regressed
- verify wallpaper user choice still works if applicable
- verify reduced transparency/reduced motion behavior remains coherent
- verify no unreadable text or broken contrast states

O. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Theme preview system added/updated
3. Midnight Manuscript preview tile design approach
4. Background/wallpaper architecture touched
5. How theme-aware background behavior was implemented
6. How user wallpaper compatibility was preserved
7. Which shared/page components required cleanup
8. Localization keys added
9. Analyzer/test results
10. Follow-up recommendations

DESIGN SUMMARY
This pass should make Midnight Manuscript feel:
- intentional
- premium
- atmospheric
- coherent across the app
- especially beautiful in the Qur’an section
- still unmistakably Path of Nūr

It should NOT feel like:
- a generic dark mode skin
- a one-off background hack
- a wallpaper-heavy redesign
- a theme that only works on one page

IMPORTANT
Build this as a real reusable refinement of the app theme system.
Do not break theme persistence.
Do not remove the existing glass container identity.
Do not let page-level hardcoding fight the central theme/background architecture.
At the very end, run a final audit and provide one complete implementation summary.
