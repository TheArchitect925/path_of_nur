String? mapAppDeepLink(Uri uri) {
  if (uri.scheme != 'pathofnur') return null;

  final path = _normalizedPath(uri);
  final host = uri.host.toLowerCase();
  final quranPath = host == 'quran' && !path.startsWith('/quran')
      ? '/quran$path'
      : path;

  if (path.startsWith('/home')) return _pathWithQuery('/home', uri);
  if (path.startsWith('/worship')) return _pathWithQuery('/worship', uri);
  if (path == '/prayer' || path.startsWith('/prayer/')) {
    return _pathWithQuery('/worship/prayer', uri);
  }
  if (path == '/dhikr' || path.startsWith('/dhikr/')) {
    return _pathWithQuery('/worship/dhikr', uri);
  }

  if (host == 'growth' || path.startsWith('/growth')) {
    final growthPath = host == 'growth'
        ? uri.path
        : path.substring('/growth'.length);
    if (growthPath == '/today') return _pathWithQuery('/journey/today', uri);
    if (growthPath == '/reflection') {
      return _pathWithQuery('/journey/reflection', uri);
    }
    if (growthPath == '/journey') {
      return _pathWithQuery('/journey/progress', uri);
    }
    if (growthPath == '/habits') return _pathWithQuery('/journey/habits', uri);
    if (growthPath.startsWith('/habit/')) {
      final id = growthPath.substring('/habit/'.length);
      if (id.isNotEmpty) return _pathWithQuery('/journey/habit/$id', uri);
    }
  }

  if (path.startsWith('/progress')) {
    return _pathWithQuery('/journey/progress', uri);
  }
  if (path.startsWith('/journey')) return _pathWithQuery(path, uri);
  if (quranPath.startsWith('/quran')) {
    return _pathWithQuery(
      quranPath == '/quran/read' ? '/quran/surah/1' : quranPath,
      uri,
    );
  }
  if (path.startsWith('/learn')) return _pathWithQuery(path, uri);
  if (path.startsWith('/ocean')) return _pathWithQuery('/journey/ocean', uri);
  if (path.startsWith('/garden')) return _pathWithQuery('/journey/garden', uri);
  if (path.startsWith('/tracking')) {
    return _pathWithQuery('/journey/statistics', uri);
  }

  if (path == "/") {
    return _pathWithQuery('/home', uri);
  }

  return null;
}

String _pathWithQuery(String path, Uri uri) {
  return Uri(
    path: path,
    queryParameters: uri.queryParameters.isEmpty ? null : uri.queryParameters,
  ).toString();
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
