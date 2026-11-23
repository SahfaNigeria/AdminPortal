import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalModel {
  final String id;
  final String address;
  final DateTime? createdAt;
  final String district;
  final double latitude;
  final GeoPoint? location;
  final double longitude;
  final String name;
  final String phoneNumber;
  final bool status;
  final DateTime? submittedAt;
  final String submittedBy;
  final String type;
  final DateTime? verifiedAt;

  HospitalModel({
    required this.id,
    required this.address,
    this.createdAt,
    required this.district,
    required this.latitude,
    this.location,
    required this.longitude,
    required this.name,
    required this.phoneNumber,
    required this.status,
    this.submittedAt,
    required this.submittedBy,
    required this.type,
    this.verifiedAt,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json, String id, ) {
    return HospitalModel(
      id: id,
      address: json['address'] ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      district: json['district'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      location: json['location'] as GeoPoint?,
      longitude: (json['longitude'] ?? 0).toDouble(),
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? false,
      submittedAt: (json['submittedAt'] as Timestamp?)?.toDate(),
      submittedBy: json['submittedBy'] ?? '',
      type: json['type'] ?? '',
      verifiedAt: (json['verifiedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'district': district,
      'latitude': latitude,
      'location': location,
      'longitude': longitude,
      'name': name,
      'phoneNumber': phoneNumber,
      'status': status,
      'submittedAt': submittedAt != null ? Timestamp.fromDate(submittedAt!) : null,
      'submittedBy': submittedBy,
      'type': type,
      'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
    };
  }
}