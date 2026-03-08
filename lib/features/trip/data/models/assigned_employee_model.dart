import '../../domain/entities/assigned_employee.dart';

/// ---------------------------------------------------------------------------
/// AssignedEmployeeModel
/// ---------------------------------------------------------------------------
/// Data model for an employee assigned to a tourist.
///
/// This class handles the mapping between the backend JSON response
/// and the domain [AssignedEmployee] entity.
/// ---------------------------------------------------------------------------
class AssignedEmployeeModel {
  final int employeeId;
  final String employeeName;
  final String email;
  final String phone;
  final String category;
  final double rating;
  final String agencyName;
  final List<String> languages;

  AssignedEmployeeModel({
    required this.employeeId,
    required this.employeeName,
    required this.email,
    required this.phone,
    required this.category,
    required this.rating,
    required this.agencyName,
    required this.languages,
  });

  /// -------------------------------------------------------------------------
  /// Factory: fromJson
  /// -------------------------------------------------------------------------
  /// Converts a JSON [Map] into an [AssignedEmployeeModel] instance.
  ///
  /// Handles null-safety for:
  /// - [rating]: Defaults to 0.0 if null.
  /// - [languages]: Defaults to an empty list if null.
  factory AssignedEmployeeModel.fromJson(Map<String, dynamic> json) {
    return AssignedEmployeeModel(
      employeeId: json['EmployeeId'],
      employeeName: json['EmployeeName'],
      email: json['Email'],
      phone: json['Phone'],
      category: json['Category'],
      // Ensure double conversion from potentially int values in JSON
      rating: (json['Rating'] ?? 0).toDouble(),
      agencyName: json['AgencyName'],
      languages: List<String>.from(json['Languages'] ?? []),
    );
  }

  /// -------------------------------------------------------------------------
  /// Method: toEntity
  /// -------------------------------------------------------------------------
  /// Maps the data model to a domain-level [AssignedEmployee] entity.
  ///
  /// Used in the Repository layer to separate Data logic from Domain logic.
  AssignedEmployee toEntity() {
    return AssignedEmployee(
      employeeId: employeeId,
      employeeName: employeeName,
      email: email,
      phone: phone,
      category: category,
      rating: rating,
      agencyName: agencyName,
      languages: languages,
    );
  }
}
