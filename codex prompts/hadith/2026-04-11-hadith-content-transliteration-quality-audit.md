# ===== PHASE AUDIT — HADITH CONTENT + TRANSLITERATION QUALITY =====

PRIMARY OBJECTIVE === AUDIT HADITH CONTENT COVERAGE AND TRANSLITERATION QUALITY WITHOUT MODIFYING DATA

You are working in the existing Flutter codebase for “Path of Nūr”.

Task type:
Content audit only. DO NOT modify or overwrite any hadith data in this phase.

Background:
The hadith system is now structurally sound (browse, reader, continuity).
However, content quality—especially transliteration—is inconsistent or missing across many entries.

We need a precise audit before any enrichment.

CRITICAL RULES:
1. DO NOT generate or overwrite transliteration content.
2. DO NOT “guess” Arabic or transliteration.
3. DO NOT modify existing datasets.
4. Only audit, classify, and report.

---

## A. Identify hadith data sources

Locate:
- hadith datasets / JSON / local storage
- providers feeding hadith content
- models representing hadith entries

For each hadith entry, identify fields such as:
- arabicText
- transliteration
- translation
- source
- grade
- metadata

---

## B. Coverage audit

For the full dataset (or a representative sample if very large), compute:

1. % of hadith with:
   - Arabic text present
   - Transliteration present
   - Translation present

2. Identify:
   - entries missing transliteration
   - entries missing Arabic
   - entries missing translation

3. Group results by:
   - source (Bukhari, Muslim, etc.)
   - collection
   - theme

---

## C. Transliteration quality audit

For entries WITH transliteration:

Detect issues such as:
- empty or placeholder values
- extremely short or obviously incomplete strings
- non-Latin characters inside transliteration
- broken tokenization (e.g. random punctuation, spacing errors)
- inconsistent casing patterns
- mixed styles (diacritic-heavy vs simplified)

Classify transliteration into:
- GOOD (usable and consistent)
- PARTIAL (present but likely low quality)
- POOR (clearly broken)
- MISSING

---

## D. Consistency audit

Check for duplicate hadith entries across:
- themes
- collections
- sources

Verify:
- whether transliteration differs between duplicates
- whether translation differs

Flag inconsistencies.

---

## E. UX impact classification

For each hadith, classify:

- FULLY USABLE
  (Arabic + transliteration + translation)

- LIMITED
  (missing one of the three)

- POOR
  (missing multiple fields or low-quality transliteration)

---

## F. Output summary

Provide:

1. Dataset coverage stats (percentages)
2. Count of:
   - missing transliteration
   - poor transliteration
3. Top problem areas:
   - specific collections/themes with highest gaps
4. Examples:
   - a few sample hadith entries with missing or poor transliteration
5. Risk level:
   - how severe this is for user experience

---

## G. DO NOT FIX YET

Do NOT:
- generate transliteration
- modify any hadith entry
- add fallback logic

Only audit and report.

---

## Deliverable

Return a structured audit summary with:
- stats
- classification breakdown
- concrete examples
- recommended next step strategy (high-level only)

===== END =====
