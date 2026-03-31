# ===== PHASE X PROMPT — REVERT BROKEN FULL-VIEWPORT PAGE FILL AND RESTORE CONTENT =====

PRIMARY OBJECTIVE === RESTORING PAGE CONTENT AFTER THE VIEWPORT-FILL FIX BROKE THE MAIN PAGE LAYOUT

You are working in the existing Flutter codebase for Path of Nūr.

Current problem:
A recent attempt to eliminate the remaining gap above the bottom navigation bar has broken the affected main pages.
The pages now show the full scenic background, but the actual page content is no longer visible.

Important:
Do NOT continue pushing the viewport-fill approach if it is breaking layout.
This pass must first restore the existing page content, then apply a safer minimal fix.

Execution rules:
1. Audit first before editing.
2. Revert the last layout pattern that caused content to disappear.
3. Do not modify the background system again.
4. Do not use IntrinsicHeight / Expanded / Spacer inside scroll content unless absolutely necessary and proven safe.
5. Preserve the existing page content and scroll behavior.
6. Use the safest minimal fix for the bottom visual remainder.
7. Keep implementation production-ready and maintainable.
8. Run analyzer on changed files and summarize results.

==================================================
PART A — FIND THE BREAKING CHANGE
==================================================

Audit the most recent page-body composition changes on affected pages such as:
- Learn
- Growth
- Worship
- Qur’an hub
and identify exactly what caused content to stop rendering.

Look for:
- LayoutBuilder + ConstrainedBox + IntrinsicHeight combinations
- Expanded inside a SingleChildScrollView
- Spacer inside scrollable column content
- a content child accidentally removed from the returned widget tree
- a Stack/z-order mistake where content is behind something
- a constraints issue causing zero-height/overflow/collapse

Deliverable:
- exact breaking layout change

==================================================
PART B — RESTORE THE PREVIOUS WORKING CONTENT TREE
==================================================

Restore the last known-good page content structure so:
- page content renders again
- scroll behavior works normally
- background remains correct
- the page does not show only the scenic artwork

Do not over-refactor.
Prefer restoring the previously working content tree first.

==================================================
PART C — APPLY A SAFER FIX FOR THE REMAINING LOWER GAP
==================================================

After content is restored, use a safer minimal approach for the lower-page finishing behavior.

Preferred approach:
- keep the existing SingleChildScrollView/ListView structure
- use appropriate bottom content padding
- if needed, add a small page-owned bottom finishing space within the content flow
- avoid raw unused scenic space directly above the bottom nav
- do not attempt a complex full-viewport fill architecture if it destabilizes the layout

Important:
The fix must not hide or collapse the content again.

==================================================
PART D — VALIDATION
==================================================

1. Confirm affected pages show their normal content again.
2. Confirm the scenic background remains correct.
3. Confirm the lower gap issue is improved without breaking layout.
4. Confirm scroll behavior works.
5. Confirm no page renders as only a background.
6. Confirm analyzer passes on changed files.

==================================================
DELIVERABLES
==================================================

Provide:
- files changed
- exact breaking change found
- what was reverted/restored
- what safer lower-gap fix was used instead
- analyzer result

IMPORTANT:
Do not let the system go haywire and remove/delete unrelated records, routes, logic, or data for no reason.
Restore the page content first, then fix the lower visual remainder safely.
