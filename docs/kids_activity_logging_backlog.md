# Kids Activity Logging Backlog

- Add a compact integration test that completes a story, a dua, an Arabic lesson, and a Seerah node, then verifies the canonical learner activity feed ordering.
- Expand canonical logging to optional non-completion “resume” signals for quiz, memory, and dua story flows if parent continuation needs become richer.
- Decide whether Kids Dua story views/completions should join the canonical cross-feature feed or remain feature-local until their parent surfaces expand.
- Add a lightweight activity-domain filter UI only if a parent-facing review surface later needs it; keep the current dashboard calm for now.
- Consider replacing more derived last-active calculations in broader kids summaries with canonical activity queries once enough legacy history has accumulated.
- Unify fallback learner ID behavior across bedtime, dua, Arabic, progression, and the new activity log so single-learner households never fragment state.
