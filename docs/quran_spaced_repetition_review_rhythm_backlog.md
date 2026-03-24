# Qur'an Spaced Repetition + Review Rhythm Backlog

## Enhancement options

1. Decide whether the review rhythm should later show a calmer explanation label such as “Suggested for today” instead of date-heavy wording on every card.
2. Consider one lightweight familiarity control if user testing shows “Reviewed well / Needs repetition” is not enough to tune revisit timing.
3. Decide whether the Qur'an hub should surface a tiny “Review today” cue when there are due memorization items, but only if it stays calm and non-intrusive.
4. Evaluate whether memorization review should eventually support grouped surah sets in addition to ayah-first review, without turning the flow into a full trainer.
5. Add on-device QA for review-card density, large text, and screen reader order so the new grouped sections remain easy to scan.
6. Consider one optional review sort/filter control only if real memorization lists become long enough that the current sectioning is no longer sufficient.
7. If product later wants slightly smarter rhythm tuning, add one bounded familiarity signal derived from the existing “Reviewed well / Needs repetition” actions instead of introducing a full spaced-repetition engine.

## Notes

- This phase intentionally extends the existing memorization progress model rather than introducing a separate scheduler.
- The current rhythm is explainable and local: added date, last reviewed, review count, next review, and last review outcome.
