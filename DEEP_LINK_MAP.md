# Path of Nūr Deep Link Map

## Shell Tabs
- `/worship`
- `/learn`
- `/home`
- `/journey`
- `/profile`

## Core
- `/onboarding`
- `/settings`
- `/salah-times`
- `/assistant`

## Legal / Support
- `/legal/privacy`
- `/legal/terms`
- `/legal/support`

## Qur’an
- `/learn/quran/explorer`
- `/learn/quran/search`
- `/learn/quran/bookmarks`
- `/learn/quran/notes`
- `/learn/quran/names-of-allah`
- `/learn/quran/top-words`
- `/learn/quran/word-review`
- `/learn/quran/surah/:surahNumber?ayah=:ayahNumber`

## Learn Domains
- Life
  - `/learn/life`
  - `/learn/life/theme/:themeId`
  - `/learn/life/subcategory/:subcategoryId`
  - `/learn/life/lesson/:lessonId`
- World
  - `/learn/world`
  - `/learn/world/theme/:themeId`
  - `/learn/world/subcategory/:subcategoryId`
  - `/learn/world/lesson/:lessonId`
- Hadith
  - `/learn/hadith`
  - `/learn/hadith/theme/:themeId`
  - `/learn/hadith/subcategory/:subcategoryId`
  - `/learn/hadith/lesson/:lessonId`

## Community
- `/circles`
- `/circles/joined`
- `/circles/events`
- `/circles/moderation`
- `/circles/accountability`
- `/circles/nearby-mosques`
- `/circles/mosque-buddy`
- `/circles/:circleId`

## Journey and Rewards
- `/journey/ocean`
- `/journey/wallpapers`

## Journal
- `/journal`
- `/journal/create`

## Hardened / Legacy Redirects
- `/quran/explorer` -> `/learn/quran/explorer`
- `/quran/search` -> `/learn/quran/search`

## Route Guard Notes
- Invalid circle ID deep links fallback to circles discovery.
- Missing Learn domain path parameters fallback to domain landing pages.
- Unknown routes show a safe not-found screen.
