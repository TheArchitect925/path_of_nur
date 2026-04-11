# Phase 2 — Dua Hisn al-Muslim Alignment + Release Trust Pass

Align the dua dataset against trusted compiled sources using Hisn al-Muslim as the main practical baseline, while preserving stronger direct source attribution already present in the dataset.

Scope:
- `lib/features/learn/dua/data/dua_seed_data.dart`
- directly related dua model/repository/provider files only if required for trust/verification support

Constraints:
- audit first
- do not invent Arabic wording, transliterations, or source references
- prefer `needs_review` over overstating certainty
- keep variants separate only where they are genuinely distinct canonical forms
- preserve useful taxonomy and orchestration metadata added in earlier phases

Target trust levels:
- `verified_strong`
- `verified_general`
- `needs_review`
- `exclude_from_default_surface`
