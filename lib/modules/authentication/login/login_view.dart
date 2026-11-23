import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/auth_background_widget.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/auth_text_field.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_single_child_scroll_view.dart';
import 'package:material_ui/material_ui.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_customized_bg.dart';
import '../../../core/routes/route_helper.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/utils/validator.dart';
import '../../../shared/widgets/custom_app_button.dart';
import 'login_logic.dart';

class LoginPage extends GetView<LoginLogic> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCustomizedBg(
      body: CustomSingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height/8.5,
            ),
            if (context.canPop()) Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const FaIcon(
                          FontAwesomeIcons.xmark,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            AuthBackgroundWidget(
              onChanged: controller.onValidationChanged,
              formKey: controller.loginFormStateKey,
              pageTitle: "Admin Login",
              pageSubTitle: "Enter your details to continue",
              children: [
                SizedBox(height: 40,),
                AuthTextField(
                  fieldTitle: "Email",
                  controller: controller.emailController,
                  validator: (p0) => ValidationUtil.validateEmail(p0!),
                  suffix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(FontAwesomeIcons.envelope, size: 20,),
                  ),
                ),

                SizedBox(height: 20,),

                Obx(() {
                  return AuthTextField(
                    fieldTitle: "Password",
                    validator: (p0) => ValidationUtil.validatePassword(p0!),
                    controller: controller.passwordController,
                    obscureText:
                    !controller.isPasswordVisible.value,
                    suffix: IconButton(
                      onPressed: () {
                        controller.isPasswordVisible.value =
                        !controller.isPasswordVisible.value;
                      }, icon: FaIcon(!controller.isPasswordVisible.value
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye, size: 20,),),
                  );
                }),


                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppText(text: "Don't have an account?"),
                    SizedBox(width: 5,),
                    GestureDetector(
                      onTap: () => context.goNamed(RouteHelpers.adminRegistration),
                      child: AppText(text: "Register", style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),),
                    )
                  ],
                ),

                SizedBox(height: 20,),

                Obx(() {
                  return CustomAppButton(
                    title: "Login",
                    onTap: () => controller.adminLogin(context),
                    isLoading: controller.isSubmitting.value,
                    isDisabled: !controller.isLoginComplete.value,
                  );
                })
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
