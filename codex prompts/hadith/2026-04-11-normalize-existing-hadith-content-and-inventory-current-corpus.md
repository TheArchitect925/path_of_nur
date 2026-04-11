===== PHASE — NORMALIZE ALL EXISTING HADITH CONTENT INTO THE CANONICAL INGESTION FORMAT + INVENTORY CURRENT CORPUS =====

PRIMARY OBJECTIVE === TAKE ALL EXISTING HADITH CONTENT WE ALREADY HAVE IN THE REPO, MAP IT INTO THE NEW CANONICAL HADITH FORMAT, AND PRODUCE A CLEAR INVENTORY OF WHAT CONTENT EXISTS TODAY

You are working in the existing Flutter codebase for Path of Nūr.

This is a data normalization + inventory task.
Do not redesign the app.
Do not build search yet.
Do not guess. Use the actual repo content and canonical Hadith foundation path already established.

CONTEXT
We now have a canonical Hadith structure direction and ingestion/output format.
Before importing a lot of new Hadith content, we need to:
1. normalize all existing Hadith content we already have into that canonical format
2. identify exactly what content already exists
3. identify gaps, duplicates, and weak/incomplete entries
4. prepare a clean baseline corpus we can expand from later

GOAL
Use the canonical Hadith mapping format and normalize all existing Hadith content in the repo into that structure, then provide a grounded inventory report of the current corpus.

CANONICAL TARGET FORMAT
Map existing content into the canonical structure we defined, including fields like:

- id
- sourceCollectionId
- sourceCollectionTitle
- primarySourceCollectionId
- primarySourceCollectionTitle
- displaySourceCollectionTitle

- bookId
- bookNumber
- bookTitle

- chapterId
- chapterNumber
- chapterTitle

- hadithNumber
- primaryHadithNumber
- normalizedSourceReference
- displayReference

- arabicText
- translationText
- transliteration

- narrator
- normalizedNarrator

- gradeText
- standardizedGrade

- sourceUrl

- categoryId
- categoryTitle
- subcategoryId
- subcategoryTitle

- themeId
- themeTag
- tags
- lessons

- quranConnections
- relatedHadithIds

- isVerifiedSource
- isVerifiedArabicMatn
- isVerifiedTranslation

- provenance

USE THE EXISTING REPO CONTENT ONLY
This phase is not yet about importing large new external datasets.
This phase is about taking what already exists in the repo and mapping it correctly.

IMPLEMENT THE FOLLOWING

A. FIND ALL EXISTING HADITH CONTENT SOURCES IN THE REPO
- Audit all existing Hadith content sources currently present in the repo, including:
  - canonical Hadith foundation data
  - legacy Hadith curriculum/lesson content
  - editorial override paths
  - any supporting Hadith JSON/artifacts
- Identify all relevant files and content owners.

B. NORMALIZE EXISTING CONTENT INTO THE CANONICAL FORMAT
- Build or extend a normalization path that can take current existing Hadith content and map it into the canonical Hadith structure.
- Reuse the canonical Hadith foundation model/repository as the source of truth where possible.
- Keep display fields separate from normalized fields.
- Generate canonical ids using the canonical strategy already chosen.
- Normalize source/book/chapter/reference/grade/category/subcategory/narrator fields where possible.

C. HANDLE LEGACY / INCOMPLETE CONTENT SAFELY
- If some legacy content cannot fully satisfy the canonical structure:
  - normalize as much as possible
  - mark gaps explicitly
  - do not silently fabricate trust-critical metadata
- Do not broaden public surfacing rules.
- Keep verified-only/public-default gating intact.

D. BUILD A CURRENT CORPUS INVENTORY
Produce a clear inventory of what content exists after normalization, including:
- total number of normalized Hadith entries
- counts by source collection/book
- counts by category
- counts by subcategory
- counts by grade
- counts by verification readiness
- counts by presence/absence of:
  - Arabic text
  - translation
  - narrator
  - source URL
  - source reference
  - category/subcategory
  - Qur’an connections
- list of duplicated or suspicious entries if found
- list of entries that fail launch/public-readiness

E. IDENTIFY REAL CONTENT GAPS
Report clearly:
- what major authentic collections are currently present
- what major authentic collections are currently absent
- whether current content is mostly curated subset vs full book coverage
- where metadata is weakest
- what content is ready to ship publicly now
- what content needs more work before expansion

F. OUTPUT A CLEAN NORMALIZED DATASET / ARTIFACT
- Produce a clean normalized output artifact from existing content, suitable as the internal baseline corpus.
- Keep it separate from raw legacy input if needed.
- Do not replace canonical runtime ownership incorrectly; keep the current repository trust model intact.

G. PRESERVE CURRENT APP BEHAVIOR
- Do not break current Hadith routes
- Do not break verified-only public surfacing
- Do not break reader/detail behavior
- Do not break saved Hadith / daily Hadith / review persistence
- Do not delete the legacy curriculum path yet unless it is clearly unused and safe

H. ADD TEST COVERAGE
Add or update focused tests for:
- normalization of existing content into canonical format
- deterministic id generation for existing entries
- normalization does not break verified-only/public surfacing
- normalized inventory outputs are structurally valid
- current public routes and readers still resolve correctly

I. DO NOT BREAK
- canonical public Hadith foundation owner
- verified-only public Hadith surfacing
- existing GoRouter route names
- saved Hadith persistence
- daily reflection persistence
- editorial override flow
- kids Hadith routes
- Hadith Reflection routes
- localization

J. KEEP THE CHANGESET TIGHT
- Focus on normalization + inventory only.
- Do not build search yet.
- Do not redesign the Hadith reader.
- Do not start broad new dataset import in this phase.

DELIVERABLES
After implementing, provide:

1. Executive summary
2. Files changed
3. What existing Hadith content sources were found
4. How the canonical normalization path works
5. What normalized output artifact(s) were created
6. A grounded inventory of the current Hadith corpus, including:
   - counts by source collection
   - counts by category/subcategory
   - counts by grade
   - counts by verification readiness
   - metadata completeness gaps
7. Which content is launch/public-ready today
8. Which content is incomplete or weak
9. Analyzer results
10. Test results
11. Recommended next content expansion priorities based on the actual normalized corpus

IMPORTANT
At the very end, explicitly provide:
- the approximate total number of usable Hadith entries currently in the normalized canonical corpus
- what collections/books are currently represented
- what major content gaps still remain

===== END =====
