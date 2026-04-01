# Daily Dhikr Path Hardening Backlog

Date: 2026-03-31

## Enhancement Options

### High Impact / Low Risk

1. Add a compact post-completion card on the Daily Dhikr path detail page that surfaces the dhikr tool and the next recommended path without needing to reopen the handoff page.
2. Add stronger “already started” emphasis on the Character and Salah next-step cards if the learner has progress there.
3. Let personalization recognize completion of the Daily Dhikr path as a stronger signal for Character or Salah follow-up suggestions.

### Medium Impact / Low Risk

1. Create a second light Dhikr follow-up path built from `dhikr-after-salah`, `dhikr-istighfar`, and `dhikr-salawat` once the starter lane has been validated.
2. Add one calmer in-tool entry hint that reminds users to begin with a small count and presence rather than chasing numbers.
3. Consider one optional Stories or Daily Wisdom cross-link if product testing shows some learners respond better to reflective follow-up than practice follow-up.

### Medium Impact / Medium Risk

1. Audit whether the `daily-dhikr` journey lessons should expose the counter action later or more selectively for beginners.
2. Add more explicit multilingual review for the dhikr lesson bodies if beginner terminology still feels heavy in non-English QA.

## Do Not Break

- keep `daily-dhikr-starter` path id stable
- keep existing Daily Dhikr step ids stable unless a real migration plan is added
- preserve the core dhikr counter route and reward hooks
- avoid turning the starter path back into a utilities-first flow
- keep guided paths as orchestration rather than duplicating dhikr ownership

## Recommended Next Pass

If continuing curriculum hardening in order, the safest next pass is:

1. Qur’an Beginner bridge hardening
2. Kids Starter Path progression hardening
3. Stories starter-path hardening
