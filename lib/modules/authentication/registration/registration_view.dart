import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';

import '../../../core/routes/route_helper.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/utils/validator.dart';
import '../../../shared/widgets/app_customized_bg.dart';
import '../../../shared/widgets/app_text.dart';
import '../../../shared/widgets/auth_background_widget.dart';
import '../../../shared/widgets/auth_text_field.dart';
import '../../../shared/widgets/custom_app_button.dart';
import '../../../shared/widgets/custom_single_child_scroll_view.dart';
import 'registration_logic.dart';

class RegistrationPage extends GetView<RegistrationLogic> {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCustomizedBg(
      body: CustomSingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery
                  .sizeOf(context)
                  .height / 8.5,
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
              isScrollable: false,
              onChanged: controller.onValidationChanged,
              formKey: controller.registerFormStateKey,
              pageTitle: "Admin Registration",
              pageSubTitle: "Enter your details to continue",
              children: [
                const SizedBox(height: 40),
                AuthTextField(
                  fieldTitle: "Name",
                  controller: controller.userNameController,
                  validator: (p0) => ValidationUtil.validateName(p0!, "Name"),
                  suffix: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FaIcon(FontAwesomeIcons.user, size: 20),
                  ),
                ),

                const SizedBox(height: 20),
                AuthTextField(
                  fieldTitle: "Email",
                  controller: controller.emailController,
                  validator: (p0) => ValidationUtil.validateEmail(p0!),
                  suffix: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FaIcon(FontAwesomeIcons.envelope, size: 20),
                  ),
                ),

                const SizedBox(height: 20),

                Obx(() {
                  return AuthTextField(
                    fieldTitle: "Password",
                    validator: (p0) => ValidationUtil.validatePassword(p0!),
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    suffix: IconButton(
                      onPressed: () {
                        controller.isPasswordVisible.value =
                        !controller.isPasswordVisible.value;
                      },
                      icon: FaIcon(
                        !controller.isPasswordVisible.value
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        size: 20,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const AppText(text: "Already have an account?"),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => context.goNamed(RouteHelpers.adminLogin),
                      child: AppText(
                        text: "Login",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                Obx(() {
                  return CustomAppButton(
                    title: "Register",
                    isLoading: controller.isSubmitting.value,
                    onTap: () => controller.adminRegister(context),
                    isDisabled: !controller.isRegistrationComplete.value,
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
