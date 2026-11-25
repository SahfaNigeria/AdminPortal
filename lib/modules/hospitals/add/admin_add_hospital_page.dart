import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:scale_button/scale_button.dart';

import '../../../core/routes/route_helper.dart';
import '../../../core/theme/colors.dart';
import '../../../shared/widgets/app_customized_bg.dart';
import '../../../shared/widgets/app_text.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/custom_app_button.dart';
import '../../../shared/widgets/custom_responsive_builder.dart';
import '../../../shared/widgets/dashboard_container_widget.dart';
import 'admin_add_hospital_logic.dart';

class AdminAddHospitalPage extends GetView<AdminAddHospitalLogic> {
  const AdminAddHospitalPage({Key? key}) : super(key: key);

  Widget _buildSectionHeader({
    required dynamic icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: icon is IconData
              ? Icon(
                  icon,
                  size: 16,
                  color: AppColors.primary,
                )
              : FaIcon(
                  icon,
                  size: 16,
                  color: AppColors.primary,
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: title,
                size: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 2),
              AppText(
                text: subtitle,
                size: 12,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          AppText(
            text: label.toUpperCase(),
            size: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          if (isRequired)
            const AppText(
              text: " *",
              size: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label, isRequired: isRequired),
        AppTextField(
          controller: controller,
          enabled: true,
          hintText: hintText,
          prefix: Icon(
            icon,
            size: 16,
            color: AppColors.textSecondary,
          ),
          validator: validator ??
              (val) {
                if (isRequired && (val == null || val.trim().isEmpty)) {
                  return "$label is required";
                }
                return null;
              },
        ),
      ],
    );
  }

  Widget _buildFacilityTypeDropdown(AdminAddHospitalLogic controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Facility Type", isRequired: true),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 1.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedFacilityType,
              isExpanded: true,
              icon: const FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 14,
                color: AppColors.textSecondary,
              ),
              items: controller.facilityTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.hospital,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      AppText(
                        text: type,
                        size: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  controller.setSelectedFacilityType(val);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: title,
                  size: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: subtitle,
                  size: 11,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            activeThumbColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderChip(String label, {bool isRequired = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isRequired
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isRequired
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.border.withValues(alpha: 0.3),
        ),
      ),
      child: AppText(
        text: label,
        size: 11,
        fontWeight: isRequired ? FontWeight.w700 : FontWeight.w500,
        color: isRequired ? AppColors.primary : AppColors.textSecondary,
      ),
    );
  }

  Widget _buildCsvUploadSection(
      BuildContext context, AdminAddHospitalLogic controller) {
    final bool hasParsedData = controller.parsedCsvHospitals.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobileSection = constraints.maxWidth < 600;

        return Container(
          padding: EdgeInsets.all(isMobileSection ? 16 : 24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasParsedData
                  ? const Color(0xFF2E7D32).withValues(alpha: 0.4)
                  : AppColors.border.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header Row
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.fileCsv,
                        size: 18,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        AppText(
                          text: "Batch Upload Hospitals via CSV",
                          size: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(height: 2),
                        AppText(
                          text:
                              "Import multiple hospitals at once using a CSV spreadsheet file",
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (!hasParsedData) ...[
                // Dropzone Box
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: isMobileSection ? 20 : 28,
                    horizontal: isMobileSection ? 14 : 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.cloudArrowUp,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const AppText(
                        text: "Select a CSV spreadsheet to import hospitals",
                        size: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const AppText(
                        text:
                            "Upload standard .csv file containing hospital names, contact, address & coordinates",
                        size: 11,
                        color: AppColors.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      if (isMobileSection) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () =>
                                  controller.downloadSampleCsv(context),
                              icon: const FaIcon(
                                FontAwesomeIcons.download,
                                size: 13,
                                color: AppColors.primary,
                              ),
                              label: const AppText(
                                text: "Download Sample CSV",
                                size: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomAppButton(
                              color: const Color(0xFF2E7D32),
                              onTap: () => controller.pickAndParseCsv(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.fileImport,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  AppText(
                                    text: "Browse & Select CSV File",
                                    size: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () =>
                                  controller.downloadSampleCsv(context),
                              icon: const FaIcon(
                                FontAwesomeIcons.download,
                                size: 13,
                                color: AppColors.primary,
                              ),
                              label: const AppText(
                                text: "Download Sample CSV",
                                size: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 14,
                                ),
                                side: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            CustomAppButton(
                              color: const Color(0xFF2E7D32),
                              onTap: () => controller.pickAndParseCsv(context),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.fileImport,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  AppText(
                                    text: "Browse & Select CSV File",
                                    size: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Column Headers Tag List
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      text: "SUPPORTED HEADERS:",
                      size: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildHeaderChip("name *", isRequired: true),
                          _buildHeaderChip("type"),
                          _buildHeaderChip("phoneNumber"),
                          _buildHeaderChip("email"),
                          _buildHeaderChip("address"),
                          _buildHeaderChip("district"),
                          _buildHeaderChip("stateValue"),
                          _buildHeaderChip("countryValue"),
                          _buildHeaderChip("latitude"),
                          _buildHeaderChip("longitude"),
                          _buildHeaderChip("status"),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // State 2: Parsed File Preview
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.check,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: controller.csvFileName ?? "CSV File Loaded",
                              size: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B5E20),
                            ),
                            const SizedBox(height: 2),
                            AppText(
                              text:
                                  "Parsed ${controller.parsedCsvHospitals.length} hospital entries.",
                              size: 11,
                              color: const Color(0xFF2E7D32),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AppText(
                          text: "${controller.parsedCsvHospitals.length} READY",
                          size: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const AppText(
                  text: "PARSED ENTRIES PREVIEW:",
                  size: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 8),

                // ListView of parsed hospital preview items
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.parsedCsvHospitals.length > 5
                        ? 5
                        : controller.parsedCsvHospitals.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final h = controller.parsedCsvHospitals[index];
                      final name = h['name'] ?? 'Unnamed';
                      final type = h['type'] ?? 'Health Center';
                      final phone = h['phoneNumber'] ?? '';
                      final district = h['district'] ?? '';
                      final state = h['stateValue'] ?? '';
                      final status = h['status'] == true;
                      final loc = [
                        if (district.isNotEmpty) district,
                        if (state.isNotEmpty) state
                      ].join(", ");

                      if (isMobileSection) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.border.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: AppText(
                                        text: "${index + 1}",
                                        size: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: AppText(
                                      text: name,
                                      size: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              if (loc.isNotEmpty || phone.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                AppText(
                                  text: [
                                    if (phone.isNotEmpty) phone,
                                    if (loc.isNotEmpty) loc
                                  ].join(" • "),
                                  size: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: AppText(
                                      text: type,
                                      size: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: status
                                          ? const Color(0xFF2E7D32)
                                              .withValues(alpha: 0.1)
                                          : const Color(0xFFED6C02)
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: AppText(
                                      text: status ? "Approved" : "Pending",
                                      size: 10,
                                      fontWeight: FontWeight.w600,
                                      color: status
                                          ? const Color(0xFF2E7D32)
                                          : const Color(0xFFED6C02),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: AppText(
                                  text: "${index + 1}",
                                  size: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: name,
                                    size: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                  if (loc.isNotEmpty || phone.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    AppText(
                                      text: [
                                        if (phone.isNotEmpty) phone,
                                        if (loc.isNotEmpty) loc
                                      ].join(" • "),
                                      size: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: AppText(
                                text: type,
                                size: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: status
                                    ? const Color(0xFF2E7D32)
                                        .withValues(alpha: 0.1)
                                    : const Color(0xFFED6C02)
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: AppText(
                                text: status ? "Approved" : "Pending",
                                size: 11,
                                fontWeight: FontWeight.w600,
                                color: status
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFFED6C02),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (controller.parsedCsvHospitals.length > 5) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: AppText(
                      text:
                          "+ ${controller.parsedCsvHospitals.length - 5} more hospital entries ready for upload",
                      size: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                if (isMobileSection) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomAppButton(
                        color: const Color(0xFF2E7D32),
                        onTap: () =>
                            controller.uploadCsvHospitalsToFirebase(context),
                        isLoading: controller.isUploadingCsv,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.cloudArrowUp,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            AppText(
                              text:
                                  "Upload ${controller.parsedCsvHospitals.length} Hospitals",
                              size: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: controller.clearParsedCsv,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const AppText(
                          text: "Clear & Cancel",
                          size: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: controller.clearParsedCsv,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const AppText(
                          text: "Clear & Cancel",
                          size: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      CustomAppButton(
                        color: const Color(0xFF2E7D32),
                        onTap: () =>
                            controller.uploadCsvHospitalsToFirebase(context),
                        isLoading: controller.isUploadingCsv,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.cloudArrowUp,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            AppText(
                              text:
                                  "Upload ${controller.parsedCsvHospitals.length} Hospitals",
                              size: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCustomizedBg(
      body: CustomResponsiveBuilder(
        builder: (context, sizingInfo) {
          final bool isMobileScreen = sizingInfo.isMobile;
          final double outerPadding = isMobileScreen ? 12.0 : 24.0;

          return GetBuilder<AdminAddHospitalLogic>(
            builder: (controller) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(outerPadding),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Navigation Row
                          Row(
                            children: [
                              ScaleButton(
                                onTap: () {
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.goNamed(
                                        RouteHelpers.adminHospitals);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.border
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.chevronLeft,
                                        size: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                      SizedBox(width: 8),
                                      AppText(
                                        text: "Back to Hospitals",
                                        size: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Main Header Section
                          DashboardContainerWidget(
                            padding: EdgeInsets.all(outerPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const FaIcon(
                                        FontAwesomeIcons.hospital,
                                        size: 22,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          AppText(
                                            text: "Add New Hospital",
                                            size: 20,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                          SizedBox(height: 4),
                                          AppText(
                                            text:
                                                "Register a new healthcare facility or hospital into the JamboMama platform",
                                            size: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const Divider(height: 1),
                                const SizedBox(height: 24),

                                // CSV Batch Upload Section
                                _buildCsvUploadSection(context, controller),

                                const SizedBox(height: 28),
                                const Divider(height: 1),
                                const SizedBox(height: 28),

                                // Layout Grid
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final bool isDesktop =
                                        constraints.maxWidth > 650;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Section 1: Basic Info
                                        _buildSectionHeader(
                                          icon: FontAwesomeIcons
                                              .buildingCircleCheck,
                                          title: "Basic Facility Information",
                                          subtitle:
                                              "Hospital name, facility classification, and main contacts",
                                        ),
                                        const SizedBox(height: 16),

                                        if (isDesktop) ...[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: _buildInputField(
                                                  label:
                                                      "Hospital / Facility Name",
                                                  controller:
                                                      controller.nameController,
                                                  hintText:
                                                      "e.g. Gambo Sawaba General Hospital",
                                                  icon: Icons
                                                      .local_hospital_outlined,
                                                  isRequired: true,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child:
                                                    _buildFacilityTypeDropdown(
                                                        controller),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: _buildInputField(
                                                  label: "Phone Number",
                                                  controller: controller
                                                      .phoneController,
                                                  hintText:
                                                      "e.g. +234 803 123 4567",
                                                  icon: Icons.phone_outlined,
                                                  isRequired: true,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: _buildInputField(
                                                  label: "Email Address",
                                                  controller: controller
                                                      .emailController,
                                                  hintText:
                                                      "e.g. info@hospital.org",
                                                  icon: Icons.email_outlined,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ] else ...[
                                          _buildInputField(
                                            label: "Hospital / Facility Name",
                                            controller:
                                                controller.nameController,
                                            hintText:
                                                "e.g. Gambo Sawaba General Hospital",
                                            icon: Icons.local_hospital_outlined,
                                            isRequired: true,
                                          ),
                                          const SizedBox(height: 14),
                                          _buildFacilityTypeDropdown(
                                              controller),
                                          const SizedBox(height: 14),
                                          _buildInputField(
                                            label: "Phone Number",
                                            controller:
                                                controller.phoneController,
                                            hintText: "e.g. +234 803 123 4567",
                                            icon: Icons.phone_outlined,
                                            isRequired: true,
                                            keyboardType: TextInputType.phone,
                                          ),
                                          const SizedBox(height: 14),
                                          _buildInputField(
                                            label: "Email Address",
                                            controller:
                                                controller.emailController,
                                            hintText: "e.g. info@hospital.org",
                                            icon: Icons.email_outlined,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                        ],

                                        const SizedBox(height: 28),
                                        const Divider(height: 1),
                                        const SizedBox(height: 28),

                                        // Section 2: Location & Address
                                        _buildSectionHeader(
                                          icon: FontAwesomeIcons.locationDot,
                                          title: "Location & Address Details",
                                          subtitle:
                                              "Physical street address, district/LGA, and jurisdiction",
                                        ),
                                        const SizedBox(height: 16),

                                        if (isDesktop) ...[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: _buildInputField(
                                                  label: "Street Address",
                                                  controller: controller
                                                      .addressController,
                                                  hintText:
                                                      "e.g. Musa Yardua Street",
                                                  icon: Icons
                                                      .location_on_outlined,
                                                  isRequired: true,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: _buildInputField(
                                                  label:
                                                      "District / LGA / Town",
                                                  controller: controller
                                                      .districtController,
                                                  hintText: "e.g. Anchau",
                                                  icon: Icons
                                                      .location_city_outlined,
                                                  isRequired: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: _buildInputField(
                                                  label: "State",
                                                  controller:
                                                      controller.stateController,
                                                  hintText:
                                                      "e.g. Kaduna State / Federal Capital Territory",
                                                  icon: Icons.map_outlined,
                                                  isRequired: true,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: _buildInputField(
                                                  label: "Country",
                                                  controller: controller
                                                      .countryController,
                                                  hintText: "e.g. 🇳🇬 Nigeria",
                                                  icon: Icons.public_outlined,
                                                  isRequired: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ] else ...[
                                          _buildInputField(
                                            label: "Street Address",
                                            controller:
                                                controller.addressController,
                                            hintText: "e.g. Musa Yardua Street",
                                            icon: Icons.location_on_outlined,
                                            isRequired: true,
                                          ),
                                          const SizedBox(height: 14),
                                          _buildInputField(
                                            label: "District / LGA / Town",
                                            controller:
                                                controller.districtController,
                                            hintText: "e.g. Anchau",
                                            icon: Icons.location_city_outlined,
                                            isRequired: true,
                                          ),
                                          const SizedBox(height: 14),
                                          _buildInputField(
                                            label: "State",
                                            controller:
                                                controller.stateController,
                                            hintText:
                                                "e.g. Kaduna State / Federal Capital Territory",
                                            icon: Icons.map_outlined,
                                            isRequired: true,
                                          ),
                                          const SizedBox(height: 14),
                                          _buildInputField(
                                            label: "Country",
                                            controller:
                                                controller.countryController,
                                            hintText: "e.g. 🇳🇬 Nigeria",
                                            icon: Icons.public_outlined,
                                            isRequired: true,
                                          ),
                                        ],

                                        const SizedBox(height: 28),
                                        const Divider(height: 1),
                                        const SizedBox(height: 28),

                                        // Section 3: Coordinates
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildSectionHeader(
                                                icon: FontAwesomeIcons.compass,
                                                title: "Geographic Coordinates",
                                                subtitle:
                                                    "GPS location coordinates for navigation and emergency routing",
                                              ),
                                            ),
                                            TextButton.icon(
                                              onPressed: controller
                                                  .autoFillCoordinates,
                                              icon: const FaIcon(
                                                FontAwesomeIcons.crosshairs,
                                                size: 12,
                                                color: AppColors.primary,
                                              ),
                                              label: const AppText(
                                                text: "Auto-fill",
                                                size: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),

                                        if (isDesktop) ...[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: _buildInputField(
                                                  label: "Latitude (° N)",
                                                  controller: controller
                                                      .latitudeController,
                                                  hintText: "e.g. 11.0663",
                                                  icon:
                                                      Icons.my_location_outlined,
                                                  keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                      decimal: true),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: _buildInputField(
                                                  label: "Longitude (° E)",
                                                  controller: controller
                                                      .longitudeController,
                                                  hintText: "e.g. 7.6996",
                                                  icon:
                                                      Icons.my_location_outlined,
                                                  keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                      decimal: true),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ] else ...[
                                          _buildInputField(
                                            label: "Latitude (° N)",
                                            controller:
                                                controller.latitudeController,
                                            hintText: "e.g. 11.0663",
                                            icon: Icons.my_location_outlined,
                                            keyboardType:
                                                const TextInputType.numberWithOptions(
                                                    decimal: true),
                                          ),
                                          const SizedBox(height: 14),
                                          _buildInputField(
                                            label: "Longitude (° E)",
                                            controller:
                                                controller.longitudeController,
                                            hintText: "e.g. 7.6996",
                                            icon: Icons.my_location_outlined,
                                            keyboardType:
                                                const TextInputType.numberWithOptions(
                                                    decimal: true),
                                          ),
                                        ],

                                        const SizedBox(height: 28),
                                        const Divider(height: 1),
                                        const SizedBox(height: 28),

                                        // Section 4: Status & Capabilities
                                        _buildSectionHeader(
                                          icon: FontAwesomeIcons.shieldHalved,
                                          title: "Status & Capabilities",
                                          subtitle:
                                              "Verification status and available healthcare services",
                                        ),
                                        const SizedBox(height: 16),

                                        _buildToggleTile(
                                          title: "Approved & Verified Facility",
                                          subtitle:
                                              "When active, this hospital is instantly visible and verified on the app",
                                          value: controller.isApproved,
                                          onChanged: (val) =>
                                              controller.setApproved(val),
                                          icon: Icons.verified_user_outlined,
                                        ),
                                        const SizedBox(height: 12),
                                        _buildToggleTile(
                                          title: "24/7 Emergency Care",
                                          subtitle:
                                              "Facility provides round-the-clock emergency medical services",
                                          value: controller.hasEmergencyCare,
                                          onChanged: (val) => controller
                                              .setHasEmergencyCare(val),
                                          icon: Icons.medical_services_outlined,
                                        ),
                                        const SizedBox(height: 12),
                                        _buildToggleTile(
                                          title: "Maternal & Child Healthcare",
                                          subtitle:
                                              "Equipped for maternity, delivery, and prenatal care",
                                          value:
                                              controller.hasMaternityServices,
                                          onChanged: (val) => controller
                                              .setHasMaternityServices(val),
                                          icon: Icons.child_care_outlined,
                                        ),

                                        const SizedBox(height: 32),
                                        const Divider(height: 1),
                                        const SizedBox(height: 24),

                                        // Form Actions
                                        if (isMobileScreen) ...[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              CustomAppButton(
                                                onTap: () => controller
                                                    .submitForm(context),
                                                title: "Save Hospital",
                                                isLoading:
                                                    controller.isSubmitting,
                                              ),
                                              const SizedBox(height: 12),
                                              OutlinedButton(
                                                onPressed: () {
                                                  if (context.canPop()) {
                                                    context.pop();
                                                  } else {
                                                    context.goNamed(
                                                        RouteHelpers
                                                            .adminHospitals);
                                                  }
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 16),
                                                  side: const BorderSide(
                                                    color: AppColors.border,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const AppText(
                                                  text: "Cancel",
                                                  size: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ] else ...[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  if (context.canPop()) {
                                                    context.pop();
                                                  } else {
                                                    context.goNamed(
                                                        RouteHelpers
                                                            .adminHospitals);
                                                  }
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 24,
                                                    vertical: 16,
                                                  ),
                                                  side: const BorderSide(
                                                    color: AppColors.border,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const AppText(
                                                  text: "Cancel",
                                                  size: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              CustomAppButton(
                                                onTap: () => controller
                                                    .submitForm(context),
                                                title: "Save Hospital",
                                                isLoading:
                                                    controller.isSubmitting,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
