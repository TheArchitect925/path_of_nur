# Phase 6 French Localization Backlog

Date: 2026-03-23

## Current blocker

- `app_fr.arb` does not exist in the repo yet.
- This is a full new-locale creation task, not a small parity cleanup pass.
- Current source size:
  - English keys: `9025`
  - French keys: `0`

## Why this was not force-completed in one pass

- A production-ready new locale needs:
  - full key coverage copied from `app_en.arb`
  - placeholder-safe translation
  - metadata preservation
  - generator validation
  - at least a basic terminology and tone QA pass
- Creating `app_fr.arb` honestly is a large translation/build step, not a quick QC patch.

## Safest next step

1. Generate a staged French locale from `app_en.arb` into a temp file first.
2. Translate all user-facing values with placeholder masking and metadata preservation.
3. Validate:
   - full key parity
   - zero placeholder mismatches
   - `flutter gen-l10n`
   - `flutter analyze`
4. Promote the temp file to `app_fr.arb` only after validation.
5. Run a focused French editorial cleanup on high-traffic strings.

## Enhancement options

1. Add a reusable locale-generation script for new languages so future locale creation does not start from scratch.
2. Add automated placeholder-parity and key-parity validation for every locale in CI or a local QA script.
3. Prioritize a high-traffic-screen French editorial pass immediately after structural generation to catch awkward mobile phrasing early.
