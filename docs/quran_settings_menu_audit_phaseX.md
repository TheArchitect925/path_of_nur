# Qur'an Settings Menu Audit

Last updated: 2026-03-25

## Executive summary

The Qur'an reader settings surface had a real feature inventory already, but the information architecture was too flat. High-frequency reading controls, low-frequency memorization controls, audio setup, downloads, and beta helpers were mixed into one long collapsible list. The result was functional but harder to scan, easier to misread, and noisier than the rest of the reader experience.

This pass kept the canonical settings providers and storage keys intact, but reorganized the live reader settings panel into clearer intent-based groups.

## Current settings inventory before reorganization

### Reader-focused

- Translation source
  - Purpose: choose translation dataset
  - Surface: reader collapsible settings
  - Frequency: medium
- Show Arabic
  - Purpose: visibility of Arabic ayah text
  - Surface: reader collapsible settings
  - Frequency: high
- Show translation
  - Purpose: visibility of translation text
  - Surface: reader collapsible settings
  - Frequency: high
- Show transliteration
  - Purpose: visibility of transliteration text
  - Surface: reader collapsible settings
  - Frequency: high
- Clean reading mode
  - Purpose: reduce ayah-card action clutter
  - Surface: reader collapsible settings
  - Frequency: medium
- Red diacritics
  - Purpose: readability styling for harakat
  - Surface: reader collapsible settings
  - Frequency: medium
- Arabic text size
  - Purpose: Arabic readability
  - Surface: reader collapsible settings
  - Frequency: high
- Translation text size
  - Purpose: translation readability
  - Surface: reader collapsible settings
  - Frequency: medium
- Transliteration text size
  - Purpose: transliteration readability
  - Surface: reader collapsible settings
  - Frequency: medium

### Study / optional helpers

- Word-by-word translation (beta)
  - Purpose: learning aid
  - Surface: reader collapsible settings
  - Frequency: medium
- Live word sync highlight (beta)
  - Purpose: timing-linked study aid
  - Surface: reader collapsible settings
  - Frequency: medium
- Learn More visibility
  - Purpose: show contextual learning links
  - Surface: reader collapsible settings
  - Frequency: medium

### Playback-focused

- Background playback + lock-screen controls
  - Purpose: audio session behavior
  - Surface: reader collapsible settings
  - Frequency: medium
- Reciter
  - Purpose: choose audio reciter
  - Surface: reader collapsible settings
  - Frequency: medium
- Reciter sample
  - Purpose: preview reciter
  - Surface: reader collapsible settings
  - Frequency: low
- Playback speed
  - Purpose: audio pacing
  - Surface: reader collapsible settings
  - Frequency: medium
- Repeat from / to
  - Purpose: set repeat range
  - Surface: reader collapsible settings
  - Frequency: low to medium
- Loop count
  - Purpose: set repetition count
  - Surface: reader collapsible settings
  - Frequency: low to medium
- Play loop
  - Purpose: start configured practice loop
  - Surface: reader collapsible settings
  - Frequency: low to medium

### Offline-focused

- Download surah
  - Purpose: save audio locally
  - Surface: reader collapsible settings
  - Frequency: low
- Remove download
  - Purpose: delete local audio
  - Surface: reader collapsible settings
  - Frequency: low

### Memorization-focused

- Memorization mode enabled
  - Purpose: hifz-oriented display
  - Surface: reader collapsible settings
  - Frequency: low
- Reveal mode
  - Purpose: memorization reveal depth
  - Surface: reader collapsible settings
  - Frequency: low
- Daily revision chips
  - Purpose: jump to revision anchors
  - Surface: reader collapsible settings
  - Frequency: low
- Open review deck
  - Purpose: word review handoff
  - Surface: reader collapsible settings
  - Frequency: low

### Related settings outside the collapsible panel

- Follow Ayah Mode
  - Purpose: playback-follow behavior
  - Surface: reader playback controls card
  - Frequency: high while listening
- Focus Recitation toggles
  - Purpose: focus-mode display and session controls
  - Surface: Focus Recitation bottom sheet
  - Frequency: medium within Focus Mode only

## Current UX / IA problems before reorganization

- One long mixed list combined reading, playback, downloads, beta tools, and memorization.
- Quick reading controls were visually competing with downloads and looping controls.
- Destructive download removal sat too close to harmless display changes.
- Beta features were mixed with primary reading preferences.
- Memorization controls were surfaced in the same visual weight as everyday reader settings.
- Audio speed and repeat controls sat beside reciter/download controls without a stronger internal hierarchy.
- The panel was scan-heavy for one-handed use because it read as a long wall of toggles and forms.

## Recommended information architecture

### Quick access kept near the top

- Reading & Display
  - Arabic size
  - translation/transliteration size
  - translation source
  - Arabic/translation/transliteration visibility
  - clean reading mode
  - red diacritics

### Mid-depth reader helpers

- Study Tools
  - Learn More visibility
  - word-by-word translation beta
  - live word sync beta

### Playback setup

- Audio & Playback
  - background playback
  - reciter
  - reciter sample
  - playback speed
  - repeat & practice controls

### Deeper / lower-frequency controls

- Downloads & Offline
  - download surah
  - remove download
- Memorization & Review
  - memorization mode
  - reveal mode
  - revision plan
  - review deck

### Quick access kept outside the collapsible menu

- Follow Ayah Mode remains in the reader playback controls card because it is a live listening action rather than a deep reader preference.
- Focus Recitation settings remain in the Focus Mode sheet because they are mode-specific rather than global reader settings.

## Label / copy improvements

New section labels introduced:

- Reading & Display
- Study Tools
- Audio & Playback
- Downloads & Offline
- Memorization & Review
- Repeat & practice

These are shorter and more intent-based than the previous flatter “Text Settings / Audio Settings / Memorization Settings” sequence.

## Reorganization result

- The reader panel now groups settings by user intent.
- Reading controls appear first and are no longer visually buried under audio setup.
- Beta / optional learning helpers moved into their own calmer section.
- Downloads are isolated from display and playback controls.
- Memorization controls stay available but read as a separate specialist section.
- No persistence keys were migrated or reset in this pass.
