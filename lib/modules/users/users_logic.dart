import 'dart:developer';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/health_professional/health_professional_controller.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/mothers/mothers_controller.dart';
import 'package:material_ui/material_ui.dart';

class UsersLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final MothersController mothersController;
  final HealthProfessionalController healthProfessionalController;

  late TabController tabController;

  UsersLogic({required this.mothersController, required this.healthProfessionalController});

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
