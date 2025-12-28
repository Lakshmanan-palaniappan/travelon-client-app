class Trip {
  final int id;
  final String status; // ONGOING | COMPLETED | PENDING
  final DateTime createdAt;
  final DateTime? completedAt;

  Trip({
    required this.id,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });
}
