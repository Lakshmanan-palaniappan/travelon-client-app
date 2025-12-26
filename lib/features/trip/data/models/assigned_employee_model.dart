import '../../domain/entities/assigned_employee.dart';

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

  factory AssignedEmployeeModel.fromJson(Map<String, dynamic> json) {
    return AssignedEmployeeModel(
      employeeId: json['EmployeeId'],
      employeeName: json['EmployeeName'],
      email: json['Email'],
      phone: json['Phone'],
      category: json['Category'],
      rating: (json['Rating'] ?? 0).toDouble(),
      agencyName: json['AgencyName'],
      languages: List<String>.from(json['Languages'] ?? []),
    );
  }

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
