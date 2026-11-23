import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/health_professional/health_professional_controller.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_loading_animation.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../shared/widgets/custom_search_text_field.dart';
import '../../../../shared/widgets/users_expandable_widget.dart';

class HealthProfessionalTab extends GetView<HealthProfessionalController> {
  const HealthProfessionalTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HealthProfessionalController>(builder: (_) {
      return controller.isLoading.value? CustomLoadingAnimation():Column(
        children: [
          CustomSearchTextField(
            fieldTitle: "Health Professionals",
            controller: controller.searchController,
            onChanged: (value) {
              controller.searchHealthProfessionals(value);
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.filteredHealthProfessionals.length == 0 ? controller.healthProfessionals.length : controller.filteredHealthProfessionals.length ,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final pro = controller.filteredHealthProfessionals.length == 0? controller.healthProfessionals[index] : controller.filteredHealthProfessionals[index];
              final bool isApproved = (pro.approved as bool?) ?? false;

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
              if ((pro.position)
                  .toString()
                  .trim()
                  .isNotEmpty) {
                additionalDetails["Position"] =
                    pro.position.trim();
              }
              if ((pro.healthFacility)
                  .toString()
                  .trim()
                  .isNotEmpty) {
                additionalDetails["Health Facility"] =
                    pro.healthFacility.trim();
              }
              if ((pro.professional)
                  .toString()
                  .trim()
                  .isNotEmpty) {
                additionalDetails["Professional Type"] =
                    pro.professional.trim();
              }
              if ((pro.qualificationNumber)
                  .toString()
                  .trim()
                  .isNotEmpty) {
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
              if ((pro.createdAt ?? "")
                  .toString()
                  .isNotEmpty) {
                additionalDetails["Created At"] = pro.createdAt.toString();
              }

              return UsersExpandableWidget(
                userName: pro.fullName,
                userId: pro.qualificationNumber,
                userRole: "Health Professional",
                status: isApproved ? "Approved" : "Pending",
                email: pro.email,
                isLoading: controller.isUpdateLoading.value,
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
        ],
      );
    });
  }
}
