# Packaging And Route Truth Follow-Up Backlog

1. Run a real signed Android release build once production keystore credentials are available and confirm Play/App Bundle packaging succeeds end to end.
2. Audit remaining app-owned alias producers and retire legacy `/growth/*` and `/journey/growth/*` outputs after compatibility usage is no longer needed.
3. Add one small Android release-packaging smoke step to the documented release gate once CI or local secret handling is stable.
4. Review older docs under `docs/` and `.codex_memory/` for any remaining references to the legacy Profile tab or `LearningJourneyHomePage` as the `/learn` root.
