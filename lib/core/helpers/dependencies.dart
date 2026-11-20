import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:jambomama_nigeria_admin_portal/modules/authentication/registration/registration_logic.dart';

import '../../modules/authentication/login/login_logic.dart';
import '../../modules/users/users_logic.dart';

Future<void> init() async {
  /// loading the getx dependencies
  final box = GetSecureStorage(password: 'strongpassword');

  Get.lazyPut(() => box, fenix: true);

  /// api client

  /// controllers
  Get.lazyPut(() => LoginLogic(), fenix: true);
  Get.lazyPut(() => UsersLogic(), fenix: true);
  Get.lazyPut(() => RegistrationLogic(), fenix: true);
}
