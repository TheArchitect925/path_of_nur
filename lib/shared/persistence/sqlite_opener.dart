// Native builds reach SQLite through FFI; the web build loads it as
// WebAssembly (web/sqlite3.wasm) and keeps the file in IndexedDB.
export 'sqlite_opener_native.dart'
    if (dart.library.js_interop) 'sqlite_opener_web.dart';
