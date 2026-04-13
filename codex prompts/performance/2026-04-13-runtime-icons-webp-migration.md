Continue with the next safest post-verification step by running a narrow staged WebP migration for the verified live-runtime subset of `assets/icons/`.

Requirements:
- Audit `assets/icons/` first
- Keep launcher/config-owned icon files out of the first batch
- Convert only the verified live-runtime subset to sibling `.webp`
- Migrate only verified runtime references
- Tighten the allowlist from a broad `assets/icons/` prefix to explicit remaining PNG exceptions
- Validate with analyzer/policy
- Delete only the verified legacy PNGs for the converted subset

Safe first-batch scope:
- `assets/icons/home_lantern_cropped.png`
- `assets/icons/learn_quran_cropped.png`
- `assets/icons/brotherlogo.PNG`
- `assets/icons/sisterlogo.png`

Keep out of this first batch:
- `assets/icons/app_iconv2.png`
- `assets/icons/app_icondarkv2.png`
- any unused icon PNGs unless they are later selected intentionally
