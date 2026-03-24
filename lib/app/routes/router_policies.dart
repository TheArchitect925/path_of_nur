bool isQuranLocation(String location) {
  return location.startsWith('/quran') ||
      location.startsWith('/quran-verse') ||
      location.startsWith('/learn/quran') ||
      location.startsWith('/learn/hub/quran');
}

String? redirectChildLearningLocation({
  required String matchedLocation,
  required bool isChildProfile,
}) {
  if (!isChildProfile || !matchedLocation.startsWith('/learn')) {
    return null;
  }
  if (isKidsLearningLocationAllowed(matchedLocation)) {
    if (matchedLocation == '/learn') {
      return '/learn/category/kids-learning';
    }
    return null;
  }
  return '/learn/category/kids-learning';
}

bool isKidsLearningLocationAllowed(String matchedLocation) {
  return matchedLocation == '/learn' ||
      matchedLocation == '/learn/category/kids-learning' ||
      matchedLocation.startsWith('/learn/kids/') ||
      matchedLocation.startsWith('/learn/quizzes/crossword') ||
      matchedLocation.startsWith('/learn/quizzes/word-search') ||
      matchedLocation.startsWith('/learn/quizzes/matching') ||
      matchedLocation.startsWith('/learn/quizzes/ayah-completion') ||
      matchedLocation.startsWith('/learn/quizzes/hadith-reflection') ||
      matchedLocation.startsWith('/learn/quizzes/daily-challenge');
}
