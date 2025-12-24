class Tourist {
  final String? id;
  final String name;
  final String nationality;
  final String contact;
  final String email;
  final String gender;
  final String address;
  final int agencyId;
  final String? kycUrl;
  final String? userType;

  Tourist({
    this.id,
    required this.name,
    required this.nationality,
    required this.contact,
    required this.email,
    required this.gender,
    required this.address,
    required this.agencyId,
    this.kycUrl,
    this.userType,
  });
}
