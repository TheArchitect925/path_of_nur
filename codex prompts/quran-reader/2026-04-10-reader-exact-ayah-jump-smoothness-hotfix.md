# Hotfix — Make Quran Reader Exact-Ayah Jump Feel Smooth

Primary objective:
- keep exact-ayah landing correct while making the reader scroll feel smooth and deliberate

Implementation intent:
- audit the current staged target-ayah jump flow
- replace coarse pre-target animated scans with non-animated positioning
- keep one final exact animated landing when the target widget is mounted
- avoid repeated exact landing animations after minor relayouts
