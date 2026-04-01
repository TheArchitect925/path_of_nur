# Learning Hub Copy Cleanup Backlog

Date: 2026-03-31
Scope: follow-up enhancements after the visible `/learn` naming cleanup

## Recommended Next Steps

### 1. Explore All Copy Cleanup

- Risk: Low
- Goal: make `/learn/explore` feel like the clear secondary owner for tools, notes, FAQ, and browse-heavy discovery
- Dependencies: landing copy cleanup complete
- Do not break: search, filters, route aliases, category wheel

### 2. Games Subpage Language Unification

- Risk: Medium
- Goal: make the Games island, quiz hub, trivia surfaces, and challenge pages use one coherent user-facing vocabulary
- Dependencies: landing copy cleanup complete
- Do not break: existing game routes, analytics hooks, kids game routes

### 3. Kids Adult-vs-Child Messaging Pass

- Risk: Medium
- Goal: align adult-mode Kids discovery copy with child-profile island wording
- Dependencies: landing copy cleanup complete
- Do not break: kids route family, child profile mode, parent-facing discoverability

### 4. Cross-Link Stale Language Audit

- Risk: Low
- Goal: audit Home shortcuts and Learn cross-links for stale words like `journey home`, `legacy`, `hub`, and `browse all knowledge`
- Dependencies: landing copy cleanup complete
- Do not break: named navigation and deep links

### 5. Translation Follow-Through

- Risk: Low
- Goal: replace English fallback values for the new landing-specific keys in priority locales
- Dependencies: localization keys merged
- Do not break: existing locale loading or generated localization outputs

## Do-Not-Break Notes

- keep `/quran/*` as canonical Qur'an ownership
- keep kids routes fully reachable
- keep search/index identifiers stable
- keep old routes/aliases alive unless a later migration pass explicitly retires them
