import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/health_professionals.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/firebase_error.dart';
import 'package:material_ui/material_ui.dart';

class HealthProfessionalController extends GetxController {
  final filteredHealthProfessionals = <HealthProfessionalsModel>[].obs;
  final isSearchActive = false.obs;
  final isSearchLoading = false.obs;

  late TextEditingController searchController;
  final updatingProfessionalIds = <String>{}.obs;

  @override
  void onInit() {
    searchController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> searchHealthProfessionals([String? query]) async {
    final searchQuery = (query ?? searchController.text).trim().toLowerCase();
    if (searchQuery.isEmpty) {
      filteredHealthProfessionals.clear();
      isSearchActive.value = false;
      return;
    }

    try {
      isSearchLoading.value = true;
      final data = await FirebaseReference.healthProfessionals.get();
      final results = data.docs
          .map(HealthProfessionalsModel.fromFirestore)
          .where((professional) =>
              professional.fullName.toLowerCase().contains(searchQuery) ||
              professional.qualificationNumber
                  .toLowerCase()
                  .contains(searchQuery))
          .toList();

      filteredHealthProfessionals.assignAll(results);
      isSearchActive.value = true;
    } catch (error) {
      FirebaseError.handle(error);
    } finally {
      isSearchLoading.value = false;
    }
  }

  Future<bool> updateApproval(bool approve, String midwifeId) async {
    try {
      updatingProfessionalIds.add(midwifeId);
      await FirebaseReference.healthProfessionals.doc(midwifeId).update({
        'approved': approve,
      });

      final index = filteredHealthProfessionals.indexWhere(
        (professional) => professional.midWifeId == midwifeId,
      );
      if (index != -1) {
        filteredHealthProfessionals[index] =
            filteredHealthProfessionals[index].copyWith(approved: approve);
      }

      return true;
    } catch (e) {
      FirebaseError.handle(e);
      return false;
    } finally {
      updatingProfessionalIds.remove(midwifeId);
    }
  }
}
