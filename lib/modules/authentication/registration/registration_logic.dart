import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/core/routes/route_helper.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';
import 'package:material_ui/material_ui.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/utils/firebase_error.dart';
import '../../../shared/utils/toast.dart';

class RegistrationLogic extends GetxController {
  final FlutterSecureStorage flutterSecureStorage;
  late TextEditingController emailController, passwordController, userNameController;

  final GlobalKey<FormState> registerFormStateKey = GlobalKey<FormState>();

  var isRegistrationComplete = false.obs;

  RxBool isPasswordVisible = false.obs;


  RxBool isSubmitting = false.obs;

  RegistrationLogic({required this.flutterSecureStorage});

  @override
  void onInit() {
    // TODO: implement onInit
    emailController = TextEditingController();
    passwordController = TextEditingController();
    userNameController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  void onValidationChanged() {
    isRegistrationComplete.value = registerFormStateKey.currentState!.validate();
  }


  Future<void> adminRegister(BuildContext context) async {
    try{
      isSubmitting.value = true;
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final userName = userNameController.text.trim();
      final userCredential = await FirebaseReference.firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      if(userCredential.user?.uid != null){
        await userCredential.user!.updateDisplayName(userName);
        final adminModel = AdminModel(
          id: userCredential.user?.uid??"",
          approvedBySuperAdminId: "",
          displayPhoto: "",
          username: userName,
          email: email,
          accountType: AccountType.admin,
          accessibleTabs: [],
          isApproved: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        log("Admin Model ${adminModel.toMap()}");
         await FirebaseReference.admins.doc(userCredential.user?.uid??"").set(
          adminModel.toMap()
        ).then((value)async{
           isSubmitting.value = false;
           userNameController.clear();
           emailController.clear();
           passwordController.clear();
           await flutterSecureStorage.write( key: AppConstants.adminIdKey,  value: adminModel.id);
           Get.focusScope?.unfocus();
           context.goNamed(RouteHelpers.adminAnalytics);
           AppToast.success("Admin registered successfully");
         });

      }else{
        isSubmitting.value = false;
        AppToast.error("Something went wrong");
      }

    }catch(e){
      log("Admin Registration Error $e");
      isSubmitting.value = false;
      FirebaseError.handle(e);
    }
  }
}
