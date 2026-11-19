import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late TextEditingController _emailController, _passwordController;

  final GlobalKey<FormState> loginFormStateKey = GlobalKey<FormState>();

  var isLoginComplete = false.obs;

  bool isPasswordHidden = true;

  @override
  void onInit() {
    // TODO: implement onInit
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onValidationChanged() {
    isLoginComplete.value = loginFormStateKey.currentState!.validate();
  }
}
