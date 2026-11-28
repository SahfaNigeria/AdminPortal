import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNotificationModel {
  final String fid;
  final String platform;
  final bool notificationsEnabled;
  final DateTime? lastUpdated;

  const AdminNotificationModel({
    required this.fid,
    this.platform = 'web',
    this.notificationsEnabled = true,
    this.lastUpdated,
  });

  AdminNotificationModel copyWith({
    String? fid,
    String? platform,
    bool? notificationsEnabled,
    DateTime? lastUpdated,
  }) {
    return AdminNotificationModel(
      fid: fid ?? this.fid,
      platform: platform ?? this.platform,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fid': fid,
      'platform': platform,
      'notificationsEnabled': notificationsEnabled,
      'lastUpdated': lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fid': fid,
      'platform': platform,
      'notificationsEnabled': notificationsEnabled,
      'lastUpdated': lastUpdated != null
          ? Timestamp.fromDate(lastUpdated!)
          : FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toJson() => toMap();

  factory AdminNotificationModel.fromMap(
    Map<String, dynamic> map, {
    String? fid,
  }) {
    final rawLastUpdated = map['lastUpdated'];
    DateTime? parsedDate;

    if (rawLastUpdated is Timestamp) {
      parsedDate = rawLastUpdated.toDate();
    } else if (rawLastUpdated is DateTime) {
      parsedDate = rawLastUpdated;
    } else if (rawLastUpdated is String) {
      parsedDate = DateTime.tryParse(rawLastUpdated);
    } else if (rawLastUpdated is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(rawLastUpdated);
    }

    return AdminNotificationModel(
      fid: map['fid']?.toString() ?? fid ?? '',
      platform: map['platform']?.toString() ?? 'web',
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      lastUpdated: parsedDate,
    );
  }

  factory AdminNotificationModel.fromJson(
    Map<String, dynamic> json, {
    String? fid,
  }) {
    return AdminNotificationModel.fromMap(json, fid: fid);
  }

  factory AdminNotificationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return AdminNotificationModel.fromMap(
      doc.data() ?? {},
      fid: doc.id,
    );
  }
}
