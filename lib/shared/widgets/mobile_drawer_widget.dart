import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jambomama_nigeria_admin_portal/modules/profile/access/admin_access_controller.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/routes/route_helper.dart';
import '../../core/theme/colors.dart';
import 'admin_identity_widget.dart';
import 'app_text.dart';
import 'custom_list_tile.dart';
import 'logo_widget.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? currentRoute;

  @override
  void initState() {
    // TODO: implement initState
    _initCurrentRoute();
    super.initState();
  }

  void _initCurrentRoute() {
    try {
      currentRoute = GoRouter.of(context).state.name;
    } catch (_) {
      currentRoute = null;
    }
  }

  void _updateCurrentRoute({VoidCallback? callback}) {
    Scaffold.of(context).closeDrawer();
    callback?.call();

    setState(() {
      currentRoute = GoRouter.of(context).state.name;
    });
  }

  final accessController = Get.find<AdminAccessController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //     topRight: Radius.circular(24),
      //     bottomRight: Radius.circular(24),
      //   ),
      // ),
      child: SafeArea(
        child: Column(
          children: [
            // Header Section: Brand Logo & Title
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const LogoWidget(
                    size: Size(40, 50),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppText(
                          text: "Admin Portal",
                          size: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const AppText(
                            text: "Admin Dashboard",
                            size: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // User Profile Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: const AdminIdentityWidget(
                radius: 20,
                showRole: true,
                showEmail: true,
              ),
            ),

            const SizedBox(height: 8),

            // Main Menu Section Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  AppText(
                    text: "MAIN MENU",
                    size: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),

            // Navigation Options List
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Obx(
                  () => Column(
                    children: [
                      if (accessController
                          .hasTabAccess(AdminTab.analytics)) ...[
                        CustomListTileWidget(
                          iconSize: 14,
                          textSize: 12,
                          text: "Analytics",
                          iconData: FontAwesomeIcons.chartPie,
                          enabled: currentRoute == RouteHelpers.adminAnalytics,
                          onTap: () {
                            _updateCurrentRoute(
                              callback: () {
                                context.goNamed(RouteHelpers.adminAnalytics);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                      ],
                      if (accessController.hasTabAccess(AdminTab.users)) ...[
                        CustomListTileWidget(
                          iconSize: 14,
                          textSize: 12,
                          text: "Users",
                          iconData: FontAwesomeIcons.users,
                          enabled: currentRoute == RouteHelpers.adminUsers,
                          onTap: () {
                            _updateCurrentRoute(
                              callback: () {
                                context.goNamed(RouteHelpers.adminUsers);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                      ],
                      if (accessController.hasTabAccess(AdminTab.hospital)) ...[
                        CustomListTileWidget(
                          iconSize: 14,
                          textSize: 12,
                          text: "Hospitals",
                          iconData: FontAwesomeIcons.hospital,
                          enabled: currentRoute == RouteHelpers.adminHospitals,
                          onTap: () {
                            _updateCurrentRoute(
                              callback: () {
                                context.goNamed(RouteHelpers.adminHospitals);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                      ],
                      if (accessController.hasTabAccess(AdminTab.approval)) ...[
                        CustomListTileWidget(
                          iconSize: 14,
                          textSize: 12,
                          text: "Emergencies",
                          iconData: FontAwesomeIcons.triangleExclamation,
                          enabled:
                              currentRoute == RouteHelpers.adminEmergencies,
                          onTap: () {
                            _updateCurrentRoute(
                              callback: () {
                                context.goNamed(RouteHelpers.adminEmergencies);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                      ],
                      if (accessController.hasTabAccess(AdminTab.contents)) ...[
                        CustomListTileWidget(
                          iconSize: 14,
                          textSize: 12,
                          text: "Contents",
                          iconData: FontAwesomeIcons.pen,
                          enabled: currentRoute == RouteHelpers.adminContents,
                          onTap: () {
                            _updateCurrentRoute(
                              callback: () {
                                context.goNamed(RouteHelpers.adminContents);
                              },
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Footer Section: Logout & Version
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  CustomListTileWidget(
                    iconSize: 16,
                    textSize: 15,
                    text: "Log Out",
                    iconData: FontAwesomeIcons.rightFromBracket,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.primary,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.goNamed(RouteHelpers.adminLogin);
                    },
                  ),
                  const SizedBox(height: 12),
                  const AppText(
                    text: "Admin Portal v1.0",
                    size: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
