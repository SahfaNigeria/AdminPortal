import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/hospital_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/firebase_error.dart';
import 'package:material_ui/material_ui.dart';

class HospitalPageController extends GetxController {
  final filteredHospitals = <HospitalModel>[].obs;
  final isSearchActive = false.obs;
  final isSearchLoading = false.obs;

  late TextEditingController searchController;
  final updatingHospitalIds = <String>{}.obs;

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

  Future<void> searchHospitals([String? query]) async {
    final searchQuery = (query ?? searchController.text).trim().toLowerCase();
    if (searchQuery.isEmpty) {
      filteredHospitals.clear();
      isSearchActive.value = false;
      return;
    }

    try {
      isSearchLoading.value = true;
      final data = await FirebaseReference.hospitals.get();
      final results = data.docs
          .map(HospitalModel.fromFirestore)
          .where((hospital) =>
              hospital.name.toLowerCase().contains(searchQuery) ||
              hospital.type.toLowerCase().contains(searchQuery) ||
              hospital.district.toLowerCase().contains(searchQuery) ||
              hospital.address.toLowerCase().contains(searchQuery) ||
              hospital.phoneNumber.toLowerCase().contains(searchQuery))
          .toList();

      filteredHospitals.assignAll(results);
      isSearchActive.value = true;
    } catch (error) {
      FirebaseError.handle(error);
    } finally {
      isSearchLoading.value = false;
    }
  }

  Future<bool> updateApproval(bool approve, String hospitalId) async {
    try {
      updatingHospitalIds.add(hospitalId);
      final updateData = <String, dynamic>{
        'status': approve,
      };
      if (approve) {
        updateData['verifiedAt'] = FieldValue.serverTimestamp();
      }
      await FirebaseReference.hospitals.doc(hospitalId).update(updateData);

      final index = filteredHospitals.indexWhere(
        (hospital) => hospital.id == hospitalId,
      );
      if (index != -1) {
        filteredHospitals[index] = filteredHospitals[index].copyWith(
          status: approve,
          verifiedAt: approve ? DateTime.now() : filteredHospitals[index].verifiedAt,
        );
      }

      return true;
    } catch (e) {
      FirebaseError.handle(e);
      return false;
    } finally {
      updatingHospitalIds.remove(hospitalId);
    }
  }
}
