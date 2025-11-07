import 'package:flutter/material.dart';

import '../../domain/entities/tourist.dart';

import '../../domain/entities/tourist.dart';

class TouristModel extends Tourist {
  TouristModel({
    required String name,
    required String nationality,
    required String contact,
    required String email,
    required String gender,
    required String kycType,
    required String emergencyContact,
    required String address,
    required String password,
    required int agencyId,
    required String kycNo,
    String? id,
    String? kycUrl,
  }) : super(
         name: name,
         nationality: nationality,
         contact: contact,
         email: email,
         gender: gender,
         kycType: kycType,
         emergencyContact: emergencyContact,
         address: address,
         password: password,
         agencyId: agencyId,
         kycNo: kycNo,
         id: id,
         kycUrl: kycUrl,
       );

  /// ✅ Convert JSON (from API) to Model
  factory TouristModel.fromJson(Map<String, dynamic> json) {
    print("🧩 Parsing TouristModel from JSON: $json"); // debug log

    return TouristModel(
      id: json['TouristId']?.toString(),
      name: json['Name'] ?? '',
      nationality: json['Nationality'] ?? '',
      contact: json['Contact']?.toString() ?? '',
      email: json['Email'] ?? '',
      gender: json['Gender'] ?? '',
      kycType: json['KycType'] ?? '',
      emergencyContact: json['EmergencyContact']?.toString() ?? '',
      address: json['Address'] ?? '',
      password: json['PasswordHash'] ?? '',
      agencyId:
          json['AgencyId'] is int
              ? json['AgencyId']
              : int.tryParse(json['AgencyId']?.toString() ?? '0') ?? 0,
      kycNo: json['KYCHash'] ?? '',
      kycUrl: json['KycURL'],
    );
  }

  /// ✅ Convert Model to JSON (for API calls)
  Map<String, dynamic> toJson() {
    return {
      'TouristId': id,
      'Name': name,
      'Nationality': nationality,
      'Contact': contact,
      'Email': email,
      'Gender': gender,
      'KycType': kycType,
      'EmergencyContact': emergencyContact,
      'Address': address,
      'Password': password,
      'AgencyId': agencyId,
      'KYCHash': kycNo,
      'KycURL': kycUrl,
    };
  }

  factory TouristModel.fromControllers({
    required TextEditingController nameCtrl,
    required TextEditingController emailCtrl,
    required TextEditingController contactCtrl,
    required TextEditingController emergencyCtrl,
    required TextEditingController agencyCtrl,
    required TextEditingController addressCtrl,
    required TextEditingController kycNoCtrl,
    required TextEditingController passCtrl,
    required String? gender,
    required String? nationality,
    required String? kycType,
  }) {
    return TouristModel(
      name: nameCtrl.text.trim(),
      nationality: nationality ?? '',
      contact: contactCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      gender: gender ?? '',
      kycType: kycType ?? '',
      emergencyContact: emergencyCtrl.text.trim(),
      address: addressCtrl.text.trim(),
      password: passCtrl.text.trim(),
      agencyId: int.tryParse(agencyCtrl.text.trim()) ?? 0,
      kycNo: kycNoCtrl.text.trim(),
    );
  }

  Tourist toEntity() {
    return Tourist(
      id: id,
      name: name,
      nationality: nationality,
      contact: contact,
      email: email,
      gender: gender,
      kycType: kycType,
      kycNo: kycNo,
      emergencyContact: emergencyContact,
      address: address,
      password: password,
      agencyId: agencyId,
      kycUrl: kycUrl,
    );
  }

  @override
  String toString() {
    return 'Tourist(id: $id, name: $name, agencyId: $agencyId, email: $email, contact: $contact)';
  }
}
