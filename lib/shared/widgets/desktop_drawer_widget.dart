import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jambomama_nigeria_admin_portal/modules/profile/access/admin_access_controller.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/app_helpers.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_single_child_scroll_view.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/routes/route_helper.dart';
import '../../core/theme/colors.dart';
import 'admin_identity_widget.dart';
import 'app_text.dart';
import 'custom_list_tile.dart';

class DesktopDraweWidget extends StatelessWidget {
  const DesktopDraweWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final accessController = Get.find<AdminAccessController>();

    return AnimatedBuilder(
      animation: router.routerDelegate,
      builder: (context, child) {
        final currentRoute = router.state.name;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const AdminIdentityWidget(
                    radius: 18,
                    showRole: true,
                    showEmail: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: AppText(
                  text: "MAIN MENU",
                  size: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: CustomSingleChildScrollView(
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (accessController
                            .hasTabAccess(AdminTab.analytics)) ...[
                          CustomListTileWidget(
                            iconSize: 15,
                            textSize: 14,
                            text: "Analytics",
                            iconData: FontAwesomeIcons.chartPie,
                            enabled: currentRoute == RouteHelpers.adminAnalytics,
                            onTap: () =>
                                context.goNamed(RouteHelpers.adminAnalytics),
                          ),
                          const SizedBox(height: 6),
                        ],
                        if (accessController.hasTabAccess(AdminTab.users)) ...[
                          CustomListTileWidget(
                            iconSize: 15,
                            textSize: 14,
                            text: "Users",
                            iconData: FontAwesomeIcons.users,
                            enabled: currentRoute == RouteHelpers.adminUsers,
                            onTap: () =>
                                context.goNamed(RouteHelpers.adminUsers),
                          ),
                          const SizedBox(height: 6),
                        ],
                        if (accessController
                            .hasTabAccess(AdminTab.hospital)) ...[
                          CustomListTileWidget(
                            iconSize: 15,
                            textSize: 14,
                            text: "Hospitals",
                            iconData: FontAwesomeIcons.hospital,
                            enabled: currentRoute == RouteHelpers.adminHospitals,
                            onTap: () =>
                                context.goNamed(RouteHelpers.adminHospitals),
                          ),
                          const SizedBox(height: 6),
                        ],
                        if (accessController
                            .hasTabAccess(AdminTab.approval)) ...[
                          CustomListTileWidget(
                            iconSize: 15,
                            textSize: 14,
                            text: "Emergencies",
                            iconData: FontAwesomeIcons.triangleExclamation,
                            enabled:
                                currentRoute == RouteHelpers.adminEmergencies,
                            onTap: () =>
                                context.goNamed(RouteHelpers.adminEmergencies),
                          ),
                          const SizedBox(height: 6),
                        ],
                        if (accessController
                            .hasTabAccess(AdminTab.contents)) ...[
                          CustomListTileWidget(
                            iconSize: 15,
                            textSize: 14,
                            text: "Contents",
                            iconData: FontAwesomeIcons.pen,
                            enabled: currentRoute == RouteHelpers.adminContents,
                            onTap: () =>
                                context.goNamed(RouteHelpers.adminContents),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.black12),
              const SizedBox(height: 12),
              CustomListTileWidget(
                iconSize: 15,
                textSize: 14,
                text: "Log Out",
                iconData: FontAwesomeIcons.rightFromBracket,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primary,
                onTap: () {
                  AppHelpers.clearStorage();
                  context.goNamed(RouteHelpers.adminLogin);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
