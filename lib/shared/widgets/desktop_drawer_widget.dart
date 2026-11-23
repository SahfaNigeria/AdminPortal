import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/app_helpers.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/routes/route_helper.dart';
import '../../core/theme/colors.dart';
import 'app_text.dart';
import 'custom_list_tile.dart';

class DesktopDraweWidget extends StatefulWidget {
  const DesktopDraweWidget({Key? key}) : super(key: key);

  @override
  State<DesktopDraweWidget> createState() => _DesktopDraweWidgetState();
}

class _DesktopDraweWidgetState extends State<DesktopDraweWidget> {
  String? currentRoute;


  void _initCurrentRoute(){
    try {
      currentRoute = GoRouter.of(context).state.name;
    } catch (_) {
      currentRoute = null;
    }
  }

  void _updateCurrentRoute({VoidCallback? callback}){
    Scaffold.of(context).closeDrawer();
    callback?.call();
    setState(() {
      currentRoute = GoRouter.of(context).state.name;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    _initCurrentRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AppText(
              text: "MAIN MENU",
              size: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          CustomListTileWidget(
            iconSize: 15,
            textSize: 14,
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
          CustomListTileWidget(
            iconSize: 15,
            textSize: 14,
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
          CustomListTileWidget(
            iconSize: 15,
            textSize: 14,
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
          CustomListTileWidget(
            iconSize: 15,
            textSize: 14,
            text: "Emergencies",
            iconData: FontAwesomeIcons.triangleExclamation,
            enabled: currentRoute == RouteHelpers.adminEmergencies,
            onTap: () {
              _updateCurrentRoute(
                callback: () {
                  context.goNamed(RouteHelpers.adminEmergencies);
                },
              );
            },
          ),
          const SizedBox(height: 6),
          CustomListTileWidget(
            iconSize: 15,
            textSize: 14,
            text: "Content",
            iconData: FontAwesomeIcons.pen,
            enabled: false,
            onTap: () {},
          ),
          const Spacer(),
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
  }
}
