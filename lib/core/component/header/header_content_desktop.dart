import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

import '../../../shared/constants/app_constants.dart';
import '../../../shared/widgets/app_text.dart';
import '../../../shared/widgets/custom_circle_avatar_widget.dart';
import '../../../shared/widgets/logo_widget.dart';
import '../../theme/colors.dart';

class HeaderContentDesktop extends StatelessWidget {
  const HeaderContentDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            spreadRadius: 0,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // Brand Logo
          const LogoWidget(
            size: Size(44, 54),
          ),
          const SizedBox(width: 16),

          // Vertical Divider
          Container(
            height: 28,
            width: 1,
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 16),

          // Portal Title & Version Badge
          Row(
            children: [
              const AppText(
                text: "Admin Dashboard",
                size: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child:  AppText(
                  text: AppConstants.appVersion,
                  size: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Notification Icon
          _HeaderIconButton(
            icon: FontAwesomeIcons.bell,
            hasBadge: true,
            onTap: () {},
          ),

          const SizedBox(width: 10),

          // Settings Icon
          _HeaderIconButton(
            icon: FontAwesomeIcons.gear,
            onTap: () {},
          ),

          const SizedBox(width: 16),

          // Vertical Divider
          Container(
            height: 28,
            width: 1,
            color: Colors.grey.withValues(alpha: 0.2),
          ),

          const SizedBox(width: 16),

          // User Profile Card
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.18),
                  width: 1,
                ),
              ),
              child: const Row(
                children: [
                  CustomCircleAvatarWidget(radius: 16),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        text: "Admin User",
                        size: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      AppText(
                        text: "Super Admin",
                        size: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  SizedBox(width: 8),
                  FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 11,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final FaIconData icon;
  final bool hasBadge;
  final VoidCallback onTap;

  const _HeaderIconButton({
    Key? key,
    required this.icon,
    this.hasBadge = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(9),
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
            FaIcon(
              icon,
              size: 15,
              color: AppColors.textPrimary,
            ),
            if (hasBadge)
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  width: 8,
                  height: 8,
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
    );
  }
}
