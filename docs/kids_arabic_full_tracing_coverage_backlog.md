# Kids Arabic Full Tracing Coverage Backlog

Date: 2026-03-24
Primary task: Phase 34 full Kids tracing coverage expansion

## Enhancement options

1. Add widget-level tracing-pad coverage for one dot-family letter, one loop/curve-heavy letter, and one multi-stroke letter so future tracing-path edits cannot silently regress the expanded full-alphabet coverage.
2. Run an on-device tracing QA sweep for small phones and tablets to confirm gesture responsiveness, ghost preview timing, and visual stroke width remain consistent across the newly expanded letters.
3. Consider one tiny internal tracing-debug helper for sampled-path density and completion-threshold visualization, but keep it developer-only and out of the shipped Kids UI.
4. If future family QA finds certain late-alphabet letters too hard, tune only their `minimumEffortPoints`, completion thresholds, or dot-stroke thresholds rather than branching into a stricter scoring model.
5. Decide whether word tracing should later reuse more of the same guide-backed vector strategy now that the full letter alphabet is covered consistently.

## Notes

- This pass intentionally kept fallback guides intact even though full alphabet vector coverage is now available.
- No reward, routing, or progress behavior was changed.
