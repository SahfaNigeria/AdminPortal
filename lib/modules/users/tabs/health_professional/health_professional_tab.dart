import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/health_professionals.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/custom_app_button.dart';
import '../../../../shared/widgets/custom_circular_progress_indicator.dart';
import '../../../../shared/widgets/custom_initial_loader_widget.dart';
import '../../../../shared/widgets/custom_search_text_field.dart';
import '../../../../shared/widgets/country_filter_button.dart';
import '../../../../shared/widgets/users_expandable_widget.dart';
import 'health_professional_controller.dart';

class HealthProfessionalTab extends GetView<HealthProfessionalController> {
  const HealthProfessionalTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomSearchTextField(
                fieldTitle: "Health Professionals",
                controller: controller.searchController,
              ),
            ),
            const SizedBox(width: 10),
            Obx(
              () {
                final selectedCountry = controller.selectedCountry.value;
                return CountryFilterButton(
                  selectedCountry: selectedCountry,
                  onChanged: controller.setSelectedCountry,
                );
              },
            ),
            const SizedBox(width: 10),
            Obx(
              () => CustomAppButton(
                child: FaIcon(
                  controller.isSearchActive.value &&
                          controller.selectedCountry.value == null
                      ? FontAwesomeIcons.xmark
                      : FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                  color: AppColors.surface,
                ),
                isLoading: controller.isSearchLoading.value,
                onTap: controller.isSearchActive.value &&
                        controller.selectedCountry.value == null
                    ? controller.clearFilter
                    : controller.searchHealthProfessionals,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Obx(() {
            if (controller.isSearchActive.value) {
              if (controller.filteredHealthProfessionals.isEmpty) {
                return const Center(
                  child:
                      AppText(text: "No health professionals found.", size: 18),
                );
              }
              return ListView.builder(
                itemCount: controller.filteredHealthProfessionals.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) => _buildProfessional(
                  controller.filteredHealthProfessionals[index],
                ),
              );
            }

            return FirestorePagination(
              key: const ValueKey("health-professionals-pagination"),
              bottomLoader: CustomCircularProgressIndicator(
                height: 20,
                color: AppColors.primary,
                width: 20,
              ),
              query: FirebaseReference.healthProfessionals
                  .orderBy(FieldPath.documentId),
              limit: 20,
              initialLoader: CustomInitialLoaderWidget(),
              onEmpty: Center(
                child: AppText(
                  text: "No health professionals found.",
                  size: 26,
                ),
              ),
              itemBuilder: (context, documents, index) {
                final document = documents[index]
                    as QueryDocumentSnapshot<Map<String, dynamic>>;
                return _buildProfessional(
                  HealthProfessionalsModel.fromFirestore(document),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProfessional(HealthProfessionalsModel professional) {
    final bool isApproved = professional.approved;
    final String villageTown = professional.villageTown;
    final String cityValue = professional.cityValue;
    final String stateValue = professional.stateValue;
    final String countryValue = professional.countryValue;

    final List<String> locationParts = [
      if (villageTown.isNotEmpty) villageTown,
      if (cityValue.isNotEmpty) cityValue,
      if (stateValue.isNotEmpty) stateValue,
      if (countryValue.isNotEmpty) countryValue,
    ];

    final Map<String, String> additionalDetails = {};
    if (professional.position.trim().isNotEmpty) {
      additionalDetails["Position"] = professional.position.trim();
    }
    if (professional.healthFacility.trim().isNotEmpty) {
      additionalDetails["Health Facility"] = professional.healthFacility.trim();
    }
    if (professional.professional.trim().isNotEmpty) {
      additionalDetails["Professional Type"] = professional.professional.trim();
    }
    if (professional.qualificationNumber.trim().isNotEmpty) {
      additionalDetails["Qualification Number"] =
          professional.qualificationNumber.trim();
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
    if (professional.createdAt != null) {
      additionalDetails["Created At"] = professional.createdAt.toString();
    }

    return Obx(
      () => UsersExpandableWidget(
        userName: professional.fullName,
        userId: professional.midWifeId,
        userRole: "Health Professional",
        status: isApproved ? "Approved" : "Pending",
        email: professional.email,
        isLoading:
            controller.updatingProfessionalIds.contains(professional.midWifeId),
        phoneNumber: professional.phoneNumber,
        registrationDate: professional.createdAt?.toString(),
        location: locationParts.isNotEmpty ? locationParts.join(", ") : null,
        imageUrl: professional.midWifeImage,
        additionalDetails: additionalDetails,
        isApproved: isApproved,
        additionalActions: professional.email.trim().isEmpty
            ? null
            : [
                CustomAppButton(
                  title: "Send reset link",
                  isLoading: controller.sendingPasswordResetIds
                      .contains(professional.midWifeId),
                  onTap: () => controller.sendPasswordResetLink(
                    professional.midWifeId,
                    professional.email,
                  ),
                ),
              ],
        onApprovalChanged: (value) {
          controller.updateApproval(value, professional.midWifeId);
        },
      ),
    );
  }
}
