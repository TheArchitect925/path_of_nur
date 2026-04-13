# Growth Performance Hardening Backlog

Date: 2026-04-11

## Enhancement options

1. Move the Growth home page from eager `children: [...]` composition to a sliver-backed lazy body so large sections do not all build up front.
2. Narrow the Growth progress card watches with smaller `select` boundaries so snapshot/progress updates do not rebuild unrelated home sections.
3. Audit `quranPersonalizedRecommendationBundleProvider` for a lighter Growth-specific read path if the recommendation card still feels noisy after widget isolation.
