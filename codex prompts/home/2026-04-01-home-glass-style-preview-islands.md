# Phase: Temporary Homepage Glass Style Preview Islands (safe to remove later)

Repo: TheArchitect925/path_of_nur

Goal:
Add a temporary, clearly isolated homepage preview section that showcases multiple glass style variants as “islands”/cards so I can visually compare them in-app with real text content. This is a preview-only feature and must be easy and safe to remove later without affecting the rest of the app.

Important constraints:
- Do NOT redesign the whole homepage.
- Do NOT replace the existing global surface system yet.
- Do NOT wire the liquid glass package into the entire app.
- Keep this isolated, reversible, and low-risk.
- Follow the existing Path of Nūr theme, typography, spacing, navigation, localization patterns, and warm spiritual visual language.
- Use the app’s existing color system as the base, even for the sample variants.
- Build this so it can later be deleted by removing one widget import/section and one folder if needed.
- Prefer using the installed `liquid_glass_renderer` package only inside this preview area if feasible.
- If package integration is unstable or too invasive, emulate the styles with the app’s current surface primitives while keeping the structure ready for future swap-in.

What I want:
Create a new temporary homepage section containing preview “islands” for ALL major glass/surface styles, including ones not recommended, so I can compare them side by side with text visible inside them.

The preview islands should include:
1. Warm Glass
2. Milky Glass
3. Crystal Glass
4. Night Glass
5. Tinted Glass
6. Frosted Glass
7. Layered Glass
8. Edge-lit Glass
9. Adaptive Glass
10. Soft Matte Glass
11. Dense Sanctuary Glass
12. Clear Showcase Glass

Each island/card must show:
- style name
- short one-line descriptor
- 2–4 lines of body text
- at least one smaller inner chip/pill
- one small metadata row or stat row
- enough text contrast to properly evaluate readability
- sample content that matches the app tone

Example content style:
- title: “Milky Glass”
- subtitle: “Cloudy ivory diffusion with softer transparency”
- body: “Designed for calm, readable surfaces with gentle depth. Best for devotional cards, prayer summaries, and serene learning moments.”
- chip: “Sample chip”
- meta row: “Blur • Opacity • Readability”

Placement:
- Add this as a dedicated temporary section on the homepage below the existing core home content, or in a clearly separated demo area that does not interfere with normal flows.
- Add a section header such as:
  - “Glass Style Preview”
  - with a short support line like:
    “Temporary visual comparison of surface styles”
- Make clear in code comments that this is temporary preview UI.

Structure requirements:
Create this in an isolated, removable way.

Recommended structure:
- new folder under something like:
  lib/features/home/presentation/glass_preview/
or
  lib/features/home/presentation/widgets/glass_preview/
- keep all preview-specific models, builders, and widgets inside that folder
- add a single entry widget such as:
  `HomeGlassStylePreviewSection`
- homepage should only import and render that single widget
- avoid modifying shared global components unless absolutely necessary
- if a tiny shared helper is needed, keep it minimal and generic

Implementation requirements:
1. Create a small local preview model for the style definitions:
   - id
   - localized title key or temporary fallback
   - description
   - variant type
   - blur strength
   - opacity
   - tint behavior
   - border strength
   - inner chip style
   - whether it uses layered inner surfaces
   - notes/recommended use

2. Build reusable preview widgets:
   - preview section container
   - preview island/card
   - preview chip
   - preview metadata row
   - optional legend/help note

3. The cards should:
   - use the app’s existing rounded island/card language
   - stay consistent with warm Path of Nūr styling
   - show enough variation to compare materials clearly
   - not become neon, cyber, or overly iOS-demo-like
   - keep spiritual calm and premium softness

4. For visual differentiation between styles, vary carefully:
   - blur amount
   - translucency
   - tint warmth/coolness
   - border visibility
   - highlight intensity
   - shadow softness
   - inner layering
   - clarity of background bleed-through

5. For Night Glass:
   - keep it elegant and legible
   - dark smoke feel, but still within Path of Nūr
   - avoid harsh black panels

6. For Crystal / Clear Showcase Glass:
   - allow it to feel more transparent and reflective
   - but still use app-compatible colors and typography

7. For Milky / Dense Sanctuary:
   - make them feel closest to the cloudy ivory sacred calm look
   - these should read as strong candidates for devotional surfaces

Readability:
- Ensure all sample text is readable on every card
- Adjust foreground colors per variant when needed
- No low-contrast demo nonsense
- Body text should be long enough to judge readability
- Chips should also remain readable

Localization:
- If this section is temporary and localization overhead is too large, it is acceptable to keep the preview strings temporary and clearly marked in code comments for later localization/removal.
- But if easy, add clean localization keys in the normal pattern.

Removal safety:
Add clear comments like:
- TEMPORARY GLASS PREVIEW SECTION
- SAFE TO REMOVE AFTER GLASS DIRECTION IS CHOSEN

Also make removal easy:
- one homepage widget insertion
- one preview folder
- no hidden dependencies
- no broad refactors

Navigation / visibility:
Choose one of these safe options, whichever is less invasive:
A. Render directly on homepage beneath existing sections
B. Add a temporary debug/demo entry from homepage into a dedicated preview page

Prefer A if it can be done cleanly without clutter.
Prefer B if homepage would become too crowded.

If B is chosen:
- add a temporary homepage island linking to the preview page
- preview page should still use app scaffolds and theme

Technical expectations:
- Audit current home page composition first
- Find the safest insertion point
- Reuse existing section scaffolds/cards if possible
- Keep code tidy and self-contained
- Avoid breaking routing, localization, or existing surfaces
- Avoid touching unrelated pages

Deliverables:
1. Implement the temporary preview UI
2. Keep it isolated and removable
3. Add concise code comments marking temporary ownership
4. Summarize:
   - files added
   - files modified
   - insertion point used
   - exactly how to remove later
   - whether `liquid_glass_renderer` was truly used or visually emulated
   - which styles looked strongest in code/runtime

Acceptance criteria:
- I can open the app and visually compare all listed surface styles
- each sample island includes visible title, supporting text, chip, and meta content
- styles are visibly distinct but still within app design language
- implementation is easy to back out later
- no homepage regression
- no global theme refactor done yet

Nice-to-have:
- add a small note at the bottom:
  “Preview only — not yet applied across the app”
- optional simple toggle within the preview section:
  - compact
  - expanded
  only if trivial and isolated

Do not stop at planning only. Make the changes.
