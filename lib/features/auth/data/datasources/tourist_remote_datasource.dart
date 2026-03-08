import 'dart:io';
import 'package:Travelon/core/network/apiclient.dart';
import 'package:Travelon/core/utils/error_helper.dart';
import 'package:dio/dio.dart';
import '../models/tourist_model.dart';

/// ---------------------------------------------------------------------------
/// TouristRemoteDataSource
/// ---------------------------------------------------------------------------
/// Abstract contract for tourist-related network operations.
/// 
/// Defines the required methods for account lifecycle management, including
/// authentication, profile synchronization, and security updates.
/// ---------------------------------------------------------------------------
abstract class TouristRemoteDataSource {
  Future<Map<String, dynamic>> registerTourist(TouristModel tourist, File kycFile);
  Future<void> updateTourist(String touristId, Map<String, dynamic> data);
  Future<Map<String, dynamic>> loginTourist(String email, String password);
  Future<TouristModel> getTouristById(String touristId);
  Future<void> forgotPassword(String email);
  Future<void> changePassword({
    required String touristId,
    required String oldPassword,
    required String newPassword,
  });
}

/// ---------------------------------------------------------------------------
/// TouristRemoteDataSourceImpl
/// ---------------------------------------------------------------------------
/// Concrete implementation using [ApiClient] to communicate with the backend.
/// ---------------------------------------------------------------------------
class TouristRemoteDataSourceImpl implements TouristRemoteDataSource {
  final ApiClient apiClient;

  TouristRemoteDataSourceImpl(this.apiClient);

  /// -------------------------------------------------------------------------
  /// registerTourist
  /// -------------------------------------------------------------------------
  /// Performs a multipart POST request to register a new user.
  /// 
  /// Logic:
  /// - Sends [TouristModel] JSON alongside a physical [kycFile].
  /// - Uses a specialized [postMultipart] helper to handle the binary stream.
  /// - Integrates [DioErrorHandler] for granular network error reporting.
  /// -------------------------------------------------------------------------
  @override
  Future<Map<String, dynamic>> registerTourist(
    TouristModel tourist,
    File kycFile,
  ) async {
    try {
      final response = await apiClient.postMultipart(
        "/tourist/register",
        tourist.toJson(),
        kycFile.path,
        "KycFile",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception("Failed to register.");
      }
    } on DioException catch (e) {
      final message = DioErrorHandler.handle(e);
      throw Exception(message);
    } catch (e) {
      throw Exception("Unexpected error occurred.");
    }
  }

  @override
  Future<Map<String, dynamic>> loginTourist(String email, String password) async {
    final response = await apiClient.post("/login", {
      "Username": email,
      "Password": password,
    });

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception("Failed to login: ${response.data}");
    }
  }

  /// -------------------------------------------------------------------------
  /// getTouristById
  /// -------------------------------------------------------------------------
  /// Fetches the complete profile model for a specific tourist.
  /// 
  /// Logic:
  /// - Accesses the `/tourist/$touristId` endpoint.
  /// - Extracts data from the standard 'data' envelope used by your API.
  /// -------------------------------------------------------------------------
  @override
  Future<TouristModel> getTouristById(String touristId) async {
    final response = await apiClient.get('/tourist/$touristId');

    if (response.statusCode == 200) {
      return TouristModel.fromJson(response.data['data']);
    } else {
      throw Exception("Failed to fetch tourist");
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    final response = await apiClient.post("/forgot-password", {"email": email});
    if (response.statusCode != 200) throw Exception("Failed to send reset link");
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String touristId,
  }) async {
    final response = await apiClient.patch("/tourist/change-password", {
      "touristId": touristId,
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });

    if (response.statusCode != 200) {
      throw Exception(response.data?['message'] ?? "Failed to change password");
    }
  }

  @override
  Future<void> updateTourist(String touristId, Map<String, dynamic> data) async {
    final response = await apiClient.put("/tourist/$touristId", data);
    if (response.statusCode != 200) {
      throw Exception(response.data?['message'] ?? "Failed to update profile");
    }
  }
}