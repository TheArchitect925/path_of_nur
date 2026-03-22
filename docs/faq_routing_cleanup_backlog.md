# FAQ Routing Cleanup Backlog

- Add a small route test covering `LearnHubCategoryId.faq` so future taxonomy changes cannot regress the direct `faqLanding` destination.
- Consider adding a dedicated FAQ browse chip inside the broader Learn browse surface when `category=faq` is active, so the relationship between direct FAQ and full browsing is even clearer.
- Audit Home and Help entry points for any remaining legacy FAQ shortcuts that should also normalize to `faqLanding`.
