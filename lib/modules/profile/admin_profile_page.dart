import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:scale_button/scale_button.dart';

import '../../core/firebase/firebase_reference.dart';
import '../../core/routes/route_helper.dart';
import '../../core/theme/colors.dart';
import '../../shared/utils/validator.dart';
import '../../shared/widgets/app_customized_bg.dart';
import '../../shared/widgets/app_text.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/custom_app_button.dart';
import '../../shared/widgets/custom_circle_avatar_widget.dart';
import '../../shared/widgets/custom_circular_progress_indicator.dart';
import '../../shared/widgets/custom_responsive_builder.dart';
import '../../shared/widgets/dashboard_container_widget.dart';
import 'admin_profile_controller.dart';

class AdminProfilePage extends GetView<AdminProfileController> {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppCustomizedBg(
      body: CustomResponsiveBuilder(
        builder: (context, sizingInfo) {
          return Obx(() {
            if (controller.isLoading.value && controller.adminModel.value == null) {
              return const Center(
                child: CustomCircularProgressIndicator(height: 36, width: 36),
              );
            }

            final admin = controller.adminModel.value;
            final savedUsername = admin?.username.trim() ?? '';
            final authName =
                FirebaseReference.firebaseAuth.currentUser?.displayName
                        ?.trim() ??
                    '';
            final accountEmail = admin?.email.trim().isNotEmpty == true
                ? admin!.email.trim()
                : FirebaseReference.firebaseAuth.currentUser?.email?.trim() ??
                    '';
            final accountName = savedUsername.isNotEmpty
                ? savedUsername
                : authName.isNotEmpty
                    ? authName
                    : accountEmail.isNotEmpty
                        ? accountEmail
                        : 'Admin';
            final avatarInitial =
                String.fromCharCode(accountName.runes.first).toUpperCase();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Navigation Bar
                      Row(
                        children: [
                          ScaleButton(
                            onTap: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.goNamed(RouteHelpers.adminAnalytics);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.border.withValues(alpha: 0.3),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.chevronLeft,
                                    size: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                  SizedBox(width: 8),
                                  AppText(
                                    text: "Back to Dashboard",
                                    size: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Profile Main Container Card
                      DashboardContainerWidget(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: controller.profileFormStateKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Profile Header with Avatar & Admin Badge
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide = constraints.maxWidth > 550;

                                  Widget avatarWidget = Center(
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Obx(() {
                                          if (controller.selectedImageBytes.value != null) {
                                            return CircleAvatar(
                                              radius: 46,
                                              backgroundImage: MemoryImage(
                                                  controller.selectedImageBytes.value!),
                                            );
                                          } else if (admin?.displayPhoto != null &&
                                              admin!.displayPhoto!.isNotEmpty) {
                                            return CustomCircleAvatarWidget(
                                              imageUrl: admin.displayPhoto,
                                              radius: 46,
                                            );
                                          } else {
                                            return CircleAvatar(
                                              radius: 46,
                                              backgroundColor:
                                              AppColors.primary.withValues(alpha: 0.1),
                                              child: AppText(
                                                text: avatarInitial,
                                                size: 32,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            );
                                          }
                                        }),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: InkWell(
                                            onTap: controller.pickProfileImage,
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const FaIcon(
                                                FontAwesomeIcons.camera,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  Widget infoWidget = Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: isWide
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: isWide
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.center,
                                        children: [
                                          AppText(
                                            text: accountName,
                                            size: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: (admin?.isSuperAdmin ?? false)
                                                  ? AppColors.primary.withValues(alpha: 0.1)
                                                  : Colors.blue.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: AppText(
                                              text: admin?.accountType.displayName ?? "Admin",
                                              size: 11,
                                              fontWeight: FontWeight.bold,
                                              color: (admin?.isSuperAdmin ?? false)
                                                  ? AppColors.primary
                                                  : Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      AppText(
                                        text: accountEmail,
                                        size: 13,
                                        color: AppColors.textSecondary,
                                        textAlign: isWide ? TextAlign.left : TextAlign.center,
                                      ),
                                    ],
                                  );

                                  if (isWide) {
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        avatarWidget,
                                        const SizedBox(width: 20),
                                        Expanded(child: infoWidget),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        avatarWidget,
                                        const SizedBox(height: 14),
                                        infoWidget,
                                      ],
                                    );
                                  }
                                },
                              ),

                              const SizedBox(height: 24),
                              const Divider(height: 1),
                              const SizedBox(height: 24),

                              // Form Section Title
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const FaIcon(
                                      FontAwesomeIcons.userPen,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const AppText(
                                    text: "Account Details",
                                    size: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Username Input
                              const AppText(
                                text: "USERNAME",
                                size: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 6),
                              AppTextField(
                                controller: controller.usernameController,
                                enabled: true,
                                hintText: "Enter username",
                                prefix: const Icon(
                                  Icons.person_outline,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                validator: (val) =>
                                    ValidationUtil.validateName(val ?? '', "Username"),
                              ),

                              const SizedBox(height: 16),

                              // Email Input
                              const AppText(
                                text: "EMAIL ADDRESS",
                                size: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 6),
                              AppTextField(
                                controller: controller.emailController,
                                enabled: true,
                                hintText: "Enter email address",
                                prefix: const Icon(
                                  Icons.email_outlined,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                                validator: (val) => ValidationUtil.validateEmail(val ?? ''),
                              ),

                              const SizedBox(height: 28),
                              const Divider(height: 1),
                              const SizedBox(height: 24),

                              // Account Role & Permissions Overview Section
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const FaIcon(
                                      FontAwesomeIcons.shieldHalved,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const AppText(
                                    text: "Permissions & Role Info",
                                    size: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isGrid = constraints.maxWidth > 550;

                                  Widget col1 = _buildMetaTile(
                                    label: "ACCOUNT TYPE",
                                    value: admin?.accountType.displayName ?? "Admin",
                                    icon: FontAwesomeIcons.userGear,
                                  );

                                  Widget col2 = _buildMetaTile(
                                    label: "APPROVAL STATUS",
                                    value: (admin?.isApproved ?? false)
                                        ? "Approved"
                                        : "Pending Approval",
                                    icon: (admin?.isApproved ?? false)
                                        ? FontAwesomeIcons.circleCheck
                                        : FontAwesomeIcons.clock,
                                    valueColor: (admin?.isApproved ?? false)
                                        ? Colors.green
                                        : Colors.orange,
                                  );

                                  if (isGrid) {
                                    return Row(
                                      children: [
                                        Expanded(child: col1),
                                        const SizedBox(width: 16),
                                        Expanded(child: col2),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        col1,
                                        const SizedBox(height: 12),
                                        col2,
                                      ],
                                    );
                                  }
                                },
                              ),

                              const SizedBox(height: 16),

                              // Accessible Tabs Chips
                              const AppText(
                                text: "MODULE PERMISSIONS",
                                size: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 8),

                              if (admin?.isSuperAdmin ?? false)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.circleCheck,
                                        size: 14,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: 8),
                                      AppText(
                                        text: "Super Admin — Full access to all modules",
                                        size: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                )
                              else if (admin?.accessibleTabs.isNotEmpty ?? false)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: admin!.accessibleTabs.map((tab) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: AppText(
                                        text: tab.displayName,
                                        size: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    );
                                  }).toList(),
                                )
                              else
                                const AppText(
                                  text: "No module permissions assigned",
                                  size: 13,
                                  color: AppColors.textSecondary,
                                ),

                              const SizedBox(height: 32),
                              const Divider(height: 1),
                              const SizedBox(height: 24),

                              // Action Buttons
                              Obx(() => Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      if (context.canPop()) {
                                        context.pop();
                                      } else {
                                        context.goNamed(RouteHelpers.adminAnalytics);
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                      side: const BorderSide(
                                        color: AppColors.border,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const AppText(
                                      text: "Cancel",
                                      size: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  CustomAppButton(
                                    onTap: controller.updateProfile,
                                    isLoading: controller.isSaving.value ||
                                        controller.isUploadingImage.value,
                                    title: "Save Profile",
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildMetaTile({
    required String label,
    required String value,
    required FaIconData icon,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 14, color: valueColor ?? AppColors.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: label,
                size: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 2),
              AppText(
                text: value,
                size: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
