import '../../domain/entities/tourist.dart';

class TouristModel extends Tourist {
  TouristModel({
    required super.name,
    required super.nationality,
    required super.contact,
    required super.email,
    required super.gender,
    required super.kycType,
    required super.emergencyContact,
    required super.address,
    required super.password,
    required super.agencyId,
    required super.kycNo,
  });

  /// Convert JSON (from API) to Model
  factory TouristModel.fromJson(Map<String, dynamic> json) {
    return TouristModel(
      name: json['Name'] ?? '',
      nationality: json['Nationality'] ?? '',
      contact: json['Contact'] ?? '',
      email: json['Email'] ?? '',
      gender: json['Gender'] ?? '',
      kycType: json['KycType'] ?? '',
      emergencyContact: json['EmergencyContact'] ?? '',
      address: json['Address'] ?? '',
      password: json['Password'] ?? '',
      agencyId: json['AgencyId'] is int
          ? json['AgencyId']
          : int.tryParse(json['AgencyId'].toString()) ?? 0,
      kycNo: json['KycNo'] ?? '',
    );
  }

  /// Convert Model to JSON (for sending to API)
  Map<String, String> toJson() {
    return {
      "Name": name,
      "Nationality": nationality,
      "Contact": contact,
      "Email": email,
      "Gender": gender,
      "KycType": kycType,
      "EmergencyContact": emergencyContact,
      "Address": address,
      "Password": password,
      "AgencyId": agencyId.toString(),
      "KycNo": kycNo,
    };
  }
}
