abstract class GeofenceAlertEvent {}

class LoadGeofenceAlerts extends GeofenceAlertEvent {}

class ResolveGeofenceAlertEvent extends GeofenceAlertEvent {
  final int alertId;
  ResolveGeofenceAlertEvent(this.alertId);
}

class ChangeGeofenceFilter extends GeofenceAlertEvent {
  final GeofenceFilter filter;
  ChangeGeofenceFilter(this.filter);
}

enum GeofenceFilter { all, open, resolved }
