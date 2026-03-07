import 'package:Travelon/core/utils/error_extract_helper.dart';
import 'package:Travelon/core/utils/token_storage.dart';
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
      emit(TripError(mapErrorToMessage(e)));
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
      emit(AssignedEmployeeError(mapErrorToMessage(e)));
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
    debugPrint('FetchAgencyPlaces for agencyId: ${event.agencyId}');
    try {
      final places = await getAgencyPlaces(event.agencyId);
      debugPrint('Places loaded: ${places.length}');
      emit(TripLoaded(places));
    } catch (e) {
      debugPrint('Error loading places: $e');
      emit(TripError('Failed to load places: ${mapErrorToMessage(e)}'));
    }
  }

  Future<void> _onSubmitTripRequest(
    SubmitTripRequest event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());

    try {
      final existingRequestId = await TokenStorage.getRequestId();

      if (existingRequestId != null) {
        emit(TripRequestSuccess("Trip request already exists"));
        return;
      }

      // Convert String → DateTime
      final start = parseDmy(event.startDate);
      final end = parseDmy(event.endDate);


      final requestId = await tripRepository.requestTrip(
        touristId: event.touristId,
        agencyId: event.agencyId,
        StartDate: start,
        EndDate: end,
      );

      await TokenStorage.saveRequestId(requestId: requestId);

      emit(TripRequestSuccess("Trip request created"));
    } catch (e) {
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


      await tripRepository.selectPlaces(
        requestId: requestId,
        placeIds: event.placeIds,
      );

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
      emit(TripError(mapErrorToMessage(e)));
    }
  }

  Future<void> _onFetchTouristTripsWithPlaces(
    FetchTouristTripsWithPlaces event,
    Emitter<TripState> emit,
  ) async {
    emit(TouristTripsLoading()); 

    try {
      final tripsWithPlaces = await tripRepository.getTouristTripsPlaces(
        event.touristId,
      );

      emit(TouristTripsWithPlacesLoaded(tripsWithPlaces));
    } catch (e) {
      emit(TripError(mapErrorToMessage(e)));
    }
  }
}
