# Living Garden Vista — layered scene art

Generated WebP layers for the growing-garden progress scene. Source of truth
is the parametric generator `tooling/art_src/garden_art/generate_garden_art.mjs`
(never edit files here by hand):

- **Design space 2000×1200** (horizon y=600). Every coordinate lives ONLY in
  the generator's LAYOUT; the app reads them from the emitted
  `lib/features/garden/data/garden_scene_layout.g.dart`. Never hardcode a
  scene coordinate in a widget.
- **Crops**: hero x130 y0 1740×1200 (the GardenPage 1.45:1 frame); Home card
  x100 y280 1800×800. The tree, stream mouth, and at least two plant anchors
  must stay inside BOTH crops.
- **Style**: painterly calm — volumetric foliage lit from the upper left,
  soft gradient skies, warm ivory light (`#F0E4C0`), gold accents
  (`#E2C177`), atmospheric haze. No faces, no figures, no text in artwork.
- **Naming contract** (the resolver walks variants/stages downward through
  whatever exists):
  `garden_sky_{dawn|morning|warm|evening}_{day|night}` ·
  `garden_ground_{day|night}` · `garden_water_e{01..05}[_night]` ·
  `garden_tree_s{01..04}` · `garden_tree_s{05..10}_{trunk|canopy}` ·
  `garden_plant_{olive|palm|fig|pomegranate|vine|gourd|sidr|rayhan}_v{1..3}` ·
  `garden_animal_{hoopoe|ants|beehive|bee}` · `garden_fg_vignette` ·
  `garden_milestone_m{01..10}`
- **Budgets**: element layers are tightly cropped to their layout rects;
  target 10–20 KB each at `cwebp -q 78` (`-alpha_q 90` for transparent
  layers); the whole set stays under ~700 KB.
- Regenerate: `node tooling/art_src/garden_art/generate_garden_art.mjs`, then
  rsvg-convert each SVG at its layout size and `cwebp -q 78` the result. New
  files must also be appended to AVAILABLE_FILES in the generator so the
  emitted availability set picks them up.
