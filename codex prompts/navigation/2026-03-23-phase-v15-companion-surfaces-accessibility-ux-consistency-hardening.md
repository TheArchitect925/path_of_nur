# ===== PHASE V15 PROMPT — COMPANION SURFACES ACCESSIBILITY + UX CONSISTENCY HARDENING =====

## PRIMARY OBJECTIVE === BUILDING ACCESSIBILITY + UX CONSISTENCY HARDENING

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- V10: Companion surfaces buildout
- V11–V13: Content depth + expansion
- V12: Interaction + personalization
- V14: Localization + copy quality hardening

Current state:
- Seerah, Character, and Daily Wisdom surfaces are live
- content is stronger
- copy is cleaner
- localization is structured
- the next gap is **accessibility, readability, and UX consistency**

This phase is about making the surfaces:
- easier to read
- more consistent
- more usable across devices and user conditions
- more polished for production

**Critical safety rule:**  
Do not go haywire redesigning the UI system.  
Do not break layout, routing, or structure.  
Refine what exists instead of rebuilding.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Accessibility audit, UI consistency refinement, and UX polish.

---

## PRODUCT GOAL

Improve:
- readability
- spacing
- visual hierarchy
- accessibility
- consistency across companion surfaces

Focus on:
- `/learn/seerah`
- `/learn/character`
- `/learn/daily-wisdom`

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not redesign the app.**
3. **Reuse existing design system and components.**
4. **Keep visual style consistent with Path of Nūr.**
5. **Avoid clutter or over-decoration.**
6. **Do not remove content unless clearly harmful.**
7. **Maintain calm, premium feel.**
8. **Run analyzer and tests at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit accessibility

Evaluate:
- text size scaling
- contrast (light/dark)
- spacing
- readability
- tap targets
- scroll comfort

Check:
- long text blocks
- dense card layouts
- small or low-contrast elements

---

## B. Improve readability

Refine:
- line spacing
- section spacing
- paragraph length
- card padding
- text hierarchy (title → subtitle → body)

Ensure:
- content is easy to scan
- sections are visually distinct

---

## C. Improve layout consistency

Across all three surfaces:
- ensure consistent card spacing
- consistent section headers
- consistent use of PremiumCard
- consistent padding/margins

Remove:
- inconsistent spacing patterns
- uneven visual grouping

---

## D. Improve visual hierarchy

Ensure:
- headers are clearly distinguishable
- sections flow logically
- primary content stands out
- secondary content is subdued but readable

---

## E. Improve interaction clarity

Check:
- buttons vs chips vs cards
- clickable vs non-clickable elements
- labels for actions

Improve:
- clarity of tappable elements
- affordances for navigation

---

## F. Improve focus and entry clarity

Ensure:
- focused entry states (e.g. Hijrah) are visually clear
- users understand where they landed and why
- transitions from Journey feel intentional

---

## G. Improve dark mode / contrast safety

Audit:
- background colors
- text contrast
- card visibility

Fix:
- any low contrast issues
- readability problems in dark mode

---

## H. Optional small UX refinements

If safe:
- slightly improve section ordering
- reduce clutter in dense areas
- improve spacing between unrelated sections

Do NOT:
- redesign navigation
- restructure pages heavily

---

## I. Tests and validation

Run:
- `flutter analyze`
- existing tests

Add tests only if:
- layout logic changes significantly

---

# VALIDATION

After implementation:

1. content is easier to read
2. spacing feels consistent
3. hierarchy is clear
4. accessibility is improved
5. dark mode is readable
6. interaction affordances are clear
7. no UI regressions introduced
8. analyzer passes
9. tests pass

---

# DELIVERABLES

Provide a concise summary with:

1. **Accessibility audit findings**
   - readability issues
   - spacing issues
   - contrast issues

2. **Improvements made**
   - readability
   - layout consistency
   - hierarchy
   - interaction clarity

3. **Files changed**

4. **Validation**
   - analyzer
   - tests
   - UI stability

5. **Final audit**
   - whether surfaces feel more polished
   - remaining UX issues

---

# IMPORTANT SAFETY RULE

This is a **UX polish phase**.

Do not:
- redesign the app
- remove working structure
- overcomplicate UI

Do:
- refine
- simplify
- improve clarity
- make the experience calm and premium

# END OF PROMPT
