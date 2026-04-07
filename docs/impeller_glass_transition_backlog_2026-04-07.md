# Impeller Glass Transition Follow-up

- Audit the remaining `FadeTransition`, `AnimatedOpacity`, and `AnimatedSwitcher` usages around glass-backed surfaces and convert any shared offenders to size/slide motion.
- If Impeller warnings persist after this fix, capture which screen is visible when they appear so the remaining opacity wrapper can be isolated faster.
- Consider a shared `GlassSafeCollapse` helper for future collapsible glass sections to avoid reintroducing opacity-based transitions.
