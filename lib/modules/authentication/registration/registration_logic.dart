import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/core/routes/route_helper.dart';
import 'package:jambomama_nigeria_admin_portal/core/services/notification/firebase_notification_service.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_notification_model.dart';
import 'package:material_ui/material_ui.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/utils/firebase_error.dart';
import '../../../shared/utils/toast.dart';

class RegistrationLogic extends GetxController {
  final FlutterSecureStorage flutterSecureStorage;
  late TextEditingController emailController,
      passwordController,
      userNameController,
      countryController;

  final GlobalKey<FormState> registerFormStateKey = GlobalKey<FormState>();

  var isRegistrationComplete = false.obs;

  RxBool isPasswordVisible = false.obs;

  RxBool isSubmitting = false.obs;

  RegistrationLogic({required this.flutterSecureStorage});

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    userNameController = TextEditingController();
    countryController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    countryController.dispose();
    super.dispose();
  }

  void onValidationChanged() {
    isRegistrationComplete.value =
        registerFormStateKey.currentState!.validate();
  }

  Future<void> adminRegister(BuildContext context) async {
    try {
      isSubmitting.value = true;
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final userName = userNameController.text.trim();
      final country = countryController.text.trim();
      final userCredential =
          await FirebaseReference.firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user?.uid != null) {
        await userCredential.user!.updateDisplayName(userName);
        final adminModel = AdminModel(
          id: userCredential.user?.uid ?? "",
          approvedBySuperAdminId: "",
          displayPhoto: "",
          username: userName,
          email: email,
          country: country.isNotEmpty ? country : null,
          accountType: AccountType.admin,
          accessibleTabs: [],
          isApproved: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        log("Admin Model ${adminModel.toMap()}");
        await FirebaseReference.admins
            .doc(userCredential.user?.uid ?? "")
            .set(adminModel.toMap())
            .then((value) async {
          final fid = await FirebaseNotificationService.getInstallationId();
          final AdminNotificationModel adminNotificationModel =
              AdminNotificationModel(
            fid: fid ?? "",
            lastUpdated: DateTime.now(),
          );
          await FirebaseReference.admins
              .doc(userCredential.user?.uid ?? "")
              .collection(FirebaseReference.notificationIdSubCollection)
              .doc(userCredential.user?.uid ?? "").set(adminNotificationModel.toMap())
              .then((value) async {
            isSubmitting.value = false;
            await flutterSecureStorage.write(
                key: AppConstants.adminIdKey, value: adminModel.id);
            Get.focusScope?.unfocus();
            context.goNamed(RouteHelpers.adminAnalytics);
            AppToast.success("Admin registered successfully");
            userNameController.clear();
            emailController.clear();
            passwordController.clear();
            countryController.clear();
          });
        });
      } else {
        isSubmitting.value = false;
        AppToast.error("Something went wrong");
      }
    } catch (e) {
      log("Admin Registration Error $e");
      isSubmitting.value = false;
      FirebaseError.handle(e);
    }
  }
}
