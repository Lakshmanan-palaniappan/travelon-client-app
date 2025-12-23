import 'dart:io';
import 'package:Travelon/core/network/apiclient.dart';
import '../models/tourist_model.dart';

/// Abstract data source defining the remote operations
abstract class TouristRemoteDataSource {
  Future<Map<String, dynamic>> registerTourist(
    TouristModel tourist,
    File kycFile,
  );

  Future<Map<String, dynamic>> loginTourist(String email, String password);

  Future<Map<String, dynamic>> getTouristById(String touristId);

 Future<void> forgotPassword(String email);
}

/// Implementation of the remote data source
class TouristRemoteDataSourceImpl implements TouristRemoteDataSource {
  final ApiClient apiClient;

  TouristRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> registerTourist(
    TouristModel tourist,
    File kycFile,
  ) async {
    print("🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣");
    print(tourist);
    print("🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣--------------------");
    print(tourist.userType);
    final response = await apiClient.postMultipart(
      "/tourist/register",
      tourist.toJson(),
      kycFile.path,
      "KycFile",
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Received RAW Data : ${response.data.toString()}");
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception("❌ Failed to register tourist: ${response.data}");
    }
  }

  @override
  Future<Map<String, dynamic>> loginTourist(
    String email,
    String password,
  ) async {
    final response = await apiClient.post("/login", {
      "Username": email,
      "Password": password,
    });

    if (response.statusCode == 200) {
      print(response.data.toString());
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception("❌ Failed to login: ${response.data}");
    }
  }

  /// ✅ New: Get agency info by Tourist ID
  @override
  Future<Map<String, dynamic>> getTouristById(String touristId) async {
    final response = await apiClient.get('/tourist/$touristId');
    print('🛰 Raw response from /tourist/$touristId → ${response.data}');

    if (response.statusCode == 200) {
      final data = response.data['data'];

      return data as Map<String, dynamic>;
    } else {
      throw Exception("❌ Failed to fetch tourist by ID: ${response.data}");
    }
  }
  
@override
Future<void> forgotPassword(String email) async {
  final response = await apiClient.post(
    "/forgot-password",
    {"email": email},
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to send reset link");
  }
}


}
