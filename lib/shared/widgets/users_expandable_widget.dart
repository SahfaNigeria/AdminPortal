import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import 'app_text.dart';
import 'custom_app_button.dart';
import 'custom_circle_avatar_widget.dart';
import 'custom_expandable_widget.dart';

/// A reusable expandable tile widget for displaying user information.
///
/// Features:
/// - User avatar.
/// - User name, ID and role.
/// - Optional status badge.
/// - Expandable user details.
/// - Optional additional details.
/// - Single Approve/Disapprove button controlled by [isApproved].
class UsersExpandableWidget extends StatelessWidget {
  /// User's avatar image URL.
  final String? imageUrl;

  final Widget? leading;

  /// Radius of the circle avatar.
  final double avatarRadius;

  /// Full name of the user.
  final String userName;

  /// Unique user identifier.
  final String userId;

  /// User role/category.
  final String? userRole;

  /// User email address.
  final String? email;

  /// User phone number.
  final String? phoneNumber;

  /// Date user registered or joined.
  final String? registrationDate;

  /// User address or location.
  final String? location;

  /// User status.
  final String? status;

  /// Custom color for the status badge.
  final Color? statusColor;

  /// Map of additional key-value details.
  final Map<String, String>? additionalDetails;

  /// Custom widget content inside the expanded view.
  final Widget? customExpandedContent;

  /// Whether the user has been approved.
  final bool isApproved;

  /// Loading state for the approval action.
  final bool isLoading;

  /// Callback when approval status changes.
  /// Returns true when approving and false when disapproving.
  final ValueChanged<bool>? onApprovalChanged;

  /// Custom action widgets.
  final List<Widget>? customActions;

  /// Whether to display the action buttons section.
  final bool? showActionButtons;

  /// Initial expansion state.
  final bool initiallyExpanded;

  /// Callback when expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// Background color for the expandable card.
  final Color? backgroundColor;

  /// Container margin.
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
    required this.isApproved,
    this.isLoading = false,
    this.onApprovalChanged,
    this.customActions,
    this.showActionButtons,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.backgroundColor,
    this.margin, this.leading,
  }) : super(key: key);

  bool get _hasActions =>
      showActionButtons ??
          (onApprovalChanged != null ||
              (customActions != null && customActions!.isNotEmpty));

  Color _getStatusColor(String statusText) {
    switch (statusText.trim().toLowerCase()) {
      case 'approved':
      case 'active':
      case 'verified':
        return const Color(0xFF2E7D32);

      case 'pending':
      case 'in review':
      case 'awaiting':
        return const Color(0xFFED6C02);

      case 'disapproved':
      case 'rejected':
      case 'inactive':
      case 'blocked':
        return const Color(0xFFD32F2F);

      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildStatusChip(String statusText) {
    final Color effectiveColor =
        statusColor ?? _getStatusColor(statusText);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
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
      tiles.add(
        _buildDetailTile(
          icon: Icons.email_outlined,
          label: "Email Address",
          value: email!,
        ),
      );
    }

    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      tiles.add(
        _buildDetailTile(
          icon: Icons.phone_outlined,
          label: "Phone Number",
          value: phoneNumber!,
        ),
      );
    }

    if (userRole != null && userRole!.isNotEmpty) {
      tiles.add(
        _buildDetailTile(
          icon: Icons.badge_outlined,
          label: "User Role",
          value: userRole!,
        ),
      );
    }

    if (registrationDate != null &&
        registrationDate!.isNotEmpty) {
      tiles.add(
        _buildDetailTile(
          icon: Icons.calendar_today_outlined,
          label: "Registered On",
          value: registrationDate!,
        ),
      );
    }

    if (location != null && location!.isNotEmpty) {
      tiles.add(
        _buildDetailTile(
          icon: Icons.location_on_outlined,
          label: "Location / Address",
          value: location!,
        ),
      );
    }

    if (additionalDetails != null) {
      additionalDetails!.forEach((key, val) {
        if (val.isNotEmpty) {
          tiles.add(
            _buildDetailTile(
              icon: Icons.info_outline_rounded,
              label: key,
              value: val,
            ),
          );
        }
      });
    }

    return tiles;
  }

  Widget _buildApprovalButton() {
    return CustomAppButton(
      onTap: () {
        onApprovalChanged?.call(!isApproved);
      },
      title: isApproved ? "Disapprove" : "Approve",
      color: isApproved
          ? const Color(0xFFFDE8E8)
          : const Color(0xFF2E7D32),
      textColor: isApproved
          ? const Color(0xFFD32F2F)
          : Colors.white,
      isLoading: isLoading,
    );
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

      leading: leading??CustomCircleAvatarWidget(
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
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
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

            if (detailTiles.isNotEmpty)
              const SizedBox(height: 12),
          ],

          if (detailTiles.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isDesktop =
                    constraints.maxWidth > 550;

                if (isDesktop) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: detailTiles
                        .map(
                          (tile) => SizedBox(
                        width:
                        (constraints.maxWidth - 12) / 2,
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
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
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

            if (customActions != null &&
                customActions!.isNotEmpty)
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: customActions!,
              )
            else
              _buildApprovalButton(),
          ],
        ],
      ),
    );
  }
}