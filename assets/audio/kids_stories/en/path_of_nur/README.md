Kids non-prophet story audio should live in this folder.

Canonical path:
- `assets/audio/kids_stories/en/path_of_nur/`

Recommended filename convention:
- `<story_slug>_kids_story_en_v1.mp3`

Examples:
- `sharing_with_others_kids_story_en_v1.mp3`
- `telling_the_truth_kids_story_en_v1.mp3`
- `ramadan_kindness_kids_story_en_v1.mp3`

Notes:
- Prophet bedtime stories still keep their existing bedtime-story audio path.
- The broader kids story library uses this folder for non-prophet story narration.
- If a file is missing, the story still works in transcript/read mode without broken playback UI.

Recording kit (K3): `python3 tools/import_kids_narration.py --script` prints
one reading sheet per story with the exact file name to save the take as;
`python3 tools/import_kids_narration.py <raw_dir>` trims, normalises and
writes the mp3s here; `--check` lists what is narrated and flags strays.
Until a slot is filled the reader uses the device voice.
