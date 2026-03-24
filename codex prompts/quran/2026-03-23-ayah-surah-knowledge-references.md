# PHASE QURAN ENRICHMENT PROMPT — AYAH + SURAH KNOWLEDGE REFERENCES

## PRIMARY OBJECTIVE === BUILDING AYAH + SURAH KNOWLEDGE REFERENCES

You are working in the existing Flutter codebase for **Path of Nūr**.

Task type:
Qur’an reader enrichment using the app’s existing internal content library.

Product goal:
When the user is reading an ayah or viewing a surah, they should be able to discover connected learning references from the app’s existing content ecosystem, such as:
- related Hadith
- signs / creation / worldly lessons
- character / adab lessons
- Seerah / Prophet references
- life lessons
- journeys / learning modules
- surah-level themes and related learning paths

The user should be able to learn from the ayah more deeply without the reader becoming cluttered or noisy.

This is **not** a rebuild of the Qur’an reader.
This is an **enrichment and linking phase** using existing owned content where possible.

**Critical safety rule:**  
Do not go haywire deleting or replacing current reader behavior for no reason.  
Do not break playback, notes, bookmarks, highlights, translations, or current “Learn more” behavior.  
Build on top of the current Qur’an reader safely.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

## EXECUTION RULES

1. **Audit first before editing.**
2. **Reuse the existing content library and reference graph where possible.**
3. **Do not hardcode random links blindly.**
4. **Do not link content just because it shares a vague keyword.**
5. **Prefer semantically correct references over volume.**
6. **Keep the reader calm, premium, and readable.**
7. **Do not overload every ayah with too many chips/cards.**
8. **Keep localization intact.**
9. **Run analyzer and relevant tests at the end.**
10. **Provide a final audit summary with what was linked and what still needs follow-up.**

## IMPLEMENTATION SCOPE

Audit and improve:
- `quran_reader_page.dart`
- `quran_reference_viewer.dart`
- `quran_ayah_enrichment_provider.dart`
- `quran_reference_graph_provider.dart`
- `quran_surah_insights_provider.dart`
- existing “Learn more” / related knowledge models
- existing content libraries for Hadith, world/creation, life/divine life, prophets/seerah, journeys, and Qur’an insights

Desired outcomes:
- strengthen ayah-level references
- strengthen surah-level theme insights
- reuse existing internal content owners
- improve the current “Learn more” experience carefully
- add focused tests for provider behavior and route integrity

## DELIVERABLES

Provide a concise summary with:
1. Audit findings before changes
2. Ayah-level enrichment improvements
3. Surah-level insight improvements
4. UI improvements
5. Files changed
6. Validation
7. Final audit
