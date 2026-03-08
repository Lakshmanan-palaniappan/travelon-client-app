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

/// ---------------------------------------------------------------------------
/// TripBloc
/// ---------------------------------------------------------------------------
/// Manages the state for all trip-related features.
/// 
/// This BLoC handles the complex orchestration of:
/// - Planning and requesting new trips.
/// - Selecting destinations for a pending request.
/// - Fetching current active trips and assigned staff.
/// - Managing historical trip data.
/// ---------------------------------------------------------------------------
class TripBloc extends Bloc<TripEvent, TripState> {
  final TripRepository tripRepository;
  final GetAgencyPlaces getAgencyPlaces;
  final GetAssignedEmployee getAssignedEmployee;

  TripBloc({
    required this.getAgencyPlaces,
    required this.tripRepository,
    required this.getAssignedEmployee,
  }) : super(TripInitial()) {
    // Event Handlers Mapping
    on<FetchAgencyPlaces>(_onFetchAgencyPlaces);
    on<SubmitTripRequest>(_onSubmitTripRequest);
    on<SubmitTripWithPlaces>(_onSubmitTripWithPlaces);
    on<FetchAssignedEmployee>(_onFetchAssignedEmployee);
    on<FetchCurrentTrip>(_onFetchCurrentTrip);
    on<FetchTouristTrips>(_onFetchTouristTrips);
    on<FetchTouristTripsWithPlaces>(_onFetchTouristTripsWithPlaces);
  }

  /// -------------------------------------------------------------------------
  /// Fetch Current Trip
  /// -------------------------------------------------------------------------
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

  /// -------------------------------------------------------------------------
  /// Utility: parseDmy
  /// -------------------------------------------------------------------------
  /// Converts a date string in DD/MM/YYYY format to a [DateTime] object.
  DateTime parseDmy(String input) {
    final parts = input.split('/');
    return DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );
  }

  /// -------------------------------------------------------------------------
  /// Fetch Assigned Employee
  /// -------------------------------------------------------------------------
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

  /// -------------------------------------------------------------------------
  /// Fetch Agency Places
  /// -------------------------------------------------------------------------
  Future<void> _onFetchAgencyPlaces(
    FetchAgencyPlaces event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());
    try {
      final places = await getAgencyPlaces(event.agencyId);
      emit(TripLoaded(places));
    } catch (e) {
      emit(TripError('Failed to load places: ${mapErrorToMessage(e)}'));
    }
  }

  /// -------------------------------------------------------------------------
  /// Step 1: Submit Trip Request
  /// -------------------------------------------------------------------------
  /// Initiates the trip creation process. 
  /// Checks for existing requests and saves the new Request ID to local storage.
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

  /// -------------------------------------------------------------------------
  /// Step 2: Submit Trip + Select Places
  /// -------------------------------------------------------------------------
  /// Finalizes the trip by attaching specific locations to the pending request.
  /// Clears the local Request ID upon successful completion.
  Future<void> _onSubmitTripWithPlaces(
    SubmitTripWithPlaces event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());
    try {
      final requestId = await TokenStorage.getRequestId();
      if (requestId == null) {
        emit(TripRequestError("Request ID missing! Please start a trip first."));
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

  /// -------------------------------------------------------------------------
  /// Cancel Pending Request
  /// -------------------------------------------------------------------------
  Future<void> cancelTripRequest() async {
    await TokenStorage.clearRequestId();
  }

  /// -------------------------------------------------------------------------
  /// Fetch Tourist Trip History
  /// -------------------------------------------------------------------------
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

  /// -------------------------------------------------------------------------
  /// Fetch Detailed Trip History (with Itineraries)
  /// -------------------------------------------------------------------------
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