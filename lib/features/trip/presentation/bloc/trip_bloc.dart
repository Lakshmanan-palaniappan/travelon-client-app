import 'package:Travelon/features/trip/domain/repository/trip_repository.dart';
import 'package:Travelon/features/trip/domain/usecases/get_places_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart'; // for debugPrint
import 'package:meta/meta.dart';

part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final TripRepository tripRepository;
  final GetAgencyPlaces getAgencyPlaces;

  TripBloc({required this.getAgencyPlaces, required this.tripRepository})
    : super(TripInitial()) {
    on<FetchAgencyPlaces>(_onFetchAgencyPlaces);
    on<SubmitTripRequest>(_onSubmitTripRequest);
    on<SubmitTripWithPlaces>(_onSubmitTripWithPlaces);
  }

  Future<void> _onFetchAgencyPlaces(
    FetchAgencyPlaces event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());
    debugPrint(
      '🟩 FetchAgencyPlaces triggered for agencyId: ${event.agencyId}',
    );
    try {
      final places = await getAgencyPlaces(event.agencyId);
      debugPrint('✅ Places loaded: ${places.length}');
      emit(TripLoaded(places));
    } catch (e) {
      debugPrint('❌ Error loading places: $e');
      emit(TripError('Failed to load places: ${e.toString()}'));
    }
  }

  Future<void> _onSubmitTripRequest(
    SubmitTripRequest event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());
    debugPrint(
      '🟦 SubmitTripRequest triggered | touristId: ${event.touristId}, agencyId: ${event.agencyId}',
    );
    try {
      await tripRepository.requestTrip(
        touristId: event.touristId,
        agencyId: event.agencyId,
      );
      debugPrint('✅ Trip request sent (without places)');
      emit(TripRequestSuccess("Trip request created successfully!"));
    } catch (e) {
      debugPrint('❌ Failed to create trip request: $e');
      emit(TripRequestError("Failed to create trip request: $e"));
    }
  }

  Future<void> _onSubmitTripWithPlaces(
    SubmitTripWithPlaces event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());
    debugPrint(
      '🟨 SubmitTripWithPlaces triggered | touristId: ${event.touristId}, agencyId: ${event.agencyId}, places: ${event.placeIds}',
    );
    try {
      // Step 1: Create trip request
      final requestId = await tripRepository.requestTrip(
        touristId: event.touristId,
        agencyId: event.agencyId,
      );
      debugPrint('✅ Trip request created with requestId: $requestId');

      // Step 2: Select places
      await tripRepository.selectPlaces(
        requestId: requestId,
        placeIds: event.placeIds,
      );
      debugPrint('✅ Places sent to server: ${event.placeIds}');

      emit(TripRequestSuccess("Trip request created successfully!"));
    } catch (e) {
      debugPrint('❌ Failed to create trip with places: $e');
      emit(TripRequestError("Failed to create trip request: $e"));
    }
  }
}
