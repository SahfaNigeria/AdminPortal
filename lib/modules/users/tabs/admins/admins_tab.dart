import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/admins/admins_controller.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_app_button.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_search_text_field.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/users_expandable_widget.dart';
import 'package:material_ui/material_ui.dart';

class AdminsTab extends GetView<AdminsController> {
  const AdminsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomSearchTextField(
                fieldTitle: 'Admins',
                controller: controller.searchController,
              ),
            ),
            const SizedBox(width: 10),
            Obx(
              () => CustomAppButton(
                child: FaIcon(
                  controller.isSearchActive.value
                      ? FontAwesomeIcons.xmark
                      : FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                  color: AppColors.surface,
                ),
                isLoading: controller.isLoading.value,
                onTap: controller.isSearchActive.value
                    ? controller.clearAdminSearch
                    : controller.searchAdmins,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CustomCircularProgressIndicator(
                  height: 24,
                  width: 24,
                  color: AppColors.primary,
                ),
              );
            }

            if (controller.loadError.value != null) {
              return _MessageState(
                message: controller.loadError.value!,
                action: TextButton(
                  onPressed: controller.loadAdmins,
                  child: const AppText(
                    text: 'Retry',
                    size: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              );
            }

            if (!controller.canManageAdmins.value) {
              return const _MessageState(
                message: 'Administrator management is available to approved '
                    'Super Admins only.',
              );
            }

            final admins = controller.filteredAdmins;
            if (admins.isEmpty) {
              return Center(
                child: AppText(
                  text: controller.searchQuery.value.isEmpty
                      ? 'No admins found.'
                      : 'No admins match your search.',
                  size: 18,
                ),
              );
            }

            return ListView.builder(
              itemCount: admins.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) =>
                  _buildAdmin(context, admins[index]),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAdmin(BuildContext context, AdminModel admin) {
    final isCurrentAdmin = admin.id == controller.currentAdminId;
    final tabAccess = admin.isSuperAdmin
        ? 'All tabs'
        : admin.accessibleTabs.isEmpty
            ? 'No tabs assigned'
            : admin.accessibleTabs.map((tab) => tab.displayName).join(', ');
    final details = <String, String>{
      'Account Type': admin.accountType.displayName,
      'Tab Access': tabAccess,
      if (admin.approvedBySuperAdminId?.isNotEmpty ?? false)
        'Approved By': admin.approvedBySuperAdminId!,
      if (admin.createdAt != null)
        'Created At': admin.createdAt!.toLocal().toString(),
      if (admin.updatedAt != null)
        'Updated At': admin.updatedAt!.toLocal().toString(),
      if (isCurrentAdmin) 'Note': 'This is your current account.',
    };

    return Obx(
      () => UsersExpandableWidget(
        userName: admin.username.isEmpty ? admin.email : admin.username,
        userId: admin.id,
        userRole: admin.accountType.displayName,
        status: admin.isApproved ? 'Approved' : 'Pending',
        email: admin.email,
        imageUrl: admin.displayPhoto,
        additionalDetails: details,
        isApproved: admin.isApproved,
        isLoading: controller.updatingAdminIds.contains(admin.id),
        showActionButtons: admin.email.trim().isNotEmpty || !isCurrentAdmin,
        customActions: [
          if (admin.email.trim().isNotEmpty)
            CustomAppButton(
              title: 'Send reset link',
              isLoading: controller.sendingPasswordResetIds.contains(admin.id),
              onTap: () => controller.sendPasswordResetLink(
                admin.id,
                admin.email,
              ),
            ),
          if (!isCurrentAdmin)
            CustomAppButton(
              title: admin.isApproved ? 'Manage Access' : 'Review & Approve',
              isLoading: controller.updatingAdminIds.contains(admin.id),
              onTap: () => _openAccessReview(context, admin),
            ),
        ],
      ),
    );
  }

  void _openAccessReview(BuildContext context, AdminModel admin) {
    controller.prepareAccessReview(admin);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AdminAccessDialog(controller: controller, admin: admin),
    );
  }
}

class _AdminAccessDialog extends StatelessWidget {
  const _AdminAccessDialog({
    required this.controller,
    required this.admin,
  });

  final AdminsController controller;
  final AdminModel admin;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSuperAdmin =
          controller.draftAccountType.value == AccountType.superAdmin;
      final isSaving = controller.updatingAdminIds.contains(admin.id);
      final isApproved = controller.draftIsApproved.value;
      final title =
          admin.isApproved ? 'Manage administrator' : 'Review administrator';
      final saveLabel = isApproved
          ? admin.isApproved
              ? 'Save changes'
              : 'Approve & save'
          : admin.isApproved
              ? 'Revoke approval'
              : 'Select approval to continue';

      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        backgroundColor: AppColors.surface,
        elevation: 18,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: MediaQuery.sizeOf(context).height * 0.88,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.userShield,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: title,
                            size: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(height: 3),
                          const AppText(
                            text: 'Set role and dashboard permissions',
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _AdminStatusBadge(isApproved: admin.isApproved),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE9E9EC)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 21,
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.1),
                              child: AppText(
                                text: (admin.username.isEmpty
                                        ? admin.email
                                        : admin.username)
                                    .characters
                                    .first
                                    .toUpperCase(),
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: admin.username.isEmpty
                                        ? admin.email
                                        : admin.username,
                                    fontWeight: FontWeight.w700,
                                    size: 14,
                                  ),
                                  if (admin.username.isNotEmpty) ...[
                                    const SizedBox(height: 3),
                                    AppText(
                                      text: admin.email,
                                      color: AppColors.textSecondary,
                                      size: 12,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      const _AdminDialogSectionTitle(
                        title: 'Approval',
                        subtitle:
                            'Approval is required before access is granted.',
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: isApproved
                              ? const Color(0xFFF0F8F1)
                              : const Color(0xFFF7F7F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isApproved
                                ? const Color(0xFFD4EAD6)
                                : const Color(0xFFE9E9EC),
                          ),
                        ),
                        child: SwitchListTile(
                          value: isApproved,
                          onChanged:
                              isSaving ? null : controller.setDraftApproval,
                          activeThumbColor: AppColors.primary,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: const AppText(
                            text: 'Approve this administrator',
                            fontWeight: FontWeight.w600,
                            size: 14,
                          ),
                          subtitle: AppText(
                            text: isApproved
                                ? 'This account is approved.'
                                : 'This account remains pending.',
                            color: AppColors.textSecondary,
                            size: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const _AdminDialogSectionTitle(
                        title: 'Account role',
                        subtitle: 'Choose the administrator permission level.',
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _AdminRoleChoice(
                            title: 'Admin',
                            subtitle: 'Choose specific tabs',
                            icon: FontAwesomeIcons.userGear,
                            selected: controller.draftAccountType.value ==
                                AccountType.admin,
                            onSelected: isSaving
                                ? null
                                : () => controller
                                    .setDraftAccountType(AccountType.admin),
                          ),
                          _AdminRoleChoice(
                            title: 'Super Admin',
                            subtitle: 'Access to every tab',
                            icon: FontAwesomeIcons.shieldHalved,
                            selected: isSuperAdmin,
                            onSelected: isSaving
                                ? null
                                : () => controller.setDraftAccountType(
                                      AccountType.superAdmin,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _AdminDialogSectionTitle(
                        title: 'Dashboard access',
                        subtitle: isSuperAdmin
                            ? 'Super Admins automatically have all access.'
                            : '${controller.selectedTabs.length} of '
                                '${AdminTab.values.length} tabs selected',
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: AdminTab.values.map((tab) {
                          final hasAccess = isSuperAdmin ||
                              controller.selectedTabs.contains(tab);
                          return FilterChip(
                            avatar: FaIcon(
                              _adminTabIcon(tab),
                              size: 14,
                              color: hasAccess
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                            label: AppText(
                              text: tab.displayName,
                              color: hasAccess
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              size: 13,
                            ),
                            selected: hasAccess,
                            showCheckmark: false,
                            backgroundColor: const Color(0xFFF7F7F8),
                            selectedColor:
                                AppColors.primary.withValues(alpha: 0.1),
                            side: BorderSide(
                              color: hasAccess
                                  ? AppColors.primary.withValues(alpha: 0.35)
                                  : const Color(0xFFE4E4E7),
                            ),
                            onSelected: isSuperAdmin || isSaving
                                ? null
                                : (selected) =>
                                    controller.setTabAccess(tab, selected),
                          );
                        }).toList(),
                      ),
                      if (!isSuperAdmin && controller.selectedTabs.isEmpty) ...[
                        const SizedBox(height: 12),
                        const _AdminInfoNotice(
                          message: 'No tabs selected. This Admin will not see '
                              'dashboard sections until access is assigned.',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    TextButton(
                      onPressed:
                          isSaving ? null : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                      ),
                      child: const AppText(
                        text: 'Cancel',
                        color: AppColors.textSecondary,
                        size: 14,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isSaving || (!isApproved && !admin.isApproved)
                          ? null
                          : () async {
                              final saved =
                                  await controller.saveAdminAccess(admin);
                              if (saved) Navigator.of(context).pop();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.surface,
                        disabledBackgroundColor:
                            AppColors.primary.withValues(alpha: 0.35),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.surface,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FaIcon(
                                  isApproved
                                      ? FontAwesomeIcons.check
                                      : FontAwesomeIcons.ban,
                                  size: 14,
                                  color: AppColors.surface,
                                ),
                                const SizedBox(width: 8),
                                AppText(
                                  text: saveLabel,
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  FaIconData _adminTabIcon(AdminTab tab) {
    switch (tab) {
      case AdminTab.analytics:
        return FontAwesomeIcons.chartLine;
      case AdminTab.users:
        return FontAwesomeIcons.users;
      case AdminTab.hospital:
        return FontAwesomeIcons.hospital;
      case AdminTab.approval:
        return FontAwesomeIcons.bell;
      case AdminTab.contents:
        return FontAwesomeIcons.fileLines;
    }
  }
}

class _AdminDialogSectionTitle extends StatelessWidget {
  const _AdminDialogSectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: title,
          size: 16,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 3),
        AppText(
          text: subtitle,
          size: 12,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}

class _AdminStatusBadge extends StatelessWidget {
  const _AdminStatusBadge({required this.isApproved});

  final bool isApproved;

  @override
  Widget build(BuildContext context) {
    final color = isApproved ? const Color(0xFF2E7D32) : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        text: isApproved ? 'Approved' : 'Pending',
        color: color,
        size: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _AdminRoleChoice extends StatelessWidget {
  const _AdminRoleChoice({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final String subtitle;
  final FaIconData icon;
  final bool selected;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.07)
              : const Color(0xFFF7F7F8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.5)
                : const Color(0xFFE4E4E7),
          ),
        ),
        child: Row(
          children: [
            FaIcon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    color: selected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    size: 14,
                  ),
                  const SizedBox(height: 2),
                  AppText(
                    text: subtitle,
                    color: AppColors.textSecondary,
                    size: 11,
                  ),
                ],
              ),
            ),
            if (selected)
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                color: AppColors.primary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

class _AdminInfoNotice extends StatelessWidget {
  const _AdminInfoNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF2E1B8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FaIcon(
            FontAwesomeIcons.circleInfo,
            size: 18,
            color: Color(0xFF986C0B),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              text: message,
              color: const Color(0xFF725208),
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message, this.action});

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(text: message, size: 16),
          if (action != null) ...[
            const SizedBox(height: 8),
            action!,
          ],
        ],
      ),
    );
  }
}
