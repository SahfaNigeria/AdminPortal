import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/routes/route_helper.dart';
import '../../core/theme/colors.dart';
import 'app_text.dart';
import 'custom_list_tile.dart';

class DesktopDraweWidget extends StatelessWidget {
  const DesktopDraweWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? currentRoute;
    try {
      currentRoute = GoRouter.of(context).state.name;
    } catch (_) {
      currentRoute = null;
    }

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
              context.goNamed(RouteHelpers.adminAnalytics);
            },
          ),
          const SizedBox(height: 6),
          CustomListTileWidget(
            iconSize: 15,
            textSize: 14,
            text: "Campaigns",
            iconData: FontAwesomeIcons.bullhorn,
            enabled: false,
            onTap: () {},
          ),
          const SizedBox(height: 6),
          CustomListTileWidget(
            iconSize: 15,
            textSize: 14,
            text: "Tags",
            iconData: FontAwesomeIcons.tags,
            enabled: false,
            onTap: () {},
          ),
          const SizedBox(height: 6),
          CustomListTileWidget(
            iconSize: 15,
            textSize: 14,
            text: "Settings",
            iconData: FontAwesomeIcons.gear,
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
              context.goNamed(RouteHelpers.adminLogin);
            },
          ),
        ],
      ),
    );
  }
}
