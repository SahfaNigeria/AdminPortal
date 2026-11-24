import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'package:jambomama_nigeria_admin_portal/modules/profile/access/admin_access_controller.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_circle_avatar_widget.dart';
import 'package:material_ui/material_ui.dart';

class AdminIdentityWidget extends GetView<AdminAccessController> {
  const AdminIdentityWidget({
    Key? key,
    this.radius = 20,
    this.showName = true,
    this.showEmail = false,
    this.showRole = false,
  }) : super(key: key);

  final double radius;
  final bool showName;
  final bool showEmail;
  final bool showRole;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final admin = controller.admin.value;
      final authUser = FirebaseReference.firebaseAuth.currentUser;
      final username = admin?.username.trim() ?? '';
      final authName = authUser?.displayName?.trim() ?? '';
      final email = admin?.email.trim().isNotEmpty == true
          ? admin!.email.trim()
          : authUser?.email?.trim() ?? '';
      final name = username.isNotEmpty
          ? username
          : authName.isNotEmpty
              ? authName
              : email.isNotEmpty
                  ? email
                  : 'Admin';
      final role = admin?.accountType.displayName ?? 'Admin';
      final photo = admin?.displayPhoto?.trim();
      final tooltip = [name, role, if (email.isNotEmpty) email].join('\n');

      return Tooltip(
        message: tooltip,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCircleAvatarWidget(
              radius: radius,
              imageUrl: photo == null || photo.isEmpty ? null : photo,
            ),
            if (showName) ...[
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      text: name,
                      size: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    if (showRole)
                      AppText(
                        text: role,
                        size: 11,
                        color: AppColors.textSecondary,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    if (showEmail && email.isNotEmpty)
                      AppText(
                        text: email,
                        size: 11,
                        color: AppColors.textSecondary,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
