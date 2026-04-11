# Codex Prompt Archive — iPhone Home + Lock Screen Widgets V1.5

Task continuation:

- Extend the in-progress Path of Nūr iPhone widget work from Home Screen widgets into a broader iPhone Home Screen + Lock Screen widget system.

Requested scope:

1. Audit the repo again first.
2. Reuse existing:
   - WidgetKit / widget extension work
   - shared storage bridge
   - app groups
   - deep links
   - prayer state/providers
   - dhikr state/providers
   - streak / XP / light data
   - live activities / lock-screen related work
3. Support both:
   - Home Screen widgets
   - Lock Screen accessory widgets

Requested target widgets:

- Home Screen:
  - Small Next Prayer
  - Medium Daily Prayer Overview
  - Small/Medium Daily Dhikr
  - Small Journey / Light Progress
- Lock Screen:
  - Accessory Inline: compact next-prayer line
  - Accessory Circular: next-prayer circular summary
  - Accessory Rectangular: prayer summary
  - Optional Dhikr accessory summary

Implementation requirements:

- one shared snapshot pipeline for Home + Lock Screen
- explicit Flutter sync methods for next prayer, prayer overview, dhikr, journey, lock-screen widgets, and update-all
- canonical widget deep links
- compact, honest Lock Screen behavior that respects WidgetKit refresh constraints
- document any manual Xcode work instead of pretending it is complete
