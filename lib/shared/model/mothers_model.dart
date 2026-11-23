import 'package:cloud_firestore/cloud_firestore.dart';

class MothersModel {
  final String address;
  final String cityValue;
  final String countryValue;
  final String dateOfBirth;
  final String email;
  final String fullName;
  final String hospital;
  final String motherId;
  final String phoneNumber;
  final String profileImage;
  final String profileImageType;
  final String stateValue;
  final String villageTown;

  MothersModel({
    required this.address,
    required this.cityValue,
    required this.countryValue,
    required this.dateOfBirth,
    required this.email,
    required this.fullName,
    required this.hospital,
    required this.motherId,
    required this.phoneNumber,
    required this.profileImage,
    required this.profileImageType,
    required this.stateValue,
    required this.villageTown,
  });

  // Convert Firestore document to Model
  factory MothersModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    return MothersModel(
      address: data['address'] ?? '',
      cityValue: data['cityValue'] ?? '',
      countryValue: data['countryValue'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      email: data['email'] ?? '',
      fullName: data['full name'] ?? '',
      hospital: data['hospital'] ?? '',
      motherId: data['motherId'] ?? doc.id,
      phoneNumber: data['phone number'] ?? '',
      profileImage: data['profileImage'] ?? '',
      profileImageType: data['profileImageType'] ?? '',
      stateValue: data['stateValue'] ?? '',
      villageTown: data['villageTown'] ?? '',
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'cityValue': cityValue,
      'countryValue': countryValue,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'full name': fullName,
      'hospital': hospital,
      'motherId': motherId,
      'phone number': phoneNumber,
      'profileImage': profileImage,
      'profileImageType': profileImageType,
      'stateValue': stateValue,
      'villageTown': villageTown,
    };
  }

  // Convert JSON to Model
  factory MothersModel.fromJson(
      Map<String, dynamic> json, {
        String? id,
      }) {
    return MothersModel(
      address: json['address'] ?? '',
      cityValue: json['cityValue'] ?? '',
      countryValue: json['countryValue'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full name'] ?? '',
      hospital: json['hospital'] ?? '',
      motherId: json['motherId'] ?? id ?? '',
      phoneNumber: json['phone number'] ?? '',
      profileImage: json['profileImage'] ?? '',
      profileImageType: json['profileImageType'] ?? '',
      stateValue: json['stateValue'] ?? '',
      villageTown: json['villageTown'] ?? '',
    );
  }
}