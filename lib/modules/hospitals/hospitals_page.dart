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
      builder: (p0, p1) {
        return Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            DashBoardSectionWidget(
              title: "Hospitals Overview",
              subtitle: "Overview of hospitals on the platform",
              icon: FontAwesomeIcons.hospital,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(child: CustomSearchTextField()),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: CustomAppButton(
                          onTap: ()=> context.goNamed(RouteHelpers.adminAddHospitals),
                          title: "Add Hospital",
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.hospitals.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final hospital = controller.hospitals[index];
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
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
