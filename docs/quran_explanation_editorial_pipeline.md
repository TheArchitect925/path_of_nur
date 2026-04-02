# Qur'an Explanation Editorial Pipeline

Last updated: 2026-04-01

## Purpose

This repo keeps Qur'an explanation content local-first and code-reviewed. The goal is safe, disciplined expansion, not ad hoc content growth.

## Source rules

- Ground every entry in mainstream Sunni tafsir methodology.
- Use Qur'an cross-reference and widely accepted classical tafsir meaning first.
- Do not copy tafsir text directly.
- Do not invent speculative or weakly grounded interpretations.
- If an ayah has interpretive breadth or dispute, write the safest broadly accepted meaning.

## Writing rules

- `simpleSummary`: 1-2 sentences, beginner-safe, plain meaning.
- `standardExplanation`: clear meaning plus one practical takeaway.
- `deepExplanation`: only when a deeper layer can stay clearly grounded.
- `kidsExplanation`: warm, simple, one core idea, no academic tone.
- `keyLessons`: short phrases, not mini paragraphs.
- `reflectionPrompt`: calm and practical, never speculative.

## Where to add content

- Seed data currently lives in:
  - `lib/features/learn/quran/data/seeded_quran_ayah_explanations.dart`
- Use the helper shape in:
  - `lib/features/learn/quran/data/quran_ayah_explanation_entry_builder.dart`

## Rollout packs

- `foundations`
- `commonSalahSurahs`
- `beginnerCoreAyahs`
- `kidsStarter`
- `reflectionComfort`

Pick the pack that best matches the user-facing reason for coverage, not just the surah number.

## Review metadata

- `draft`: added but not trusted for release expansion
- `reviewed`: acceptable for current rollout
- `verified`: strongest current editorial confidence
- `kidsReviewed`: kids wording has been specifically checked
- `needsExpansion`: valid starter content, but still missing desired depth

## Avoid duplicates

- Check the ayah key before adding: `surahNumber:ayahNumber`
- Run:

```bash
dart run tool/quran_explanation_audit.dart
```

## Required checks before merging new entries

1. No duplicate ayah entries
2. No empty `simpleSummary`
3. No empty `standardExplanation`
4. No empty `kidsExplanation` for seeded rollout content
5. Source refs present
6. Rollout pack chosen
7. Review status chosen

## Future multilingual guidance

- UI labels belong in `lib/l10n/*.arb`
- Explanation body text belongs in explanation entry localized content fields
- Do not mix UI-copy localization and editorial content localization into one layer
