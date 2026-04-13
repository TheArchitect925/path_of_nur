# Learning Hub Header Icon Enhancement Backlog

Date: 2026-04-12
Area: Learn / shared header chrome

## Completed in this pass

- Added a shared `headerIconSize` override path through `AppPageScaffold`, `SectionHubScaffold`, and `LearnHubPageScaffold`.
- Updated the Learning Hub test surface to size its header icon at `120%` of the active `titleLarge` text size for a slightly stronger visual anchor.
- Added shared header alignment and icon-spacing controls, then applied a centered icon/text alignment plus a slightly tighter icon gap on the Learning Hub test surface.
- Left Home unchanged.

## Enhancement options for next steps

- Evaluate `30` as a second test size if `28` still feels too close to the current scale.
- Review whether the larger icon should also get slightly tighter vertical alignment with the title block before rolling out globally.
- If the Learn result feels right, promote `28` as the shared default for scaffolded section headers while keeping an override for exceptions such as Home or dense utility pages.
- If different surfaces need different emphasis, define a small shared header size scale such as `standard`, `prominent`, and `compact` instead of hardcoded per-page numbers.

## Design options to make the header and icon nicer

- Keep the current layout, but tune proportions more deliberately:
  - slightly bolder title weight
  - icon at `110%` to `120%` of title size
  - slightly tighter gap between icon and title block

- Improve vertical alignment:
  - center the icon against the combined title/subtitle block for a calmer look
  - or align the icon to the title baseline so the top line feels sharper and more editorial

- Add a soft icon container:
  - place the icon inside a subtle tinted circle or rounded square
  - keep the container very light so it feels premium, not button-like
  - this works especially well on section landing pages

- Give the title more hierarchy:
  - use a stronger `titleLarge` style with a calmer subtitle
  - slightly reduce subtitle prominence so the icon and title become the clear first read

- Introduce section-specific accent color very lightly:
  - keep the text color the same
  - let only the icon or icon container pick up a soft section tint
  - this preserves the shared visual system without creating page-specific themes

- Add a short eyebrow label above the title on section pages:
  - example pattern: small category label above the main title
  - useful if we want the main title to feel more intentional without changing route names

- Improve spacing rhythm:
  - slightly reduce the gap below the header row
  - increase the separation between the header and quote block only when needed
  - tune the back button, icon, and text spacing as one unit instead of separately

- Use a responsive header scale:
  - modest icon/text sizing on dense phones
  - slightly roomier sizing on larger devices and tablets
  - keeps the header elegant without feeling oversized on small screens

- Add very subtle motion:
  - a soft fade/slide for the icon and title together on page load
  - no independent icon bounce or flashy motion

- Create a shared header style tier system:
  - `standard` for utility/detail pages
  - `section` for hub and landing pages
  - `hero` for rare flagship surfaces
  - this would let us improve aesthetics globally without forcing one header treatment everywhere

## Recommended next options

- Best low-risk option: keep the current structure and refine icon/title spacing plus vertical alignment.
- Best visual-upgrade option: add a very subtle rounded icon container for section landing pages only.
- Best scalable system option: introduce shared header tiers so hubs and detail pages do not have to use the exact same header treatment.
