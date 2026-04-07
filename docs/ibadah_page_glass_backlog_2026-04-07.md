# Ibadah Page Glass Backlog

Date: 2026-04-07

Context: The `practice-worship` Learning Journey island now wraps its major content containers with the loading-screen `AppHeroGlassShell` recipe.

## Enhancement options

1. Review the page vertically on smaller phones because the loading-screen shell padding is more generous than the older card containers.
2. Decide whether `LearnActionCard` and `RelatedToolsSection` should eventually expose a dedicated “hero shell” mode rather than being wrapped page-locally on Ibadah.
3. Add a focused widget test for the `practice-worship` island to keep these container wrappers stable through future card refactors.
