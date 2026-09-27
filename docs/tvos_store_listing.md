# Path of Nūr on Apple TV: the store listing

Last updated: 2026-09-27

What goes into App Store Connect for the tvOS platform of the existing app.
The Apple TV app shares the iPhone app's record (universal purchase), so the
app's name, subtitle, category, privacy policy and age rating are already set
there and are not repeated here. What the tvOS platform needs of its own is
the text below and the screenshots.

Every line follows `docs/voice_and_copy_guide.md`. It claims what the build
does and nothing else: update the surah count when the reader holds more.

The German, French, Arabic and Urdu are machine translations. They want a
native reader before the listing goes public.

## Screenshots

```
bash scripts/capture_tvos_store_screenshots.sh
```

writes nine screenshots for each language to `build/store/tvos/<language>/`,
3840x2160, without an alpha channel. `build/` is not in the repository: run
the script again after any change to a screen. Apple takes up to ten.

Upload them in this order. The first three are what most people see.

| File | What it shows |
| --- | --- |
| `02-prayer.jpg` | Today's prayer times for the viewer's town |
| `04-listening.jpg` | An ayah full screen, with its recitation playing |
| `06-routine.jpg` | A dhikr routine, counted on the ring |
| `01-home.jpg` | Home at night |
| `08-daylight.jpg` | Home by day |
| `03-quran.jpg` | The reader |
| `05-dhikr.jpg` | The four routines |
| `07-settings.jpg` | Prayer settings: location, authority, Asr |
| `09-cities.jpg` | The list of cities |

Each language is taken in a city of its own (Toronto, Berlin, Paris, Makkah,
Karachi), so the times on screen are real times for that place on the day the
script ran.

## English

### Promotional text (170 characters at most)

Prayer times for where you are, the Qur’an recited ayah by ayah, and dhikr
routines to follow together, on the largest screen in the house.

### Description

Path of Nūr on Apple TV brings the day's worship to the room the family shares.

PRAYER TIMES
The five prayers for your town, calculated on the Apple TV the way your phone
calculates them. Choose from five authorities (Muslim World League, Egyptian
General Authority, Islamic Society of North America, University of Karachi,
Umm al-Qura University) and the Shafi’i or Hanafi rule for Asr. The Apple TV
asks for its location once. If you prefer, choose your city from a list.

QUR’AN
Read Al Fatiha and four short surahs in large Arabic, with a transliteration
and a translation in English, French or Urdu. Listen ayah by ayah with Mahmoud
Khalil Al-Husary, Mishary Rashid Alafasy or Abdul Basit, and open any ayah
full screen.

DHIKR
Four routines from the phone: after salah, morning, evening and before sleep.
Count with the remote, or let the Apple TV keep the pace so everyone can
follow with empty hands.

A LOOK FOR EVERY HOUR
Cream by day and a night sky after dark, with the moon in its true phase.
Jumu’ah and Ramadan arrive on their own.

IN YOUR LANGUAGE
English, Deutsch, Français, العربية and اردو.

PRIVATE
No account and no sign-in. Your location is used on the Apple TV to calculate
prayer times and is not collected.

### Keywords (100 characters at most)

prayer times,salah,quran,dhikr,adhkar,tasbih,muslim,islam,fajr,recitation,ramadan

## Deutsch

### Werbetext

Gebetszeiten für Ihren Ort, der Koran Aya für Aya rezitiert und Dhikr-Routinen
zum gemeinsamen Mitsprechen, auf dem größten Bildschirm im Haus.

### Beschreibung

Path of Nūr auf Apple TV bringt die Anbetung des Tages in den Raum, den die
Familie teilt.

GEBETSZEITEN
Die fünf Gebete für Ihren Ort, auf dem Apple TV so berechnet, wie Ihr Telefon
sie berechnet. Wählen Sie aus fünf Autoritäten (Islamische Weltliga,
Ägyptische Generalbehörde, Islamic Society of North America, Universität
Karatschi, Umm-al-Qura-Universität) und die schafiitische oder hanafitische
Regel für Asr. Das Apple TV fragt einmal nach seinem Standort. Wenn Sie
möchten, wählen Sie Ihre Stadt aus einer Liste.

KORAN
Lesen Sie Al-Fatiha und vier kurze Suren in großem Arabisch, mit Umschrift
und Übersetzung. Hören Sie Aya für Aya mit Mahmoud Khalil Al-Husary, Mishary
Rashid Alafasy oder Abdul Basit und öffnen Sie jede Aya im Vollbild.

DHIKR
Vier Routinen vom Telefon: nach dem Salah, am Morgen, am Abend und vor dem
Schlafen. Zählen Sie mit der Fernbedienung oder lassen Sie das Apple TV das
Tempo halten, damit alle mit leeren Händen folgen können.

EIN LOOK FÜR JEDE STUNDE
Creme am Tag und ein Nachthimmel nach Einbruch der Dunkelheit, mit dem Mond
in seiner wahren Phase. Jumu’ah und Ramadan kommen von selbst.

IN IHRER SPRACHE
English, Deutsch, Français, العربية und اردو.

PRIVAT
Kein Konto und keine Anmeldung. Ihr Standort wird auf dem Apple TV zur
Berechnung der Gebetszeiten verwendet und nicht erfasst.

### Schlüsselwörter

gebetszeiten,salah,koran,dhikr,adhkar,tasbih,muslim,islam,fajr,rezitation,ramadan

## Français

### Texte promotionnel

Les horaires de prière de votre ville, le Coran récité verset par verset et
des routines de dhikr à suivre ensemble, sur le plus grand écran de la maison.

### Description

Path of Nūr sur Apple TV apporte l’adoration du jour dans la pièce que la
famille partage.

HORAIRES DE PRIÈRE
Les cinq prières de votre ville, calculées sur l’Apple TV comme votre
téléphone les calcule. Choisissez parmi cinq autorités (Ligue islamique
mondiale, Autorité générale égyptienne, Société islamique d’Amérique du Nord,
Université de Karachi, Université Oumm al-Qura) et la règle chaféite ou
hanafite pour Asr. L’Apple TV demande sa position une seule fois. Si vous
préférez, choisissez votre ville dans une liste.

CORAN
Lisez Al-Fatiha et quatre courtes sourates en grand arabe, avec une
translittération et une traduction en français. Écoutez verset par verset
avec Mahmoud Khalil Al-Husary, Mishary Rashid Alafasy ou Abdul Basit, et
ouvrez chaque verset en plein écran.

DHIKR
Quatre routines venues du téléphone : après la prière, le matin, le soir et
avant de dormir. Comptez avec la télécommande, ou laissez l’Apple TV tenir le
rythme pour que chacun suive les mains libres.

UNE APPARENCE POUR CHAQUE HEURE
Crème le jour et un ciel de nuit à la tombée du soir, avec la lune dans sa
vraie phase. Jumu’ah et Ramadan arrivent d’eux-mêmes.

DANS VOTRE LANGUE
English, Deutsch, Français, العربية et اردو.

PRIVÉ
Ni compte ni connexion. Votre position sert sur l’Apple TV à calculer les
horaires de prière et n’est pas collectée.

### Mots-clés

horaires de prière,salah,coran,dhikr,adhkar,tasbih,musulman,islam,fajr,ramadan

## العربية

### النص الترويجي

أوقات الصلاة لمدينتك، والقرآن مرتّلًا آية آية، وأوراد ذكر تتابعها الأسرة معًا،
على أكبر شاشة في البيت.

### الوصف

‏Path of Nūr على Apple TV يأتي بعبادة اليوم إلى الغرفة التي تجتمع فيها الأسرة.

أوقات الصلاة
الصلوات الخمس لمدينتك، تُحسب على الـ Apple TV كما يحسبها هاتفك. اختر من خمس
جهات (رابطة العالم الإسلامي، الهيئة المصرية العامة للمساحة، الجمعية الإسلامية
لأمريكا الشمالية، جامعة العلوم الإسلامية بكراتشي، جامعة أم القرى) واختر قول
الشافعي أو الحنفي في وقت العصر. يطلب الـ Apple TV موقعه مرة واحدة، ويمكنك أن
تختار مدينتك من قائمة.

القرآن
اقرأ الفاتحة وأربع سور قصار بخط عربي كبير. استمع آية آية بصوت محمود خليل
الحصري أو مشاري راشد العفاسي أو عبد الباسط، وافتح أي آية بملء الشاشة.

الذكر
أربعة أوراد من الهاتف: بعد الصلاة، والصباح، والمساء، وقبل النوم. عُدّ بجهاز
التحكم، أو دع الـ Apple TV يضبط الإيقاع ليتابع الجميع بأيدٍ خالية.

مظهر لكل ساعة
لون كريمي نهارًا وسماء ليل بعد الغروب، والقمر في طوره الحقيقي. الجمعة ورمضان
يحضران تلقائيًا.

بلغتك
English و Deutsch و Français والعربية و اردو.

خصوصيتك
بلا حساب وبلا تسجيل دخول. يُستخدم موقعك على الـ Apple TV لحساب أوقات الصلاة
ولا يُجمع.

### الكلمات المفتاحية

أوقات الصلاة,صلاة,قرآن,ذكر,أذكار,تسبيح,مسلم,إسلام,الفجر,تلاوة,رمضان

## اردو

### تشہیری متن

آپ کے شہر کے اوقاتِ نماز، قرآن کی تلاوت آیت بہ آیت، اور ذکر کے معمولات جو
سب مل کر پڑھیں، گھر کی سب سے بڑی اسکرین پر۔

### تفصیل

‏Path of Nūr ایپل ٹی وی پر دن بھر کی عبادت اس کمرے میں لاتا ہے جہاں گھر والے
اکٹھے بیٹھتے ہیں۔

اوقاتِ نماز
آپ کے شہر کی پانچوں نمازیں، Apple TV پر اسی طرح حساب کی جاتی ہیں جیسے آپ کا
فون کرتا ہے۔ پانچ اداروں میں سے چنیں (رابطہ عالم اسلامی، مصری جنرل اتھارٹی،
اسلامک سوسائٹی آف نارتھ امریکہ، جامعہ علوم اسلامیہ کراچی، جامعہ ام القریٰ)
اور عصر کے لیے شافعی یا حنفی قول۔ Apple TV اپنا مقام ایک بار پوچھتا ہے۔ آپ
چاہیں تو فہرست میں سے اپنا شہر چن لیں۔

قرآن
الفاتحہ اور چار مختصر سورتیں بڑے عربی خط میں پڑھیں، نقل حرفی اور اردو ترجمے
کے ساتھ۔ محمود خلیل الحصری، مشاری راشد العفاسی یا عبد الباسط کی آواز میں
آیت بہ آیت سنیں، اور کوئی بھی آیت پوری اسکرین پر کھولیں۔

ذکر
فون کے چار معمولات: نماز کے بعد، صبح، شام اور سونے سے پہلے۔ ریموٹ سے گنیں،
یا Apple TV کو رفتار سنبھالنے دیں تاکہ سب خالی ہاتھ ساتھ چل سکیں۔

ہر گھڑی کا انداز
دن میں کریم رنگ اور اندھیرا ہونے پر رات کا آسمان، چاند اپنی اصل حالت میں۔
جمعہ اور رمضان خود آ جاتے ہیں۔

آپ کی زبان میں
English، Deutsch، Français، العربية اور اردو۔

نجی
نہ اکاؤنٹ، نہ سائن اِن۔ آپ کا مقام Apple TV پر اوقاتِ نماز کے حساب کے لیے
استعمال ہوتا ہے اور جمع نہیں کیا جاتا۔

### کلیدی الفاظ

اوقات نماز,نماز,قرآن,ذکر,اذکار,تسبیح,مسلم,اسلام,فجر,تلاوت,رمضان

## Notes for App Review

Paste into the review notes for the tvOS version.

> No account or sign-in is needed. Every section is open on first launch.
>
> Location: on first launch the app asks for When In Use location, to
> calculate prayer times for the viewer's town. The coordinates stay on the
> device and are not sent to us or stored off the device. If location is
> refused, prayer times can be set from Settings › Prayer times › Choose a
> city, and the rest of the app works without it.
>
> Audio: Qur’an recitation is streamed over HTTPS from everyayah.com. Open
> Qur’an, select an ayah, then press Play/Pause, or select Open listening
> mode.
>
> Dhikr: open Dhikr, select a routine. Select counts once; Play/Pause lets
> the Apple TV count on its own.

## App privacy answers

The tvOS app collects no data. Answer **Data Not Collected** for the tvOS
platform if App Store Connect asks for it separately from the iPhone app.

- Location is used on the device to calculate prayer times. It is not sent to
  any server of ours. The town's name comes from Apple's own geocoder.
- Preferences, and a short log of sections opened and playback errors, are
  kept on the device in user defaults and never leave it. The build declares
  this in `ios/PathOfNurTV/PrivacyInfo.xcprivacy`.
- Nothing is sent to us. The target has no analytics service, no advertising
  and no tracking. Its only network traffic is the recitation it streams and
  Apple's geocoder.

If the iPhone app's privacy answers differ (it has accounts and sync), the
record carries the iPhone app's answers: App Store Connect keeps one set per
app, and the stricter answer stands.
