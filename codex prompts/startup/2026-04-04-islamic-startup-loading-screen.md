===== PHASE 1 — LOADING / WELCOME BACK SCREEN (ISLAMIC GREETING SYSTEM) =====

PRIMARY OBJECTIVE === BUILDING PATH OF NUR LOADING EXPERIENCE

Build a production-ready loading screen for Path of Nur that appears during app startup / restore and matches the provided reference design closely.

This screen must feel:
- Calm
- Spiritual
- Premium
- Warm (parchment / ivory glass style)
- Simple and not overwhelming

--------------------------------------------------

CRITICAL GUARDRAILS

- FIRST: Audit the repo for any existing splash/loading/startup/restore screens
- DO NOT break:
  - startup flow
  - onboarding routing
  - auth/session restore
  - local storage restore
  - riverpod providers
- DO NOT delete or reset any stored user data
- DO NOT introduce fake loading logic if real state exists
- REUSE:
  - theme system
  - glass / card system
  - typography
  - logo assets
  - localization system (ARB)

--------------------------------------------------

SCREEN STRUCTURE (CENTER CARD LAYOUT)

Create a centered vertical layout inside a premium glass card:

1. TOP TEXT (Arabic, large, elegant)
   الله أكبر

2. APP LOGO
   (use existing asset, centered, optional soft glow/halo if already supported)

3. ISLAMIC GREETING (Arabic, dynamic)
   Based on time of day

4. GREETING TRANSLATION (English, small, subtle)
   Directly under Arabic

5. WELCOME TEXT
   Welcome Back

6. SUBTEXT
   Restoring your progress

7. LOADING ANIMATION
   Minimal, elegant

8. STATUS TEXT (dynamic)
   Example:
   - Preparing your space…
   - Restoring your progress…
   - Syncing your journey…
   - Finalizing…

--------------------------------------------------

TIME-BASED ISLAMIC GREETING SYSTEM

Create a helper function:

Morning (5am–12pm):
Arabic: أسعد الله صباحك
Translation: May Allah bless your morning

Afternoon/Evening (12pm–10pm):
Arabic: أسعد الله مساءك
Translation: May Allah bless your evening

Night (optional enhancement later):
Arabic: طاب مساؤك بذكر الله
Translation: May your evening be filled with remembrance of Allah

RULES:
- Arabic is primary
- Translation is secondary (smaller, softer color)
- Keep both short and readable
- Do NOT use long duas on loading screen

--------------------------------------------------

VISUAL DESIGN (MATCH SCREENSHOT)

BACKGROUND:
- Soft cloudy / sky / parchment tone
- Light, spiritual, not busy

CENTER CARD:
- Rounded rectangle
- Ivory / warm glass effect
- Slight transparency
- Soft gold border
- Subtle shadow
- Optional blur if system already supports glass

TYPOGRAPHY:
- Arabic headline: elegant (Amiri if available)
- Arabic greeting: medium emphasis
- English translation: small, muted
- Welcome Back: premium heading style
- Subtext: softer tone
- Status text: subtle and dynamic

SPACING:
- Balanced vertical rhythm
- No crowding
- Maintain calm breathing space

--------------------------------------------------

LOADING ANIMATION

- Use minimal circular indicator OR custom soft gold spinner
- Keep it small and centered
- No harsh colors
- No aggressive motion

--------------------------------------------------

STATE + STATUS HANDLING

IF real startup states exist:
→ Hook into them

ELSE:
→ Create a lightweight staged system:
- initializing
- restoring
- syncing
- finalizing

Expose a provider for loading status text

--------------------------------------------------

LOCALIZATION (REQUIRED)

Add ARB keys:

loadingHeadlineAllahAkbar
loadingGreetingMorning
loadingGreetingMorningTranslation
loadingGreetingEvening
loadingGreetingEveningTranslation
loadingWelcomeBack
loadingRestoringProgress
loadingStatusPreparing
loadingStatusRestoring
loadingStatusSyncing
loadingStatusFinalizing

--------------------------------------------------

IMPLEMENTATION STEPS

1. Audit existing startup flow
2. Identify loading ownership
3. Create widget:
   NurLoadingScreen / AppLoadingScreen

4. Build greeting helper:
   getIslamicGreeting()

5. Build UI:
   - background layer
   - centered card
   - stacked content

6. Add loading state provider (if missing)

7. Wire screen into startup sequence

8. Ensure smooth transition to home/onboarding

9. Add localization keys

10. Ensure responsiveness across devices

--------------------------------------------------

QA CHECKLIST

- Screen shows immediately on app launch
- No flicker between splash/loading
- Arabic renders correctly
- Greeting changes with time
- Translation displays correctly
- Layout matches reference closely
- Logo loads correctly
- Animation smooth and subtle
- Status updates correctly
- Transition out is seamless
- No regression in onboarding/auth/startup

--------------------------------------------------

DESIGN PRINCIPLES

- Calm over flashy
- Spiritual over decorative
- Simple over complex
- Intentional spacing
- Premium feel

--------------------------------------------------

FINAL CODEX AUDIT (MANDATORY)

At the end, provide:

1. Files created/modified
2. Startup flow ownership
3. How loading state is managed
4. Greeting logic implementation
5. Localization keys added
6. Any risks or follow-ups

DO NOT skip this audit
