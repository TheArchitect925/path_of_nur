# Qur'an Learning Progression Backlog

Last updated: 2026-03-22

## Enhancement options

- Add widget coverage for:
  - Ayah Insights `Mark studied` actions
  - path-step completion buttons and completed path state
  - Daily Ayah completion + completion-state rendering together
- Decide whether completed Ayah Insights entries should surface as a dedicated section inside Saved Reflections or continue to stay separate.
- Add a calm completion-history surface for Qur'an learning if the current continue-learning/personalization cards start needing more context.
- Consider lightweight Garden/Journey summary surfacing for Qur'an learning milestones only after the current reward cadence is validated in use.
- If needed later, add a tiny non-noisy completion toast/banner that reuses an existing calm reward-feedback pattern instead of inventing a new gamification surface.

## Guardrails

- Do not reward raw reader opens, generic taps, or repeated path-step button presses.
- Keep Daily Ayah, insight completion, and path completion deduped through shared source refs and persisted completion state.
- Do not turn Qur'an learning progression into badge spam or a separate streak engine.
