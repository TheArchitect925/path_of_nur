===== PHASE X PROMPT — CONVERT SHORTCUT PILLS INTO UNIQUE-COLORED VERTICAL STACK =====

PRIMARY OBJECTIVE === CHANGE THE CURRENT SHORTCUT PILL PRESENTATION FROM A SINGLE/FLOATING HORIZONTAL TREATMENT INTO A VERTICAL STACK OF INDIVIDUAL PILLS, WITH EACH PILL HAVING ITS OWN UNIQUE COLOR

Context:
We already corrected the oversized full-width behavior.
Now the next design step is:
- each shortcut should be its own pill
- pills should be stacked vertically
- each pill should have a distinct unique color
- the result should still feel premium, calm, and consistent with Path of Nūr
- the pills should remain compact and elegant, not loud or toy-like

DESIGN INTENT
The shortcut area should now read like:
- a small vertical cluster of action pills
- each pill visually distinct
- easy to scan quickly
- lightweight and refined
- not a giant menu block
- not a full-width list row system

TARGET BEHAVIOR
Refactor the shortcut UI so that:
- each shortcut action is rendered as an individual pill
- pills are arranged in a vertical stack
- each pill has its own unique color identity
- pills remain compact and content-aware
- the stack feels intentionally placed and visually balanced
- tap behavior for each shortcut still works
- the stack does not stretch across the page width
- the stack remains visually secondary to the main page content

LAYOUT REQUIREMENTS
- Stack pills vertically, one under the other
- Keep spacing between pills modest and clean
- Do not make each pill full-width unless there is a very specific reason already established by the design
- Prefer content-based width or a small consistent compact width approach
- Keep the stack aligned cleanly within its region
- If the prior direction was right-aligned floating placement, preserve that spirit unless the surrounding UI clearly needs slight adjustment for balance
- The stack should feel like a floating utility group, not a heavy sidebar

COLOR REQUIREMENTS
Each pill should have its own distinct color treatment.
Do this tastefully.

Important:
- colors must feel premium, soft, and readable
- avoid neon, oversaturated, childish, or random-looking color choices
- preserve enough contrast for text/icon readability
- stay within Path of Nūr visual language
- colors should still harmonize with the glass/parchment/warm spiritual theme

Recommended direction:
- use muted jewel / nature / spiritual tones
- slightly softened, premium-tinted surfaces
- maintain consistency in opacity, border softness, and shadow treatment
- each pill should still look like part of the same family even with different colors

Possible palette direction examples:
- soft emerald
- muted sapphire
- warm amber
- dusty rose
- soft plum
- teal
- parchment-gold accent variant

Do not blindly use these exact colors if the app already has a better internal palette system. Reuse theme tokens where possible.

COMPONENT REQUIREMENTS
For each pill:
- compact capsule shape
- icon + label composition
- consistent height across pills
- consistent internal padding
- consistent border radius
- consistent typography scale
- consistent shadow/border treatment
- unique surface color per pill

If a pill has selected / pressed / hovered / focused states, make sure those states still work cleanly with its assigned color.

IMPLEMENTATION RULES
- Audit the current shortcut pill component and refactor it into a reusable item builder if needed
- Replace any single shared surface style that forces all pills to look identical
- Introduce a structured per-shortcut style mapping
- Keep the implementation production ready
- Do not introduce fragile hardcoded one-off UI logic scattered across the page
- Prefer a clean model-driven structure where each shortcut item can define or receive:
  - label
  - icon
  - action
  - visual style / color token

RECOMMENDED STRUCTURE
Refactor toward something like:
- shortcut item model
- mapped list of shortcut pills
- vertical layout using a Column
- a consistent pill widget that accepts style data

Example architecture direction:
- ShortcutActionItem(...)
- ShortcutPillStyle(...)
- ShortcutPill(...)
- Column(children: shortcuts.map(...))

If the page already has a shortcut menu model, extend it cleanly rather than rebuilding the whole system badly.

VISUAL HIERARCHY
The vertical shortcut stack should:
- feel helpful and elegant
- not overpower the prayer card or hero area
- remain clearly tappable
- be quickly scannable

Do not let the color variation become visually chaotic.
The family resemblance between the pills is important.

DO NOT
- do not revert to a full-width block list
- do not make the pills huge
- do not use harsh saturated colors
- do not give every pill a completely different shape/style language
- do not introduce inconsistent spacing or sizing
- do not redesign unrelated page sections
- do not break tap behavior or navigation
- do not leave the code as one-off repeated containers

ACCESSIBILITY / USABILITY
- maintain readable contrast
- maintain sensible tap targets
- ensure long labels do not break layout awkwardly
- verify no overflow on narrow screens
- verify stacking remains clean on different device sizes
- ensure semantics and focus behavior still work

AUDIT CHECKLIST
1. Find the current shortcut pill implementation.
2. Refactor to individual pill items.
3. Build a vertical stack layout.
4. Assign each shortcut a unique but harmonized color treatment.
5. Keep sizing and spacing consistent.
6. Verify all actions still work.
7. Verify mobile width behavior.
8. Verify visual balance against surrounding content.
9. Remove any now-unused single-pill code paths.
10. Audit final result for polish.

OUTPUT REQUIRED
At the end provide:
A. files changed
B. final layout approach for the vertical shortcut stack
C. how per-pill unique colors were assigned
D. any theme tokens or palette strategy used
E. confirmation that pills are now vertically stacked and individually colored
F. final UI audit summary

At the very end, audit the result and provide one full summary.
