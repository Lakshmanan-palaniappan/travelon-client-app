class RegisterTouristEntity {
  final String name;
  final String email;
  final String contact;
  final String? emergencyContact;
  final String nationality;
  final String gender;
  final String address;
  final int agencyId;
  final String password;

  final String? kycNo;
  final String? userType;
  final String? kycType;

  RegisterTouristEntity({
    required this.name,
    required this.email,
    required this.contact,
    required this.nationality,
    required this.gender,
    required this.address,
    required this.agencyId,
    required this.password,
    this.kycNo,
    this.userType,
    this.kycType,
    this.emergencyContact,
  });
}
