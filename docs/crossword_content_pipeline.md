# Crossword Content Pipeline

Last updated: 2026-03-21

## Purpose

This document defines the local authoring structure for the Path of Nūr crossword system.

The crossword feature remains offline-first, but the data layer is intentionally shaped so a future remote override or content pack loader can replace or extend the local bundle cleanly.

## Current source of truth

- content bundle metadata:
  - `lib/features/learn/crossword/data/crossword_seed_data.dart`
  - `crosswordContentBundle`
- seeded puzzle definitions:
  - `CrosswordPuzzleSeed`
- layout templates:
  - `CrosswordLayoutTemplate`
- normalized content entries:
  - built in `lib/features/learn/crossword/application/crossword_repository.dart`
  - sourced from existing app datasets such as Qur’an words, hadith, prophets, duas, and kids Arabic

## Required fields

### CrosswordEntry

- `id`
- `mode`
- `category`
- `difficulty`
- `clue`
- `answer`
- `sourceType`
- `tags`

### CrosswordPuzzleSeed

- `id`
- `mode`
- `category`
- `difficulty`
- `gridSize`
- `tags`
- `placements`

### CrosswordLayoutTemplate

- `id`
- `gridSize`
- `mode`
- `difficultyScore`
- `tags`
- `slots`

## Optional metadata used for scale

- `theme`
- `clueType`
- `isDailyEligible`
- `dailyThemes`
- `levelBandMin`
- `levelBandMax`
- `packTags`
- `sourceId`
- `layoutKey`

## Validation expectations

The validation layer in `crossword_validation.dart` currently checks:

- entry answer normalization
- missing clue text
- invalid level bands
- empty templates
- invalid slot lengths
- template overflow
- duplicate answers inside one puzzle
- conflicting puzzle overlaps
- solution-grid mismatches
- missing daily-theme metadata warnings
- pack references to missing puzzles

## Authoring guidelines

- Keep answers normalization-safe:
  - prefer uppercase transliteration-compatible answers
  - avoid punctuation-dependent answers
  - avoid fragile spacing or symbol requirements
- Keep clues calm, short, and meaningfully tied to trusted app knowledge.
- Only mark puzzles or entries as daily-eligible when their tags/theme/category clearly match the weekday rotation system.
- Prefer extending existing categories and pack tags instead of inventing near-duplicates.

## Future-ready extension points

- remote bundle override
- additional pack versions
- imported content packs
- richer template libraries
- author tooling / validation CLI
