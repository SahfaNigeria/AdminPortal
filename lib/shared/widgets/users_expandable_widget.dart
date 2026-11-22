import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import 'app_text.dart';
import 'custom_app_button.dart';
import 'custom_circle_avatar_widget.dart';
import 'custom_expandable_widget.dart';

/// A modern, reusable expandable tile widget specifically designed for displaying
/// user information across different user roles (e.g. Mothers, Health Professionals, Admin).
///
/// Features:
/// - Leading user avatar (`imageUrl`) with customizable radius.
/// - Header showing user's full name, ID, role/category badge, and status indicator.
/// - Expanded details sheet showing key info (Email, Phone, Role, Date Joined, Location, etc.).
/// - Support for optional `additionalDetails` key-value pairs for role-specific information.
/// - Flexible action bar with optional Approve & Disapprove buttons or custom actions.
class UsersExpandableWidget extends StatelessWidget {
  /// User's avatar image URL.
  final String? imageUrl;

  /// Radius of the circle avatar. Default is `24.0`.
  final double avatarRadius;

  /// Full name of the user.
  final String userName;

  /// Unique user identifier.
  final String userId;

  /// User role/category (e.g., "Mother", "Health Professional", "Admin").
  final String? userRole;

  /// User email address.
  final String? email;

  /// User phone number.
  final String? phoneNumber;

  /// Date user registered or joined.
  final String? registrationDate;

  /// User address or location.
  final String? location;

  /// User status (e.g., "Pending", "Approved", "Disapproved", "Active", "Inactive").
  final String? status;

  /// Custom color for the status badge.
  final Color? statusColor;

  /// Map of additional key-value details to display in the grid (e.g. `{"Hospital": "St. Mary", "License": "HP-994"}`).
  final Map<String, String>? additionalDetails;

  /// Custom widget content to render inside the expanded view.
  final Widget? customExpandedContent;

  /// Callback when the Approve button is tapped.
  final VoidCallback? onApprove;

  /// Callback when the Disapprove button is tapped.
  final VoidCallback? onDisapprove;

  /// Text label for the Approve button. Default is `"Approve"`.
  final String approveButtonText;

  /// Text label for the Disapprove button. Default is `"Disapprove"`.
  final String disapproveButtonText;

  /// Loading state for the Approve button.
  final bool isApproving;

  /// Loading state for the Disapprove button.
  final bool isDisapproving;

  /// Custom action widgets to display in the action bar.
  final List<Widget>? customActions;

  /// Whether to display the action buttons section. If `null`, action buttons are automatically shown if [onApprove], [onDisapprove], or [customActions] are provided.
  final bool? showActionButtons;

  /// Initial expansion state. Default is `false`.
  final bool initiallyExpanded;

  /// Callback when expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// Background color for the expandable card.
  final Color? backgroundColor;

  /// Container margin. Default is `EdgeInsets.symmetric(vertical: 6)`.
  final EdgeInsetsGeometry? margin;

  const UsersExpandableWidget({
    Key? key,
    this.imageUrl,
    this.avatarRadius = 24.0,
    required this.userName,
    required this.userId,
    this.userRole,
    this.email,
    this.phoneNumber,
    this.registrationDate,
    this.location,
    this.status,
    this.statusColor,
    this.additionalDetails,
    this.customExpandedContent,
    this.onApprove,
    this.onDisapprove,
    this.approveButtonText = "Approve",
    this.disapproveButtonText = "Disapprove",
    this.isApproving = false,
    this.isDisapproving = false,
    this.customActions,
    this.showActionButtons,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.backgroundColor,
    this.margin,
  }) : super(key: key);

  bool get _hasActions =>
      showActionButtons ?? (onApprove != null || onDisapprove != null || (customActions != null && customActions!.isNotEmpty));

  Color _getStatusColor(String statusText) {
    switch (statusText.trim().toLowerCase()) {
      case 'approved':
      case 'active':
      case 'verified':
        return const Color(0xFF2E7D32); // Green
      case 'pending':
      case 'in review':
      case 'awaiting':
        return const Color(0xFFED6C02); // Orange / Amber
      case 'disapproved':
      case 'rejected':
      case 'inactive':
      case 'blocked':
        return const Color(0xFFD32F2F); // Red
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildStatusChip(String statusText) {
    final Color effectiveColor = statusColor ?? _getStatusColor(statusText);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: effectiveColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: AppText(
        text: statusText,
        size: 11,
        fontWeight: FontWeight.w600,
        color: effectiveColor,
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 15,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: label,
                  size: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: value,
                  size: 13,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDetailsGrid() {
    final List<Widget> tiles = [];

    if (email != null && email!.isNotEmpty) {
      tiles.add(_buildDetailTile(
        icon: Icons.email_outlined,
        label: "Email Address",
        value: email!,
      ));
    }

    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      tiles.add(_buildDetailTile(
        icon: Icons.phone_outlined,
        label: "Phone Number",
        value: phoneNumber!,
      ));
    }

    if (userRole != null && userRole!.isNotEmpty) {
      tiles.add(_buildDetailTile(
        icon: Icons.badge_outlined,
        label: "User Role",
        value: userRole!,
      ));
    }

    if (registrationDate != null && registrationDate!.isNotEmpty) {
      tiles.add(_buildDetailTile(
        icon: Icons.calendar_today_outlined,
        label: "Registered On",
        value: registrationDate!,
      ));
    }

    if (location != null && location!.isNotEmpty) {
      tiles.add(_buildDetailTile(
        icon: Icons.location_on_outlined,
        label: "Location / Address",
        value: location!,
      ));
    }

    if (additionalDetails != null) {
      additionalDetails!.forEach((key, val) {
        if (val.isNotEmpty) {
          tiles.add(_buildDetailTile(
            icon: Icons.info_outline_rounded,
            label: key,
            value: val,
          ));
        }
      });
    }

    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> detailTiles = _buildDetailsGrid();

    return CustomExpandableTileWidget(
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
      backgroundColor: backgroundColor,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 6),
      showDivider: true,
      leading: CustomCircleAvatarWidget(
        imageUrl: imageUrl,
        radius: avatarRadius,
      ),
      titleWidget: Row(
        children: [
          Expanded(
            child: AppText(
              text: userName,
              size: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (status != null && status!.isNotEmpty) ...[
            const SizedBox(width: 8),
            _buildStatusChip(status!),
          ],
        ],
      ),
      subtitleWidget: Row(
        children: [
          AppText(
            text: "ID: $userId",
            size: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          if (userRole != null && userRole!.isNotEmpty) ...[
            AppText(
              text: " • ",
              size: 12,
              color: AppColors.textSecondary,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: AppText(
                text: userRole!,
                size: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
      expandedChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (customExpandedContent != null) ...[
            customExpandedContent!,
            if (detailTiles.isNotEmpty) const SizedBox(height: 12),
          ],
          if (detailTiles.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isDesktop = constraints.maxWidth > 550;
                if (isDesktop) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: detailTiles
                        .map(
                          (tile) => SizedBox(
                            width: (constraints.maxWidth - 12) / 2,
                            child: tile,
                          ),
                        )
                        .toList(),
                  );
                } else {
                  return Column(
                    children: detailTiles
                        .map(
                          (tile) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: tile,
                          ),
                        )
                        .toList(),
                  );
                }
              },
            ),
          if (_hasActions) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, thickness: 1),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (customActions != null && customActions!.isNotEmpty)
                  ...customActions!
                else ...[
                  if (onDisapprove != null) ...[
                    Expanded(
                      child: CustomAppButton(
                        onTap: onDisapprove,
                        title: disapproveButtonText,
                        color: const Color(0xFFFDE8E8),
                        textColor: const Color(0xFFD32F2F),
                        isLoading: isDisapproving,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (onApprove != null) ...[
                    Expanded(
                      child: CustomAppButton(
                        onTap: onApprove,
                        title: approveButtonText,
                        color: const Color(0xFF2E7D32),
                        textColor: Colors.white,
                        isLoading: isApproving,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
