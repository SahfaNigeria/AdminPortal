import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/health_professionals.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/firebase_error.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/isolate_helper.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/firebase/firebase_parser_function.dart';

class HealthProfessionalController extends GetxController {
  final healthProfessionals = <HealthProfessionalsModel>[].obs;
  final updatingProfessionalIds = <String>{}.obs;
  final currentPage = 1.obs;
  static const int pageSize = 10;

  late TextEditingController searchController;
  final isLoading = false.obs;
  bool _hasLoaded = false;

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

  final filteredHealthProfessionals = <HealthProfessionalsModel>[].obs;

  List<HealthProfessionalsModel> get visibleHealthProfessionals =>
      searchController.text.trim().isEmpty
          ? healthProfessionals
          : filteredHealthProfessionals;

  int get totalPages =>
      (visibleHealthProfessionals.length / pageSize)
          .ceil()
          .clamp(1, double.infinity)
          .toInt();

  List<HealthProfessionalsModel> get paginatedHealthProfessionals {
    final startIndex = (currentPage.value - 1) * pageSize;
    return visibleHealthProfessionals.skip(startIndex).take(pageSize).toList();
  }

  bool isUpdating(String professionalId) =>
      updatingProfessionalIds.contains(professionalId);

  void searchHealthProfessionals(String query) {
    currentPage.value = 1;
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      filteredHealthProfessionals.clear();
      return;
    }

    filteredHealthProfessionals.value = healthProfessionals.where((mother) {
      final username = mother.fullName.toLowerCase();
      final userId = mother.qualificationNumber.toLowerCase();

      return username.contains(searchQuery) || userId.contains(searchQuery);
    }).toList();
  }

  void changePage(int page) {
    currentPage.value = page.clamp(1, totalPages);
  }

  Future<bool> updateApproval(bool approve, String midwifeId) async {
    if (isUpdating(midwifeId)) return false;

    try {
      updatingProfessionalIds.add(midwifeId);
      await FirebaseReference.healthProfessionals.doc(midwifeId).update({
        'approved': approve,
      });
      final professionalIndex = healthProfessionals.indexWhere(
        (professional) => professional.midWifeId == midwifeId,
      );
      if (professionalIndex != -1) {
        final updatedProfessional = _withApproval(
          healthProfessionals[professionalIndex],
          approve,
        );
        healthProfessionals[professionalIndex] = updatedProfessional;

        final filteredIndex = filteredHealthProfessionals.indexWhere(
          (professional) => professional.midWifeId == midwifeId,
        );
        if (filteredIndex != -1) {
          filteredHealthProfessionals[filteredIndex] = updatedProfessional;
        }
      }
      return true;
    } catch (e) {
      FirebaseError.handle(e);
      return false;
    } finally {
      updatingProfessionalIds.remove(midwifeId);
    }
  }

  HealthProfessionalsModel _withApproval(
    HealthProfessionalsModel professional,
    bool approved,
  ) {
    return HealthProfessionalsModel(
      approved: approved,
      cityValue: professional.cityValue,
      countryValue: professional.countryValue,
      createdAt: professional.createdAt,
      email: professional.email,
      fullName: professional.fullName,
      healthFacility: professional.healthFacility,
      midWifeId: professional.midWifeId,
      midWifeImage: professional.midWifeImage,
      phoneNumber: professional.phoneNumber,
      position: professional.position,
      professional: professional.professional,
      qualificationNumber: professional.qualificationNumber,
      stateValue: professional.stateValue,
      villageTown: professional.villageTown,
    );
  }

  Future<void> fetchHealthProfessional() async {
    if (_hasLoaded || isLoading.value) return;

    try {
      isLoading.value = true;
      final data = await FirebaseReference.healthProfessionals.get();
      final healthProfF = await IsolateHelper.run(
        parseHealthProfessionals,
        data.docs.map((doc) => {...doc.data(), '_documentId': doc.id}).toList(),
      );
      healthProfessionals.value = healthProfF;
      currentPage.value = 1;
      _hasLoaded = true;
    } catch (error) {
      FirebaseError.handle(error);
    } finally {
      isLoading.value = false;
    }
  }
}
