String? mapAppDeepLink(Uri uri) {
  if (uri.scheme != 'pathofnur') return null;

  final path = _normalizedPath(uri);
  final host = uri.host.toLowerCase();

  if (path.startsWith('/home')) return '/home';
  if (path.startsWith('/worship')) return '/worship';
  if (path == '/prayer' || path.startsWith('/prayer/')) return '/worship';
  if (path == '/dhikr' || path.startsWith('/dhikr/')) return '/worship';
  if (path.startsWith('/progress')) return '/journey/growth/today';
  if (path.startsWith('/journey')) return path;
  if (path.startsWith('/quran')) {
    return path == '/quran/read' ? '/quran/surah/1' : path;
  }
  if (path.startsWith('/learn')) return path;
  if (path.startsWith('/ocean')) return '/journey/ocean';
  if (path.startsWith('/garden')) return '/journey/garden';
  if (path.startsWith('/tracking')) return '/journey/tracking';

  if (host == 'growth' || path.startsWith('/growth')) {
    final growthPath = host == 'growth'
        ? uri.path
        : path.substring('/growth'.length);
    if (growthPath == '/today') return '/journey/growth/today';
    if (growthPath == '/reflection') return '/journey/growth/reflection';
    if (growthPath == '/journey') return '/journey/growth/journey';
    if (growthPath == '/habits') return '/journey/growth/habits';
    if (growthPath.startsWith('/habit/')) {
      final id = growthPath.substring('/habit/'.length);
      if (id.isNotEmpty) return '/journey/habit/$id';
    }
  }

  if (host == 'quran' && uri.path == '/read') {
    return '/quran/surah/1';
  }

  if (path == "/") {
    return '/home';
  }

  return null;
}

String _normalizedPath(Uri uri) {
  if (uri.path.isNotEmpty) {
    return uri.path;
  }
  if (uri.host.isNotEmpty) {
    return '/${uri.host}';
  }
  return '/';
}
