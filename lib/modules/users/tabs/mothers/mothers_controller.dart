import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/firebase_error.dart';

import '../../../../shared/model/mothers_model.dart';

class MothersController extends GetxController {
  final filteredMothers = <MothersModel>[].obs;
  final isSearchActive = false.obs;
  final isSearchLoading = false.obs;

  late TextEditingController searchController;

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

  Future<void> searchMothers([String? query]) async {
    final searchQuery = (query ?? searchController.text).trim().toLowerCase();
    if (searchQuery.isEmpty) {
      filteredMothers.clear();
      isSearchActive.value = false;
      return;
    }

    try {
      isSearchLoading.value = true;
      final data = await FirebaseReference.mothers.get();
      final results = data.docs
          .map(MothersModel.fromFirestore)
          .where((mother) =>
              mother.fullName.toLowerCase().contains(searchQuery) ||
              mother.motherId.toLowerCase().contains(searchQuery))
          .toList();

      filteredMothers.assignAll(results);
      isSearchActive.value = true;
    } catch (error) {
      FirebaseError.handle(error);
    } finally {
      isSearchLoading.value = false;
    }
  }
}
