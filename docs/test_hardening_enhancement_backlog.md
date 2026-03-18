# Test hardening enhancement backlog

Non-blocking follow-up items after the focused release-hardening test pass:

1. Add a dedicated startup-route guard harness once home-shell provider side effects are isolated enough to test shared-device router redirects directly.
2. Add one focused test around `app_navigation_bridge` on iOS-only deep-link intake if that bridge becomes more critical.
3. Add a small audio bootstrap contract test for live activity / background playback boundaries if the platform layer gets a test seam.
4. Add one smoke test for reminder scheduler behavior during sister-cycle auto-adjust mode.
5. Add one fast localization smoke around `onGenerateTitle` and router error page copy.
