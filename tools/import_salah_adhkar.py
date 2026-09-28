#!/usr/bin/env python3
"""Turn raw adhkar takes into the salah trainer's recording slots.

Usage:
  python3 tools/import_salah_adhkar.py <raw_dir>     convert every take found
  python3 tools/import_salah_adhkar.py --check       validate what is bundled

Raw takes are matched by name: <raw_dir>/<id>.<any audio extension>, where
<id> is one of the slots below (the same list as `salahAdhkarAudioIds` in
lib/features/learn/salah/data/salah_trainer_data.dart). Voice Memos m4a,
wav, aiff, mp3 and ogg all work. Each take is trimmed of leading and
trailing silence, loudness-normalised, and written as a mono 44.1 kHz
96 kbps mp3 into assets/audio/salah/adhkar/, which the app resolves through
the asset manifest at runtime; a slot with no file keeps the device voice.

Trimming matters: the app scales the word highlight to the clip length, so
silence at either end drifts the highlight.
"""

from __future__ import annotations

import json
import pathlib
import shutil
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
ASSET_DIR = ROOT / "assets" / "audio" / "salah" / "adhkar"
DART_DATA = ROOT / "lib" / "features" / "learn" / "salah" / "data" / "salah_trainer_data.dart"

# id -> (what to recite, once, plus the plausible spoken length in seconds)
CLIPS: dict[str, tuple[str, float, float]] = {
    "takbir": ("Allahu akbar", 0.6, 3.0),
    "opening_supplication": ("Subhanaka Allahumma wa bihamdika ...", 5.0, 20.0),
    "opening_wajjahtu": ("Wajjahtu wajhiya lilladhi fatara ...", 10.0, 40.0),
    "qunut": ("Allahumma ihdini fiman hadayt ...", 12.0, 45.0),
    "ruku": ("Subhana rabbiyal azim (once)", 1.0, 5.0),
    "standing_after_ruku": ("Sami Allahu liman hamidah, Rabbana wa lakal hamd", 2.0, 8.0),
    "sujud": ("Subhana rabbiyal a'la (once)", 1.0, 5.0),
    "sitting_between_sujud": ("Rabbighfir li warhamni ...", 3.0, 12.0),
    "tashahhud": ("At-tahiyyatu lillahi ...", 10.0, 40.0),
    "salawat": ("Allahumma salli ala Muhammad ... (both halves)", 12.0, 45.0),
    "final_dua": ("Allahumma inni a'udhu bika min adhabi jahannam ...", 8.0, 30.0),
    "taslim": ("As-salamu alaykum wa rahmatullah (once)", 1.0, 5.0),
}

AUDIO_EXTENSIONS = {".m4a", ".mp3", ".wav", ".aiff", ".aif", ".ogg", ".flac", ".caf", ".mp4"}

# Head 150 ms / tail 300 ms of near-silence are kept so the clip does not
# start or end abruptly; everything quieter than -45 dB beyond that goes.
FILTER = (
    "silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.15,"
    "areverse,"
    "silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.3,"
    "areverse,"
    "loudnorm=I=-16:TP=-1:LRA=11"
)


def dart_ids() -> list[str]:
    """The slot list the app declares, so this tool cannot drift from it."""
    source = DART_DATA.read_text()
    start = source.index("const salahAdhkarAudioIds = <String>[")
    end = source.index("];", start)
    return [
        line.strip().strip(",").strip("'")
        for line in source[start:end].splitlines()[1:]
        if line.strip().startswith("'")
    ]


def require_ffmpeg() -> None:
    for tool in ("ffmpeg", "ffprobe"):
        if shutil.which(tool) is None:
            sys.exit(f"{tool} is not installed (brew install ffmpeg)")


def duration_seconds(path: pathlib.Path) -> float:
    out = subprocess.run(
        ["ffprobe", "-v", "error", "-show_entries", "format=duration",
         "-of", "json", str(path)],
        capture_output=True, text=True, check=True,
    ).stdout
    return float(json.loads(out)["format"]["duration"])


def convert(take: pathlib.Path, clip_id: str) -> pathlib.Path:
    ASSET_DIR.mkdir(parents=True, exist_ok=True)
    target = ASSET_DIR / f"{clip_id}.mp3"
    subprocess.run(
        ["ffmpeg", "-y", "-loglevel", "error", "-i", str(take),
         "-af", FILTER, "-ac", "1", "-ar", "44100", "-b:a", "96k", str(target)],
        check=True,
    )
    return target


def check_only() -> int:
    ids = dart_ids()
    problems = 0
    print(f"{'slot':24} {'file':10} {'length':>8}  status")
    for clip_id in ids:
        target = ASSET_DIR / f"{clip_id}.mp3"
        if not target.exists():
            print(f"{clip_id:24} {'missing':10} {'':>8}  device voice will be used")
            continue
        length = duration_seconds(target)
        low, high = CLIPS[clip_id][1], CLIPS[clip_id][2]
        ok = low <= length <= high
        problems += 0 if ok else 1
        print(f"{clip_id:24} {'mp3':10} {length:7.2f}s  {'ok' if ok else f'outside {low}-{high}s, check the take'}")
    strays = [p.name for p in ASSET_DIR.iterdir()
              if p.is_file() and not p.name.startswith(".") and p.stem not in ids]
    if strays:
        problems += len(strays)
        print("stray files (not a declared slot, will never play):", ", ".join(strays))
    return 1 if problems else 0


def import_takes(raw_dir: pathlib.Path) -> int:
    ids = dart_ids()
    unknown = sorted(CLIPS) ^ set(ids)
    if unknown:
        sys.exit(f"CLIPS in this tool and salahAdhkarAudioIds disagree on: {sorted(unknown)}")
    takes = {p.stem: p for p in raw_dir.iterdir()
             if p.is_file() and p.suffix.lower() in AUDIO_EXTENSIONS}
    done, missing = [], []
    for clip_id in ids:
        take = takes.get(clip_id)
        if take is None:
            missing.append(clip_id)
            continue
        target = convert(take, clip_id)
        length = duration_seconds(target)
        low, high = CLIPS[clip_id][1], CLIPS[clip_id][2]
        flag = "" if low <= length <= high else f"  <- outside {low}-{high}s, listen to it"
        print(f"{clip_id:24} {take.name:28} -> {target.name:28} {length:6.2f}s{flag}")
        done.append(clip_id)
    ignored = sorted(set(takes) - set(ids))
    print()
    print(f"converted {len(done)} of {len(ids)} slots")
    if missing:
        print("still using the device voice:", ", ".join(missing))
    if ignored:
        print("ignored (no such slot):", ", ".join(ignored))
    print("bundled folder:", ASSET_DIR.relative_to(ROOT))
    return 0


def main(argv: list[str]) -> int:
    require_ffmpeg()
    if len(argv) == 2 and argv[1] == "--check":
        return check_only()
    if len(argv) == 2 and pathlib.Path(argv[1]).is_dir():
        return import_takes(pathlib.Path(argv[1]))
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv))
