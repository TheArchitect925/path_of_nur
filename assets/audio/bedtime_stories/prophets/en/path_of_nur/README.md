Canonical bundled bedtime story narration lives here.

Naming convention:
- `prophet_<name>_bedtime_en_v1.mp3`
- `prophet_muhammad_part1_bedtime_en_v1.mp3`

This path is the first bundled-audio lookup used by the bedtime story media resolver.

Recording kit (K3): `python3 tools/import_kids_narration.py --script` prints
one reading sheet per story with the exact file name to save the take as;
`python3 tools/import_kids_narration.py <raw_dir>` trims, normalises and
writes the mp3s here; `--check` lists what is narrated and flags strays.
Until a slot is filled the reader uses the device voice.
