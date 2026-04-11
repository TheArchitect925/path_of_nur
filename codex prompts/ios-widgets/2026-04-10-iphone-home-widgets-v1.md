# Codex Prompt Archive — iPhone Home Widgets V1

Continuation note from the interrupted session:

- previous session got interrupted, see where we finished and continue implementing the following: `===== PHASE IOS WIDGETS V1 — PATH OF NUR IPHONE WIDGETS =====`

Primary objective:

- Build production-ready iOS iPhone Home Screen widgets for Path of Nūr that read real app data and display calm, useful snapshots for worship and progress.

Requested scope:

1. Audit first
2. Reuse existing infrastructure where possible:
   - iOS native setup
   - WidgetKit setup
   - App Group configuration references
   - `home_widget`
   - shared storage bridge
   - live activities / ActivityKit
   - deep links
   - prayer summary providers
   - dhikr / streak / XP providers
3. Build widgets in this priority order:
   - Small Next Prayer
   - Medium Daily Prayer Overview
   - Small/Medium Daily Dhikr
   - Small Journey / Light Progress
4. Implement a stable shared snapshot pipeline between Flutter and iOS
5. Add a Flutter-side sync layer with explicit update methods / full widget refresh support
6. Create or extend an iOS WidgetKit extension
7. Reuse canonical deep links:
   - Next Prayer -> prayer page
   - Prayer Overview -> worship/prayer page
   - Dhikr -> dhikr page
   - Journey -> journey/growth page
8. Keep localization practical and staged if full native widget localization is not realistic in V1
9. Document any manual Xcode setup instead of pretending it is complete
10. Validate analyzer/build behavior and give a final audit summary
