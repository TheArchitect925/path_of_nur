# Path of Nūr Watch Developer Guide

## Why the watch apps are native

The watch companions are intentionally native:
- watchOS uses SwiftUI
- Wear OS uses Kotlin + Jetpack Compose for Wear OS

This keeps the experience fast, platform-correct, and reliable for glanceable wrist use.

## Scope

V1 includes only:
- Today snapshot
- prayer check-in
- dhikr counter
- minimal progress
- local queue + sync bridge scaffold
- notification scaffolding

It deliberately excludes full learning, dense settings, and phone-sized workflows.

## Apple Watch structure

- `PathOfNurWatch/App`: app entry and root tabs
- `Domain`: watch-facing models
- `Data`: local cache and queue persistence
- `Sync`: sync bridge protocol and stub service
- `ViewModels`: Today / Prayers / Dhikr / Progress
- `Views`: reusable components and screens
- `Theme`: calm dark styling tokens

## Wear OS structure

- `wear_os_app/app/src/main/java/com/pathofnur/watch/domain`
- `data`
- `sync`
- `ui/theme`
- `ui/components`
- `ui/screens`

## Shared watch product logic

The phone app remains the source of truth.
The watch keeps:
- today snapshot cache
- prayer states
- dhikr session state
- sync queue items

Offline actions update the watch immediately and queue for later sync.

## Current limitations

- sync to the phone is scaffolded, not yet wired to WatchConnectivity / Data Layer transport
- notifications are scaffolded, not fully scheduled from live phone data
- prayer calculation is expected to come from the phone snapshot, not from a full watch-side engine
- watch targets are separated from the Flutter app to preserve mobile build stability

## Next steps

1. Wire phone-to-watch transport:
   - WatchConnectivity on Apple Watch
   - Data Layer on Wear OS
2. Add notification scheduling and action handlers
3. Add complications / Smart Stack widget and Wear Tile later
4. Replace mock snapshot data with real synced daily snapshot feeds
