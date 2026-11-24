import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jambomama_nigeria_admin_portal/core/helpers/admin_access_controller.dart';
import 'package:jambomama_nigeria_admin_portal/core/routes/route_helper.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'package:jambomama_nigeria_admin_portal/shared/constants/app_constants.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/firebase_error.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/firebase/firebase_reference.dart';

class PendingApprovalPage extends GetView<AdminAccessController> {
  const PendingApprovalPage({Key? key}) : super(key: key);

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
                  final isApproved = admin?.isApproved ?? false;
                  final hasAdmin = admin != null;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: (isApproved
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFED6C02))
                              .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          !hasAdmin
                              ? Icons.error_outline_rounded
                              : isApproved
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.hourglass_top_rounded,
                          size: 38,
                          color: isApproved
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFED6C02),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppText(
                        text: isApproved
                            ? 'Your account is approved'
                            : hasAdmin
                                ? 'Approval pending'
                                : 'Account status unavailable',
                        size: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      AppText(
                        text: isApproved
                            ? 'A Super Admin approved your account. You can now '
                                'continue to your dashboard.'
                            : hasAdmin
                                ? 'Your registration is complete. A Super Admin '
                                    'must approve your account before you can '
                                    'access the admin dashboard.'
                                : 'We could not load your administrator account. '
                                    'Please sign out and sign in again.',
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
                      if (isApproved)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => context.go(
                              controller.firstAccessibleLocation,
                            ),
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
                      else if (hasAdmin)
                        const AppText(
                          text: 'This page will update automatically after '
                              'your account has been reviewed.',
                          size: 12,
                          color: AppColors.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => _signOut(context),
                        child: const Text(
                          'Sign out',
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

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseReference.firebaseAuth.signOut();
      await const FlutterSecureStorage().delete(
        key: AppConstants.adminIdKey,
      );
      await controller.clearCurrentAdmin();
      if (context.mounted) context.goNamed(RouteHelpers.adminLogin);
    } catch (error) {
      FirebaseError.handle(error);
    }
  }
}
