import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/health_professional/health_professional_controller.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_loading_animation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:number_pagination/number_pagination.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/custom_search_text_field.dart';
import '../../../../shared/widgets/users_expandable_widget.dart';

class HealthProfessionalTab extends GetView<HealthProfessionalController> {
  const HealthProfessionalTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const CustomLoadingAnimation();
      }

      final professionals = controller.paginatedHealthProfessionals;

      return Column(
        children: [
          CustomSearchTextField(
            fieldTitle: "Health Professionals",
            controller: controller.searchController,
            onChanged: controller.searchHealthProfessionals,
          ),

          SizedBox(
            height: 10,
          ),
          Expanded(
            child: controller.visibleHealthProfessionals.isEmpty
                ? const Center(child: Text("No health professionals found."))
                : ListView.builder(
                    primary: false,
                    itemCount: professionals.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final pro = professionals[index];
                      final bool isApproved = pro.approved;
                      final String villageTown = pro.villageTown;
                      final String cityValue = pro.cityValue;
                      final String stateValue = pro.stateValue;
                      final String countryValue = pro.countryValue;

                      final List<String> locationParts = [
                        if (villageTown.isNotEmpty) villageTown,
                        if (cityValue.isNotEmpty) cityValue,
                        if (stateValue.isNotEmpty) stateValue,
                        if (countryValue.isNotEmpty) countryValue,
                      ];

                      final Map<String, String> additionalDetails = {};
                      if (pro.position.trim().isNotEmpty) {
                        additionalDetails["Position"] = pro.position.trim();
                      }
                      if (pro.healthFacility.trim().isNotEmpty) {
                        additionalDetails["Health Facility"] =
                            pro.healthFacility.trim();
                      }
                      if (pro.professional.trim().isNotEmpty) {
                        additionalDetails["Professional Type"] =
                            pro.professional.trim();
                      }
                      if (pro.qualificationNumber.trim().isNotEmpty) {
                        additionalDetails["Qualification Number"] =
                            pro.qualificationNumber.trim();
                      }
                      if (villageTown.isNotEmpty) {
                        additionalDetails["Village / Town"] = villageTown;
                      }
                      if (cityValue.isNotEmpty) {
                        additionalDetails["City"] = cityValue;
                      }
                      if (stateValue.isNotEmpty) {
                        additionalDetails["State"] = stateValue;
                      }
                      if (countryValue.isNotEmpty) {
                        additionalDetails["Country"] = countryValue;
                      }
                      if (pro.createdAt != null) {
                        additionalDetails["Created At"] =
                            pro.createdAt.toString();
                      }

                      return UsersExpandableWidget(
                        userName: pro.fullName,
                        userId: pro.qualificationNumber,
                        userRole: "Health Professional",
                        status: isApproved ? "Approved" : "Pending",
                        email: pro.email,
                        isLoading: controller.isUpdating(pro.midWifeId),
                        phoneNumber: pro.phoneNumber,
                        IdName: "Qualification Number:",
                        registrationDate: pro.createdAt?.toString(),
                        location: locationParts.isNotEmpty
                            ? locationParts.join(", ")
                            : null,
                        imageUrl: pro.midWifeImage,
                        additionalDetails: additionalDetails,
                        isApproved: isApproved,
                        onApprovalChanged: (value) {
                          controller.updateApproval(value, pro.midWifeId);
                        },
                      );
                    },
                  ),
          ),
          if (controller.totalPages > 1)
            SizedBox(
              height: 20,
            ),
            NumberPagination(
              currentPage: controller.currentPage.value,
              totalPages: controller.totalPages,
              onPageChanged: controller.changePage,
              selectedButtonColor: AppColors.primary,
              selectedNumberColor: AppColors.surface,
              unSelectedButtonColor: AppColors.surface,
              unSelectedNumberColor: AppColors.textPrimary,
              buttonUnSelectedBorderColor: AppColors.border,
              buttonRadius: 8,
              buttonElevation: 0,
              numberButtonSize: const Size(36, 36),
              controlButtonSize: const Size(36, 36),
            ),
        ],
      );
    });
  }
}
