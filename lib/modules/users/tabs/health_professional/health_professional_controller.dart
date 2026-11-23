import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/health_professionals.dart';
import 'package:material_ui/material_ui.dart';

class HealthProfessionalController extends GetxController{
  final healthProfessionals = <HealthProfessionalsModel>[].obs;

  late TextEditingController searchController;
  final isLoading = false.obs;

  @override
  void onInit() {
    fetchHealthProfessional();
    searchController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  final filteredHealthProfessionals = <HealthProfessionalsModel>[].obs;

  void searchHealthProfessionals(String query) {
    final searchQuery = query.trim().toLowerCase();

    healthProfessionals.value = healthProfessionals.where((mother) {
      final username = mother.fullName.toLowerCase();
      final userId = mother.qualificationNumber.toLowerCase();

      return username.contains(searchQuery) ||
          userId.contains(searchQuery);
    }).toList();

    update();
  }

  void fetchHealthProfessional() async {
    try {
      isLoading.value = true;
      final data = await FirebaseReference.healthProfessionals.get();
      final healthProfF =
      data.docs.map((doc) => HealthProfessionalsModel.fromFirestore(doc)).toList();
      healthProfessionals.value = healthProfF;
    } finally {
      isLoading.value = false;
    }
  }
}