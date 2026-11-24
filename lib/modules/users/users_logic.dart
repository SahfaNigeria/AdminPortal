import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/health_professional/health_professional_controller.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/mothers/mothers_controller.dart';
import 'package:material_ui/material_ui.dart';

class UsersLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final MothersController mothersController;
  final HealthProfessionalController healthProfessionalController;

  late TabController tabController;

  UsersLogic(
      {required this.mothersController,
      required this.healthProfessionalController});

  @override
  void onInit() {
    tabController = TabController(
      length: 3,
      vsync: this,
    );
    tabController.addListener(_loadSelectedTab);
    super.onInit();
  }

  @override
  void onReady() {
    mothersController.fetchMothers();
    super.onReady();
  }

  void _loadSelectedTab() {
    if (tabController.index == 1 && !tabController.indexIsChanging) {
      healthProfessionalController.fetchHealthProfessional();
    }
  }

  @override
  void onClose() {
    tabController.removeListener(_loadSelectedTab);
    tabController.dispose();
    super.onClose();
  }
}
