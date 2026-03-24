# Arabic Alphabet Foundation Phase 30 Backlog

## Highest-value follow-ups

1. Refactor the adult Qur'anic Arabic audio manifest to derive from the shared alphabet catalog instead of keeping a parallel static mapping.
2. Audit any remaining Arabic-learning route or progress helpers for hardcoded adult seed ids and replace them with the shared compatibility helpers where safe.
3. Add shared joined-form or positional-shape metadata only if the next Arabic phase needs it for real lessons, tracing, or pronunciation support.
4. Add a focused widget/integration pass that opens both Kids Arabic and Adult Qur'anic Arabic entry points and verifies full alphabet rendering from the shared source.
5. Review whether Kids-only reward metadata should remain hardcoded defaults or move into a small shared progression policy layer if another Arabic mode is added later.

## Enhancement options

1. Add a shared searchable metadata layer for Arabic letters if the product later needs glossary/search integration across Kids and Adult Arabic.
2. Add canonical pronunciation notes for tricky pairs such as `ha` vs `ha2`, `taa` vs `ta`, and `zaa` vs `zay` once the adult explanation layer is expanded.
3. Add a shared “availability matrix” helper so future Arabic modules can distinguish full catalog coverage from tracing/audio/quiz coverage without scattering booleans across screens.
4. Introduce a shared Arabic-learning analytics/event naming helper so Kids and Adult flows can log the same letter ids consistently.
5. Expand tracing coverage beyond the current 17 Kids vector letters once product chooses whether full-alphabet tracing is a release goal or a staged rollout.
