import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/tourist_model.dart';

abstract class TouristRemoteDataSource {
  Future<Map<String, dynamic>> registerTourist(
    TouristModel tourist,
    File kycFile,
  );
}

class TouristRemoteDataSourceImpl implements TouristRemoteDataSource {
  final String baseUrl = "http://192.168.185.152:5821/api/tourist";

  @override
  Future<Map<String, dynamic>> registerTourist(
    TouristModel tourist,
    File kycFile,
  ) async {
    final uri = Uri.parse("$baseUrl/register");
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll(tourist.toJson());
    if (kycFile.path.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('KycFile', kycFile.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to register tourist: ${response.body}");
    }
  }
}
