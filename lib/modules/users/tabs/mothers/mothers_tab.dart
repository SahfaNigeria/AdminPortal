import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../shared/model/mothers_model.dart';
import '../../../../shared/widgets/custom_app_button.dart';
import '../../../../shared/widgets/custom_circular_progress_indicator.dart';
import '../../../../shared/widgets/custom_loading_animation.dart';
import '../../../../shared/widgets/custom_search_text_field.dart';
import '../../../../shared/widgets/users_expandable_widget.dart';
import 'mothers_controller.dart';

class MothersTab extends GetView<MothersController> {
  const MothersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomSearchTextField(
                fieldTitle: "Mothers",
                controller: controller.searchController,
              ),
            ),
            const SizedBox(width: 10),
            Obx(
              () => CustomAppButton(
                child: FaIcon(
                  controller.isSearchActive.value?  FontAwesomeIcons.xmark:FontAwesomeIcons.magnifyingGlass,
                  size: 20,
                  color: AppColors.surface,
                ),
                isLoading: controller.isSearchLoading.value,
                onTap: controller.isSearchActive.value? () {
                  controller.searchController.clear();
                  controller.isSearchActive.value = false;
                }:controller.searchMothers,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Obx(() {
            if (controller.isSearchActive.value) {
              if (controller.filteredMothers.isEmpty) {
                return const Center(child: AppText(text: "No mothers found."));
              }
              return ListView.builder(
                itemCount: controller.filteredMothers.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) =>
                    _buildMother(controller.filteredMothers[index]),
              );
            }

            return FirestorePagination(
              key: const ValueKey("mothers-pagination"),
              bottomLoader:  CustomCircularProgressIndicator(
                height: 20,
                color: AppColors.primary,
                width: 20,
              ),
              query: FirebaseReference.mothers.orderBy(FieldPath.documentId),
              limit: 20,
              initialLoader: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  CustomCircularProgressIndicator(
                    height: 20,
                    color: AppColors.primary,
                    width: 20,
                  ),
                ],
              ),
              onEmpty: const Center(child: AppText(text: "No mothers found.", size: 26,),),
              itemBuilder: (context, documents, index) {
                final document = documents[index]
                    as QueryDocumentSnapshot<Map<String, dynamic>>;
                return _buildMother(MothersModel.fromFirestore(document));
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMother(MothersModel mother) {
    final String address = mother.address;
    final String villageTown = mother.villageTown;
    final String cityValue = mother.cityValue;
    final String stateValue = mother.stateValue;
    final String countryValue = mother.cityValue;

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
      additionalDetails["Profile Image Type"] = mother.profileImageType;
    }

    return UsersExpandableWidget(
      userName: mother.fullName,
      userId: mother.motherId,
      userRole: "Mother",
      status: "Active",
      email: mother.email,
      phoneNumber: mother.phoneNumber,
      location: locationParts.isNotEmpty ? locationParts.join(", ") : null,
      imageUrl: mother.profileImage,
      additionalDetails: additionalDetails,
      isApproved: true,
    );
  }
}
