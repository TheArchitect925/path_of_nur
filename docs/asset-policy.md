# Asset Policy

Runtime Flutter imagery should prefer WebP under `assets/`.

PNG is still allowed when it is genuinely required for native/platform packaging, such as:
- `ios/**/Assets.xcassets/`
- `android/app/src/main/res/`
- `macos/**/Assets.xcassets/`
- `web/favicon.png` and `web/icons/`
- other native packaging folders like tvOS asset catalogs

Temporary runtime PNG exceptions must be listed in [runtime_png_allowlist.txt](/Users/shahabmansoor/Developer/path_of_nur/tooling/config/runtime_png_allowlist.txt) with a clear reason. Prefer exact file-path exceptions over folder-wide prefixes.

Legacy runtime PNGs may remain on disk temporarily without an allowlist entry only when a sibling `.webp` exists and no live runtime source still points to the `.png`.

Run the policy check locally with:

```bash
bash tooling/scripts/check_runtime_png_policy.sh
```

CI runs this check in the main validation workflow and fails only for disallowed runtime PNGs under the app asset paths.
