import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/firebase_error.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/toast.dart';

import '../../../../shared/model/mothers_model.dart';

class MothersController extends GetxController {
  final filteredMothers = <MothersModel>[].obs;
  final isSearchActive = false.obs;
  final isSearchLoading = false.obs;
  final sendingPasswordResetIds = <String>{}.obs;
  final selectedCountry = RxnString();

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
    final countryQuery = selectedCountry.value?.trim().toLowerCase() ?? '';

    if (searchQuery.isEmpty && countryQuery.isEmpty) {
      filteredMothers.clear();
      isSearchActive.value = false;
      return;
    }

    try {
      isSearchLoading.value = true;
      final data = await FirebaseReference.mothers.get();
      final results = data.docs.map(MothersModel.fromFirestore).where((mother) {
        final matchesSearch = searchQuery.isEmpty ||
            mother.fullName.toLowerCase().contains(searchQuery) ||
            mother.motherId.toLowerCase().contains(searchQuery) ||
            mother.email.toLowerCase().contains(searchQuery);

        final matchesCountry = countryQuery.isEmpty ||
            mother.countryValue.toLowerCase().contains(countryQuery);

        return matchesSearch && matchesCountry;
      }).toList();

      filteredMothers.assignAll(results);
      isSearchActive.value = true;
    } catch (error) {
      FirebaseError.handle(error);
    } finally {
      isSearchLoading.value = false;
    }
  }

  void setSelectedCountry(String? country) {
    selectedCountry.value = country;
    searchMothers();
  }

  void clearFilter() {
    searchController.clear();
    selectedCountry.value = null;
    filteredMothers.clear();
    isSearchActive.value = false;
  }

  Future<void> sendPasswordResetLink(String motherId, String email) async {
    final resetEmail = email.trim();
    if (resetEmail.isEmpty) {
      AppToast.error('This user does not have an email address.');
      return;
    }
    if (sendingPasswordResetIds.contains(motherId)) {
      return;
    }

    sendingPasswordResetIds.add(motherId);
    try {
      await FirebaseReference.firebaseAuth
          .sendPasswordResetEmail(email: resetEmail);
      AppToast.success('Password reset link sent to $resetEmail.');
    } catch (error) {
      FirebaseError.handle(error);
    } finally {
      sendingPasswordResetIds.remove(motherId);
    }
  }
}
