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
                  FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                  color: AppColors.surface,
                ),
                isLoading: controller.isLoading.value,
                onTap: controller.searchAdmins,
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
                  child: const Text('Retry'),
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
              itemBuilder: (context, index) => _buildAdmin(admins[index]),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAdmin(AdminModel admin) {
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
        showActionButtons: !isCurrentAdmin,
        customActions: isCurrentAdmin
            ? null
            : [
                CustomAppButton(
                  title:
                      admin.isApproved ? 'Manage Access' : 'Review & Approve',
                  isLoading: controller.updatingAdminIds.contains(admin.id),
                  onTap: () => _openAccessReview(admin),
                ),
              ],
      ),
    );
  }

  void _openAccessReview(AdminModel admin) {
    controller.prepareAccessReview(admin);
    Get.dialog<void>(
      _AdminAccessDialog(controller: controller, admin: admin),
      barrierDismissible: false,
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

      return AlertDialog(
        title: Text(
          admin.isApproved ? 'Manage administrator access' : 'Review admin',
        ),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(admin.username.isEmpty ? admin.email : admin.username),
                const SizedBox(height: 16),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Approve this administrator'),
                  value: controller.draftIsApproved.value,
                  onChanged: isSaving
                      ? null
                      : (approved) =>
                          controller.setDraftApproval(approved ?? false),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Account role',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                RadioGroup<AccountType>(
                  groupValue: controller.draftAccountType.value,
                  onChanged: (value) {
                    if (controller.draftIsApproved.value &&
                        !isSaving &&
                        value != null) {
                      controller.setDraftAccountType(value);
                    }
                  },
                  child: Column(
                    children: [
                      RadioListTile<AccountType>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Admin'),
                        value: AccountType.admin,
                        enabled: controller.draftIsApproved.value && !isSaving,
                      ),
                      RadioListTile<AccountType>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Super Admin'),
                        subtitle: const Text(
                          'Automatically has access to every tab.',
                        ),
                        value: AccountType.superAdmin,
                        enabled: controller.draftIsApproved.value && !isSaving,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Dashboard tabs',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (isSuperAdmin)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Super Admins automatically have access to all tabs.',
                    ),
                  ),
                ...AdminTab.values.map(
                  (tab) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(tab.displayName),
                    value:
                        isSuperAdmin || controller.selectedTabs.contains(tab),
                    onChanged: isSuperAdmin ||
                            !controller.draftIsApproved.value ||
                            isSaving
                        ? null
                        : (hasAccess) => controller.setTabAccess(
                              tab,
                              hasAccess ?? false,
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: isSaving ? null : () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: isSaving
                ? null
                : () async {
                    final saved = await controller.saveAdminAccess(admin);
                    if (saved) Get.back<void>();
                  },
            child: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    controller.draftIsApproved.value
                        ? 'Save access'
                        : 'Revoke approval',
                  ),
          ),
        ],
      );
    });
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
