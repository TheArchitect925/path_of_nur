String? mapAppDeepLink(Uri uri) {
  if (uri.scheme != 'pathofnur') return null;

  final path = uri.path;
  if (uri.host == 'growth') {
    if (path == '/today') return '/journey/growth/today';
    if (path == '/reflection') return '/journey/growth/reflection';
    if (path == '/journey') return '/journey/growth/journey';
    if (path == '/habits') return '/journey/growth/habits';
    if (path.startsWith('/habit/')) {
      final id = path.substring('/habit/'.length);
      if (id.isNotEmpty) return '/journey/habit/$id';
    }
  }

  if (uri.host == 'quran' && path == '/read') {
    return '/quran/surah/1';
  }

  return null;
}
