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
  static const _keyTouristData = 'touristData';
  static const _keyRequestId = 'requestId';

  // -----------------------------
  // Request ID
  // -----------------------------
  static Future<void> saveRequestId({required String requestId}) async {
    await _storage.write(key: _keyRequestId, value: requestId);
  }

  static Future<String?> getRequestId() => _storage.read(key: _keyRequestId);

  static Future<void> clearRequestId() async {
    await _storage.delete(key: _keyRequestId);
  }

  // -----------------------------
  // Auth Data
  // -----------------------------
  static Future<void> saveAuthData({
    required String token,
    required String refreshToken,
    String? touristId,
    String? kycURL,
    String? agencyId,
  }) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);

    if (touristId != null) {
      await _storage.write(key: _keyTouristID, value: touristId);
    }
    if (kycURL != null) {
      await _storage.write(key: _keyKYCURL, value: kycURL);
    }
    if (agencyId != null) {
      await _storage.write(key: _keyAgencyId, value: agencyId);
    }
  }



  // -----------------------------
  // Tourist Entity
  // -----------------------------
  // static Future<void> saveTourist(Tourist tourist) async {
  //   final jsonStr = jsonEncode({
  //     "TouristId": tourist.id,
  //     "Name": tourist.name,
  //     "Email": tourist.email,
  //     "Contact": tourist.contact,
  //     "AgencyId": tourist.agencyId,
  //   });

  //   await _storage.write(key: _keyTouristData, value: jsonStr);
  // }
static Future<void> saveTourist(Tourist tourist) async {
  final model = TouristModel.fromEntity(tourist);
  final jsonStr = jsonEncode(model.toJson());
  await _storage.write(key: _keyTouristData, value: jsonStr);
}

static Future<Tourist?> getTourist() async {
  final jsonStr = await _storage.read(key: _keyTouristData);
  if (jsonStr == null) return null;

  final model = TouristModel.fromJson(jsonDecode(jsonStr));
  return model.toEntity(); // ✅ convert to entity
}


  // -----------------------------
  // Reads
  // -----------------------------
  static Future<String?> getToken() => _storage.read(key: _keyToken);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: _keyRefreshToken);

  static Future<String?> getTouristId() => _storage.read(key: _keyTouristID);

  static Future<String?> getKycHash() => _storage.read(key: _keyKYCURL);

  static Future<String?> getAgencyId() => _storage.read(key: _keyAgencyId);

  // -----------------------------
  // Clear All
  // -----------------------------
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
