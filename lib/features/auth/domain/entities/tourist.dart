// class Tourist {
//   final String name;
//   final String nationality;
//   final String contact;
//   final String email;
//   final String gender;
//   final String kycType;
//   final String kycNo;
//   final String emergencyContact;
//   final String address;
//   final String password;
//   final int agencyId;

//   Tourist({
//     required this.name,
//     required this.nationality,
//     required this.contact,
//     required this.email,
//     required this.gender,
//     required this.kycType,
//     required this.emergencyContact,
//     required this.address,
//     required this.password,
//     required this.agencyId,
//     required this.kycNo
//   });
// }

class Tourist {
  final String name;
  final String nationality;
  final String contact;
  final String email;
  final String gender;
  final String kycType;
  final String kycNo;
  final String emergencyContact;
  final String address;
  final String password;
  final int agencyId;
  final String? id;
  final String? kycUrl;

  Tourist({
    required this.name,
    required this.nationality,
    required this.contact,
    required this.email,
    required this.gender,
    required this.kycType,
    required this.emergencyContact,
    required this.address,
    required this.password,
    required this.agencyId,
    required this.kycNo,
    this.id,
    this.kycUrl,
  });

  @override
  String toString() {
    return 'Tourist(id: $id, name: $name, agencyId: $agencyId, email: $email, contact: $contact)';
  }
}
