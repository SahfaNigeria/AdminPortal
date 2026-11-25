import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/core/routes/route_helper.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'package:jambomama_nigeria_admin_portal/modules/hospitals/hospital_page_controller.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/hospital_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_app_button.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_responsive_builder.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_search_text_field.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/dash_board_section_widget.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/users_expandable_widget.dart';
import 'package:material_ui/material_ui.dart';

class HospitalsPage extends GetView<HospitalPageController> {
  const HospitalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomResponsiveBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.isMobile;

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              DashBoardSectionWidget(
                title: "Hospitals Overview",
                subtitle: "Overview of hospitals on the platform",
                icon: FontAwesomeIcons.hospital,
                child: Column(
                  children: [
                    if (isMobile) ...[
                      Row(
                        children: [
                          Expanded(
                            child: CustomSearchTextField(
                              fieldTitle: "Hospitals",
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
                              isLoading: controller.isSearchLoading.value,
                              onTap: controller.isSearchActive.value
                                  ? () {
                                      controller.searchController.clear();
                                      controller.isSearchActive.value = false;
                                    }
                                  : controller.searchHospitals,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: CustomAppButton(
                          color: AppColors.primary,
                          onTap: () => context.goNamed(RouteHelpers.adminAddHospitals),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              FaIcon(
                                FontAwesomeIcons.plus,
                                size: 16,
                                color: AppColors.surface,
                              ),
                              SizedBox(width: 8),
                              AppText(
                                text: "Add Hospital",
                                color: AppColors.surface,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: CustomSearchTextField(
                              fieldTitle: "Hospitals",
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
                              isLoading: controller.isSearchLoading.value,
                              onTap: controller.isSearchActive.value
                                  ? () {
                                      controller.searchController.clear();
                                      controller.isSearchActive.value = false;
                                    }
                                  : controller.searchHospitals,
                            ),
                          ),
                          const SizedBox(width: 10),
                          CustomAppButton(
                            color: AppColors.primary,
                            onTap: () => context.goNamed(RouteHelpers.adminAddHospitals),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                FaIcon(
                                  FontAwesomeIcons.plus,
                                  size: 16,
                                  color: AppColors.surface,
                                ),
                                SizedBox(width: 8),
                                AppText(
                                  text: "Add Hospital",
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Obx(() {
                        if (controller.isSearchActive.value) {
                          if (controller.filteredHospitals.isEmpty) {
                            return const Center(
                              child: Text("No hospitals found."),
                            );
                          }
                          return ListView.builder(
                            itemCount: controller.filteredHospitals.length,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemBuilder: (context, index) => _buildHospital(
                              controller.filteredHospitals[index],
                            ),
                          );
                        }

                        return FirestorePagination(
                          key: const ValueKey("hospitals-pagination"),
                          bottomLoader: CustomCircularProgressIndicator(
                            height: 20,
                            color: AppColors.primary,
                            width: 20,
                          ),
                          query: FirebaseReference.hospitals
                              .orderBy(FieldPath.documentId),
                          limit: 20,
                          initialLoader: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              CustomCircularProgressIndicator(
                                height: 20,
                                color: AppColors.primary,
                                width: 20,
                              ),
                            ],
                          ),
                          onEmpty: Center(
                            child: AppText(
                              text: "No hospitals found.",
                              size: 26,
                            ),
                          ),
                          itemBuilder: (context, documents, index) {
                            final document = documents[index]
                                as QueryDocumentSnapshot<Map<String, dynamic>>;
                            return _buildHospital(
                              HospitalModel.fromFirestore(document),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHospital(HospitalModel hospital) {
    final bool isVerified = hospital.status;
    final String address = hospital.address;
    final String district = hospital.district;

    final List<String> locationParts = [
      if (address.isNotEmpty) address,
      if (district.isNotEmpty) district,
    ];

    final Map<String, String> additionalDetails = {};
    if (hospital.type.trim().isNotEmpty) {
      additionalDetails["Facility Type"] = hospital.type.trim();
    }
    if (address.isNotEmpty) {
      additionalDetails["Address"] = address;
    }
    if (district.isNotEmpty) {
      additionalDetails["District"] = district;
    }
    if (hospital.latitude != 0 || hospital.longitude != 0) {
      additionalDetails["Coordinates"] =
          "${hospital.latitude}° N, ${hospital.longitude}° E";
    }
    if (hospital.submittedBy.isNotEmpty) {
      additionalDetails["Submitted By"] = hospital.submittedBy;
    }
    if (hospital.createdAt != null) {
      additionalDetails["Created At"] = hospital.createdAt.toString();
    }
    if (hospital.verifiedAt != null) {
      additionalDetails["Verified At"] = hospital.verifiedAt.toString();
    }

    return Obx(
      () => UsersExpandableWidget(
        userName: hospital.name.isNotEmpty ? hospital.name : "Unnamed Hospital",
        userId: hospital.id,
        IdName: "ID:",
        userRole: "Hospital",
        status: isVerified ? "Approved" : "Pending",
        phoneNumber: hospital.phoneNumber.isNotEmpty ? hospital.phoneNumber : null,
        registrationDate: hospital.createdAt?.toString(),
        location: locationParts.isNotEmpty ? locationParts.join(", ") : null,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FaIcon(
            FontAwesomeIcons.hospital,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        additionalDetails: additionalDetails,
        isApproved: isVerified,
        isLoading: controller.updatingHospitalIds.contains(hospital.id),
        onApprovalChanged: (value) {
          controller.updateApproval(value, hospital.id);
        },
      ),
    );
  }
}
