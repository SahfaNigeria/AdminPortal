import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:jambomama_nigeria_admin_portal/modules/authentication/login/controller/login_controller.dart';

Future<void> init() async {
  /// loading the getx dependencies
  final box = GetSecureStorage(password: 'strongpassword');

  Get.lazyPut(() => box, fenix: true);

  /// api client

  /// controllers
  Get.lazyPut(() => LoginController(), fenix: true);
}
