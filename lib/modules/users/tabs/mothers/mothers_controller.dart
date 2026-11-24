import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/firebase_error.dart';

import '../../../../core/firebase/firebase_parser_function.dart';
import '../../../../shared/model/mothers_model.dart';
import '../../../../shared/utils/isolate_helper.dart';

class MothersController extends GetxController {
  final mothers = <MothersModel>[].obs;
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

  final filteredMothers = <MothersModel>[].obs;

  List<MothersModel> get visibleMothers =>
      searchController.text.trim().isEmpty ? mothers : filteredMothers;

  int get totalPages =>
      (visibleMothers.length / pageSize).ceil().clamp(1, double.infinity).toInt();

  List<MothersModel> get paginatedMothers {
    final startIndex = (currentPage.value - 1) * pageSize;
    return visibleMothers.skip(startIndex).take(pageSize).toList();
  }

  void searchMothers(String query) {
    currentPage.value = 1;
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      filteredMothers.clear();
      return;
    }

    filteredMothers.value = mothers.where((mother) {
      final username = mother.fullName.toLowerCase();
      final userId = mother.motherId.toLowerCase();

      return username.contains(searchQuery) || userId.contains(searchQuery);
    }).toList();
  }

  void changePage(int page) {
    currentPage.value = page.clamp(1, totalPages);
  }

  Future<void> fetchMothers() async {
    if (_hasLoaded || isLoading.value) return;

    try {
      isLoading.value = true;
      final data = await FirebaseReference.mothers.get();
      final mothersData = await IsolateHelper.run(
        parseMothers,
        data.docs.map((doc) => {...doc.data(), '_documentId': doc.id}).toList(),
      );

      mothers.value = mothersData;
      currentPage.value = 1;
      _hasLoaded = true;
    } catch (error) {
      FirebaseError.handle(error);
    } finally {
      isLoading.value = false;
    }
  }
}
