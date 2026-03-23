# Phase 7 Indonesian Localization Backlog

Date: 2026-03-23

## Current blocker

- `app_id.arb` is not in the same state as the Urdu, Arabic, and German files.
- Current parity audit:
  - English keys: `9025`
  - Indonesian keys: `3497`
  - Missing keys: `5531`
  - Extra keys: `3`
  - Placeholder mismatches in the current file: `546`
- This is not a small QC patch. It is a large-scale locale build-out.

## Why this was not force-completed in one pass

- A safe production-ready Indonesian pass needs a staged translation workflow with placeholder protection and QA.
- The current repo Indonesian file is too incomplete to honestly claim “done” after a quick patch.
- A long-running bulk machine-translation attempt is possible, but it should be done in a controlled batch workflow with checkpoints instead of silently replacing the file in one unsafe shot.

## Safest next step

1. Run a staged Indonesian merge script that:
   - copies metadata from `app_en.arb`
   - preserves structurally valid existing Indonesian strings
   - fills missing keys in controlled batches with placeholder masking
   - writes to a temp file first
2. Validate:
   - full key parity
   - zero placeholder mismatches
   - `flutter gen-l10n`
   - `flutter analyze`
3. Do a focused editorial cleanup on high-traffic strings after structural completion.

## Enhancement options

1. Add a reusable localization QA script for key parity and placeholder parity across all locales.
2. Add a staged bulk-translation command that writes to `*.generated.arb` first so incomplete locale runs never overwrite the canonical file.
3. Prioritize Indonesian high-traffic screens first if full-locale completion is split across multiple passes.
