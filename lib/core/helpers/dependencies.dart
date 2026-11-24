import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/modules/authentication/registration/registration_logic.dart';
import 'package:jambomama_nigeria_admin_portal/modules/profile/access/admin_access_controller.dart';
import 'package:jambomama_nigeria_admin_portal/modules/profile/admin_profile_controller.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/health_professional/health_professional_controller.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/mothers/mothers_controller.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/admins/admins_controller.dart';

import '../../modules/analytics/admin_analytics_controller.dart';
import '../../modules/authentication/login/login_logic.dart';
import '../../modules/hospitals/add/admin_add_hospital_logic.dart';
import '../../modules/users/users_logic.dart';

Future<void> init() async {
  /// loading the getx dependencies
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Get.lazyPut(() => _storage, fenix: true);

  /// api client

  /// controllers
  Get.lazyPut(() => LoginLogic(flutterSecureStorage: _storage), fenix: true);
  Get.lazyPut(() => HealthProfessionalController(), fenix: true);
  Get.lazyPut(() => UsersLogic(), fenix: true);
  Get.lazyPut(() => AdminAnalyticsController(), fenix: true);
  Get.lazyPut(() => AdminProfileController(), fenix: true);
  Get.lazyPut(() => RegistrationLogic(flutterSecureStorage: _storage),
      fenix: true);
  Get.lazyPut(() => AdminAddHospitalLogic(), fenix: true);
  Get.lazyPut(() => MothersController(), fenix: true);
  Get.lazyPut(() => AdminsController(), fenix: true);
  Get.lazyPut(() => AdminAccessController(), fenix: true);
}
