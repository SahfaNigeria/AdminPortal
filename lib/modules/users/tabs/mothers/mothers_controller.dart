import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';

import '../../../../shared/model/mothers_model.dart';

class MothersController extends GetxController {
  final mothers = <MothersModel>[].obs;

  late TextEditingController searchController;
  final isLoading = false.obs;

  @override
  void onInit() {
    fetchMothers();
    searchController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  final filteredMothers = <MothersModel>[].obs;

  void searchMothers(String query) {
    final searchQuery = query.trim().toLowerCase();

    filteredMothers.value = mothers.where((mother) {
      final username = mother.fullName.toLowerCase();
      final userId = mother.motherId.toLowerCase();

      return username.contains(searchQuery) ||
          userId.contains(searchQuery);
    }).toList();

    update();
  }

  void fetchMothers() async {
    try {
      isLoading.value = true;
      final data = await FirebaseReference.mothers.get();
      final mothersF =
          data.docs.map((doc) => MothersModel.fromFirestore(doc)).toList();
      mothers.value = mothersF;
    } finally {
      isLoading.value = false;
    }
  }
}
