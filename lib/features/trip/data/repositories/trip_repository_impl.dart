import 'package:Travelon/core/network/apiclient.dart';
import 'package:Travelon/core/utils/token_storage.dart';
import 'package:Travelon/features/trip/data/datasources/trip_remote_datasource.dart';
import 'package:Travelon/features/trip/data/models/assigned_employee_model.dart';
import 'package:Travelon/features/trip/data/models/trip_with_places._model.dart';
import 'package:Travelon/features/trip/domain/entities/assigned_employee.dart';
import 'package:Travelon/features/trip/domain/entities/current_trip.dart';
import 'package:Travelon/features/trip/domain/entities/trip.dart';
import 'package:Travelon/features/trip/domain/entities/trip_with_places.dart';
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


    final data = res.data?['data'];
    if (data == null) {
      debugPrint("🚫 No active trip");
      return null;
    }

    final trip = CurrentTrip.fromJson(data);
    debugPrint("Parsed Current Trip: ${res.toString()}");

    debugPrint("🧭 Trip status = ${trip.status}");

    return trip;
  }

  @override
  Future<List<Trip>> getTouristTrips(String touristId) async {
    final models = await remoteDataSource.getTouristTrips(touristId);
    return models;
  }

  @override
  Future<List<TripWithPlacesModel>> getTouristTripsWithPlaces(
      String touristId,
      ) async {
    final res = await apiClient.get('/trip/tourist/$touristId');

    // 🔽 PRINT RAW API RESPONSE
    debugPrint("📥 /trip/tourist/$touristId RAW RESPONSE:");
    debugPrint(res.data.toString());

    final data = res.data?['data'];
    if (data is! List) {
      throw Exception('Invalid trips response');
    }

    return data
        .map<TripWithPlacesModel>((e) => TripWithPlacesModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<TripWithPlaces>> getTouristTripsPlaces(String touristId) async {
    try {
      // 1. Get the list of models from the DataSource
      final List<TripWithPlacesModel> models = await remoteDataSource
          .getTouristTripsPlaces(touristId);

      // 2. Cast the list to the Entity type so it matches the return signature
      return models.cast<TripWithPlaces>();
    } catch (e) {
      debugPrint("Repository Error: $e");
      throw Exception("Could not load trip itineraries");
    }
  }

  @override
  Future<void> rateEmployee({
    required int tripId,
    required int employeeId,
    required int rating,
  }) async {
    final body = {
      "tripId": tripId,
      "employeeId": employeeId,
      "rating": rating,
    };

    final response = await apiClient.post("/employee/rate", body);

    if (response.statusCode != 200) {
      throw Exception("Failed to rate employee");
    }
  }

  @override
  Future<Map<String, dynamic>> getRatingStatus({required int tripId}) async {
    final res = await apiClient.get("/employee/rating-status?tripId=$tripId");

    if (res.statusCode != 200) {
      throw Exception("Failed to get rating status");
    }

    return res.data["data"];
  }



// @override
  // Future<List<TripWithPlaces>> getTouristTripsWithPlaces(
  //   String touristId,
  // ) async {
  //   final trips = await remoteDataSource.getTouristTripsGeneric<TripWithPlaces>(
  //     touristId,
  //     (json) => TripWithPlaces.fromJson(json),
  //   );

  //   return trips; // Already a List<TripWithPlaces>
  // }
}
