abstract class TripRepository {
  // 🔹 1. Get all places of an agency
  Future<List<dynamic>> getAgencyPlaces(String agencyId);

  // 🔹 2. Create a trip request (returns requestId as String)
  Future<String> requestTrip({
    required String touristId,
    required String agencyId,
  });

  // 🔹 3. Select places for that request
  Future<void> selectPlaces({
    required String requestId,
    required List<int> placeIds,
  });
}
