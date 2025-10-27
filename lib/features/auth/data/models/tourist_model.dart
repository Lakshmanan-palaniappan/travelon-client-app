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
    required super.agencyId, required super.kycNo,
  });

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
      "KycNo" : kycNo
    };
  }
}
