# Prompt

===== PHASE 1 — QURAN TRANSLATIONS API AUDIT =====

PRIMARY OBJECTIVE === AUDIT CURRENT QURAN TRANSLATIONS IMPLEMENTATION AND PREPARE FOR PRODUCTION-READY MULTI-LANGUAGE SUPPORT USING QURAN.COM API

CONTEXT:
We are working inside the existing Flutter codebase for “Path of Nūr”.

The app should support:
- Multiple Quran translations (user selectable)
- Multiple languages
- Offline-first caching
- Clean integration with the Quran reader

We want to standardize on:
https://api.quran.com/api/v4

Key endpoints:
- /resources/translations → list available translations
- /verses/by_chapter/{chapter} → fetch verses with translations
- translations passed via: translations=<ids>

IMPORTANT:
- Quran.com API uses TRANSLATION IDs, not language strings
- Must support multiple translations per ayah
- Must support offline-first architecture

EXECUTION RULES:
1. AUDIT FIRST — DO NOT IMPLEMENT ANYTHING
2. DO NOT break existing Quran reader
3. DO NOT redesign UI
4. DO NOT delete working code unless duplicated
5. REUSE existing architecture (Riverpod, repositories, etc.)
6. KEEP everything offline-first compatible

--------------------------------------------------

TASK A — LOCATE CURRENT IMPLEMENTATION

Search for:
- Quran API usage
- translation logic
- verse fetching
- tafsir handling
- local JSON datasets

Identify:
- All services fetching Quran data
- All models for verses/translations
- All repositories/controllers
- Any hardcoded translations
- Any APIs used (alquran.cloud, quran.com, local files, etc.)

--------------------------------------------------

TASK B — IDENTIFY DATA SOURCE STRATEGY

Determine:
- What API is currently used?
- Is translation tied to:
  - language code
  - translation ID
  - hardcoded mapping
- Are multiple translations supported?
- Is transliteration supported?

--------------------------------------------------

TASK C — GAP ANALYSIS

Compare current system vs REQUIRED system:

REQUIRED SYSTEM:
- Dynamic translation list from /resources/translations
- Translation IDs stored (NOT language strings)
- Multi-translation support per ayah
- Per-user translation preferences
- Offline caching per translation
- Clean separation between Arabic + translations

FIND:
- Hardcoded translations
- Missing catalog sync
- No multi-language switching
- No caching layer
- Duplicate API usage
- Broken or inconsistent models

--------------------------------------------------

TASK D — ARCHITECTURE AUDIT

Check for existence of:

- quran_translation_service
- quran_translation_repository
- quran_translation_preferences
- quran_reader_controller

Evaluate:
- Separation of concerns
- API vs repository vs UI boundaries
- Duplication across features

--------------------------------------------------

TASK E — DATA MODEL AUDIT

Inspect verse models.

IF model looks like:
class Verse {
  String text;
  String translation;
}

FLAG AS INVALID

REQUIREMENT:
Must support multiple translations per ayah:
- List<Translation>
- keyed by translation ID

--------------------------------------------------

TASK F — PERFORMANCE + OFFLINE

Check:
- Is data cached?
- Where? (SharedPreferences, DB, memory)
- Per-surah caching?
- Per-translation caching?

Identify:
- Repeated API calls
- Missing cache strategy
- Inefficient data loading

--------------------------------------------------

TASK G — RISK ANALYSIS

Identify risks when switching to Quran.com API:

- UI expecting single translation
- Tight coupling to old API format
- Missing translation IDs
- Pagination issues
- Model mismatches

--------------------------------------------------

TASK H — OUTPUT FORMAT

Provide structured output:

1. CURRENT STATE
- APIs used
- Data flow
- Architecture summary

2. ISSUES FOUND
- Grouped by severity

3. MISSING COMPONENTS
- Exact files/services needed

4. RECOMMENDED ARCHITECTURE
Define:
- Services
- Repositories
- Models
- Storage
- Controllers

5. MIGRATION PLAN
Step-by-step upgrade path

6. RISK LEVEL
(low / medium / high)

--------------------------------------------------

FINAL STEP:

Provide:
- Plain English summary
- Biggest architectural flaw

DO NOT IMPLEMENT ANYTHING YET
THIS IS AUDIT ONLY

===== END =====
