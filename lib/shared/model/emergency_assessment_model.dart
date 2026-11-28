import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyAssessmentModel {
  final String id;
  final String? userId;
  final String? patientName;
  final String? providerId;
  final String? status;
  final bool? isEmergency;
  final DateTime? timestamp;
  final bool? babyStoppedMoving;
  final String? bleedingAmount;
  final String? contractionType;
  final int? coughDays;
  final String? coughTiming;
  final int? diarrheaFrequency;
  final int? diarrheadays;
  final String? dischargeDuration;
  final String? fluidAmount;
  final bool? hasBurningUrination;
  final bool? hasContractions;
  final bool? hasCough;
  final bool? hasDiarrhea;
  final bool? hasFever;
  final bool? hasFluidLoss;
  final bool? hasHeadache;
  final bool? hasNumbness;
  final bool? hasSwollenLegs;
  final bool? hasVaginalBleeding;
  final bool? hasVaginalDischarge;
  final String? headacheSeverity;
  final String? otherConcerns;

  EmergencyAssessmentModel({
    required this.id,
    this.userId,
    this.patientName,
    this.providerId,
    this.status,
    this.isEmergency,
    this.timestamp,
    this.babyStoppedMoving,
    this.bleedingAmount,
    this.contractionType,
    this.coughDays,
    this.coughTiming,
    this.diarrheaFrequency,
    this.diarrheadays,
    this.dischargeDuration,
    this.fluidAmount,
    this.hasBurningUrination,
    this.hasContractions,
    this.hasCough,
    this.hasDiarrhea,
    this.hasFever,
    this.hasFluidLoss,
    this.hasHeadache,
    this.hasNumbness,
    this.hasSwollenLegs,
    this.hasVaginalBleeding,
    this.hasVaginalDischarge,
    this.headacheSeverity,
    this.otherConcerns,
  });

  DateTime? get createdAt => timestamp;

  factory EmergencyAssessmentModel.fromJson(Map<String, dynamic> json, String id) {
    DateTime? parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      return null;
    }

    int? parseInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    return EmergencyAssessmentModel(
      id: id,
      userId: json['userId'] as String?,
      patientName: json['patientName'] as String?,
      providerId: json['providerId'] as String?,
      status: json['status'] as String?,
      isEmergency: json['isEmergency'] as bool?,
      timestamp: parseDate(json['timestamp'] ?? json['createdAt']),
      babyStoppedMoving: json['babyStoppedMoving'] as bool?,
      bleedingAmount: json['bleedingAmount'] as String?,
      contractionType: json['contractionType'] as String?,
      coughDays: parseInt(json['coughDays']),
      coughTiming: json['coughTiming'] as String?,
      diarrheaFrequency: parseInt(json['diarrheaFrequency']),
      diarrheadays: parseInt(json['diarrheadays'] ?? json['diarrheaDays']),
      dischargeDuration: json['dischargeDuration'] as String?,
      fluidAmount: json['fluidAmount'] as String?,
      hasBurningUrination: json['hasBurningUrination'] as bool?,
      hasContractions: json['hasContractions'] as bool?,
      hasCough: json['hasCough'] as bool?,
      hasDiarrhea: json['hasDiarrhea'] as bool?,
      hasFever: json['hasFever'] as bool?,
      hasFluidLoss: json['hasFluidLoss'] as bool?,
      hasHeadache: json['hasHeadache'] as bool?,
      hasNumbness: json['hasNumbness'] as bool?,
      hasSwollenLegs: json['hasSwollenLegs'] as bool?,
      hasVaginalBleeding: json['hasVaginalBleeding'] as bool?,
      hasVaginalDischarge: json['hasVaginalDischarge'] as bool?,
      headacheSeverity: json['headacheSeverity'] as String?,
      otherConcerns: json['otherConcerns'] as String?,
    );
  }

  factory EmergencyAssessmentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return EmergencyAssessmentModel.fromJson(doc.data() ?? {}, doc.id);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'patientName': patientName,
      'providerId': providerId,
      'status': status,
      'isEmergency': isEmergency,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
      'babyStoppedMoving': babyStoppedMoving,
      'bleedingAmount': bleedingAmount,
      'contractionType': contractionType,
      'coughDays': coughDays,
      'coughTiming': coughTiming,
      'diarrheaFrequency': diarrheaFrequency,
      'diarrheadays': diarrheadays,
      'dischargeDuration': dischargeDuration,
      'fluidAmount': fluidAmount,
      'hasBurningUrination': hasBurningUrination,
      'hasContractions': hasContractions,
      'hasCough': hasCough,
      'hasDiarrhea': hasDiarrhea,
      'hasFever': hasFever,
      'hasFluidLoss': hasFluidLoss,
      'hasHeadache': hasHeadache,
      'hasNumbness': hasNumbness,
      'hasSwollenLegs': hasSwollenLegs,
      'hasVaginalBleeding': hasVaginalBleeding,
      'hasVaginalDischarge': hasVaginalDischarge,
      'headacheSeverity': headacheSeverity,
      'otherConcerns': otherConcerns,
    };
  }
}
