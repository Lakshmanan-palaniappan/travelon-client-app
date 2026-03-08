/// ---------------------------------------------------------------------------
/// Tourist
/// ---------------------------------------------------------------------------
/// The core business representation of a tourist within the system.
/// 
/// This entity is used across the Domain and Presentation layers to display 
/// and manage user profile information. It purposefully excludes sensitive 
/// "transit-only" data like raw passwords or full KYC numbers.
/// ---------------------------------------------------------------------------
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
  final String? KycLast4;
  final String? KycType;
  final String? emergencyContact;

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
    this.KycLast4,
    this.KycType,
    this.emergencyContact,
  });
}