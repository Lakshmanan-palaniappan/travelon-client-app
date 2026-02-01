import 'package:Travelon/core/utils/token_storage.dart';
import 'package:Travelon/features/trip/data/models/trip_with_places._model.dart';
import 'package:Travelon/features/trip/domain/entities/assigned_employee.dart';
import 'package:Travelon/features/trip/domain/entities/current_trip.dart';
import 'package:Travelon/features/trip/domain/entities/trip.dart';
import 'package:Travelon/features/trip/domain/entities/trip_with_places.dart';
import 'package:Travelon/features/trip/domain/repository/trip_repository.dart';
import 'package:Travelon/features/trip/domain/usecases/get_assigned_employee.dart';
import 'package:Travelon/features/trip/domain/usecases/get_places_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final TripRepository tripRepository;
  final GetAgencyPlaces getAgencyPlaces;
  final GetAssignedEmployee getAssignedEmployee;

  TripBloc({
    required this.getAgencyPlaces,
    required this.tripRepository,
    required this.getAssignedEmployee,
  }) : super(TripInitial()) {
    on<FetchAgencyPlaces>(_onFetchAgencyPlaces);
    on<SubmitTripRequest>(_onSubmitTripRequest);
    on<SubmitTripWithPlaces>(_onSubmitTripWithPlaces);
    on<FetchAssignedEmployee>(_onFetchAssignedEmployee);
    on<FetchCurrentTrip>(_onFetchCurrentTrip);
    on<FetchTouristTrips>(_onFetchTouristTrips);
    on<FetchTouristTripsWithPlaces>(_onFetchTouristTripsWithPlaces);
  }
Future<void> _onFetchCurrentTrip(
  FetchCurrentTrip event,
  Emitter<TripState> emit,
) async {
  emit(CurrentTripLoading());

  try {
    final trip = await tripRepository.getCurrentTrip();

    if (trip == null) {
      emit(NoCurrentTrip());
    } else {
      emit(CurrentTripLoaded(trip));
    }
  } catch (e) {
    emit(TripError(e.toString()));
  }
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

  Future<void> _onFetchAssignedEmployee(
    FetchAssignedEmployee event,
    Emitter<TripState> emit,
  ) async {
    emit(AssignedEmployeeLoading());

    try {
      final employee = await getAssignedEmployee();
      emit(AssignedEmployeeLoaded(employee));
    } catch (e) {
      emit(AssignedEmployeeError(e.toString()));
    }
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
      // 🔑 Check if request already exists
      final existingRequestId = await TokenStorage.getRequestId();

      if (existingRequestId != null) {
        debugPrint("🟡 Reusing existing requestId: $existingRequestId");
        emit(TripRequestSuccess("Trip request already exists"));
        return;
      }

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

      debugPrint("🟢 New Trip Request Created: $requestId");

      await TokenStorage.saveRequestId(requestId: requestId);

      emit(TripRequestSuccess("Trip request created"));
    } catch (e) {
      debugPrint("❌ Trip Request Error: $e");
      emit(TripRequestError("Failed to create trip request"));
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
      final requestId = await TokenStorage.getRequestId();

      if (requestId == null) {
        emit(
          TripRequestError("Request ID missing! Please start a trip first."),
        );
        return;
      }

      debugPrint("📤 Submitting places for requestId=$requestId");

      await tripRepository.selectPlaces(
        requestId: requestId,
        placeIds: event.placeIds,
      );

      // ✅ CLEAR requestId after success
      await TokenStorage.clearRequestId();

      emit(TripRequestSuccess("Trip completed successfully"));
    } catch (e) {
      emit(TripRequestError("Failed to submit places"));
    }
  }

  Future<void> cancelTripRequest() async {
    await TokenStorage.clearRequestId();
  }


  Future<void> _onFetchTouristTrips(
  FetchTouristTrips event,
  Emitter<TripState> emit,
) async {
  emit(TouristTripsLoading());

  try {
    final trips = await tripRepository.getTouristTrips(event.touristId);
    emit(TouristTripsLoaded(trips));
  } catch (e) {
    emit(TripError(e.toString()));
  }
}


Future<void> _onFetchTouristTripsWithPlaces(
  FetchTouristTripsWithPlaces event,
  Emitter<TripState> emit,
) async {
  emit(TouristTripsLoading()); // Reuse your existing loading state

  try {
    // 🟢 Call the specific repository method you just fixed
    final tripsWithPlaces = await tripRepository.getTouristTripsPlaces(event.touristId);
    
    emit(TouristTripsWithPlacesLoaded(tripsWithPlaces));
  } catch (e) {
    debugPrint('❌ Error loading trips with places: $e');
    emit(TripError(e.toString()));
  }
}
}
