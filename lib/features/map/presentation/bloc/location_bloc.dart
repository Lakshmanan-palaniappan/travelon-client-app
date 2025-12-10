import 'package:Travelon/features/map/domain/entities/location_result.dart';
import 'package:Travelon/features/map/domain/repository/location_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository repository;

  LocationBloc(this.repository) : super(LocationInitial()) {
    on<GetLocationEvent>((event, emit) async {
      emit(LocationLoading());
      try {
        final result = await repository.getTouristLocation(event.touristId);
        emit(LocationLoaded(result));
      } catch (e) {
        emit(LocationError(e.toString()));
      }
    });
  }
}
