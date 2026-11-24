import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:number_pagination/number_pagination.dart';

import '../../core/routes/route_helper.dart';
import '../../core/theme/colors.dart';
import '../../shared/widgets/custom_app_button.dart';
import '../../shared/widgets/custom_loading_animation.dart';
import '../../shared/widgets/custom_responsive_builder.dart';
import '../../shared/widgets/custom_search_text_field.dart';
import '../../shared/widgets/dash_board_section_widget.dart';
import '../../shared/widgets/users_expandable_widget.dart';
import 'hospitals_controller.dart';

class HospitalsPage extends GetView<HospitalsController> {
  const HospitalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomResponsiveBuilder(
      builder: (context, sizingInfo) {
        return Column(
          children: [
            const SizedBox(height: 24),
            Obx(() {
              final hospitals = controller.paginatedHospitals;

              return DashBoardSectionWidget(
                title: "Hospitals Overview",
                subtitle: "Overview of hospitals on the platform",
                icon: FontAwesomeIcons.hospital,
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final searchField = CustomSearchTextField(
                          fieldTitle: "Hospitals",
                          controller: controller.searchController,
                          onChanged: controller.searchHospitals,
                        );
                        final addButton = CustomAppButton(
                          onTap: () =>
                              context.goNamed(RouteHelpers.adminAddHospitals),
                          title: "Add Hospital",
                        );

                        if (constraints.maxWidth < 600) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              searchField,
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: addButton,
                              ),
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(child: searchField),
                            const SizedBox(width: 20),
                            addButton,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    if (controller.isLoading.value)
                      const CustomLoadingAnimation()
                    else if (controller.visibleHospitals.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: Text("No hospitals found.")),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: hospitals.length,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemBuilder: (context, index) {
                          final hospital = hospitals[index];
                          final locationParts = [
                            if (hospital.address.isNotEmpty) hospital.address,
                            if (hospital.district.isNotEmpty) hospital.district,
                          ];
                          final additionalDetails = <String, String>{
                            if (hospital.type.trim().isNotEmpty)
                              "Facility Type": hospital.type.trim(),
                            if (hospital.address.isNotEmpty)
                              "Address": hospital.address,
                            if (hospital.district.isNotEmpty)
                              "District": hospital.district,
                            if (hospital.latitude != 0 ||
                                hospital.longitude != 0)
                              "Coordinates":
                                  "${hospital.latitude}, ${hospital.longitude}",
                            if (hospital.submittedBy.isNotEmpty)
                              "Submitted By": hospital.submittedBy,
                            if (hospital.createdAt != null)
                              "Created At": hospital.createdAt.toString(),
                            if (hospital.verifiedAt != null)
                              "Verified At": hospital.verifiedAt.toString(),
                          };

                          return UsersExpandableWidget(
                            userName: hospital.name,
                            userId: hospital.submittedBy,
                            userRole: "Hospital",
                            status: hospital.status ? "Active" : "Pending",
                            phoneNumber: hospital.phoneNumber,
                            registrationDate: hospital.createdAt?.toString(),
                            location: locationParts.isNotEmpty
                                ? locationParts.join(", ")
                                : null,
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
                            isApproved: hospital.status,
                          );
                        },
                      ),
                    if (!controller.isLoading.value &&
                        controller.totalPages > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: NumberPagination(
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
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
