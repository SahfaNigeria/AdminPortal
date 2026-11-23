import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../shared/widgets/custom_loading_animation.dart';
import '../../../../shared/widgets/custom_search_text_field.dart';
import '../../../../shared/widgets/users_expandable_widget.dart';
import 'mothers_controller.dart';

class MothersTab extends GetView<MothersController> {
  const MothersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MothersController>(builder: (_) {
      return controller.isLoading.value? CustomLoadingAnimation():Column(
        children: [
          CustomSearchTextField(
            fieldTitle: "Mothers",
            controller: controller.searchController,
            onChanged: (value) {
              controller.searchMothers(value);
            },),
          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredMothers.length == 0 ? controller
                  .mothers.length : controller.filteredMothers.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final mother = controller.filteredMothers.length == 0
                    ? controller.mothers[index]
                    : controller.filteredMothers[index];

                final String address = mother.address ?? "";
                final String villageTown = mother.villageTown ?? "";
                final String cityValue = mother.cityValue ?? "";
                final String stateValue = mother.stateValue ?? "";
                final String countryValue = mother.cityValue ?? "";

                final List<String> locationParts = [
                  if (address.isNotEmpty) address,
                  if (villageTown.isNotEmpty) villageTown,
                  if (cityValue.isNotEmpty) cityValue,
                  if (stateValue.isNotEmpty) stateValue,
                  if (countryValue.isNotEmpty) countryValue,
                ];

                final Map<String, String> additionalDetails = {};
                if ((mother.dateOfBirth ?? "")
                    .toString()
                    .isNotEmpty) {
                  additionalDetails["Date of Birth"] = mother.dateOfBirth;
                }
                if ((mother.hospital ?? "")
                    .toString()
                    .trim()
                    .isNotEmpty) {
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
                if ((mother.profileImageType ?? "")
                    .toString()
                    .isNotEmpty) {
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
            );
          }),
        ],
      );
    });
  }
}
