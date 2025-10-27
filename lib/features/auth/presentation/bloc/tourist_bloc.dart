import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tourist.dart';
import '../../domain/usecases/register_tourist.dart';

part 'tourist_event.dart';
part 'tourist_state.dart';

class TouristBloc extends Bloc<TouristEvent, TouristState> {
  final RegisterTourist registerTouristUsecase;

  TouristBloc(this.registerTouristUsecase) : super(TouristInitial()) {
    on<RegisterTouristEvent>((event, emit) async {
      emit(TouristLoading());
      try {
        final result = await registerTouristUsecase(event.tourist, event.kycFile);
        emit(TouristRegistered(result));
      } catch (e) {
        emit(TouristError(e.toString()));
      }
    });
  }
}
