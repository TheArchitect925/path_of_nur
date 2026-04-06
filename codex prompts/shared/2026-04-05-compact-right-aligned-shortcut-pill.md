===== PHASE X PROMPT — CONVERT SHORTCUTS PILL TO SMALL RIGHT-ALIGNED FLOATING MINI PILL =====

PRIMARY OBJECTIVE === REWORK THE CURRENT “SHORTCUTS” PILL SO IT IS A SMALL RIGHT-ALIGNED FLOATING MINI PILL INSTEAD OF A FULL-WIDTH HORIZONTAL BAR

Context:
The current implementation renders the Shortcuts pill like a large full-width section header / banner.
That is not the intended UI.
We want it to behave like a compact floating utility chip anchored near the top-right area of the content/card region.

DESIGN INTENT
The Shortcuts pill should feel like:
- a small floating action chip
- right aligned
- content-driven width, not stretched
- visually light and elegant
- secondary utility element, not the primary header of the page

TARGET BEHAVIOR
Change the current pill so that it:
- hugs its content width
- stays right aligned
- has compact horizontal padding
- has compact vertical height
- floats above the page/card content rather than consuming a full row visually
- does not push layout into a big banner/header treatment
- does not expand to parent width
- does not look like a tab bar, section title bar, or segmented control

IMPLEMENTATION RULES
- Audit the existing widget and identify why it is stretching full width.
- Remove any layout behavior causing expansion, including things like:
  - width: double.infinity
  - Expanded
  - Flexible with loose usage that still fills row visually
  - SizedBox.expand
  - full-width Align/Container combinations that visually force bar treatment
  - parent wrappers that impose max width incorrectly
- The pill itself must be content-sized.
- Use right alignment at the parent level, not full-width sizing on the chip itself.
- Keep the existing visual language of Path of Nūr.
- Preserve glass/parchment styling and the app’s current theme direction.
- Do not redesign unrelated page content.

RECOMMENDED LAYOUT DIRECTION
Use a structure closer to:
- Align(alignment: Alignment.centerRight)
- then a child that sizes to content naturally
- compact padding
- minimal height
- intrinsic/content width behavior
- optional safe top spacing from surrounding content

The final result should visually read more like:
- a small floating chip in the upper-right corner
and less like:
- a full-width toolbar row

SIZE / PROPORTION GUIDANCE
Aim for something roughly in this range:
- height around compact chip size, not button bar height
- width only enough for icon + label + internal padding
- moderate border radius for a soft capsule
- icon and text should remain readable, but compact

VISUAL HIERARCHY
The pill should be subordinate to:
- page title
- prayer card
- main hero content

It should not dominate the top area.
It should not overlap in a clumsy way with the location card or other content.
If needed, slightly reposition vertically so it feels intentionally floating and not stacked awkwardly.

INTERACTION
Keep tap behavior intact.
If there is a menu/sheet/dialog attached, preserve that behavior.
Only change the size, alignment, and floating presentation.

AUDIT CHECKLIST
1. Find the widget responsible for the Shortcuts pill.
2. Identify every parent causing width expansion.
3. Refactor so the chip is content-width only.
4. Right align it cleanly.
5. Keep spacing balanced against nearby cards.
6. Verify on narrow mobile widths and larger device widths.
7. Ensure no overflow, clipping, or awkward wrap.
8. Ensure accessibility tap target is still reasonable.
9. Ensure the pill still matches app theme and glass styling.

DO NOT
- do not leave it as a full-width bar
- do not center it
- do not make it look like a page section header
- do not let it consume the whole row visually
- do not redesign the rest of the page
- do not introduce hacky magic numbers unless truly needed

OUTPUT REQUIRED
At the end provide:
A. files changed
B. root cause of the full-width behavior
C. exact layout strategy used for the compact right-aligned floating pill
D. confirmation that the pill is now content-width and right aligned
E. final UI audit summary

At the very end, audit the result and provide one full summary.
