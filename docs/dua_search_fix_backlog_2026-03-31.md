# Dua Search Fix Backlog

Date: 2026-03-31

## Follow-up options

1. Add a focused widget test for the Dua hub that types into the search field and verifies the visible list filters immediately.
2. Review other pages that reuse `LearnDiscoverySearchField` and still depend on `onChanged`-only rebuilds, then normalize them to controller-driven query state where needed.
