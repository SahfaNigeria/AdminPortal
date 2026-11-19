import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_customized_bg.dart';
import '../controller/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const AppCustomizedBg(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
        ],
      ),
    );
  }
}
