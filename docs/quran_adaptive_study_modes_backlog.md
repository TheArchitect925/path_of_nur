# Qur'an Adaptive Study Modes Backlog

## Enhancement options

1. Add explicit study-mode entry links from Surah Insights, Qur'an Topics, and selected Journey lessons so high-intent routes can open directly in `study` or `theme` mode instead of relying mostly on inference.
2. Decide whether the reader should remember the user’s last manually selected mode locally, but only if this stays predictable across Journey and memorization entry flows.
3. Run on-device QA for small screens, large text, and VoiceOver/TalkBack to confirm the new mode card, grouped Learn More layout, and mode menu stay readable and reachable.
4. Consider one lightweight “reflection-first” visual cue for ayah translation blocks if real-world testing shows Reflection mode still feels too close to Reading mode.
5. Decide whether Memorization mode should later hide or collapse some secondary ayah actions during review sessions, but only after confirming current repetition flows still feel too busy.
6. Add stronger explicit `mode=study` or `mode=theme` route handoffs from future Yusuf, Al-Kahf, and thematic study entries if those study flows grow.
7. Evaluate whether Theme mode should eventually prioritize theme-matching related links more explicitly, but keep this curated and avoid broad keyword filtering.

## Notes

- This phase intentionally kept one shared reader architecture.
- The current adaptive layer changes emphasis and ordering, not ownership or feature availability.
