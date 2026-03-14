import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final file = File('assets/data/baby_names_seed.json');

  test(
    'elite seed dataset has stable shape and balanced distribution',
    () async {
      expect(file.existsSync(), isTrue);

      final raw = await file.readAsString();
      final decoded = jsonDecode(raw);
      expect(decoded, isA<List<dynamic>>());
      final list = (decoded as List).cast<Map<String, dynamic>>();

      expect(list.length, 150);

      final required = <String>{
        'id',
        'name',
        'arabic',
        'transliteration',
        'gender',
        'meaning',
        'origin',
        'meaningThemes',
        'isQuranic',
        'associatedCategories',
        'startsWith',
      };

      final seenIds = <String>{};
      var male = 0;
      var female = 0;
      var unisex = 0;

      for (final entry in list) {
        for (final key in required) {
          expect(entry.containsKey(key), isTrue, reason: 'Missing key: $key');
        }

        final id = (entry['id'] ?? '').toString();
        expect(id, isNotEmpty);
        expect(seenIds.add(id), isTrue, reason: 'Duplicate id: $id');

        final gender = (entry['gender'] ?? '').toString();
        switch (gender) {
          case 'male':
            male += 1;
            break;
          case 'female':
            female += 1;
            break;
          case 'unisex':
            unisex += 1;
            break;
          default:
            fail('Invalid gender tag: $gender');
        }

        expect((entry['name'] ?? '').toString().trim(), isNotEmpty);
        expect((entry['arabic'] ?? '').toString().trim(), isNotEmpty);
        expect((entry['transliteration'] ?? '').toString().trim(), isNotEmpty);
        expect((entry['meaning'] ?? '').toString().trim(), isNotEmpty);
        expect(entry['origin'], isA<List<dynamic>>());
        expect((entry['origin'] as List).isNotEmpty, isTrue);
        expect(entry['meaningThemes'], isA<List<dynamic>>());
        expect((entry['meaningThemes'] as List).isNotEmpty, isTrue);
        expect((entry['startsWith'] ?? '').toString().trim(), isNotEmpty);
      }

      expect(male, 59);
      expect(female, 59);
      expect(unisex, 32);
    },
  );

  test(
    'elite seed includes core prophetic and companion-friendly coverage',
    () async {
      final raw = await file.readAsString();
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      final names = list
          .map((entry) => (entry['name'] ?? '').toString().toLowerCase())
          .toSet();

      final requiredSamples = <String>[
        'adam',
        'nuh',
        'ibrahim',
        'ismail',
        'ishaq',
        'yaqub',
        'yusuf',
        'musa',
        'harun',
        'dawud',
        'sulayman',
        'zakariya',
        'yahya',
        'isa',
        'ali',
        'umar',
        'uthman',
        'bilal',
        'talha',
        'zubair',
        'hamza',
        'ammar',
        'salman',
        'rayyan',
        'imran',
        'zayan',
        'maryam',
        'asiya',
        'hajar',
        'aisha',
        'fatima',
        'khadijah',
        'hafsa',
        'safiyyah',
        'zaynab',
        'ruqayyah',
        'sumayyah',
        'aminah',
        'huda',
        'farah',
        'yasmin',
        'noor',
        'nur',
        'iman',
        'ziya',
        'sidra',
      ];

      for (final sample in requiredSamples) {
        expect(
          names.contains(sample),
          isTrue,
          reason: 'Missing sample: $sample',
        );
      }
    },
  );
}
