import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/firebase/firebase_reference.dart';
import '../../../core/routes/route_helper.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/utils/firebase_error.dart';
import '../../../shared/utils/toast.dart';

class LoginLogic extends GetxController {
  late TextEditingController emailController, passwordController;

  final FlutterSecureStorage flutterSecureStorage;

  final GlobalKey<FormState> loginFormStateKey = GlobalKey<FormState>();

  var isLoginComplete = false.obs;

  RxBool isPasswordVisible = false.obs;


  RxBool isSubmitting = false.obs;

  LoginLogic({required this.flutterSecureStorage});

  @override
  void onInit() {
    // TODO: implement onInit
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onValidationChanged() {
    isLoginComplete.value = loginFormStateKey.currentState!.validate();
  }


  Future<void> adminLogin(BuildContext context) async {
    try{
      isSubmitting.value = true;
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final userCredential = await FirebaseReference.firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password

      );
      if(userCredential.user?.uid != null){
        isSubmitting.value = false;
        await flutterSecureStorage.write( key: AppConstants.adminIdKey,  value: userCredential.user?.uid);
        Get.focusScope?.unfocus();
        context.goNamed(RouteHelpers.adminAnalytics);
        emailController.clear();
        passwordController.clear();
      }else{
        isSubmitting.value = false;
        AppToast.error("Something went wrong");

      }

    }catch(e){
      log("Admin Login Error $e");
      isSubmitting.value = false;
      FirebaseError.handle(e);
    }
  }
}
