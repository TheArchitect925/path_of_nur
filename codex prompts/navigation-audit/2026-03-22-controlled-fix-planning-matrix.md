# PHASE AUDIT V5 PROMPT — CONTROLLED FIX PLANNING MATRIX

PRIMARY OBJECTIVE === BUILDING A PAGE-BY-PAGE FIX PLAN FROM THE COMPLETED NAVIGATION AUDIT FOR PATH OF NŪR

This is NOT the implementation phase.
This is the CONTROLLED FIX PLANNING phase.

We already have the navigation audit.
Now convert that audit into a precise review matrix so a human can approve fixes safely before Codex changes anything.

========================================================
CORE GOAL
========================================================

Using the completed audit findings, produce a structured FIX PLANNING PACK that answers:

1. What should stay exactly as-is
2. What should be rewired
3. What should become a redirect
4. What should be renamed
5. What should be merged later
6. What should remain for manual review
7. In what exact order the fixes should happen

DO NOT MODIFY CODE.
DO NOT IMPLEMENT FIXES.
DO NOT DELETE ANYTHING.

========================================================
STEP 1 — ISSUE NORMALIZATION
========================================================

Convert the prior audit findings into normalized issue records.

For each issue record include:
- issue_id
- feature_area
- page_or_route
- issue_type
- severity:
  - P0 critical
  - P1 high
  - P2 medium
  - P3 low
- user_visible (yes/no)
- architecture_impact (high/medium/low)
- summary
- evidence
- recommended_action

Issue types must include:
- missing_route
- broken_navigation
- misroute
- duplicate_front_door
- alias_conflict
- inconsistent_ownership
- child_flow_divergence
- terminal_page
- semantic_mismatch
- label_destination_mismatch
- deep_link_mismatch
- layout_consistency_issue

========================================================
STEP 2 — PAGE / ROUTE DISPOSITION MATRIX
========================================================

For every major affected page or route assign exactly one primary disposition:

- KEEP
- REWIRE
- REDIRECT
- RENAME
- MERGE_LATER
- REVIEW_FIRST
- DEPRECATE_LATER

For each include:
- current_name
- current_route
- feature_owner_current
- feature_owner_expected
- disposition
- rationale
- dependencies
- risk_level

========================================================
STEP 3 — CANONICAL OWNERSHIP MAP
========================================================

Define the canonical ownership model.

For every major feature family identify:
- canonical owner
- allowed child pages
- allowed aliases
- routes that should no longer own these pages

Required families:
- Home
- Worship
- Learn
- Qur’an
- Journey
- Kids
- Notes
- Discovery / Explore
- Settings / Profile

Output format:
FEATURE OWNER
  - canonical routes
  - canonical entry pages
  - compatibility aliases
  - pages that should be moved away from this owner

========================================================
STEP 4 — ROUTE ALIAS POLICY
========================================================

Classify every alias-like route as one of:
- CANONICAL
- COMPATIBILITY_ALIAS
- TEMPORARY_ALIAS
- SHOULD_REDIRECT
- SHOULD_BE_REMOVED_LATER
- INVALID_DUPLICATE

For each alias include:
- route
- target canonical route
- why alias exists
- whether it should remain live
- whether it should become redirect-only

========================================================
STEP 5 — LABEL vs DESTINATION REVIEW TABLE
========================================================

Create a manual-review table:

- UI label
- host page
- current destination
- expected destination
- status:
  - correct
  - misleading
  - broken
  - unclear
- recommended action

This must cover:
- main hubs
- islands
- shortcut cards
- Journey actions
- Qur’an tools
- Learn category cards
- kids entry points

========================================================
STEP 6 — FIX DEPENDENCY ORDER
========================================================

Produce an ordered fix sequence.

For each step include:
- step_number
- objective
- why this step must happen now
- what it unblocks
- what it must NOT change yet

This should explicitly separate:
PHASE A — route integrity
PHASE B — canonical ownership
PHASE C — front-door cleanup
PHASE D — child-flow normalization
PHASE E — UX label cleanup
PHASE F — terminal/dead-end cleanup
PHASE G — alias trimming

========================================================
STEP 7 — HUMAN APPROVAL CHECKLIST
========================================================

Produce a checklist for manual review before implementation.

Format:
- approve canonical Learn front door
- approve canonical Kids home
- approve Qur’an reflections route placement
- approve memorize destination behavior
- approve Garden onward actions
- approve alias policy
- approve child-mode Learn structure

========================================================
STEP 8 — SAFE IMPLEMENTATION BOUNDARIES
========================================================

Define strict guardrails for the future fix prompt.

Include:
- do not delete pages unless explicitly approved
- preserve existing data and state behavior
- preserve backward compatibility where needed
- convert aliases to redirects before removal
- do not rebuild unrelated UI
- avoid broad renames unless approved
- do not collapse feature ownership without explicit mapping

========================================================
STEP 9 — OUTPUT FORMAT
========================================================

Return exactly:

1. Executive Summary
2. Normalized Issue Register
3. Page / Route Disposition Matrix
4. Canonical Ownership Map
5. Route Alias Policy
6. Label vs Destination Review Table
7. Ordered Fix Dependency Plan
8. Human Approval Checklist
9. Safe Implementation Boundaries
10. Top 10 Recommended First Fixes
11. Files Referenced
12. Final Planning Summary

========================================================
STEP 10 — MACHINE OUTPUT
========================================================

Provide:
ISSUE_REGISTER_JSON
DISPOSITION_MATRIX_JSON
OWNERSHIP_MAP_JSON
ALIAS_POLICY_JSON
LABEL_DESTINATION_REVIEW_JSON
FIX_ORDER_JSON
APPROVAL_CHECKLIST_JSON

========================================================
FINAL RULE
========================================================

This is a FIX-PLANNING phase only.

Do not:
- modify code
- rewire routes
- delete routes
- rename pages
- merge features

Only prepare the approved plan for a later controlled fix phase.

===== END =====
