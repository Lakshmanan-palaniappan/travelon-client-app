// import '../../domain/entities/agency.dart';

// class AgencyModel extends Agency {
//   AgencyModel({required super.id, required super.name});

//   factory AgencyModel.fromJson(Map<String, dynamic> json) {
//     return AgencyModel(id: json['AgencyId'], name: json['AgencyName']);
//   }
// }

import '../../domain/entities/agency.dart';

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

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
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