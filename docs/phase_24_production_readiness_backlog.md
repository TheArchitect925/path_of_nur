# Phase 24 Production Readiness Backlog

Date: 2026-03-23

## Recommended Next Phases

1. Routing and discoverability hardening
- Remove or reduce overlapping Learn/Qur'an/Growth compatibility paths that still blur ownership.
- Audit surfaced entry points so only production-safe children are reachable from discovery cards.
- Rework failing route tests around visible reflections and kids island navigation so route intent is executable, not just documented.

2. Localization debt payoff for live surfaces
- Replace runtime localization extension shims in Qur'an, Growth, Kids Arabic, and Learning Journey with real ARB-backed keys.
- Remove hardcoded English on live pages such as Salah/Qur'an study hubs and tighten test coverage for localized UI text.
- Review settings/profile and any seeded visible labels that still bypass the main localization system.

3. Learn architecture cleanup
- Clarify ownership between `/learn`, `/quran`, and kids-specific routes.
- Reduce category overstatement where catalog breadth exceeds live content depth.
- Decide which live Learn surfaces are canonical and which should be demoted, aliased, or contained.

4. Notes, reflections, and journal unification
- Define one canonical mental model for personal writing flows.
- Keep distinct content types if needed, but unify discovery, categories, routing, and “continue writing” behavior.
- Add detail/open behavior for journal timeline rows and clean up overlapping notes entries.

5. Test stabilization pass
- Repair high-signal failing tests discovered in this audit:
  - `test/features/learn/salah/wudu_trainer_page_test.dart`
  - `test/features/learn/kids_learning_routing_fix_test.dart`
  - `test/features/learn/learn_placeholder_containment_test.dart`
  - `test/features/journey/growth_home_ia_test.dart`
  - `test/app/quran_route_integrity_test.dart`
- Expand regression coverage for Home shortcuts, notes/reflection entry points, and adult/child-profile route guards.

6. Public-beta content truthfulness pass
- Review broad catalog labels in Learn, Growth, and Kids to ensure surfaced cards reflect real current depth.
- Keep contained/unfinished areas discoverable only where clearly framed.
- Tighten empty states and future-facing copy that currently overpromise.

## Enhancements That Can Wait

- Additional Growth content breadth once route ownership and localization are stable.
- Deeper notes/journal analytics after the core writing model is unified.
- Further visual polish for already-coherent hubs.
- Expanded seasonal or reward content after core regression risk is reduced.
