import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/firebase/firebase_reference.dart';
import '../../shared/model/hospital_model.dart';
import '../../shared/utils/firebase_error.dart';

class HospitalsController extends GetxController {
  final hospitals = <HospitalModel>[].obs;
  final filteredHospitals = <HospitalModel>[].obs;
  final currentPage = 1.obs;
  final isLoading = false.obs;
  static const int pageSize = 10;

  late final TextEditingController searchController;
  bool _hasLoaded = false;

  List<HospitalModel> get visibleHospitals =>
      searchController.text.trim().isEmpty ? hospitals : filteredHospitals;

  int get totalPages =>
      (visibleHospitals.length / pageSize).ceil().clamp(1, double.infinity).toInt();

  List<HospitalModel> get paginatedHospitals {
    final startIndex = (currentPage.value - 1) * pageSize;
    return visibleHospitals.skip(startIndex).take(pageSize).toList();
  }

  @override
  void onInit() {
    searchController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    fetchHospitals();
    super.onReady();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void searchHospitals(String query) {
    currentPage.value = 1;
    final searchQuery = query.trim().toLowerCase();
    if (searchQuery.isEmpty) {
      filteredHospitals.clear();
      return;
    }

    filteredHospitals.value = hospitals.where((hospital) {
      return hospital.name.toLowerCase().contains(searchQuery) ||
          hospital.id.toLowerCase().contains(searchQuery) ||
          hospital.type.toLowerCase().contains(searchQuery) ||
          hospital.address.toLowerCase().contains(searchQuery) ||
          hospital.district.toLowerCase().contains(searchQuery) ||
          hospital.phoneNumber.toLowerCase().contains(searchQuery);
    }).toList();
  }

  void changePage(int page) {
    currentPage.value = page.clamp(1, totalPages);
  }

  Future<void> fetchHospitals() async {
    if (_hasLoaded || isLoading.value) return;

    try {
      isLoading.value = true;
      final snapshot = await FirebaseReference.hospitals.get();
      hospitals.value = snapshot.docs
          .map((document) => HospitalModel.fromJson(document.data(), document.id))
          .toList();
      currentPage.value = 1;
      _hasLoaded = true;
    } catch (error) {
      FirebaseError.handle(error);
    } finally {
      isLoading.value = false;
    }
  }
}
