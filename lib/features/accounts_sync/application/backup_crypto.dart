import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';

/// Passphrase-based encryption for manual backup exports.
///
/// Envelope format (versioned JSON):
/// ```json
/// {
///   "format": "pon-backup-enc",
///   "version": 1,
///   "kdf": {"algo": "pbkdf2-hmac-sha256", "iterations": 150000, "salt": "…"},
///   "cipher": {"algo": "aes-256-gcm", "nonce": "…"},
///   "data": "base64(ciphertext)",
///   "mac": "base64(gcm tag)"
/// }
/// ```
const String backupEnvelopeFormat = 'pon-backup-enc';
const int backupEnvelopeVersion = 1;
const String backupKdfAlgorithm = 'pbkdf2-hmac-sha256';
const String backupCipherAlgorithm = 'aes-256-gcm';
const int backupKdfIterations = 150000;
const int backupKdfSaltLength = 16;
const int backupCipherNonceLength = 12;
const int backupMinimumPassphraseLength = 8;

/// Thrown when an encrypted backup envelope cannot be opened.
class BackupDecryptionException implements Exception {
  const BackupDecryptionException(this.code);

  /// One of `wrong_passphrase` or `unsupported_envelope`.
  final String code;

  @override
  String toString() => 'BackupDecryptionException($code)';
}

/// Whether a decoded JSON value is a passphrase-encrypted backup envelope.
bool isEncryptedBackupEnvelope(Object? decoded) =>
    decoded is Map && decoded['format'] == backupEnvelopeFormat;

/// Encrypts [plaintext] with a key derived from [passphrase] and returns the
/// serialized envelope JSON. Key derivation and encryption run off the main
/// isolate because PBKDF2 at production iteration counts is noticeably slow.
Future<String> encryptBackupPayload(
  String plaintext,
  String passphrase, {
  int iterations = backupKdfIterations,
}) {
  final random = Random.secure();
  final salt = Uint8List.fromList(
    List<int>.generate(backupKdfSaltLength, (_) => random.nextInt(256)),
  );
  final nonce = Uint8List.fromList(
    List<int>.generate(backupCipherNonceLength, (_) => random.nextInt(256)),
  );
  return compute(_encryptWorker, <String, Object>{
    'plaintext': plaintext,
    'passphrase': passphrase,
    'iterations': iterations,
    'salt': salt,
    'nonce': nonce,
  });
}

/// Decrypts a parsed envelope map produced by [encryptBackupPayload].
///
/// Throws [BackupDecryptionException] with code `wrong_passphrase` when the
/// authentication tag does not verify, and `unsupported_envelope` when the
/// envelope declares parameters this build cannot handle.
Future<String> decryptBackupEnvelope(
  Map<String, dynamic> envelope,
  String passphrase,
) async {
  final version = (envelope['version'] as num?)?.toInt();
  final kdf = envelope['kdf'];
  final cipher = envelope['cipher'];
  if (envelope['format'] != backupEnvelopeFormat ||
      version == null ||
      version > backupEnvelopeVersion ||
      kdf is! Map ||
      cipher is! Map ||
      kdf['algo'] != backupKdfAlgorithm ||
      cipher['algo'] != backupCipherAlgorithm) {
    throw const BackupDecryptionException('unsupported_envelope');
  }
  final iterations = (kdf['iterations'] as num?)?.toInt();
  Uint8List salt;
  Uint8List nonce;
  Uint8List cipherText;
  Uint8List mac;
  try {
    salt = base64Decode(kdf['salt']?.toString() ?? '');
    nonce = base64Decode(cipher['nonce']?.toString() ?? '');
    cipherText = base64Decode(envelope['data']?.toString() ?? '');
    mac = base64Decode(envelope['mac']?.toString() ?? '');
  } on FormatException {
    throw const BackupDecryptionException('unsupported_envelope');
  }
  if (iterations == null || iterations <= 0 || salt.isEmpty || nonce.isEmpty) {
    throw const BackupDecryptionException('unsupported_envelope');
  }
  final result = await compute(_decryptWorker, <String, Object>{
    'passphrase': passphrase,
    'iterations': iterations,
    'salt': salt,
    'nonce': nonce,
    'cipherText': cipherText,
    'mac': mac,
  });
  final plaintext = result['plaintext'];
  if (plaintext is String) {
    return plaintext;
  }
  throw BackupDecryptionException(
    result['error']?.toString() ?? 'wrong_passphrase',
  );
}

Future<SecretKey> _deriveKey(
  String passphrase,
  Uint8List salt,
  int iterations,
) {
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: 256,
  );
  return pbkdf2.deriveKeyFromPassword(password: passphrase, nonce: salt);
}

Future<String> _encryptWorker(Map<String, Object> args) async {
  final iterations = args['iterations'] as int;
  final salt = args['salt'] as Uint8List;
  final nonce = args['nonce'] as Uint8List;
  final key = await _deriveKey(args['passphrase'] as String, salt, iterations);
  final secretBox = await AesGcm.with256bits().encrypt(
    utf8.encode(args['plaintext'] as String),
    secretKey: key,
    nonce: nonce,
  );
  return jsonEncode(<String, dynamic>{
    'format': backupEnvelopeFormat,
    'version': backupEnvelopeVersion,
    'kdf': <String, dynamic>{
      'algo': backupKdfAlgorithm,
      'iterations': iterations,
      'salt': base64Encode(salt),
    },
    'cipher': <String, dynamic>{
      'algo': backupCipherAlgorithm,
      'nonce': base64Encode(nonce),
    },
    'data': base64Encode(secretBox.cipherText),
    'mac': base64Encode(secretBox.mac.bytes),
  });
}

Future<Map<String, String>> _decryptWorker(Map<String, Object> args) async {
  final key = await _deriveKey(
    args['passphrase'] as String,
    args['salt'] as Uint8List,
    args['iterations'] as int,
  );
  final secretBox = SecretBox(
    args['cipherText'] as Uint8List,
    nonce: args['nonce'] as Uint8List,
    mac: Mac(args['mac'] as Uint8List),
  );
  try {
    final clearBytes = await AesGcm.with256bits().decrypt(
      secretBox,
      secretKey: key,
    );
    return <String, String>{'plaintext': utf8.decode(clearBytes)};
  } on SecretBoxAuthenticationError {
    return const <String, String>{'error': 'wrong_passphrase'};
  } catch (_) {
    return const <String, String>{'error': 'wrong_passphrase'};
  }
}
