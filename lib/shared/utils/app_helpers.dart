import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jambomama_nigeria_admin_portal/shared/constants/app_constants.dart';

class AppHelpers {
  static final box = FlutterSecureStorage();

  static Future<bool> get isLoggedIn  async => await box.containsKey(key: AppConstants.adminIdKey);

  static Future<String?> get adminId async => await box.read(key: AppConstants.adminIdKey);

  static void clearStorage() async {
    await box.deleteAll();

  }
}