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

/// ---------------------------------------------------------------------------
/// TripRepositoryImpl
/// ---------------------------------------------------------------------------
/// Implementation of [TripRepository].
/// 
/// This class orchestrates data flow between [TripRemoteDataSource] and 
/// the Domain layer. It handles:
/// - Mapping Data Models to Domain Entities.
/// - Requesting and selecting trip locations.
/// - Managing trip-related tokens (Request IDs).
/// - Handling employee ratings and status checks.
/// ---------------------------------------------------------------------------
class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;
  final ApiClient apiClient;

  TripRepositoryImpl(this.remoteDataSource, this.apiClient);

  @override
  Future<List<dynamic>> getAgencyPlaces(String agencyId) {
    return remoteDataSource.getAgencyPlaces(agencyId);
  }

  /// -------------------------------------------------------------------------
  /// Helper: _formatDate
  /// -------------------------------------------------------------------------
  /// Formats a [DateTime] to a YYYY-MM-DD string required by the backend.
  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

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

    final response = await apiClient.post('/trip-request/request', body);

    if (response.statusCode == 200) {
      // Extracting RequestId from nested or flat response structure
      final reqId =
          response.data['RequestId']?.toString() ??
          response.data['data']?['RequestId']?.toString() ??
          "";

      // Persistence: Save the RequestId locally for later stages of trip creation
      TokenStorage.saveRequestId(requestId: reqId);

      return reqId;
    } else {
      throw Exception("Trip Request Failed: ${response.data}");
    }
  }

  @override
  Future<void> selectPlaces({
    required String requestId,
    required List<int> placeIds,
  }) async {
    final body = {"requestId": requestId, "placeIds": placeIds};

    final response = await apiClient.post('/trip-request/select-places', body);

    if (response.statusCode != 200) {
      throw Exception("Failed to add places: ${response.data}");
    }
  }

  @override
  Future<AssignedEmployee?> getAssignedEmployee() async {
    final data = await remoteDataSource.getAssignedEmployee();
    if (data == null) return null;

    // Conversion: Map JSON map -> Data Model -> Domain Entity
    return AssignedEmployeeModel.fromJson(data).toEntity();
  }

  @override
  Future<CurrentTrip?> getCurrentTrip() async {

    final res = await apiClient.get("/trip/current");

    final data = res.data?['data'];
    if (data == null) {
      return null;
    }

    // Direct conversion to CurrentTrip entity
    final trip = CurrentTrip.fromJson(data);
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
      final List<TripWithPlacesModel> models = await remoteDataSource
          .getTouristTripsPlaces(touristId);

      // Casting Model list to Entity list for Domain consumption
      return models.cast<TripWithPlaces>();
    } catch (e) {
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
}