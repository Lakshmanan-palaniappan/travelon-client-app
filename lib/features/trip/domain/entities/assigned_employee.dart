/// ---------------------------------------------------------------------------
/// AssignedEmployee
/// ---------------------------------------------------------------------------
/// A domain entity representing an employee assigned to a trip.
/// 
/// This is a "pure" class used in the Domain layer. It is agnostic of 
/// any data source or JSON format.
/// ---------------------------------------------------------------------------
class AssignedEmployee {
  final int employeeId;
  final String employeeName;
  final String email;
  final String phone;
  final String category;
  final double rating;
  final String agencyName;
  final List<String> languages;

  AssignedEmployee({
    required this.employeeId,
    required this.employeeName,
    required this.email,
    required this.phone,
    required this.category,
    required this.rating,
    required this.agencyName,
    required this.languages,
  });
}