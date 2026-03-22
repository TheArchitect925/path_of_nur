# Ayah Completion Phase 9

Date: 2026-03-21

## Prompt Summary

Build a reusable, scalable, offline-first Ayah Completion / Fill-in-the-Blanks game using the Knowledge Games Engine.

Key constraints:

- use only verified Qur'an data already present in the app
- preserve exact Arabic text and ayah boundaries
- support kids, adult, and daily modes
- integrate with XP, Levels, Streaks, Ocean Drops, and persistence
- keep the same app build, feel, localization, and shared architecture
- make structured Qur'anic references tappable into the shared Qur'an reader

## Delivery Notes

- seed data stores canonical Qur'an references plus blank indices, not handwritten verse text
- repository hydrates Arabic and translation from the shared Qur'an repository at runtime
- UI uses shared Knowledge Games shell, shared rewards, shared progress patterns, and shared Qur'an navigation/audio helpers
