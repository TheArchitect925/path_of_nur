# Qur'an Reader Ayah Explanation Backlog

Last updated: 2026-04-01

1. Expand curated ayah-by-ayah explanation coverage from the current starter set to the remaining short-surah cluster and the rest of Juz 'Amma using the same shared repository and fallback rules.
2. Add reviewed non-English localized explanation content for the seeded ayahs so explanation bodies no longer rely on English-only seed text outside the shared UI labels.
3. Add a lightweight explanation search/index surface inside existing Qur'an knowledge search so curated explanation coverage becomes discoverable without creating a second reader flow.
4. Introduce scholar/source metadata badges with a more explicit attribution presentation once the curated dataset has stronger per-entry review notes.
5. Add focused widget tests for reader explanation visibility, fallback selection, and kids explanation toggling so future reader refactors cannot silently drop the explanation layer.
6. Consider a per-surah "available explanations" progress signal so users know which ayahs in a long surah currently have curated explanation coverage.
7. Split the growing seed corpus into rollout-pack files or surah-range files so future content review can stay precise without making one large seed file harder to audit.
8. Expand the next safest curated packs with Surah Ash-Shams, Surah Al-Layl, and a small beginner-core ayah set like 2:285-286 and 49:13, but only through the same audit-first editorial pipeline.
9. Add a small internal coverage report command or debug view that highlights which seeded ayahs still lack `deepExplanation` or `kidsReviewed` status.
10. Add curated multilingual ayah-action content for the highest-traffic recommendation ayahs so the new action layer can localize beyond UI labels without relying on English fallback text.
11. Add a lightweight editorial override pack for action recommendations so more ayahs can get hand-reviewed "Live this ayah" steps instead of repository-generated fallback actions.
12. Use trusted user signals already present in Path of Nur, such as recent reading, prayer consistency, and dhikr usage, to improve daily ayah-action ranking without making the recommendations feel invasive.
13. Add focused widget and provider tests for once-per-ayah-per-day completion, Ocean Drop awarding, and kids-reader simplified action rendering so future refactors cannot introduce reward abuse.
14. Add an internal coverage/debug summary for action recommendations showing which curated explanation ayahs already have reviewed actions, kids-safe actions, and localized action text.
15. Add widget and provider tests for the new Qur'an personalization engine, especially cooldown behavior, dismiss-for-today state, kids-safe recommendation reasons, and stable scoring when multiple signals overlap.
16. Expand the personalization engine with more hand-reviewed tag coverage and editorial journey-to-ayah mappings so path suggestions rely less on generic path-reference matching.
17. Add curated non-English localized action and personalization copy for the highest-traffic ayahs so the new recommendation cards can move beyond English content fallback.
18. Decide whether the new personalization engine should later surface a tiny “show me something simpler” control on Home or Qur'an hub, but only if it can stay deterministic and avoid becoming a complex settings surface.
19. Add focused widget and provider tests for the spiritual moments engine, especially post-prayer detection, Friday and Ramadan context switching, and surface-specific cooldown behavior.
20. Expand the curated moment-to-ayah mappings with more hand-reviewed morning, after-prayer, gratitude, repentance, and sleep-reflection selections so the time-aware engine relies less on tag inference.
21. If reminder infrastructure remains stable, add an opt-in reminder layer for spiritual moments using the new internal hook ids for morning ayah, post-prayer ayah, Friday reflection, and sleep reflection without adding noisy scheduling complexity.
22. Add a small internal debug summary for spiritual moments showing the active moment type, selected ayah, matched tags, cooldown penalties, and whether Friday/Ramadan overrides were applied.
23. Run a second selective deep-coverage pass for high-value long-surah anchors such as `3:190-194`, `18:10-16`, `39:53`, `57:20`, and `59:18-24`, but keep it curated and tied to study/reflection use-cases rather than blanket length expansion.
24. Add a lightweight internal deep-coverage report showing which explanation entries now have `deepExplanation` and which high-priority study passages remain intentionally partial.
25. If the curated corpus keeps growing, split the explanation seeds into topical or surah-range files so deep-study passages from Al-Baqarah, Aal `Imran`, and story-heavy surahs can be reviewed in smaller editorial batches.
