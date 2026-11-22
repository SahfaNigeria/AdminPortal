import 'dart:developer';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class UsersLogic extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {

    tabController = TabController(
      length: 3,
      vsync: this,
    );

    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        log("Tab index changed to: ${tabController.index}");
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
