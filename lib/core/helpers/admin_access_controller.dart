import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/firebase_error.dart';

class AdminAccessController extends GetxController {
  final admin = Rxn<AdminModel>();

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _adminSubscription;
  String? _adminId;

  Future<AdminModel?> refreshCurrentAdmin() async {
    final user = FirebaseReference.firebaseAuth.currentUser;
    if (user == null) {
      await _adminSubscription?.cancel();
      _adminSubscription = null;
      _adminId = null;
      admin.value = null;
      return null;
    }

    if (_adminId == user.uid && admin.value != null) {
      return admin.value;
    }

    await _adminSubscription?.cancel();
    _adminSubscription = null;
    _adminId = user.uid;
    admin.value = null;

    try {
      final reference = FirebaseReference.admins.doc(user.uid);
      final snapshot = await reference.get();
      if (!snapshot.exists || snapshot.data() == null) return null;

      final currentAdmin = AdminModel.fromMap(
        snapshot.data()!,
        id: snapshot.id,
      );
      admin.value = currentAdmin;
      _adminSubscription = reference.snapshots().listen(
        (updatedSnapshot) {
          final data = updatedSnapshot.data();
          admin.value = updatedSnapshot.exists && data != null
              ? AdminModel.fromMap(data, id: updatedSnapshot.id)
              : null;
        },
        onError: (Object error) => FirebaseError.handle(error),
      );
      return currentAdmin;
    } catch (error) {
      FirebaseError.handle(error);
      return null;
    }
  }

  AdminTab? tabForLocation(String location) {
    if (location == '/admin/analytics') return AdminTab.analytics;
    if (location == '/admin/users') return AdminTab.users;
    if (location == '/admin/hospitals' ||
        location == '/admin/add-hospital') {
      return AdminTab.hospital;
    }
    if (location == '/admin/emergencies') return AdminTab.approval;
    return null;
  }

  String get firstAccessibleLocation {
    final currentAdmin = admin.value;
    if (currentAdmin == null) return '/admin/profile';

    const destinations = <AdminTab, String>{
      AdminTab.analytics: '/admin/analytics',
      AdminTab.users: '/admin/users',
      AdminTab.hospital: '/admin/hospitals',
      AdminTab.approval: '/admin/emergencies',
    };

    for (final entry in destinations.entries) {
      if (currentAdmin.hasTabAccess(entry.key)) return entry.value;
    }
    return '/admin/profile';
  }

  bool hasTabAccess(AdminTab tab) => admin.value?.hasTabAccess(tab) ?? false;

  Future<void> clearCurrentAdmin() async {
    await _adminSubscription?.cancel();
    _adminSubscription = null;
    _adminId = null;
    admin.value = null;
  }

  @override
  void onClose() {
    _adminSubscription?.cancel();
    super.onClose();
  }
}
