===== PHASE 4 — MIGRATE QURAN ↔ HADITH GRAPH LINKS TO CANONICAL HADITHENTRY IDs =====

PRIMARY OBJECTIVE === REPAIR THE QURAN ↔ HADITH CONNECTION LAYER SO IT USES CANONICAL HADITH FOUNDATION IDS INSTEAD OF LEGACY CURRICULUM LESSON IDS

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task based on the completed Hadith foundation and reader phases.
Do not redesign the app.
Do not build Hadith search yet.
Do not guess. Use the actual repo ownership and graph patterns already present.

CONTEXT
Completed groundwork:
- one canonical public Hadith content owner exists
- verified-only/default public surfacing rules are enforced
- Hadith source/reference/category metadata is normalized
- Hadith reader/detail parity is now in place

The current blocker for clean Qur’an ↔ Hadith linking is identity mismatch:
- parts of the Qur’an-side reference graph still point to legacy Hadith curriculum lesson ids
- the canonical Hadith runtime content now lives on `HadithEntry.id`

GOAL
Migrate the Qur’an ↔ Hadith graph so it uses canonical `HadithEntry.id` values instead of legacy curriculum ids, while preserving current route behavior and related-content UX.

IMPORTANT PRODUCT RULES
- Canonical Hadith runtime identity must be `HadithEntry.id`
- Do not reintroduce split ownership
- Do not break existing Qur’an graph behavior that is unrelated to Hadith
- Do not redesign the reader UI in this phase

IMPLEMENT THE FOLLOWING

A. AUDIT AND IDENTIFY LEGACY HADITH GRAPH REFERENCES
- Inspect the Qur’an-side graph/reference files and find all places where Hadith links still point to legacy curriculum lesson ids.
- Confirm the exact current mapping path and where legacy ids are still being produced.

B. MIGRATE HADITH GRAPH REFERENCES TO CANONICAL FOUNDATION IDS
- Replace legacy Hadith curriculum lesson ids in the Qur’an graph path with canonical `HadithEntry.id` values.
- Use deterministic mapping grounded in the actual canonical Hadith foundation dataset.
- Do not leave mixed-id behavior behind.

C. KEEP QURAN GRAPH OWNERSHIP CLEAN
- Preserve the existing Qur’an graph/reference architecture.
- Only fix the Hadith node identity inside it.
- Do not refactor unrelated Qur’an graph behavior.

D. PRESERVE RELATED QURAN / HADITH UX
- Ensure Hadith reader still shows related Qur’an correctly.
- Ensure Qur’an-side related Hadith surfaces use the canonical Hadith foundation path.
- Do not break current navigation to Hadith detail pages.

E. KEEP TRUST RULES INTACT
- Any Hadith surfaced through the Qur’an graph must still respect verified-only/default public surfacing rules.
- Do not allow legacy or non-public Hadith content to appear through graph migration.

F. ADD TEST COVERAGE
Add or update focused tests for:
- Qur’an-side Hadith graph links now resolve to canonical `HadithEntry.id`
- no legacy lesson ids remain in the active graph path where canonical Hadith links are expected
- related Hadith surfaces still resolve to valid public Hadith entries
- verified-only public surfacing still holds
- current routes still resolve correctly

G. DO NOT BREAK
- canonical public Hadith foundation owner
- verified-only public Hadith surfacing
- `quran_reference_graph_provider.dart`
- current Qur’an reader flows
- current Hadith reader/detail routes
- saved Hadith persistence
- localization

H. KEEP THE CHANGESET TIGHT
- Focus only on graph/id migration.
- Do not build Hadith search in this phase.
- Do not redesign Qur’an or Hadith readers.

DELIVERABLES
After implementing, provide:

1. Executive summary
2. Files changed
3. Where legacy Hadith ids existed
4. How they were migrated to canonical `HadithEntry.id`
5. How verified-only public surfacing remains intact
6. Validation notes
7. Analyzer results
8. Test results
9. Any follow-up notes for Phase 5 cross-domain editorial connection model or future Hadith search

At the very end, explicitly confirm:
- Qur’an ↔ Hadith graph links now use canonical `HadithEntry.id`
- legacy Hadith curriculum ids are no longer the active identity in the Qur’an graph path
- current Qur’an and Hadith routes/flows remain intact

===== END =====
