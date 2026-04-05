# Noor Glass Next Salah Card Recipe

Date: 2026-04-03

Primary source:
- `/Users/shahabmansoor/Developer/path_of_nur/lib/features/home/presentation/home_page.dart`

## Card Identity

The Home `Next Salah` card is the reference `Noor Glass` hero utility card.

It is built as a warm layered Noor surface with:
- a liquid-glass outer shell
- a softly gilded inner content shell
- a denser inner prayer/time panel
- a layered tracker section
- smaller layered mini stat cards

This is not a sacred Dense Sanctuary surface.
It is a premium warm utility card.

## Layer Stack

### Layer 1: Outer Base Shell

Widget:
- `NoorLiquidGlassContainer`

Spec:
- preset: `card`
- mode: `NoorLiquidGlassMode.liquid`
- padding: `EdgeInsets.all(2)`
- fallback treatment: `AppSurfaceTreatment.standard`
- tint color: `Color(0xFFE6C98F)`
- surface alpha override: `0.18`
- include shadow: `true`
- border radius: `32`
- border width: `1`

Purpose:
- premium floating shell
- soft warm gold glass
- subtle outer lift

### Layer 2: Content Shell Inside Outer Base

Widget:
- `Container`

Decoration:
- border radius: `28`
- border color: `Colors.white` at `0.22`
- vertical gradient:
  - top: `Colors.white` at `0.12`
  - middle: `Colors.transparent`
  - bottom: `Color(0xFFE8C98F)` at `0.08`
- gradient stops: `[0.0, 0.24, 1.0]`

Purpose:
- gives the shell a soft top sheen
- warms the lower body slightly
- keeps the interior from feeling flat

### Layer 3: Location Pill

Resolved with:
- `AppSurfaceTheme.resolve`
- variant: `AppSurfaceVariant.pill`
- tint color: `Color(0xFFE2BC72)`
- surface alpha override: `0.58`

Text/icon colors:
- icon: `Color(0xFF7A5A33)`
- text: `Color(0xFF4D4036)`
- underline color: `Color(0xFF7A5A33)`

Purpose:
- compact warm header chip
- more solid than glassy

### Layer 4: Main Prayer / Time Panel

Resolved with:
- `AppSurfaceTheme.resolve`
- variant: `AppSurfaceVariant.panel`
- tint color: `Color(0xFFE4BE74)`
- surface alpha override: `0.66`

Shape:
- radius: `22`

Purpose:
- this is the densest main panel
- more solid and readable than the outer shell
- this is the closest visual anchor for “make the inner part look denser”

### Layer 5: Prayer / Time Icon Tile

Resolved with:
- `AppSurfaceTheme.resolve`
- variant: `AppSurfaceVariant.panel`
- tint color: `Color(0xFFE5C583)`
- surface alpha override: `0.18`

Shape:
- radius: `16`
- includes shadow

Colors:
- icon: `Color(0xFF6E9A73)`

Purpose:
- soft accent tile inside the main panel

### Layer 6: Meta Chips Under Main Panel

Widget:
- `NoorGlassCard`

Config:
- surface variant: `AppSurfaceVariant.pill`
- mode: `NoorLiquidGlassMode.fake`
- surface alpha override: `0.16`
- border radius: `14`
- include shadow: `false`

Default text/icon color:
- `Color(0xFF6E5D4C)`

Warning variation:
- `Color(0xFF9A6D16)`

Danger variation:
- `Color(0xFFD01919)`

Purpose:
- quiet support chips
- denser Noor pill treatment, not bright glass

### Layer 7: Tracker Base

Mode in final Home Noor card:
- `matchHeroPanel: true`
- `clearInnerBase: true`
- `layerMiniStats: true`

This means the tracker base is not using the older plain panel.
It uses a local matched shell:
- padding: `5`
- radius: `26`
- gradient:
  - `Color(0xFFFFF4DE)` at `0.42`
  - `Color(0xFFE5C88F)` at `0.16`
- border:
  - `Color(0xFFFFF2CD)` at `0.64`
- shadow:
  - `Color(0xFF8B6831)` at `0.08`
  - blur radius: `12`
  - spread radius: `-6`
  - offset: `(0, 5)`

Purpose:
- intermediate matched shell
- ties the tracker area to the main prayer panel above it

### Layer 8: Mini Tracker Cards

Widget:
- `NoorLiquidGlassContainer`

Spec:
- preset: `panel`
- mode: `NoorLiquidGlassMode.fake`
- padding: `EdgeInsets.all(3)`
- fallback treatment: `AppSurfaceTreatment.standard`
- surface alpha override: `0.14`
- include shadow: `false`
- border radius: `18`
- border width: `1`

Inner card body:
- resolved via `AppSurfaceTheme.resolve`
- variant: `AppSurfaceVariant.panel`
- tint color varies by card

Mini tracker tint colors:
- Salah: `Color(0xFF9F7A42)`
- Dhikr: `Color(0xFF8F7547)`
- Streak: `Color(0xFFB56D43)`

Shared text colors:
- primary value: `Color(0xFF2F2923)`
- subtitle: `Color(0xFF6E5D4C)`

Purpose:
- small nested layered panels
- more restrained than the main shell
- nested fake mode avoids scroll/compositing artifacts

## Typography

Main prayer name:
- font size: `31`
- weight: `700`
- color: `Color(0xFF202228)`
- family: `serif`

Arabic line:
- font size: `16.5`
- color: `Color(0xFF4D4036)`
- family: `serif`

Offer-by time:
- font size: `25`
- weight: `700`
- color: `Color(0xFF202228)`
- family: `serif`

Offer-by label:
- font size: `12.5`
- color: `Color(0xFF6E5D4C)`

## Design Summary

If you want another surface to “look like the Next Salah card,” the short description is:

`Warm Noor hero utility card with a liquid-glass outer shell, a softly gilded inner shell, a dense warm main panel, and restrained nested fake-glass mini panels.`

## Safe Reuse Rules

Use this recipe for:
- high-priority utility hero cards
- dashboard summary cards
- prayer or progress overview cards
- premium non-sacred action surfaces

Do not use this exact recipe for:
- sacred Qur'an quote/reference blocks
- dense list items
- tiny chips that should stay simpler

