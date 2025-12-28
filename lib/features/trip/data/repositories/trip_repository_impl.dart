import 'package:Travelon/core/network/apiclient.dart';
import 'package:Travelon/core/utils/token_storage.dart';
import 'package:Travelon/features/trip/data/datasources/trip_remote_datasource.dart';
import 'package:Travelon/features/trip/data/models/assigned_employee_model.dart';
import 'package:Travelon/features/trip/domain/entities/assigned_employee.dart';
import 'package:Travelon/features/trip/domain/entities/current_trip.dart';
import 'package:Travelon/features/trip/domain/entities/trip.dart';
import 'package:Travelon/features/trip/domain/repository/trip_repository.dart';
import 'package:flutter/material.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;
  final ApiClient apiClient;

  TripRepositoryImpl(this.remoteDataSource, this.apiClient);

  @override
  Future<List<dynamic>> getAgencyPlaces(String agencyId) {
    return remoteDataSource.getAgencyPlaces(agencyId);
  }

  // Format date -> "YYYY-MM-DD"
  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  // -------------------------------------------
  // CREATE TRIP REQUEST
  // -------------------------------------------
  @override
  Future<String> requestTrip({
    required String touristId,
    required String agencyId,
    required DateTime StartDate,
    required DateTime EndDate,
  }) async {
    final body = {
      "touristId": touristId,
      "agencyId": agencyId,
      "startDate": _formatDate(StartDate),
      "endDate": _formatDate(EndDate),
    };

    print("📤 Sending trip request body => $body");

    final response = await apiClient.post('/trip-request/request', body);

    print("📥 Server Response => ${response.data}");

    if (response.statusCode == 200) {
      final reqId =
          response.data['RequestId']?.toString() ??
          response.data['data']?['RequestId']?.toString() ??
          "";

      TokenStorage.saveRequestId(requestId: reqId);

      print("✅ Trip Request Created : $reqId");
      return reqId;
    } else {
      throw Exception("Trip Request Failed: ${response.data}");
    }
  }

  // -------------------------------------------
  // SELECT PLACES
  // -------------------------------------------
  @override
  Future<void> selectPlaces({
    required String requestId,
    required List<int> placeIds,
  }) async {
    final body = {"requestId": requestId, "placeIds": placeIds};

    print("📤 Sending selectPlaces body => $body");

    final response = await apiClient.post('/trip-request/select-places', body);

    print("📥 SelectPlaces Response => ${response.data}");

    if (response.statusCode == 200) {
      print("✅ Places added successfully");
    } else {
      throw Exception("Failed to add places: ${response.data}");
    }
  }

  @override
  Future<AssignedEmployee?> getAssignedEmployee() async {
    final data = await remoteDataSource.getAssignedEmployee();
    if (data == null) return null;

    return AssignedEmployeeModel.fromJson(data).toEntity();
  }

  // @override
  // Future<Map<String, dynamic>?> getCurrentTrip() async {
  //   print("🫠🫠🫠🫠🫠🫠-----------------");
  //   final res = await apiClient.get("/trip/current");
  //   print("-----------------🫠🫠🫠🫠🫠🫠");
  //   print(res.data);
  //   return res.data;
  // }

  @override
  Future<CurrentTrip?> getCurrentTrip() async {
    debugPrint("📡 Fetching current trip");

    final res = await apiClient.get("/trip/current");

    print(res.toString());

    final data = res.data?['data'];
    if (data == null) {
      debugPrint("🚫 No active trip");
      return null;
    }

    final trip = CurrentTrip.fromJson(data);

    debugPrint("🧭 Trip status = ${trip.status}");

    return trip;
  }

  @override
Future<List<Trip>> getTouristTrips(String touristId) async {
  final models = await remoteDataSource.getTouristTrips(touristId);
  return models;
}

}
