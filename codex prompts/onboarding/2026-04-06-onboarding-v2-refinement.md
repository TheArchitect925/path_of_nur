Update the existing onboarding carousel in the Path of Nūr Flutter app.

This is a content-and-flow refinement inside the existing onboarding shell. Do not rebuild the architecture. Preserve:
- current route
- current PageView shell
- current persistence model
- current finish-side-effect wiring
- current localization approach

PRIMARY OBJECTIVE
Refine onboarding so it better explains the purpose of Path of Nūr, reduces friction, and improves page order and messaging.

IMPLEMENTATION GOALS
1. Update the first onboarding page into a mission-forward intro while preserving a calm Islamic tone.
2. Reduce friction by removing non-essential setup pages from the core first-run flow.
3. Improve page order and page messaging without changing the shell architecture.
4. Keep localization intact and add any new onboarding keys needed.
5. Fix any page-index validation mismatch uncovered during this update.

REQUIRED CHANGES

A. First page rewrite
Replace the current devotional-only opening page with a stronger mission intro.

Use this content direction:

Title:
A Journey Rooted in Knowledge

Body:
The Messenger of Allah ﷺ said:
“Seeking knowledge is obligatory upon every Muslim.” — Sunan Ibn Mājah

In Islam, knowledge is not a luxury. It is a responsibility. And what is obligatory should be within reach for everyone.

Path of Nūr was created with that belief at its core — to help keep learning, remembrance, and growth free and accessible for all.

Whether the user is beginning, returning, or trying to stay consistent, the app should feel like a calm companion for worship, reflection, and daily progress.

Add a short support line:
This short setup will personalize your experience.

Optional smaller footer:
Available across iPhone, iPad, Apple Watch, Mac, Apple TV, Windows, and Android.

Keep the page visually reverent and aligned with the existing design language.
If the existing devotional Arabic elements can still be preserved tastefully as secondary/supporting content, do that. But the page must now explain the app’s purpose.

B. Flow simplification
Remove these from the core onboarding flow:
- Family intro page
- Dhikr feedback page

These should not block first-run onboarding.
If safe and easy, move them to later settings/discovery ownership instead of deleting useful code outright.

C. Recommended page order
Update the onboarding order to:

1. Opening / mission intro
2. Language
3. Islam experience
4. Age range
5. Learning age group
6. Salah consistency
7. Growth interests
8. Arabic reading preferences
9. Prayer calculation method
10. Madhab
11. Tracking
12. Reminders
13. Identity
14. Final welcome

D. Messaging polish
Tighten subtitles and helper copy across the remaining pages:
- reduce overlap between age range and learning age group
- make reminders feel lighter and less operational
- make tracking feel like focus selection, not surveillance
- keep tone calm, premium, welcoming, and non-judgmental

E. Final welcome page
Strengthen the closing page copy.
Keep the existing personalization behavior where possible.
Refine it so it feels more inspiring and gentle.

Target direction:
- personal greeting
- your chosen focus areas
- Qur’anic dua:
  رَبِّ زِدْنِي عِلْمًا
- meaning:
  My Lord, increase me in knowledge.
- closing line about small consistent steps and meaningful progress

F. Localization
- Add/update onboarding ARB keys for any new copy
- preserve current localization mechanism
- do not leave new user-facing English strings hardcoded unless they are intentionally canonical Arabic text
- keep translation-ready structure clean

G. Validation / bug fix
- audit the existing _next() logic and fix the page index validation mismatch for Growth Interests
- ensure progress count matches the new onboarding page total
- ensure settings hint visibility logic still maps correctly after page removal/reordering
- ensure continue/back behavior still works cleanly
- ensure final page finish action still persists onboarding state correctly

H. Cleanup
- remove obsolete page-render branches or dead onboarding code related to the removed pages if no longer needed
- keep changes clean, production-ready, and minimal in scope

DELIVERABLES
After implementation, provide:
1. files changed
2. pages removed from core onboarding
3. new final onboarding order
4. localization keys added/updated
5. validation bug fixed
6. any follow-up recommendations

Do not redesign the global UI.
Do not change the onboarding architecture unless required for correctness.
Make the refinement feel like a polished V2 of the existing onboarding, not a different product.
