# PHASE AUDIT PROMPT — UNLINKED FUNCTIONALITY + ORPHANED PAGES / FEATURES

## PRIMARY OBJECTIVE === BUILDING UNLINKED FUNCTIONALITY + ORPHANED PAGES / FEATURES AUDIT

You are working in the existing Flutter codebase for **Path of Nūr**.

This is an **audit-first phase**.

The goal is to find:
- pages that exist but are not reachable
- features that are implemented but not linked from the UI
- routes that exist but are not exposed meaningfully
- islands / hubs / sections that should link to implemented features but currently do not
- utility screens that are effectively orphaned
- partially wired features that appear finished in code but are missing discoverability or entry points

Example concern already identified by product:
- **rings / progress ring functionality appears to exist but is not clearly linked into the app**

This phase should produce a **high-signal audit** and only make **small safe fixes** if they are obvious and low-risk.  
Do not turn this into a giant redesign.

**Critical safety rule:**  
Do not go haywire deleting pages, routes, widgets, data, records, or functionality for no reason.  
Do not remove code just because it looks unused until you verify whether it is intentionally hidden, incomplete, or simply unlinked.  
Audit first. Fix only clearly safe linking gaps.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Architecture/content discoverability audit, route exposure audit, and feature-linking gap analysis.

---

## PRODUCT GOAL

Determine which implemented product surfaces are currently:
- unreachable
- hidden
- weakly linked
- discoverable only through route name / direct deep link
- missing from the correct Learn / Journey / Home / Growth / Worship / Qur’an / Kids / Settings area

This phase should answer:
1. what functionality already exists,
2. where it should logically live,
3. whether it is currently linked,
4. whether it is linked in the wrong place,
5. what the highest-value missing links are.

---

## EXECUTION RULES

1. **Audit first before editing anything.**
2. **Do not assume a feature is unused just because it is unlinked.**
3. **Do not delete pages/routes/widgets during this audit.**
4. **Prefer safe discoverability fixes over broad IA redesign.**
5. **Be especially careful around hidden/internal/dev-only routes.**
6. **Identify real product-ready features separately from incomplete or debug-only features.**
7. **Preserve localization readiness.**
8. **If small safe link fixes are obvious, they may be implemented — but keep this narrow.**
9. **Run analyzer/tests only if code is changed.**
10. **At the end, provide one full audit summary with prioritized recommendations.**

---

# IMPLEMENTATION SCOPE

## A. Audit route and page ownership first

Inspect at minimum:

- `app_router.dart`
- all route registries under `lib/app/routes`
- Learn taxonomy / category routing
- Home / Journey / Worship / Qur’an / Learn hub structures
- companion surfaces
- growth / rings / stats / progress related files
- any feature directories likely to contain user-facing pages
- any route names referenced in tests but not clearly exposed in UI

Identify:
- all user-facing route-backed pages
- all pages only reachable by direct route
- all pages that appear to have no meaningful entry point
- any feature hubs with missing child links

---

## B. Specifically audit rings / growth / progress functionality

Because rings were explicitly called out, inspect all relevant files for:
- rings
- daily rings
- progress rings
- streak rings
- growth dashboard
- goal adjustment / target-setting
- ring settings
- ring widgets/components
- ring routes/pages
- ring cards on Home/Journey/Growth

Determine:
1. whether rings are fully implemented
2. whether they have a real route/page
3. whether they are reachable in the current UI
4. whether they are only partially exposed
5. where they should logically live in the app

Be explicit:
- if rings exist but are not linked, say exactly where they should be linked
- if they are only component-level and not page-level, say that clearly
- if they are behind another surface, identify it

---

## C. Identify orphaned or weakly linked functionality by app area

Audit by area:

### 1. Home
- features/pages that should be reachable from Home but are not
- cards/widgets that imply deeper pages but do not link clearly

### 2. Journey / Growth
- progress/stats/rings/XP/drops/streak-related pages
- anything implemented but not exposed meaningfully

### 3. Learn
- category pages
- owned surfaces
- companion surfaces
- history / prophets / hadith / life / world / kids / quizzes
- any routes/pages that exist but are not discoverable

### 4. Qur’an
- learning hub
- reader/player companion surfaces
- insights / reflections / search / review surfaces
- any strong page hidden behind route-only access

### 5. Worship / Practice
- dhikr
- salah trainer
- dua
- wudu
- any trainer or progress surface not linked clearly

### 6. Kids
- Arabic
- stories
- seerah
- dua
- games
- rewards / dashboards / parent pages
- any good feature hidden from the intended kids/parent flow

### 7. Tools / Explore / Settings / Profile
- utility pages that are implemented but buried or unlinked

For each area, classify findings into:
- **linked correctly**
- **linked weakly**
- **implemented but unlinked**
- **internal/dev-only**
- **incomplete / should stay hidden**

---

## D. Audit discoverability mismatches

Find cases where:
- a feature is linked, but from the wrong place
- a feature exists under one owner but users would expect it elsewhere too
- a feature has a route and page but no card/button/chip/entry point
- a feature is buried behind too many taps despite being high value

Do NOT redesign the whole IA.  
Just identify these mismatches clearly.

---

## E. Audit route names vs real UI exposure

For route-backed pages, determine:
- which route names correspond to truly live product surfaces
- which are only used by tests or internal transitions
- which are effectively orphaned in the user experience

This matters because some things may technically exist and still be practically invisible.

---

## F. Optional: apply only small safe linking fixes if clearly obvious

If you find a very obvious safe fix, you may implement it — but only if:
- the target feature is production-ready
- the correct owner/entry point is clear
- the change does not require redesign
- the UI already has an appropriate place for the link

Examples of allowed small fixes:
- adding a missing entry card to the correct category page
- linking an existing card to an already-live route
- exposing a clearly finished feature through its correct hub
- wiring a missing button to an already-live page

Not allowed in this phase:
- big IA restructuring
- major rerouting
- deleting pages because they are unlinked
- forcing visibility for incomplete/dev-only tools

If multiple fixes are found, prioritize documentation unless one or two are extremely safe and high value.

---

## G. Produce a prioritized gap list

At the end, produce a ranked list of:
1. highest-value unlinked features
2. highest-value weakly linked features
3. likely intentional hidden/internal features
4. features that need follow-up implementation before being exposed

Rank them by:
- user value
- implementation readiness
- ease of safe linking
- product fit

---

# VALIDATION

If code is changed:

1. Run `flutter analyze`
2. Run narrow relevant tests
3. Confirm no routing regressions
4. Confirm no localization issues introduced

If no code is changed:
- state clearly that this was an audit-only pass

---

# DELIVERABLES

Provide a concise summary with:

## 1. Audit findings before changes
- areas reviewed
- route/page systems reviewed
- any especially important hotspots

## 2. Rings / growth audit
- what ring functionality exists
- whether it is fully or partially implemented
- where it is currently reachable
- whether it is missing from the UI
- where it should logically be linked

## 3. Unlinked or weakly linked features by area
### Home
### Journey / Growth
### Learn
### Qur’an
### Worship
### Kids
### Tools / Settings

For each, identify:
- what exists
- current exposure
- recommended action

## 4. Small safe fixes made
- only if any were actually made

## 5. Files changed
- if any

## 6. Validation
- analyzer/tests if applicable

## 7. Prioritized next fixes
List the top 10 highest-value linking/discoverability fixes in order.

## 8. Final audit
- what is already well linked
- what feels orphaned
- what should be linked next
- what should intentionally remain hidden for now

---

# IMPORTANT SAFETY / PRODUCT RULE

This is an **audit and discoverability phase**.

Do not:
- delete code for no reason
- overexpose incomplete features
- redesign the app broadly
- confuse route existence with real product readiness

Do:
- find what already exists
- identify what is not linked
- classify what should be linked vs stay hidden
- make only extremely safe small fixes if clearly justified

# END OF PROMPT
