===== PHASE 2 PROMPT — LOCALIZATION TRANSLATION SYSTEM (ARABIC) =====

PRIMARY OBJECTIVE === BUILDING HIGH-QUALITY ARABIC LOCALIZATION FOR PATH OF NŪR

You are working in the existing Path of Nūr Flutter codebase.

Task type:
Localization translation implementation (Phase 2 — Arabic).

This is NOT a basic translation.
This must be high-quality, accurate, and suitable for an Islamic app.

========================================================
CORE GOAL
========================================================

Translate the English ARB file into Arabic while ensuring:
- correct Islamic terminology
- natural Modern Standard Arabic (MSA)
- production-ready JSON
- consistency across the entire app

========================================================
INPUT
========================================================

You will be given:
- app_en.arb

========================================================
OUTPUT
========================================================

You must produce:
- app_ar.arb (complete Arabic translation)

========================================================
STRICT TRANSLATION RULES
========================================================

1. DO NOT change keys.
2. DO NOT change JSON structure.
3. DO NOT remove placeholders.
4. DO NOT translate variable names.
5. Preserve placeholders EXACTLY.

Example:
"{count} days completed"
→ "{count} أيام مكتملة"

========================================================
ISLAMIC TERMINOLOGY (CRITICAL)
========================================================

Use correct Arabic Islamic terms:

- Qur’an → القرآن
- Salah → الصلاة
- Dhikr → الذكر
- Hadith → الحديث
- Surah → سورة
- Ayah → آية

Do NOT invent translations for these.

========================================================
LANGUAGE STYLE RULES
========================================================

Use:
- Modern Standard Arabic (MSA)
- simple, clear phrasing
- mobile-friendly wording

Avoid:
- overly classical Arabic
- overly complex grammar
- long sentences
- literal word-for-word translation

========================================================
TONE
========================================================

The tone should be:
- respectful
- clear
- calm
- instructional where needed

This is an Islamic growth app, not a formal book.

========================================================
UI / UX CONSTRAINTS
========================================================

- Keep text short where possible
- Avoid overflow-prone phrases
- Prefer clarity over formality
- Ensure button labels are concise

========================================================
PLACEHOLDER HANDLING (CRITICAL)
========================================================

Examples:

EN:
"Level {level}"
AR:
"المستوى {level}"

EN:
"{count} day streak"
AR:
"{count} يوم متتالي"

DO NOT:
- remove {}
- rename variables
- reorder placeholders incorrectly

========================================================
LOCALIZATION SYSTEM INTEGRATION
========================================================

- Keep metadata keys (@key) unchanged
- Preserve descriptions
- Ensure compatibility with flutter gen-l10n

========================================================
QUALITY RULES
========================================================

- Maintain consistency across repeated concepts
- Do not translate the same term differently in different places
- Ensure Arabic reads naturally to a native speaker

========================================================
OPTIONAL IMPROVEMENTS
========================================================

You may:
- slightly improve clarity
- simplify awkward English phrasing

BUT:
- do not change meaning
- do not expand scope

========================================================
VALIDATION BEFORE RETURN
========================================================

Before returning:

1. JSON must be valid
2. All keys must match app_en.arb
3. No missing entries
4. No extra entries
5. Placeholders preserved
6. Arabic text correctly encoded

========================================================
OUTPUT FORMAT
========================================================

Return:

1. Summary:
   - total keys translated
   - any special handling notes

2. Complete translated file:

app_ar.arb
{
  ...
}

========================================================
FINAL RULE
========================================================

This must be production-ready Arabic.

Do not:
- use incorrect Islamic terms
- break JSON
- break placeholders
- use unnatural Arabic

===== END =====
