import 'package:Travelon/features/agency/domain/usecases/get_agencies.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_event.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgencyBloc extends Bloc<AgencyEvent, AgencyState> {
  final GetAgencies getAgencies;

  AgencyBloc(this.getAgencies) : super(AgencyInitial()) {
    on<LoadAgencies>((event, emit) async {
      emit(AgencyLoading());
      try {
        print("Agency places BLOC 🚑🚑🚑🚑🚑");
        final agencies = await getAgencies();
        emit(AgencyLoaded(agencies));
      } catch (e) {
        emit(AgencyError("Failed to load agencies"));
      }
    });
  }
}
