import 'package:cloud_firestore/cloud_firestore.dart';

class HealthProfessionalsModel {
  final bool approved;
  final String cityValue;
  final String countryValue;
  final DateTime? createdAt;
  final String email;
  final String fullName;
  final String healthFacility;
  final String midWifeId;
  final String midWifeImage;
  final String phoneNumber;
  final String position;
  final String professional;
  final String qualificationNumber;
  final String stateValue;
  final String villageTown;

  HealthProfessionalsModel({
    required this.approved,
    required this.cityValue,
    required this.countryValue,
    this.createdAt,
    required this.email,
    required this.fullName,
    required this.healthFacility,
    required this.midWifeId,
    required this.midWifeImage,
    required this.phoneNumber,
    required this.position,
    required this.professional,
    required this.qualificationNumber,
    required this.stateValue,
    required this.villageTown,
  });

  // Convert Firestore document to Model
  factory HealthProfessionalsModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    return HealthProfessionalsModel(
      approved: data['approved'] ?? false,
      cityValue: data['cityValue'] ?? '',
      countryValue: data['countryValue'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      healthFacility: data['healthFacility'] ?? '',
      midWifeId: data['midWifeId'] ?? doc.id,
      midWifeImage: data['midWifeImage'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      position: data['position'] ?? '',
      professional: data['professional'] ?? '',
      qualificationNumber: data['qualificationNumber'] ?? '',
      stateValue: data['stateValue'] ?? '',
      villageTown: data['villageTown'] ?? '',
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'approved': approved,
      'cityValue': cityValue,
      'countryValue': countryValue,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : null,
      'email': email,
      'fullName': fullName,
      'healthFacility': healthFacility,
      'midWifeId': midWifeId,
      'midWifeImage': midWifeImage,
      'phoneNumber': phoneNumber,
      'position': position,
      'professional': professional,
      'qualificationNumber': qualificationNumber,
      'stateValue': stateValue,
      'villageTown': villageTown,
    };
  }

  // Convert JSON to Model
  factory HealthProfessionalsModel.fromJson(
      Map<String, dynamic> json, {
        String? id,
      }) {
    return HealthProfessionalsModel(
      approved: json['approved'] ?? false,
      cityValue: json['cityValue'] ?? '',
      countryValue: json['countryValue'] ?? '',
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : json['createdAt'] is DateTime
          ? json['createdAt']
          : null,
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      healthFacility: json['healthFacility'] ?? '',
      midWifeId: json['midWifeId'] ?? id ?? '',
      midWifeImage: json['midWifeImage'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      position: json['position'] ?? '',
      professional: json['professional'] ?? '',
      qualificationNumber: json['qualificationNumber'] ?? '',
      stateValue: json['stateValue'] ?? '',
      villageTown: json['villageTown'] ?? '',
    );
  }
}