import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/app_text.dart';
import '../../../shared/widgets/custom_circle_avatar_widget.dart';
import '../../../shared/widgets/logo_widget.dart';
import '../../routes/route_helper.dart';
import '../../theme/colors.dart';

class HeaderContentMobile extends StatelessWidget {
  final void Function()? onMenuPressed;
  const HeaderContentMobile({Key? key, this.onMenuPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Drawer Toggle Button
          Material(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onMenuPressed,
              borderRadius: BorderRadius.circular(10),
              splashColor: AppColors.primary.withValues(alpha: 0.15),
              child: Container(
                padding: const EdgeInsets.all(9),
                child: const FaIcon(
                  FontAwesomeIcons.barsStaggered,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Logo & Title
          const LogoWidget(
            size: Size(34, 44),
          ),

          const SizedBox(width: 10),

          const AppText(
            text: "Admin Portal",
            size: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),

          const Spacer(),

          // Notification Icon
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.18),
                  width: 1,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.bell,
                    size: 15,
                    color: AppColors.textPrimary,
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // User Profile Avatar
          InkWell(
            onTap: () {
              context.goNamed(RouteHelpers.adminProfile);
            },
            borderRadius: BorderRadius.circular(20),
            child: const CustomCircleAvatarWidget(radius: 16),
          ),
        ],
      ),
    );
  }
}
