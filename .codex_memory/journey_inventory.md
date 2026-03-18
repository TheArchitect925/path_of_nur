# Journey Inventory

Last updated: 2026-03-17

## Two different journey systems exist

### Growth / app journey

- main route: `/journey`
- page chain:
  - `JourneyPage`
  - `GrowthHomePage`
- additional routes:
  - growth today/reflection/journey/habits
  - path detail
  - habit detail
  - ocean drops
  - wallpaper library

### Learning Journey

- main route: `/learn`
- home page: `LearningJourneyHomePage`
- supporting routes:
  - island page
  - journey detail
  - stage page
  - browse all
  - family learning management

## Learning Journey state of implementation

- registry-backed stages counted in code:
  - `real`: 139
  - `partial`: 1
  - `placeholder`: 0 explicit stage enum entries at the moment
- however the journey system is still operationally mixed because:
  - some journey chains still describe themselves as placeholder-backed in mapping notes
  - legacy Learn tools are still linked from several journeys
  - not all route targets are equally deep or final

## What is real now

- journey home, detail, stage, and browse pages
- localized metadata layer
- lesson page and placeholder lesson page patterns
- progress persistence and streak tracking
- recommendation/today-light logic
- family learning and learn-together overlays
- many actual lesson-backed stages already exist

## What remains partial or transitional

- the registry still references legacy Learn tools in multiple journeys
- some mapping notes explicitly say meaning/fiqh/timeline/tajweed style journeys are not yet true final curricula
- some guidance still points toward future detail surfaces rather than final owned destinations

## What has already been removed

- `journey_legacy_page.dart`
- `journey_widgets.dart`
- placeholder concepts noted as removed in backlog:
  - `journey-rings`
  - `journey-streak`
  - `journey-milestones`
  - `journey-unlocks`

## What should be prioritized next

- replace the most visible residual placeholder-backed learning paths with real destination depth
- continue removing legacy Learn dependence from journey related tools
- add tests for:
  - home stage counts
  - continue journey
  - progress reload when registry IDs change
- settle final `/learn` ownership direction so the journey system stops competing with the legacy hub

## What should explicitly not come back

- a separate `journey_legacy_page`
- generic journey placeholder detail pages for rings/streaks/milestones/unlocks without real product ownership
- broad generic “legacy learning material” as a permanent top-level concept
- dead-end category taps that only land on generic placeholders
