import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:number_pagination/number_pagination.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/custom_loading_animation.dart';
import '../../../../shared/widgets/custom_search_text_field.dart';
import '../../../../shared/widgets/users_expandable_widget.dart';
import 'mothers_controller.dart';

class MothersTab extends GetView<MothersController> {
  const MothersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const CustomLoadingAnimation();
      }

      final mothers = controller.paginatedMothers;

      return Column(
        children: [
          CustomSearchTextField(
            fieldTitle: "Mothers",
            controller: controller.searchController,
            onChanged: controller.searchMothers,
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: controller.visibleMothers.isEmpty
                ? const Center(child: Text("No mothers found."))
                : ListView.builder(
                    primary: false,
                    itemCount: mothers.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final mother = mothers[index];
                      final String address = mother.address;
                      final String villageTown = mother.villageTown;
                      final String cityValue = mother.cityValue;
                      final String stateValue = mother.stateValue;
                      final String countryValue = mother.countryValue;
                      final List<String> locationParts = [
                        if (address.isNotEmpty) address,
                        if (villageTown.isNotEmpty) villageTown,
                        if (cityValue.isNotEmpty) cityValue,
                        if (stateValue.isNotEmpty) stateValue,
                        if (countryValue.isNotEmpty) countryValue,
                      ];

                      final Map<String, String> additionalDetails = {};
                      if (mother.dateOfBirth.isNotEmpty) {
                        additionalDetails["Date of Birth"] = mother.dateOfBirth;
                      }
                      if (mother.hospital.trim().isNotEmpty) {
                        additionalDetails["Hospital"] = mother.hospital.trim();
                      }
                      if (address.isNotEmpty) {
                        additionalDetails["Address"] = address;
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
                      if (mother.profileImageType.isNotEmpty) {
                        additionalDetails["Profile Image Type"] =
                            mother.profileImageType;
                      }

                      return UsersExpandableWidget(
                        userName: mother.fullName,
                        userId: mother.motherId,
                        userRole: "Mother",
                        status: "Active",
                        email: mother.email,
                        phoneNumber: mother.phoneNumber,
                        location: locationParts.isNotEmpty
                            ? locationParts.join(", ")
                            : null,
                        imageUrl: mother.profileImage,
                        additionalDetails: additionalDetails,
                        isApproved: true,
                      );
                    },
                  ),
          ),
          if (controller.totalPages > 1)
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
