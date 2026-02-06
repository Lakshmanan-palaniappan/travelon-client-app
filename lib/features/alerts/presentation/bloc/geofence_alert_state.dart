import '../../domain/entities/geofence_alert.dart';
import 'geofence_alert_event.dart';

abstract class GeofenceAlertState {}

class GeofenceAlertInitial extends GeofenceAlertState {}

class GeofenceAlertLoading extends GeofenceAlertState {}

class GeofenceAlertLoaded extends GeofenceAlertState {
  final List<GeofenceAlert> allAlerts;
  final GeofenceFilter filter;

  GeofenceAlertLoaded({required this.allAlerts, required this.filter});

  List<GeofenceAlert> get filtered {
    switch (filter) {
      case GeofenceFilter.open:
        return allAlerts.where((a) => !a.isResolved).toList();
      case GeofenceFilter.resolved:
        return allAlerts.where((a) => a.isResolved).toList();
      case GeofenceFilter.all:
      default:
        return allAlerts;
    }
  }
}

class GeofenceAlertError extends GeofenceAlertState {
  final String message;
  GeofenceAlertError(this.message);
}
