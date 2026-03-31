# Main Page Inner Visual Owner Fix Backlog

Date: 2026-03-31

## Remaining inner visual owner found

- The remaining non-Home mismatch was the scaffold-injected top quote surface on shared main pages.
- Home owns its hero ayah card inside page content, while Learn/Growth/Worship were receiving a scaffold-managed quote layer before normal content.

## Completed in this pass

- Moved the top quote block for the affected main pages out of scaffold injection and into page-owned content.
- Kept normal cards and content surfaces intact.
- Left the shell/background ownership fix in place.

## Enhancement options

- If needed, apply the same page-owned quote pattern to other root-like hubs that should visually match Home.
- Add a small shared helper for page-owned top quote cards if more main tabs need the same structure.
