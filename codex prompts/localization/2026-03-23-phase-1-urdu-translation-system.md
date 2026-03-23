===== PHASE 1 PROMPT — LOCALIZATION TRANSLATION SYSTEM (URDU) =====

PRIMARY OBJECTIVE === BUILDING A PRODUCTION-READY TRANSLATION PIPELINE FOR PATH OF NŪR

You are working in the existing Path of Nūr Flutter codebase.

Task type:
Localization translation implementation (Phase 1 — Urdu).

This is NOT a one-off translation.
This is the foundation for a scalable, multi-language localization system.

========================================================
CORE GOAL
========================================================

Translate the English ARB file into Urdu while ensuring:
- accuracy of Islamic terminology
- production-ready JSON structure
- scalability for future languages
- zero breakage in localization system

========================================================
INPUT
========================================================

You will be given:
- app_en.arb

========================================================
OUTPUT
========================================================

You must produce:
- app_ur.arb (complete Urdu translation)

========================================================
STRICT TRANSLATION RULES
========================================================

1. DO NOT change keys.
2. DO NOT change JSON structure.
3. DO NOT remove placeholders.
4. DO NOT translate variable names.
5. Preserve placeholders exactly:
   Example:
   "{count} day streak" → "{count} دن کا تسلسل"

6. Maintain Islamic terminology correctly:

- Qur’an → قرآن
- Salah → نماز
- Dhikr → ذکر
- Hadith → حدیث
- Surah → سورت
- Ayah → آیت

7. Tone must be:
- simple
- clear
- user-friendly
- not overly formal or classical

8. Avoid:
- robotic translation
- overly literal translation
- mixing Urdu + English unnecessarily

========================================================
QUALITY RULES
========================================================

- Translation must feel natural to a native Urdu speaker
- Maintain consistency across repeated terms
- Do not create multiple translations for the same concept
- Ensure UI friendliness (short enough for mobile screens)

========================================================
PLACEHOLDER HANDLING (CRITICAL)
========================================================

Examples:

EN:
"{count} days completed"

UR:
"{count} دن مکمل"

EN:
"Level {level}"

UR:
"لیول {level}"

DO NOT:
- remove {}
- rename variables
- reorder incorrectly

========================================================
LOCALIZATION SYSTEM INTEGRATION
========================================================

- Keep metadata keys (e.g. "@key") unchanged
- Preserve descriptions
- Ensure file compiles with flutter gen-l10n

========================================================
VALIDATION BEFORE RETURN
========================================================

Before returning:

1. JSON must be valid
2. All keys must match app_en.arb
3. No missing entries
4. No extra entries
5. Placeholders must be intact
6. Encoding must support Urdu characters

========================================================
OPTIONAL IMPROVEMENTS
========================================================

If obvious improvements exist:
- slightly simplify wording
- improve clarity

BUT:
- do not change meaning
- do not expand scope

========================================================
OUTPUT FORMAT
========================================================

Return:

1. Summary:
   - total keys translated
   - any special handling notes

2. Complete translated file:

app_ur.arb
{
  ...
}

========================================================
FINAL RULE
========================================================

This is a PRODUCTION-READY translation pass.

Do not:
- break JSON
- break placeholders
- over-interpret meaning
- introduce inconsistencies

===== END =====
