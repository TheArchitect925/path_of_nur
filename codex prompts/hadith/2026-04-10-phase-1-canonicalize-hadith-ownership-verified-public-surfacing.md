# Phase 1 Prompt

===== PHASE 1 — CANONICALIZE HADITH OWNERSHIP + VERIFIED PUBLIC SURFACING RULES =====

PRIMARY OBJECTIVE === ESTABLISH ONE CANONICAL HADITH FOUNDATION MODEL/REPOSITORY AND ENFORCE VERIFIED-ONLY DEFAULT PUBLIC SURFACING BEFORE BUILDING A FULL HADITH SEARCH SYSTEM

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task based on the completed Hadith audit.
Do not redesign the app yet.
Do not build the full Hadith search system in this phase.
Do not guess. Use the actual repo ownership discovered in the audit.

CONTEXT
The audit found:
	•	the canonical user entry point today is /learn/hadith
	•	the stronger modern content foundation is built around HadithEntry and hadith_foundation_repository.dart
	•	there is useful metadata already present:
	•	source URL
	•	source reference
	•	grading
	•	narrator
	•	Arabic
	•	translation
	•	tags
	•	verification booleans
	•	there is a release-gate test
	•	but ownership is split because an older curriculum/progress layer still exists
	•	there is no real production Hadith search system yet
	•	there is no explicit verified-only public-default surfacing rule in the runtime browse/repository logic

GOAL
Before building Hadith search, establish a trustworthy Hadith foundation by:
	1.	making one canonical Hadith foundation owner for public content
	2.	defining verified-only default public surfacing rules
	3.	reducing split ownership risk between the newer foundation layer and older curriculum/progress layer
	4.	keeping existing routes and user flows working

IMPORTANT PRODUCT RULE
This phase is not about making Hadith bigger.
It is about making it trustworthy, coherent, and safe enough to build on.

IMPLEMENT THE FOLLOWING

A. CANONICALIZE HADITH PUBLIC CONTENT OWNERSHIP
	•	Treat the newer Hadith foundation dataset/model/repository as the canonical public Hadith content owner.
	•	Audit the old curriculum/progress layer usage and isolate it where needed instead of letting it compete with the new foundation layer for public surfacing.
	•	Do not casually delete the old curriculum/progress system yet if shared Learn summaries or progress still depend on it.
	•	Make runtime public-facing Hadith browse/detail surfaces read from one canonical foundation path.

B. DEFINE VERIFIED-ONLY PUBLIC SURFACING RULES
	•	Add explicit runtime public-default gating rules for Hadith entries used in main Hadith browse/detail/daily surfaces.
	•	Use actual available metadata in HadithEntry.
	•	Public-default Hadith surfacing should require a trustworthy launch-ready minimum such as:
	•	source collection present
	•	source reference present
	•	grading present
	•	Arabic and/or translation presence according to the existing product needs
	•	verification flags satisfied
	•	Use the most repo-grounded launch ready rule possible.
	•	Do not allow weakly structured or incomplete entries to surface by default just because they exist in seeds.

C. KEEP TRUST RULES CENTRALIZED
	•	Put the verified/public surfacing rule in a canonical place so Hadith landing/browse/daily surfaces do not each invent their own filters.
	•	Reuse the existing release-gate direction where appropriate.
	•	Avoid duplicated trust logic across multiple pages.

D. NORMALIZE SOURCE METADATA FOUNDATIONS
	•	Without fully redesigning the data model yet, strengthen the canonical public model/repository around normalized source fields where safely possible:
	•	collection/book name
	•	reference
	•	grade
	•	narrator
	•	Do not overbuild the full search model yet, but prepare the foundation cleanly.

E. PRESERVE CURRENT USER FLOWS
	•	Keep working:
	•	/learn/hadith
	•	theme/detail flows
	•	collection/detail flows
	•	daily Hadith flow
	•	saved Hadith persistence
	•	review/path flows as applicable
	•	kids Hadith and Hadith Reflection routes
	•	Do not break route names or persistence keys.

F. ADD TEST COVERAGE
Add or update focused tests for:
	•	canonical public Hadith foundation provider/repository ownership
	•	verified-only/default public surfacing
	•	incomplete/unverified entries do not surface by default
	•	existing Hadith routes/pages still resolve through the intended content path
	•	daily Hadith uses the safe/public content subset if applicable

G. DO NOT BREAK
	•	existing GoRouter route names
	•	saved Hadith persistence
	•	daily reflection persistence
	•	review/path progress persistence
	•	editorial Hadith override flow
	•	kids Hadith and Hadith Reflection routes
	•	localization

H. KEEP THE CHANGESET TIGHT
	•	Do not build full search in this phase.
	•	Do not redesign the Hadith UI in this phase.
	•	Focus on ownership, trust rules, and safe public defaults.

DELIVERABLES
After implementing, provide:
	1.	Executive summary
	2.	Files changed
	3.	What was chosen as the canonical Hadith public content owner
	4.	What verified/public-default surfacing rules were added
	5.	How split ownership risk was reduced
	6.	Validation notes
	7.	Analyzer results
	8.	Test results
	9.	Any follow-up notes for Phase 2 source/book/chapter normalization

At the very end, explicitly confirm:
	•	one canonical Hadith public content owner now exists
	•	verified-only/default public surfacing rules are enforced
	•	existing Hadith routes and flows remain intact

===== END =====
