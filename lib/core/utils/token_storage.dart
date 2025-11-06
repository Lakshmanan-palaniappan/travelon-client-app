import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'token';
  static const _keyRefreshToken = 'refreshToken';
  static const _keyTouristID = 'touristId'; // ✅ consistent name
  static const _keyKYCHash = 'kycHash';
  static const _keyAgencyId = 'agencyId';

  // Save all tokens and info
  static Future<void> saveAuthData({
    required String token,
    required String refreshToken,
    String? touristId,
    String? kycHash,
    String? agencyId,
  }) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    if (touristId != null) {
      await _storage.write(key: _keyTouristID, value: touristId);
    }
    if (kycHash != null) {
      await _storage.write(key: _keyKYCHash, value: kycHash);
    }
    if (agencyId != null) {
      await _storage.write(key: _keyAgencyId, value: agencyId);
    }
  }

  // Read
  static Future<String?> getToken() => _storage.read(key: _keyToken);
  static Future<String?> getRefreshToken() =>
      _storage.read(key: _keyRefreshToken);
  static Future<String?> getTouristId() => _storage.read(key: _keyTouristID);
  static Future<String?> getKycHash() => _storage.read(key: _keyKYCHash);
  static Future<String?> getAgencyId() => _storage.read(key: _keyAgencyId);

  // Clear all
  static Future<void> clear() async => _storage.deleteAll();
}
