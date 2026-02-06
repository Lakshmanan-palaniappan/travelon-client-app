class SosAlert {
  final int sosId;
  final double lat;
  final double lng;
  final double? accuracy;
  final String message;
  final bool isResolved;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  SosAlert({
    required this.sosId,
    required this.lat,
    required this.lng,
    this.accuracy,
    required this.message,
    required this.isResolved,
    required this.createdAt,
    this.resolvedAt,
  });
}
