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

  HospitalModel copyWith({
    String? id,
    String? address,
    DateTime? createdAt,
    String? district,
    double? latitude,
    GeoPoint? location,
    double? longitude,
    String? name,
    String? phoneNumber,
    bool? status,
    DateTime? submittedAt,
    String? submittedBy,
    String? type,
    DateTime? verifiedAt,
  }) {
    return HospitalModel(
      id: id ?? this.id,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      district: district ?? this.district,
      latitude: latitude ?? this.latitude,
      location: location ?? this.location,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      submittedBy: submittedBy ?? this.submittedBy,
      type: type ?? this.type,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }

  factory HospitalModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return HospitalModel(
      id: doc.id,
      address: data['address'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      district: data['district'] ?? '',
      latitude: (data['latitude'] is num) ? (data['latitude'] as num).toDouble() : 0.0,
      location: data['location'] as GeoPoint?,
      longitude: (data['longitude'] is num) ? (data['longitude'] as num).toDouble() : 0.0,
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      status: data['status'] ?? false,
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate(),
      submittedBy: data['submittedBy'] ?? '',
      type: data['type'] ?? '',
      verifiedAt: (data['verifiedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory HospitalModel.fromJson(Map<String, dynamic> json, String id) {
    return HospitalModel(
      id: id,
      address: json['address'] ?? '',
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : json['createdAt'] is DateTime
              ? json['createdAt']
              : null,
      district: json['district'] ?? '',
      latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : 0.0,
      location: json['location'] as GeoPoint?,
      longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : 0.0,
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? false,
      submittedAt: json['submittedAt'] is Timestamp
          ? (json['submittedAt'] as Timestamp).toDate()
          : json['submittedAt'] is DateTime
              ? json['submittedAt']
              : null,
      submittedBy: json['submittedBy'] ?? '',
      type: json['type'] ?? '',
      verifiedAt: json['verifiedAt'] is Timestamp
          ? (json['verifiedAt'] as Timestamp).toDate()
          : json['verifiedAt'] is DateTime
              ? json['verifiedAt']
              : null,
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
