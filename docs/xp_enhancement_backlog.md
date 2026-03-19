# XP Enhancement Backlog

Last updated: 2026-03-18

1. Migrate legacy `journeyProgressProvider` XP consumers on Home, Profile, wallpapers, and watch-facing summaries to the new ledger-backed XP summary so the whole app uses one XP truth.
2. Wire Quran reading completion, learning lesson completion, taraweeh, qiyam, congregation prayer, and Jumu‘ah completion from existing feature flows into the new XP hooks where source data is already trustworthy.
3. Add localized level-title coverage for non-English locale ARB files so the new 100-level titles stop falling back to English.
4. Add a daily XP history surface and lightweight analytics helpers for Garden and Journey without turning XP into a gamified grind dashboard.
5. Add safe migration/backfill from legacy journey XP counters into the new ledger if preserving existing user XP becomes a release requirement.
6. Add profile-facing milestone unlock wiring so Garden, wallpapers, and future unlockables read the new XP summary instead of formula-based level math.
7. Add richer XP source attribution UI later, such as “earned from prayer, Qur’an, and learning today,” while keeping the current card minimal.
