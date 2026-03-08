import '../../domain/entities/agency.dart';

/// ---------------------------------------------------------------------------
/// AgencyModel
/// ---------------------------------------------------------------------------
/// The Data layer representation of a Travel Agency.
/// 
/// This class extends the [Agency] entity to include JSON serialization 
/// logic, allowing the app to convert API responses into domain objects.
/// ---------------------------------------------------------------------------
class AgencyModel extends Agency {
  AgencyModel({
    required super.id,
    required super.name,
    super.ownerName,
    super.contact,
    super.emailId,
    super.licenceNo,
    super.licenceURL,
    super.addressInfo,
  });

  /// -------------------------------------------------------------------------
  /// Deserialization: JSON -> Model
  /// 
  /// Logic:
  /// - [id/name]: Uses null-coalescing to support multiple API naming 
  ///   conventions (e.g., 'AgencyId' vs 'id').
  /// - [licenceURL]: Maps the document link for agency verification.
  /// -------------------------------------------------------------------------
  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      // Flexible ID mapping to handle different backend response formats
      id: json['AgencyId'] ?? json['id'].toString(),
      name: json['AgencyName'] ?? json['name'],
      ownerName: json['OwnerName'],
      contact: json['Contact'],
      emailId: json['EmailId'],
      licenceNo: json['LicenseNo'],
      licenceURL: json['LicenseURL'],
      addressInfo: json['AddressInfo'],
    );
  }
}