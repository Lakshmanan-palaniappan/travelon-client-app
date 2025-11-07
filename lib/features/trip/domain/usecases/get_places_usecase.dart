

import 'package:Travelon/features/trip/domain/repository/trip_repository.dart';

class GetAgencyPlaces {
  final TripRepository repository;

  GetAgencyPlaces(this.repository);

  Future<List<dynamic>> call(String agencyId) async {
    return await repository.getAgencyPlaces(agencyId);
  }
}
