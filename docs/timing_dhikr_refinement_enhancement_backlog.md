# Timing And Dhikr Refinement Backlog

1. Add a targeted integration test around prayer countdown zero-crossing once the ActivityKit bridge is covered by automated tests.
2. Consider extracting the prayer timing boundary scheduler into a shared countdown coordinator if additional live surfaces start depending on exact rollover behavior.
3. Add a small settings toggle for dhikr reflective reminders only if device QA shows users want control over the prompt frequency.
4. Tune the anti-rush threshold from real usage telemetry or structured QA feedback before broad rollout.

5. Consider letting the anti-rush reminder reuse the active dhikr phrase transliteration/translation in a future pass so each reminder can be more context-aware without changing the core verse prompt.
