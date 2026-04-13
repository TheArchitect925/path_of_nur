# WebP Migration Audit Backlog

1. Tighten the runtime PNG allowlist after the real asset conversion lands so CI stops treating broad folders like `assets/images/backgrounds/` and `assets/images/wudu/` as acceptable long-term exceptions.
2. Run the real Phase 1 conversion with `cwebp` installed and commit the generated `.webp` files so Phase 2 and Phase 3 can move from audit-only to actual migration/cleanup.
3. Replace stale runtime PNG references only when matching `.webp` siblings exist on disk, starting with the heaviest folders: backgrounds, prophets, and wudu.
4. Add a repo-owned CSV artifact export for the new audit script during release-prep so the biggest savings opportunities can be sorted and assigned quickly.
5. Decide whether `assets/icons/app_iconv2.png` and `assets/icons/app_icondarkv2.png` should remain PNG as tooling-only launcher icon sources or move out of the runtime asset tree to reduce policy ambiguity.
6. Audit missing runtime asset references outside the current PNG migration scope, especially the `quran_teacher` and `kids_stories` image paths that appear in source but are not present in the current `assets/` tree.
7. After actual WebP assets are committed, rerun the audit and add a small regression test or CI summary artifact for the largest per-file storage wins.

