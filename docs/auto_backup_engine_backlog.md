# Auto-Backup Engine Backlog

Date: 2026-03-24

Potential next enhancements:

- Add domain-level dirty tracking so the UI can explain *which* progress changed instead of only showing coarse pending reasons.
- Add a lightweight in-memory debounce queue for bursty local writes if real-device profiling shows repeated payload hashing during active sessions.
- Add a signed-in-provider capability card with deeper Apple/Google-specific setup diagnostics beyond the current status/failure labels.
- Add widget coverage for the new auto-backup settings section and retry/failure states on the Accounts, Profile & Sync page.
- Add real-device QA for app lifecycle backup attempts on iOS and Android, especially background/inactive timing and provider unavailability handling.
- Add a bounded retry backoff model that distinguishes transient transport failures from configuration failures.
- Consider a post-import/post-restore “backup recommended” auto-backup trigger after product review, but keep it opt-in and never automatic by default.
- If backup payload metadata becomes richer in a later phase, use per-domain timestamps to avoid recomputing dirty state from the whole payload fingerprint each time.
