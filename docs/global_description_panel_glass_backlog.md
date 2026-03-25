# Global Description Panel Glass Backlog

Date: 2026-03-24

## Follow-up checks

- Run simulator QA on key `AppSurfaceVariant.panel` pages:
  - Learn hub
  - Glossary
  - Hadith landing
  - Settings
  - Worship prayer surfaces
  - Celestial explorer
- Review dark mode readability on panel-heavy pages after the darker blend adjustment.
- If any panel now feels too heavy for a specific surface, prefer a local `surfaceAlphaOverride` on that one page instead of weakening the shared panel variant again.
- Consider adding a dedicated `descriptionPanel` variant later only if product wants this treatment separated from current shared `panel` usage.
