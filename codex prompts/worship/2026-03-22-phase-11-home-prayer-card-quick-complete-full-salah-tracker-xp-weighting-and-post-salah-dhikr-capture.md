# Homepage Salah Cards Update v5

===== PHASE 11 PROMPT — HOME PRAYER CARD QUICK COMPLETE, FULL SALAH TRACKER, XP WEIGHTING, AND POST-SALAH DHIKR CAPTURE =====

PRIMARY OBJECTIVE === BUILDING HOME PRAYER CARD QUICK COMPLETE, FULL SALAH TRACKER ENTRY, PRAYER CONTEXT XP WEIGHTING, AND POST-SALAH DHIKR LOGGING

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing prayer and homepage systems. DO NOT rebuild the prayer system. DO NOT remove working prayer logging, homepage cards, streaks, XP, dhikr tracking, stats, notifications, or persistence. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing prayer completion records, streaks, XP, dhikr data, notifications, stats, and homepage behavior unless explicitly improved in this phase
- Do not delete or rewrite historical user records
- Do not create duplicate prayer completions from repeated taps
- Do not create duplicate dhikr logs from repeated taps
- Keep the UX fast on the homepage and more detailed in the full tracker
- Build on top of the current prayer card interaction pattern
- Keep this production-ready, calm, intuitive, and not cluttered
- No unnecessary package churn
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Improve the Salah timings cards on the homepage so that:
   - when the user marks a prayer as offered from the homepage card, the offered time is automatically recorded

2. Allow the user to tap the prayer card again after completion and open a full tracker experience for that prayer

3. In the full tracker, let the user choose prayer context details in an intuitive way:
   - Alone
   - In Congregation
   - In Mosque

4. Let the user choose prayer timing status:
   - On Time
   - Qada

5. Apply XP weighting based on prayer context:
   - Alone < In Congregation < In Mosque

6. Add a checkbox on the main prayer card for post-salah dhikr completion

7. When dhikr is marked complete from the main card, automatically add the standard post-salah dhikr to the dhikr system:
   - 33 SubhanAllah
   - 33 Alhamdulillah
   - 34 Allahu Akbar
   Use the correct canonical total of 100. Do NOT implement 35 unless the existing product intentionally uses a different validated scheme and that is already modeled consistently across the app.

8. Ensure the dhikr action syncs safely with the dhikr page/history and does not create accidental duplicates

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the existing implementation before editing.

Inspect:
- homepage prayer timing cards
- prayer completion interaction on the homepage
- current prayer tracker / prayer detail / prayer log entry flow
- current prayer data model
- current XP awarding logic for prayers
- current dhikr tracking/logging model
- current homepage-to-prayer-page routing
- current handling for completed prayers versus pending prayers
- current history/statistics behavior for prayer entries
- any existing post-prayer dhikr logic
- any existing salah context fields such as congregation/mosque/on-time/qada
- any duplication protections already in place

Audit these questions:
- What happens today when a user taps a prayer on the homepage?
- Is offered time already captured anywhere, and if so at what precision?
- Is there already a full prayer tracker page or sheet that can be reused?
- Are there existing fields for:
  - prayedAt/offeredAt
  - on-time vs qada
  - alone vs congregation vs mosque
- How is XP currently assigned for a completed prayer?
- Does dhikr logging already support predefined bundles/sets?
- What is the safest way to prevent duplicate prayer completion and duplicate dhikr injection?
- What current UX patterns exist for a second tap on a completed card?

--------------------------------------------------
B. HOMEPAGE PRAYER CARD QUICK COMPLETE
--------------------------------------------------

Improve the homepage prayer card so that marking a prayer as offered is fast and reliable.

Requirements:
- when the user marks the prayer as offered from the homepage, automatically store the completion timestamp
- the logged time should reflect the actual action time unless the product already uses a normalized scheme that must be preserved
- preserve the current fast interaction feel
- do not force the user through the full tracker just to mark a prayer complete
- do not create duplicate completion entries on repeated taps

If the current UX uses a checkbox, button, tap target, or swipe, build on that pattern rather than inventing a completely different flow unless the current one is weak.

--------------------------------------------------
C. SECOND TAP OPENS FULL PRAYER TRACKER
--------------------------------------------------

After a prayer has been marked as offered, allow the user to tap that prayer card again to open a fuller prayer tracker experience for that specific prayer.

Goal:
- homepage = quick completion
- second interaction = richer tracking and correction

Requirements:
- if prayer is already completed, tapping the card should open the prayer detail/tracker flow for that prayer instance
- if prayer is not yet completed, preserve the quick-complete interaction pattern
- the full tracker should allow the user to review and refine the recorded prayer
- do not make the card behavior confusing or inconsistent

If a bottom sheet, modal sheet, or detail page is the best fit within the current design system, use what fits the app best and is already consistent.

--------------------------------------------------
D. FULL TRACKER UX — PRAYER CONTEXT SELECTION
--------------------------------------------------

In the full prayer tracker, let the user intuitively choose how the prayer was performed:

- Alone
- In Congregation
- In Mosque

Requirements:
- this should feel fast and obvious, not like a complicated form
- choices should be mutually exclusive
- the UI should fit the calm Path of Nūr design language
- the user must be able to edit the value later if they reopen the tracker
- if historical prayer records lack this data, keep them valid

Prefer a simple segmented control, chips, or calm selection tiles over heavy forms.

--------------------------------------------------
E. FULL TRACKER UX — TIMING STATUS
--------------------------------------------------

Let the user choose whether the prayer was:

- On Time
- Qada

Requirements:
- also intuitive and quick
- preserved on edit
- should not conflict with the automatically recorded offered time
- do not overcomplicate with too many fiqh-specific branches in this phase
- keep the data model extensible for future enrichment if needed

If the prayer was quick-completed from the homepage, choose a sensible default that the user can adjust inside the full tracker.

--------------------------------------------------
F. XP WEIGHTING FOR PRAYER CONTEXT
--------------------------------------------------

Add XP weighting for prayer context with this progression:

- Alone = base prayer XP
- In Congregation = higher XP
- In Mosque = highest XP

Requirements:
- preserve the existing XP architecture and formulas where possible
- do not hardcode magic values all over the UI
- centralize the weighting logic in a production-safe place
- do not retroactively mutate past completed prayers unless the current system is explicitly designed to recompute safely
- avoid double-awarding XP if the user edits the prayer after completion

Implement the weighting carefully so:
- initial quick completion gives a safe default XP state
- updating prayer context later adjusts XP correctly if the architecture supports this safely
- no duplicate XP events are created
- stats remain coherent

If recalculating delta XP on edit is risky, implement a safe reconciliation strategy and explain it clearly in the final summary.

--------------------------------------------------
G. MAIN CARD POST-SALAH DHIKR CHECKBOX
--------------------------------------------------

Add a checkbox or similarly clean lightweight control on the main homepage prayer card for post-salah dhikr completion.

When checked, it should log the standard post-prayer dhikr bundle into the dhikr system:
- 33 SubhanAllah
- 33 Alhamdulillah
- 34 Allahu Akbar

Requirements:
- the interaction must be simple and calm
- only available in a way that makes sense after prayer completion
- checking it should create a clear linked dhikr action
- unchecking behavior must be handled carefully to avoid corrupting dhikr history
- avoid accidental repeated logging from repeated taps

If the current dhikr architecture supports grouped bundles/sets, use that. If not, implement the safest structured equivalent.

--------------------------------------------------
H. DHIKR LOGGING SAFETY AND DEDUPLICATION
--------------------------------------------------

The post-salah dhikr checkbox must sync safely with the Dhikr page/history.

Requirements:
- no duplicate bundle injection if the user reopens the card
- no duplicate counts from rapid repeated taps
- the dhikr entry should be attributable to the linked prayer where appropriate
- if the user already logged the post-salah dhikr for that prayer, the checkbox should reflect that state
- the Dhikr page should remain coherent and not show confusing duplicate fragments if avoidable

Prefer one structured linked record over three messy independent accidental records, if the existing architecture supports that safely.

If unchecking after a log was created is risky:
- either implement a safe reversible action
- or treat it as a one-time logged state and reflect that clearly
- but do not silently corrupt user dhikr history

--------------------------------------------------
I. DATA MODEL / TRACKING ENRICHMENT
--------------------------------------------------

Extend the prayer tracking model only as needed and safely.

Potential fields may include:
- offeredAt / completedAt timestamp
- prayerPerformanceType: alone / congregation / mosque
- prayerTimingStatus: onTime / qada
- linkedPostSalahDhikrLogged
- linkedDhikrLogId or equivalent linkage if supported

Requirements:
- keep backwards compatibility for old prayer records
- no destructive migrations
- do not invalidate prior entries that lack the new metadata
- keep persistence and stats safe

Only add fields that are truly needed.

--------------------------------------------------
J. HOMEPAGE UX AND VISUAL DESIGN
--------------------------------------------------

Keep the homepage card clean.

Requirements:
- quick completion should remain the primary action
- completed prayers should still be easy to understand at a glance
- the extra dhikr checkbox should not clutter the card
- tapping a completed card should feel discoverable and natural
- avoid too many buttons on one card

Preferred behavior pattern:
- first action = mark offered quickly
- after completion = card becomes a detail/edit entry point
- lightweight dhikr completion control sits naturally within the completed state

Do not redesign the whole homepage in this phase.

--------------------------------------------------
K. STATS / HISTORY / DOWNSTREAM EFFECTS
--------------------------------------------------

Audit and preserve downstream consistency for:
- prayer history
- daily summaries
- streaks
- XP totals
- growth/statistics pages
- dhikr totals
- any prayer detail/history pages

Requirements:
- new metadata should enrich the system without breaking old dashboards
- prayer completion counts should remain correct
- dhikr totals should increment correctly when the checkbox is used
- linked prayer + dhikr behavior should remain understandable

--------------------------------------------------
L. EMPTY / ERROR / EDGE CASE HANDLING
--------------------------------------------------

Handle edge cases safely, including:
- user taps completed prayer repeatedly
- user edits prayer context multiple times
- user checks dhikr before prayer is marked complete
- prayer record exists but linked dhikr record is missing
- historical prayer record has no new metadata
- app restarts after quick completion but before full tracker edit
- invalid prayer card state

Requirements:
- no crashes
- no silent duplication
- graceful fallback behavior

--------------------------------------------------
M. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- quick completion records offered time
- tapping a completed prayer opens the full tracker
- alone / congregation / mosque selection persists correctly
- on-time / qada selection persists correctly
- XP weighting logic works safely
- editing prayer context does not duplicate XP awards
- dhikr checkbox logs the standard post-salah dhikr bundle correctly
- repeated taps do not duplicate dhikr entries
- completed card state reflects linked dhikr state
- old prayer records without new metadata remain valid

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - existing homepage prayer card behavior
   - existing prayer tracker behavior
   - existing XP and dhikr architecture constraints

3. Homepage quick-complete summary
   - how offered time is now stored
   - how repeated taps are handled

4. Full tracker summary
   - how second-tap flow works
   - how prayer context and timing status are selected

5. XP weighting summary
   - where logic lives
   - how duplicate/delta XP was prevented

6. Dhikr integration summary
   - how the post-salah dhikr checkbox works
   - what gets logged
   - how duplicates were prevented

7. Data safety summary
   - model changes
   - migration/backwards compatibility notes

8. Validation
   - analyzer/tests run
   - results

9. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-ups
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- homepage prayer quick-complete records offered time automatically
- tapping a completed prayer card opens a full tracker for that prayer
- user can choose Alone / In Congregation / In Mosque
- user can choose On Time / Qada
- XP weighting increases from Alone to Congregation to Mosque
- homepage card includes a post-salah dhikr completion control
- checking dhikr logs the standard post-prayer dhikr safely into the dhikr system
- no duplicate prayer or dhikr records are created
- existing prayer history, stats, XP, and dhikr data remain valid
- the experience feels intuitive, calm, and production-ready

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the entire prayer system
- redesign the whole homepage
- introduce fiqh-complex branching beyond this scope
- retroactively rewrite historical user records unsafely
- create duplicate XP or dhikr logs
- hardcode business logic across multiple UI files
- break prayer streaks, stats, notifications, or dhikr history

Stay focused on homepage salah quick-complete, full tracker refinement, XP weighting, and safe post-salah dhikr capture.

--------------------------------------------------

“Indeed, prayer has been decreed upon the believers a decree of specified times.” — Qur’an 4:103

===== END PHASE 11 PROMPT =====
