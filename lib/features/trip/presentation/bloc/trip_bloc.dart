import 'package:Travelon/core/utils/token_storage.dart';
import 'package:Travelon/features/trip/domain/repository/trip_repository.dart';
import 'package:Travelon/features/trip/domain/usecases/get_places_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
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

  // -----------------------------
  //  Utility function
  // -----------------------------
  DateTime parseDmy(String input) {
    final parts = input.split('/');
    return DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );
  }

  // -----------------------------
  // Fetch Agency Places
  // -----------------------------
  Future<void> _onFetchAgencyPlaces(
    FetchAgencyPlaces event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());
    debugPrint('🟩 FetchAgencyPlaces for agencyId: ${event.agencyId}');
    try {
      final places = await getAgencyPlaces(event.agencyId);
      debugPrint('✅ Places loaded: ${places.length}');
      emit(TripLoaded(places));
    } catch (e) {
      debugPrint('❌ Error loading places: $e');
      emit(TripError('Failed to load places: ${e.toString()}'));
    }
  }

  // -----------------------------
  // Submit only Trip request (Without places)
  // -----------------------------
  Future<void> _onSubmitTripRequest(
    SubmitTripRequest event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());
    try {
      // Convert String → DateTime
      final start = parseDmy(event.startDate);
      final end = parseDmy(event.endDate);

      debugPrint("📅 Parsed StartDate: $start");
      debugPrint("📅 Parsed EndDate: $end");

      final requestId = await tripRepository.requestTrip(
        touristId: event.touristId,
        agencyId: event.agencyId,
        StartDate: start,
        EndDate: end,
      );

      debugPrint("🟢 Trip Request Created: $requestId");

      // Save requestId for Step 2
      await TokenStorage.saveRequestId(requestId: requestId);

      emit(TripRequestSuccess("Trip request created"));
    } catch (e) {
      debugPrint("❌ Trip Request Error: $e");
      emit(TripRequestError("Failed to create trip request: $e"));
    }
  }

  // -----------------------------
  // Submit Trip + Select Places
  // -----------------------------
  Future<void> _onSubmitTripWithPlaces(
    SubmitTripWithPlaces event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());

    try {
      final requestId = await TokenStorage.getRequestId(); // ← FIX

      if (requestId == null) {
        emit(
          TripRequestError("Request ID missing! Did you create request first?"),
        );
        return;
      }

      debugPrint("Sending places with requestId=$requestId");

      final response = await tripRepository.selectPlaces(
        requestId: requestId,
        placeIds: event.placeIds,
      );

      emit(TripRequestSuccess("Places successfully submitted"));
    } catch (e) {
      emit(TripRequestError("Failed to submit places: $e"));
    }
  }
}
