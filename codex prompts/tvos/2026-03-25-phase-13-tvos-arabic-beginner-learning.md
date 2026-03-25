16. Phase 13 — Arabic letters and beginner learning on TV

Build the phase using our standard rules and tvOS rules:

1. tvOS is not a blind port.
Copy as much as possible from iOS, but redesign interaction whenever touch-first UX does not make sense on remote/TV.

2. Reuse shared logic first.
Prefer shared models, content registries, theme tokens, localization keys, and playback/domain logic before creating tvOS-specific duplicates.

3. Build a parity map.
For every iOS feature, classify it as:
- direct tvOS reuse
- tvOS adaptation
- tvOS later phase
- iOS only

4. Never break iOS to build tvOS.
Any refactor for shared usage must preserve existing mobile behavior.

5. Add future-release scaffolding early.
Feature flags, shared registries, section manifests, and compatibility checks should be built near the start, not at the end.

6. Optimize for family-room usage.
Large visuals, calm layouts, readable text, simple controls, resume flow, and audio-first experiences should dominate.

7. Keep writing/input minimal.
Anything requiring heavy typing or repeated manual entry should be reduced, rethought, or delegated to iPhone later.

8. Build production-ready, not placeholder-ready.
Every phase should leave behind stable foundations, not fake demo screens.
