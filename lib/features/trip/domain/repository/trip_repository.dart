import 'package:Travelon/features/trip/data/models/trip_with_places._model.dart';
import 'package:Travelon/features/trip/domain/entities/assigned_employee.dart';
import 'package:Travelon/features/trip/domain/entities/current_trip.dart';
import 'package:Travelon/features/trip/domain/entities/trip.dart';
import 'package:Travelon/features/trip/domain/entities/trip_with_places.dart';

abstract class TripRepository {
  // Future<Map<String, dynamic>?> getCurrentTrip();

  Future<CurrentTrip?> getCurrentTrip();
  // 🔹 1. Get all places of an agency
  Future<List<dynamic>> getAgencyPlaces(String agencyId);

  // 🔹 2. Create a trip request (returns requestId as String)
  Future<String> requestTrip({
    required String touristId,
    required String agencyId,
        required DateTime StartDate,
        required DateTime EndDate,
  });

  // 🔹 3. Select places for that request
  Future<void> selectPlaces({
    required String requestId,
    required List<int> placeIds,
  });

  Future<void> rateEmployee({
    required int tripId,
    required int employeeId,
    required int rating,
  });

  Future<Map<String, dynamic>> getRatingStatus({
    required int tripId,
  });


  Future<AssignedEmployee?> getAssignedEmployee();


  
  Future<List<Trip>> getTouristTrips(String touristId);

    // Future<List<TripWithPlaces>> getTouristTripsWithPlaces(String touristId);


  // Future<List<TripWithPlacesModel>> getTouristTripsWithPlaces(String touristId);

  Future<List<TripWithPlaces>> getTouristTripsPlaces(String touristId);
}
