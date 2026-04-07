# Colored Inner Glass Container Prompt

Use this prompt when you want existing glass cards or containers to keep their glass shell, but also show a visible soft color identity on the card face.

## Reusable prompt

Apply the `colored inner glass card` treatment to this surface.

Requirements:
- Keep the existing glass shell and shared glass renderer.
- Do not make it a flat solid card.
- Add a visible but soft inner color face, similar to the updated:
  - Home Salah timing cards
  - Signs in the Sky sunrise/sunset containers
  - Learn Start a Journey cards
- The treatment should include:
  - a tinted inner gradient/card face
  - a soft matching tinted border
  - preserved translucency / glass feel
  - no harsh dark colors
  - no neon or oversaturated colors
- Keep business logic, routing, localization, and layout intact.
- Do not introduce a page-specific one-off theme if the shared styling path can be reused.
- Keep the result calm, premium, and readable.

Implementation intent:
- Outer layer stays glass.
- Inner face carries the visible color identity.
- Colors should be subtle but clearly noticeable.
- Prefer palette-driven tints based on the feature’s existing accent colors or time-of-day colors.

Validation:
- Run `flutter analyze` on changed files.
- Run relevant focused tests if the surface already has them.

## Short version

Apply the `colored inner glass card` treatment here:
- keep the glass shell
- add a visible soft colored inner face and tinted border
- match the style used on the Salah timing cards / Signs in the Sky chips / Start a Journey cards
- keep it calm and premium, not solid or neon
