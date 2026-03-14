import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/creation_explorer_models.dart';

final creationCategoryMappingServiceProvider =
    Provider<CreationCategoryMappingService>(
      (ref) => const CreationCategoryMappingService(),
    );

class CreationCategoryMappingService {
  const CreationCategoryMappingService();

  CreationCategoryId? mapRawLabel(String label) {
    final normalized = label.toLowerCase().trim();
    if (_matches(normalized, const <String>[
      'dog',
      'golden retriever',
      'retriever',
      'labrador',
      'cat',
      'kitten',
      'horse',
      'cow',
      'goat',
      'sheep',
      'mammal',
      'animal',
      'deer',
    ])) {
      return CreationCategoryId.animals;
    }
    if (_matches(normalized, const <String>[
      'bird',
      'sparrow',
      'eagle',
      'hawk',
      'pigeon',
      'duck',
      'goose',
      'owl',
    ])) {
      return CreationCategoryId.birds;
    }
    if (_matches(normalized, const <String>[
      'bee',
      'butterfly',
      'insect',
      'bug',
      'beetle',
      'dragonfly',
      'ant',
    ])) {
      return CreationCategoryId.insects;
    }
    if (_matches(normalized, const <String>[
      'tree',
      'oak tree',
      'pine tree',
      'palm tree',
      'maple',
    ])) {
      return CreationCategoryId.trees;
    }
    if (_matches(normalized, const <String>[
      'flower',
      'flowering plant',
      'plant',
      'leaf',
      'grass',
      'vegetation',
      'houseplant',
    ])) {
      return CreationCategoryId.plants;
    }
    if (_matches(normalized, const <String>[
      'river',
      'lake',
      'ocean',
      'sea',
      'water',
      'waterfall',
      'stream',
    ])) {
      return CreationCategoryId.water;
    }
    if (_matches(normalized, const <String>[
      'mountain',
      'hill',
      'peak',
      'cliff',
    ])) {
      return CreationCategoryId.mountains;
    }
    if (_matches(normalized, const <String>[
      'rock',
      'stone',
      'desert',
      'sand',
      'valley',
      'canyon',
      'landscape',
    ])) {
      return CreationCategoryId.landscape;
    }
    if (_matches(normalized, const <String>[
      'sky',
      'cloud',
      'clouds',
      'sunrise',
      'sunset',
    ])) {
      return CreationCategoryId.sky;
    }
    return null;
  }

  bool _matches(String value, List<String> patterns) {
    for (final pattern in patterns) {
      if (value == pattern || value.contains(pattern)) return true;
    }
    return false;
  }
}
