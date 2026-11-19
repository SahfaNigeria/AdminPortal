import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginLogic extends GetxController {
  late TextEditingController emailController, passwordController;

  final GlobalKey<FormState> loginFormStateKey = GlobalKey<FormState>();

  var isLoginComplete = false.obs;

  RxBool isPasswordVisible = false.obs;

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
}
