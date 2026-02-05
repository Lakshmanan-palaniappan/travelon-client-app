import 'package:Travelon/features/auth/domain/entities/register_tourist.dart';
import 'package:Travelon/features/auth/domain/usecases/register_tourist.dart';
import 'package:flutter/material.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';

class TouristModel {
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
  final String? kycNo;
  final String? KycLast4;
  final String? password;
  final String? KycType; // ✅ ADD THIS

  TouristModel({
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
    this.kycNo,
    this.password,
    this.KycType, // ✅
    this.KycLast4
  });


  // Create from JSON
  factory TouristModel.fromJson(Map<String, dynamic> json) {
    return TouristModel(
      id: json['TouristId']?.toString(),
      name: json['Name'] ?? '',
      nationality: json['Nationality'] ?? '',
      contact: json['Contact']?.toString() ?? '',
      email: json['Email'] ?? '',
      gender: json['Gender'] ?? '',
      address: json['Address'] ?? '',
      agencyId: json['AgencyId'] ?? 0,
      kycUrl: json['KycURL'],
      userType: json['UserType'],        // ✅ ADD THIS
      kycNo: json['KycNo'],
      KycType: json['KycType'].toString(),           // ✅ ADD THIS
      KycLast4: json['KycLast4'].toString(),         // ✅ ADD THIS (if backend sends it)
    );
  }


  // Convert to Entity
  Tourist toEntity() => Tourist(
    id: id,
    name: name,
    nationality: nationality,
    contact: contact,
    email: email,
    gender: gender,
    address: address,
    agencyId: agencyId,
    kycUrl: kycUrl,
    userType: userType,     // ✅ ADD THIS
    KycLast4: KycLast4,     // ✅ ADD THIS
    KycType: KycType,       // ✅ ADD THIS
  );



  // Create from Entity
  factory TouristModel.fromEntity(Tourist tourist) {
    return TouristModel(
      id: tourist.id,
      name: tourist.name,
      nationality: tourist.nationality,
      contact: tourist.contact,
      email: tourist.email,
      gender: tourist.gender,
      address: tourist.address,
      agencyId: tourist.agencyId,
      kycUrl: tourist.kycUrl,
      userType: tourist.userType,
    );
  }

  // Create from form controllers (for registration)
  factory TouristModel.fromControllers({
  required TextEditingController nameCtrl,
  required TextEditingController emailCtrl,
  required TextEditingController contactCtrl,
  required TextEditingController emergencyCtrl,
  required TextEditingController agencyCtrl,
  required TextEditingController addressCtrl,
  required TextEditingController kycNoCtrl,
  required TextEditingController passCtrl,
  String? gender,
  String? nationality,
  String? kycType, // ✅ RECEIVE
  String? selectedType,
}) {
  return TouristModel(
    name: nameCtrl.text.trim(),
    email: emailCtrl.text.trim(),
    contact: contactCtrl.text.trim(),
    address: addressCtrl.text.trim(),
    agencyId: int.tryParse(agencyCtrl.text.trim()) ?? 0,
    gender: gender ?? '',
    nationality: nationality ?? '',
    kycNo: kycNoCtrl.text.trim(),
    password: passCtrl.text.trim(),
    KycType: kycType, // ✅ SET
    userType: selectedType,
  );
}


  // Convert to JSON
Map<String, dynamic> toJson() {
  return {
    "TouristId": id,
    "Name": name,
    "Nationality": nationality,
    "Contact": contact,
    "Email": email,
    "Gender": gender,
    "Address": address,
    "AgencyId": agencyId,
    "UserType": userType,
    "KycNo": kycNo,
    "KycType": KycType, // ✅ REQUIRED
    "Password": password,
  };
}

factory TouristModel.fromRegisterEntity(RegisterTouristEntity data) {
  return TouristModel(
    name: data.name,
    email: data.email,
    contact: data.contact,
    nationality: data.nationality,
    gender: data.gender,
    address: data.address,
    agencyId: data.agencyId,
    password: data.password,
    kycNo: data.kycNo,
    userType: data.userType,
    KycType: data.kycType, // ✅ FIX
  );
}

}
