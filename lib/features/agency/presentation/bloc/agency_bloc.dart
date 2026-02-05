import 'package:Travelon/features/agency/domain/usecases/get_agencies.dart';
import 'package:Travelon/features/agency/domain/usecases/get_agency_details.dart'; // Add this
import 'package:Travelon/features/agency/presentation/bloc/agency_event.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgencyBloc extends Bloc<AgencyEvent, AgencyState> {
  final GetAgencies getAgencies;
  final GetAgencyDetails getAgencyDetails; // 1. Add Usecase

  AgencyBloc({
    required this.getAgencies,
    required this.getAgencyDetails,
  }) : super(AgencyInitial()) {

    // Existing LoadAgencies
    on<LoadAgencies>((event, emit) async {
      emit(AgencyLoading());
      try {
        final agencies = await getAgencies();
        emit(AgencyLoaded(agencies));
      } catch (e) {
        emit(AgencyError("Failed to load agencies"));
      }
    });

    // 2. New Detail Fetch Logic

  }
}


class AgencyDetailsBloc extends Bloc<AgencyEvent, AgencyState> {
  final GetAgencyDetails getAgencyDetails;

  AgencyDetailsBloc({
    required this.getAgencyDetails,
  }) : super(AgencyInitial()) {

    on<FetchAgencyDetails>((event, emit) async {
      emit(AgencyLoading());
      try {
        print("Fetching details for Agency ID: ${event.id}");
        final agency = await getAgencyDetails(event.id);
        emit(AgencyDetailLoaded(agency));
      } catch (e) {
        emit(AgencyError("Failed to load agency details"));
      }
    });
  }
}
