import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/sos_alert_model.dart';
import '../../domain/usecases/get_sos_alerts.dart';

abstract class SosAlertEvent {}
class LoadSosAlerts extends SosAlertEvent {}

abstract class SosAlertState {}
class SosAlertInitial extends SosAlertState {}
class SosAlertLoading extends SosAlertState {}
class SosAlertLoaded extends SosAlertState {
  final List<SosAlertModel> items;
  SosAlertLoaded(this.items);
}
class SosAlertError extends SosAlertState {
  final String message;
  SosAlertError(this.message);
}

class SosAlertBloc extends Bloc<SosAlertEvent, SosAlertState> {
  final GetSosAlerts getSosAlerts;

  SosAlertBloc(this.getSosAlerts) : super(SosAlertInitial()) {
    on<LoadSosAlerts>((event, emit) async {
      emit(SosAlertLoading());
      try {
        final items = await getSosAlerts();
        emit(SosAlertLoaded(items));
      } catch (e) {
        emit(SosAlertError(e.toString()));
      }
    });
  }
}
