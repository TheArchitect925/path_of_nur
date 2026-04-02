# Phase X Prompt — Homepage Glass Variant Islands Rebuild

PRIMARY OBJECTIVE === BUILDING TEMPORARY HOMEPAGE GLASS VARIANT ISLANDS

Repo: TheArchitect925/path_of_nur

Task type:
Replace the current temporary glass preview implementation with a much simpler, cleaner comparison experience.

Goal:
Remove the existing temporary glass preview/cards/demo layout that was added before, and replace it with a set of homepage islands styled similarly to the Learning Hub category islands.

What I want now:
- One island per glass variant
- Each island should look and feel like a Learning Hub category tile/island
- Keep the app’s existing Path of Nūr visual language, spacing, typography, warmth, and color palette
- Each island should contain enough text to judge readability
- Each island should visually demonstrate its own glass/surface treatment
- Remove the previous preview implementation entirely

Variants to create:
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

Critical requirements:
1. Audit first.
2. Find all files that were added or changed for the previous temporary glass preview implementation.
3. Remove the old preview system fully before building the new one.
4. Do NOT leave duplicate preview systems behind.
5. Do NOT redesign the homepage.
6. Do NOT globally refactor the theme system yet.
7. Keep this new implementation isolated and easy to remove later.
8. Keep it production-clean even though it is temporary.

Design direction:
- The islands should be inspired by the Learning Hub categories, not by a big demo card system
- Treat each variant as a category-style island
- They should feel native to the app, not like a developer test page
- Keep the variants visually distinct, but still within Path of Nūr’s calm spiritual aesthetic
- No loud neon, no tacky reflections, no random colors outside the app language

Island content requirements:
Each island must include:
- Variant title
- Short subtitle/descriptor
- 2–3 lines of body text
- Small supporting micro text or label
- Enough text contrast to judge readability

Example structure inside each island:
- Title: “Milky Glass”
- Subtitle: “Cloudy ivory diffusion”
- Body: “Soft, devotional, calm surfaces with gentle depth and reduced transparency for better readability.”
- Footer label: “Best for serene content”

Visual behavior by variant:
Use the app theme/colors as the base and vary only the material treatment characteristics:
- blur strength
- opacity
- tint intensity
- border brightness
- inner depth
- highlight strength
- shadow softness
- layer density
- transparency feel

Variant intent:
- Warm Glass: parchment/ivory warmth with soft gold edges
- Milky Glass: cloudy ivory translucent material, softened visibility
- Crystal Glass: clearer, brighter, more transparent
- Night Glass: smoky/dark elegant material, still readable
- Tinted Glass: gentle app-compatible color wash
- Frosted Glass: classic frosted blur
- Layered Glass: island with subtle layered inner depth
- Edge-lit Glass: delicate rim/edge light, not overdone
- Adaptive Glass: balanced, readable, practical surface
- Soft Matte Glass: muted glass-like surface with lower shine
- Dense Sanctuary Glass: denser sacred calm ivory material
- Clear Showcase Glass: the most transparent/showcase-like option while still matching app style

Placement:
- Put these islands on the homepage in a clean temporary section
- The section should feel like another content band, similar in spirit to existing grouped homepage content
- Keep it below the core primary homepage content so it does not disrupt the normal app flow
- Section title can be:
  - Glass Variants
  - or
  - Surface Style Variants
- Optional support text:
  - Temporary homepage comparison of glass island styles

Structure / removal safety:
Build this in an isolated way so it can be removed safely later.

Recommended structure:
- Create a single temporary feature/widget folder under the home feature
- Homepage should only import one root widget, something like:
  `HomeGlassVariantIslandsSection`
- Keep variant definitions local to this feature
- Avoid modifying shared global systems unless absolutely necessary
- Add clear comments that this is temporary and removable

Required cleanup first:
Before building the new islands:
- remove the previously created temporary glass preview cards/section/page
- remove old preview-specific widgets/models/helpers if no longer needed
- remove preview-only routes if any were added
- remove preview-only localization keys if they are no longer used
- remove dead imports and references

Implementation guidance:
- Audit the Learning Hub category island styling and reuse that structural pattern where appropriate
- Reuse existing shared island/card primitives if possible
- If the `liquid_glass_renderer` package can be used safely and locally for these islands, do so
- If not, emulate the surface differences using the existing surface system in a clean way
- Do not force package usage if it destabilizes the code

Technical expectations:
- Find the safest insertion point on the homepage
- Keep the code self-contained
- Ensure no regressions to existing homepage sections
- Keep scrolling and layout stable
- Keep performance reasonable even with multiple islands

Deliverables:
1. Remove the old temporary glass preview implementation
2. Build the new homepage variant islands section
3. Add one island for each listed variant
4. Keep the implementation isolated and removable
5. Provide a concise summary of:
   - files removed
   - files added
   - files modified
   - where the homepage insertion lives
   - whether `liquid_glass_renderer` was truly used or visually emulated
   - exact removal steps later

Acceptance criteria:
- The old preview implementation is gone
- The homepage now shows one Learning-Hub-style island for each glass variant
- Each island clearly demonstrates a distinct surface treatment
- Each island includes readable text content
- The styling still feels like Path of Nūr
- No homepage regression
- Easy to remove later by deleting one section and its local files

Important:
Do not stop at planning.
Do the audit, remove the old preview implementation, and implement the new island-based version fully.

End with a final audit summary.
