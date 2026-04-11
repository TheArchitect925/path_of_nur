# Hadith Audit Prompt

===== PHASE AUDIT — HADITH CONTENT, OWNERSHIP, VERIFIED DATA, READER UX, AND SEARCH READINESS =====

PRIMARY OBJECTIVE === AUDIT THE EXISTING HADITH EXPERIENCE END TO END SO WE CAN PLAN A VERIFIED HADITH LIBRARY + READER + SEARCH SYSTEM WITH THE SAME PRODUCT QUALITY DIRECTION AS THE QURAN WORK

You are auditing the existing Flutter codebase for Path of Nūr.

Do not implement anything yet.
Audit first and report findings clearly.
Do not redesign the app yet.
Do not guess.
Base conclusions only on actual repo findings.

CONTEXT
We now want to do for Hadith what we have been doing for Qur’an:
	•	establish a trusted, verified content foundation
	•	understand exactly what content/data is already in the repo
	•	understand reader / browse / navigation / search ownership
	•	identify what is missing for a production-ready Hadith experience
	•	eventually add strong Hadith search and reader functionality

The intent is to build a Hadith experience that is:
	•	trustworthy
	•	structured
	•	searchable
	•	explainable
	•	safe for public-facing use

We want to know whether the current repo is ready for that, what can be reused, what needs to be corrected, and how to phase the work.

AUDIT GOALS
We want to determine:
	1.	what Hadith functionality already exists
	2.	what Hadith data/content already exists
	3.	whether the content is verified / graded / sourced clearly
	4.	how Hadith pages, routes, and models are structured
	5.	whether the repo is ready for a strong Hadith search system
	6.	the best production-ready implementation path

ANSWER THE FOLLOWING QUESTIONS CLEARLY

A. CURRENT HADITH PRODUCT SURFACE
	1.	What Hadith-related pages, routes, hubs, cards, browse surfaces, or reader/detail pages already exist?
	2.	What is the canonical Hadith entry point today?
	3.	Are there multiple Hadith surfaces or duplicate/legacy routes?
	4.	What user flows currently exist for Hadith:
	•	browse
	•	categories
	•	collections/books
	•	detail reading
	•	favorites/bookmarks
	•	daily Hadith
	•	search
	•	insights/explanations
	5.	Which files currently own Hadith UI and route behavior?

B. CURRENT HADITH DATA OWNERSHIP
6. Where does Hadith content come from today?
7. Is the Hadith content:
	•	bundled locally
	•	fetched from an API
	•	hardcoded/seeded
	•	partially mocked
	•	or mixed

	8.	What models currently represent Hadith data?
	9.	Does the current Hadith model already include useful fields such as:
	•	id
	•	collection/book name
	•	book/chapter metadata
	•	hadith number
	•	Arabic text
	•	translation text
	•	narrator
	•	grade/authenticity
	•	source citation
	•	tags/topics
	10.	If not, what is missing?

C. CONTENT TRUST / VERIFICATION
11. Is there already any trust model for Hadith content in the repo?
12. Are hadiths currently tagged with authenticity/grade such as:
	•	sahih
	•	hasan
	•	da’if
	•	unknown

	13.	Are there source citations and chain/book references shown clearly?
	14.	Are there existing rules for what Hadith content is allowed to surface publicly by default?
	15.	Is there already any content filtering for weak/uncertain/unreviewed hadith?
	16.	If content is currently unstructured or partially trusted, how risky is it to expose broadly as-is?

D. CURRENT READER / DETAIL EXPERIENCE
17. Is there already a Hadith detail page / reader page?
18. How is a Hadith opened today?
19. Does the detail page support:
	•	Arabic + translation
	•	source info
	•	grade/authenticity
	•	explanation/insight
	•	sharing
	•	bookmarking
	•	copying

	20.	Is the current detail experience production-ready or more like a basic content page?
	21.	What files own the Hadith detail presentation?

E. CURRENT SEARCH READINESS
22. Is there already any Hadith search in the repo?
23. If yes, what exactly does it search:
	•	title
	•	Arabic
	•	translation
	•	collection
	•	tags/topics

	24.	Is current search real, partial, mocked, or missing?
	25.	Is there already a canonical search owner/provider/repository for Hadith?
	26.	Could the current architecture support:

	•	text/phrase search
	•	Arabic search
	•	collection search
	•	topic search

	27.	What is missing for a production-grade Hadith search experience?

F. STRUCTURE / INFORMATION ARCHITECTURE
28. How is Hadith currently organized?
29. Is there already a structure like:
	•	collections/books
	•	chapters
	•	themes/topics
	•	daily Hadith
	•	beginner-friendly selections

	30.	Is the current structure coherent enough for users, or does it need ownership cleanup?
	31.	Are there route/ownership mismatches similar to past Qur’an issues?

G. SEARCH + READER PARITY POTENTIAL
32. Based on the repo, can Hadith reasonably support a search + reader workflow similar to the Qur’an build, such as:
	•	dedicated search page
	•	shared search ownership
	•	result snippets
	•	exact detail-page handoff
	•	in-reader search later

	33.	What parts of the Qur’an architecture are reusable for Hadith?
	34.	What parts should NOT be reused directly because Hadith has different structure/content requirements?

H. VERIFIED CONTENT FOUNDATION PLAN
35. Based on what is already present, what is the safest path to a verified Hadith foundation?
36. Should the app start with:
	•	one curated trusted subset
	•	a few trusted collections only
	•	existing local content after cleanup
	•	or another phased approach

	37.	What would be the safest public-default surfacing rules for V1?
	38.	What metadata absolutely must exist before a Hadith search/recommendation system is exposed broadly?

I. GAP ANALYSIS
39. What is already strong and reusable?
40. What is weak, risky, or incomplete?
41. What should be corrected before adding a big Hadith search feature?
42. What content, data, route, or UI gaps are blockers?

J. RECOMMENDED IMPLEMENTATION PLAN
43. What is the best phased implementation path for a production-ready Hadith experience?
44. Recommended phases should ideally cover:
	•	verified content foundation
	•	canonical Hadith models/repository
	•	browse/detail experience
	•	trusted surface/default rules
	•	search foundation
	•	later search polish

	45. What should explicitly not be changed to avoid regressions?

AUDIT INSTRUCTIONS
	•	Audit first before proposing implementation.
	•	Focus on actual repo ownership and content reality.
	•	Be honest if content quality or sourcing cannot be confirmed from the repo.
	•	If something cannot be confirmed, name the exact file or gap preventing confirmation.

DELIVERABLE FORMAT
Provide:
	1.	Executive summary
	2.	Existing Hadith architecture findings
	3.	Existing Hadith content/data findings
	4.	Trust / verification findings
	5.	Reader/detail findings
	6.	Search readiness findings
	7.	Exact files involved
	8.	Gaps / blockers
	9.	Recommended phased plan
	10.	Regression watchouts

IMPORTANT
Do not implement yet.
At the very end, provide:
	•	a concise “build first” checklist
	•	a concise “do not break” checklist

Focus file areas first:
	•	lib/features/**hadith**
	•	any learn/discovery/hub routes that reference hadith
	•	repositories/services/providers/models for hadith
	•	route files
	•	local assets / JSON / seeded content tied to hadith
	•	cards/widgets showing hadith content anywhere in the app

===== END =====
