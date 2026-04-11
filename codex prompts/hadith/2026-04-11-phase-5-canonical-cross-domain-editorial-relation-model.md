===== PHASE 5 — BUILD A CANONICAL CROSS-DOMAIN EDITORIAL RELATION MODEL =====

PRIMARY OBJECTIVE === CREATE A TRUSTWORTHY, CANONICAL CROSS-DOMAIN RELATION MODEL FOR QURAN ↔ HADITH ↔ DUA ↔ CREATION ↔ LEARN CONTENT USING STABLE IDS AND EXPLICIT RELATION TYPES

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task based on the completed Hadith foundation, Hadith reader, and Qur’an ↔ Hadith graph-id migration phases.
Do not redesign the app.
Do not build Hadith search yet.
Do not guess. Use the actual repo ownership and connection patterns already present.

CONTEXT
Completed groundwork:
- one canonical public Hadith content owner exists
- verified-only/default Hadith public surfacing is enforced
- Hadith source/reference/category metadata is normalized
- Hadith reader/detail parity is in place
- Qur’an ↔ Hadith graph links now use canonical `HadithEntry.id`

The next blocker is that cross-domain links are still partial and inconsistent:
- Qur’an has a mature graph/reference system
- Hadith has structured Qur’an links
- Dua has strong trust/discovery structure and Qur’an linkage
- Creation/World/Learn content has partial Qur’an-linked structures
- the contextual linking engine is recommendation-oriented, not a canonical editorial relation model

GOAL
Build a canonical cross-domain editorial relation model that can support trustworthy links between:
- Qur’an
- Hadith
- Duas
- Creation / Signs / World content
- other Learn content

IMPORTANT PRODUCT RULES
- Use stable canonical ids wherever possible.
- Prefer editorially explicit relationships over fuzzy recommendation-only links.
- Do not replace the existing contextual linking engine; layer a canonical editorial relation model alongside it.
- Keep this phase focused on data/model/repository/provider structure and safe surfaced usage where appropriate.
- Do not overbuild search yet.

IMPLEMENT THE FOLLOWING

A. DEFINE A CANONICAL CROSS-DOMAIN RELATION MODEL
- Create a structured relation model that can connect canonical content across domains.
- The model should support at least:
  - source node
  - target node
  - source domain
  - target domain
  - relation type
  - optional editorial note/label
  - optional confidence/editorial metadata if useful
- Use stable canonical ids for all supported domains where possible.

B. DEFINE RELATION TYPES
Add clear, explicit relation types such as:
- explains
- reinforces
- same_theme
- related_practice
- related_dua
- related_creation_sign
- same_lesson
- reader_follow_up

Keep the set tight and useful for V1.

C. SUPPORT THESE DOMAINS
At minimum, prepare the model to support:
- Qur’an
- Hadith
- Dua
- Creation / Signs / World
- generic Learn content where canonical ids exist

D. BUILD A CANONICAL EDITORIAL RELATION DATA PATH
- Create a canonical data/provider path for these relations.
- This can be:
  - a local editorial dataset
  - seeded structured relation entries
  - or another repo-grounded editorial source
- Keep it deterministic and maintainable.

E. KEEP EXISTING SYSTEMS COMPATIBLE
- Do not break:
  - Qur’an reference graph
  - contextual linking engine
  - existing Hadith reader related Qur’an sections
  - existing Dua Qur’an handoffs
- This new model should become the trusted editorial relation layer, not a destructive rewrite of unrelated systems.

F. ADD SAFE INITIAL USAGE
- Add safe initial usage where appropriate, such as:
  - Hadith reader can consume canonical related Qur’an / related Dua / related Learn relations if available
  - Qur’an side can later consume canonical related Hadith / related Dua relations
- Keep UI changes minimal in this phase unless a tiny safe surfacing improvement is needed.

G. KEEP TRUST RULES INTACT
- Any Hadith content surfaced through this model must still respect verified-only/default public surfacing rules.
- Do not allow non-public or legacy Hadith content to leak through relations.

H. ADD TEST COVERAGE
Add or update focused tests for:
- canonical relation model integrity
- stable id/domain handling
- relation type handling
- Qur’an ↔ Hadith canonical id usage
- Hadith ↔ Dua relation support
- public verified-only Hadith enforcement through relations
- compatibility with current route/navigation flows

I. DO NOT BREAK
- canonical public Hadith foundation owner
- verified-only Hadith public surfacing
- Qur’an reference graph
- contextual linking engine
- Hadith reader/detail routes
- Dua detail routes
- current Learn routes
- localization

J. KEEP THE CHANGESET TIGHT
- Focus on the canonical editorial relation model.
- Do not build the full Hadith search system in this phase.
- Do not redesign the readers broadly.
- Do not replace unrelated recommendation systems.

DELIVERABLES
After implementing, provide:

1. Executive summary
2. Files changed
3. What canonical relation model was added
4. What relation types were added
5. Which domains are supported
6. How existing systems remain compatible
7. How verified-only Hadith surfacing remains intact
8. Validation notes
9. Analyzer results
10. Test results
11. Any follow-up notes for Phase 6 Hadith search foundation

At the very end, explicitly confirm:
- a canonical cross-domain editorial relation model now exists
- Qur’an ↔ Hadith uses stable canonical ids
- the model is ready to support Qur’an / Hadith / Dua / Learn connection surfacing
- existing routes and trust rules remain intact

===== END =====
