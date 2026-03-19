# Learning Quote Consistency Enhancement Backlog

- Add a small widget test that asserts `LearnHubPageScaffold` and `LearningDetailPage` both default to the canonical Qur’an 20:114 learning quote.
- Audit remaining non-Learn educational surfaces that still render custom quotes and decide whether they should keep domain-specific verses or align with a shared domain-level quote policy.
- If product later wants stricter enforcement, introduce a dedicated `LearningQuoteBlock` wrapper so learning-owned pages stop passing quote objects directly.
