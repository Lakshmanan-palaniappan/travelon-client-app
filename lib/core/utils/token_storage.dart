import 'dart:convert';
import 'package:Travelon/features/auth/data/models/tourist_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/domain/entities/tourist.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'token';
  static const _keyRefreshToken = 'refreshToken';
  static const _keyTouristID = 'touristId';
  static const _keyKYCURL = 'kycURL';
  static const _keyAgencyId = 'agencyId';
  static const _keyTouristData = 'touristData'; // ✅ new key

  static const _keyRequestId = 'requestId';

  static Future<void> saveRequestId({required requestId}) async {
    await _storage.write(key: _keyRequestId, value: requestId);
  }

  // Save all tokens and info
  static Future<void> saveAuthData({
    required String token,
    required String refreshToken,
    String? touristId,
    String? kycURL,
    String? agencyId,
    String? requestId,
  }) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    if (touristId != null)
      await _storage.write(key: _keyTouristID, value: touristId);
    if (kycURL != null) await _storage.write(key: _keyKYCURL, value: kycURL);
    if (agencyId != null)
      await _storage.write(key: _keyAgencyId, value: agencyId);
    if (requestId != null)
      await _storage.write(key: _keyRequestId, value: requestId);
  }

  // ✅ Save full Tourist entity
  static Future<void> saveTourist(Tourist tourist) async {
    // Ensure we use API-style keys to match TouristModel.fromJson
    final jsonStr = jsonEncode({
      "TouristId": tourist.id,
      "Name": tourist.name,
      "Email": tourist.email,
      "Contact": tourist.contact,
      "AgencyId": tourist.agencyId,
    });
    await _storage.write(key: _keyTouristData, value: jsonStr);
  }

  // ✅ Retrieve full Tourist entity
  static Future<TouristModel?> getTourist() async {
    final jsonStr = await _storage.read(key: _keyTouristData);
    if (jsonStr == null) return null;
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    return TouristModel.fromJson(json);
  }

  // Read individual values
  static Future<String?> getToken() => _storage.read(key: _keyToken);
  static Future<String?> getRefreshToken() =>
      _storage.read(key: _keyRefreshToken);
  static Future<String?> getTouristId() => _storage.read(key: _keyTouristID);
  static Future<String?> getKycHash() => _storage.read(key: _keyKYCURL);
  static Future<String?> getAgencyId() => _storage.read(key: _keyAgencyId);
  static Future<String?> getRequestId() => _storage.read(key: _keyRequestId);

  // Clear all
  static Future<void> clear() async => _storage.deleteAll();
}
