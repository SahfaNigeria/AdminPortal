import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jambomama_nigeria_admin_portal/core/routes/route_helper.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'package:jambomama_nigeria_admin_portal/modules/profile/access/admin_access_controller.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

class NoTabsAssignedPage extends GetView<AdminAccessController> {
  const NoTabsAssignedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Obx(() {
                  final admin = controller.admin.value;
                  final hasTabs = controller.hasAnyTabAccess;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: (hasTabs
                                  ? const Color(0xFF2E7D32)
                                  : AppColors.primary)
                              .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          hasTabs
                              ? Icons.check_circle_outline_rounded
                              : Icons.dashboard_customize_outlined,
                          size: 38,
                          color: hasTabs
                              ? const Color(0xFF2E7D32)
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppText(
                        text: hasTabs
                            ? 'Dashboard access is ready'
                            : 'No dashboard tabs assigned',
                        size: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      AppText(
                        text: hasTabs
                            ? 'A Super Admin assigned dashboard access to your '
                                'account. Continue to your dashboard.'
                            : 'Your account has been approved, but a Super '
                                'Admin has not assigned any dashboard tabs to '
                                'your account yet.',
                        size: 15,
                        color: AppColors.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                      if (admin?.email.isNotEmpty ?? false) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const AppText(
                                text: 'ADMIN ACCOUNT',
                                size: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(height: 4),
                              AppText(
                                text: admin!.email,
                                size: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      if (hasTabs)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                context.go(controller.firstAccessibleLocation),
                            icon: const Icon(Icons.dashboard_outlined),
                            label: const Text('Continue to dashboard'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.surface,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        )
                      else
                        const AppText(
                          text: 'This page will update automatically when a '
                              'Super Admin assigns access.',
                          size: 12,
                          color: AppColors.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () =>
                            context.goNamed(RouteHelpers.adminProfile),
                        child: const Text(
                          'View account profile',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
