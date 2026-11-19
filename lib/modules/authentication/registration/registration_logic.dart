import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class RegistrationLogic extends GetxController {
  late TextEditingController emailController, passwordController, userNameController;

  final GlobalKey<FormState> registerFormStateKey = GlobalKey<FormState>();

  var isRegistrationComplete = false.obs;

  RxBool isPasswordVisible = false.obs;

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
}
