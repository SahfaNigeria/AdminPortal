import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/firebase_error.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/toast.dart';
import 'package:material_ui/material_ui.dart';

class AdminsController extends GetxController {
  final admins = <AdminModel>[].obs;
  final isLoading = false.obs;
  final canManageAdmins = false.obs;
  final loadError = RxnString();
  final searchQuery = ''.obs;
  final isSearchActive = false.obs;
  final updatingAdminIds = <String>{}.obs;

  final draftAccountType = AccountType.admin.obs;
  final draftIsApproved = false.obs;
  final selectedTabs = <AdminTab>[].obs;

  late final TextEditingController searchController;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _adminsSubscription;
  String? _currentAdminId;

  String? get currentAdminId => _currentAdminId;

  List<AdminModel> get filteredAdmins {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) return admins.toList();

    return admins.where((admin) {
      return admin.username.toLowerCase().contains(query) ||
          admin.email.toLowerCase().contains(query) ||
          admin.id.toLowerCase().contains(query) ||
          admin.accountType.displayName.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    searchController = TextEditingController();
    super.onInit();
    loadAdmins();
  }

  Future<void> loadAdmins() async {
    isLoading.value = true;
    loadError.value = null;
    canManageAdmins.value = false;
    var listeningForAdmins = false;

    try {
      await _adminsSubscription?.cancel();
      _adminsSubscription = null;
      admins.clear();

      final currentUser = FirebaseReference.firebaseAuth.currentUser;
      if (currentUser == null) {
        loadError.value = 'Sign in to manage administrator accounts.';
        return;
      }

      _currentAdminId = currentUser.uid;
      final currentAdminSnapshot =
          await FirebaseReference.admins.doc(currentUser.uid).get();
      final currentAdmin = currentAdminSnapshot.data() == null
          ? null
          : AdminModel.fromMap(
              currentAdminSnapshot.data()!,
              id: currentAdminSnapshot.id,
            );

      if (currentAdmin == null ||
          !currentAdmin.isSuperAdmin ||
          !currentAdmin.isApproved) {
        return;
      }

      canManageAdmins.value = true;
      _adminsSubscription = FirebaseReference.admins.snapshots().listen(
        (snapshot) {
          final loadedAdmins = snapshot.docs
              .map(
                (document) => AdminModel.fromMap(
                  document.data(),
                  id: document.id,
                ),
              )
              .toList()
            ..sort(
              (first, second) => first.username
                  .toLowerCase()
                  .compareTo(second.username.toLowerCase()),
            );
          admins.assignAll(loadedAdmins);
          isLoading.value = false;
          loadError.value = null;
        },
        onError: (Object error) {
          loadError.value = FirebaseError.handle(error);
          isLoading.value = false;
        },
      );
      listeningForAdmins = true;
    } catch (error) {
      loadError.value = FirebaseError.handle(error);
    } finally {
      if (!listeningForAdmins) {
        isLoading.value = false;
      }
    }
  }

  void searchAdmins([String? value]) {
    final query = (value ?? searchController.text).trim().toLowerCase();
    searchQuery.value = query;
    isSearchActive.value = query.isNotEmpty;
  }

  void clearAdminSearch() {
    searchController.clear();
    searchQuery.value = '';
    isSearchActive.value = false;
  }

  void prepareAccessReview(AdminModel admin) {
    draftAccountType.value = admin.accountType;
    draftIsApproved.value = admin.isApproved;
    selectedTabs.assignAll(admin.accessibleTabs);
  }

  void setDraftApproval(bool approved) {
    draftIsApproved.value = approved;
    if (!approved) {
      draftAccountType.value = AccountType.admin;
      selectedTabs.clear();
    }
  }

  void setDraftAccountType(AccountType accountType) {
    draftAccountType.value = accountType;
  }

  void setTabAccess(AdminTab tab, bool hasAccess) {
    if (hasAccess && !selectedTabs.contains(tab)) {
      selectedTabs.add(tab);
    } else if (!hasAccess) {
      selectedTabs.remove(tab);
    }
  }

  Future<bool> saveAdminAccess(AdminModel admin) async {
    final currentAdminId = _currentAdminId;
    if (currentAdminId == null || currentAdminId == admin.id) {
      AppToast.error('You cannot change your own administrator access.');
      return false;
    }

    updatingAdminIds.add(admin.id);
    try {
      final actorSnapshot =
          await FirebaseReference.admins.doc(currentAdminId).get();
      final actorData = actorSnapshot.data();
      final actor = actorData == null
          ? null
          : AdminModel.fromMap(actorData, id: actorSnapshot.id);
      if (actor == null || !actor.isSuperAdmin || !actor.isApproved) {
        canManageAdmins.value = false;
        AppToast.error('Only an approved Super Admin can manage administrators.');
        return false;
      }

      final accountType = draftIsApproved.value
          ? draftAccountType.value
          : AccountType.admin;
      final accessibleTabs = accountType == AccountType.superAdmin
          ? <AdminTab>[]
          : selectedTabs.toSet().toList();

      await FirebaseReference.admins.doc(admin.id).update({
        'accountType': accountType.toValue(),
        'accessibleTabs':
            accessibleTabs.map((tab) => tab.toValue()).toList(),
        'isApproved': draftIsApproved.value,
        'approvedBySuperAdminId':
            draftIsApproved.value ? currentAdminId : '',
        'updatedAt': DateTime.now().toIso8601String(),
      });

      AppToast.success(
        draftIsApproved.value
            ? 'Administrator access updated.'
            : 'Administrator approval revoked.',
      );
      return true;
    } catch (error) {
      FirebaseError.handle(error);
      return false;
    } finally {
      updatingAdminIds.remove(admin.id);
    }
  }

  @override
  void onClose() {
    _adminsSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
