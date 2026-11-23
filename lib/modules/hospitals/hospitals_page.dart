import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_app_button.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_search_text_field.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import '../../shared/widgets/custom_responsive_builder.dart';
import '../../shared/widgets/dash_board_section_widget.dart';
import '../../shared/widgets/users_expandable_widget.dart';

class HospitalsPage extends StatelessWidget {
  const HospitalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> hospitalsList = [
      {
        "name": "Gambo Sawaba General Hospital",
        "submittedBy": "SUtWKaGCIRRDJbJSlUXvucMuzrn1",
        "phoneNumber": "23456789101",
        "address": "Musa Yardua Street",
        "district": "Anchau",
        "type": "Health Center ",
        "status": true,
        "latitude": 11.0663,
        "longitude": 7.6996,
        "createdAt": "April 14, 2026 at 10:00:35 PM UTC+1",
        "submittedAt": "April 14, 2026 at 10:00:35 PM UTC+1",
        "verifiedAt": "May 5, 2026 at 2:22:53 PM UTC+1",
      },
      {
        "name": "Lagos Island Maternity Hospital",
        "submittedBy": "USR-99823145",
        "phoneNumber": "+234 1 234 5678",
        "address": "Campbell Street, Lagos Island",
        "district": "Lagos Island",
        "type": "Maternity Hospital",
        "status": true,
        "latitude": 6.4549,
        "longitude": 3.3888,
        "createdAt": "Jan 10, 2026 at 09:30:00 AM UTC+1",
        "submittedAt": "Jan 10, 2026 at 09:30:00 AM UTC+1",
        "verifiedAt": "Jan 15, 2026 at 11:00:00 AM UTC+1",
      },
      {
        "name": "Aminu Kano Teaching Hospital",
        "submittedBy": "USR-44321098",
        "phoneNumber": "+234 64 631 001",
        "address": "Zaria Road",
        "district": "Gwale",
        "type": "Teaching Hospital",
        "status": true,
        "latitude": 11.9705,
        "longitude": 8.5364,
        "createdAt": "Feb 02, 2026 at 02:15:00 PM UTC+1",
        "submittedAt": "Feb 02, 2026 at 02:15:00 PM UTC+1",
        "verifiedAt": "Feb 10, 2026 at 04:30:00 PM UTC+1",
      },
      {
        "name": "Enugu State University Teaching Hospital",
        "submittedBy": "USR-77612344",
        "phoneNumber": "+234 42 255 102",
        "address": "Park Avenue",
        "district": "GRA",
        "type": "General Hospital",
        "status": false,
        "latitude": 6.4584,
        "longitude": 7.5464,
        "createdAt": "Mar 20, 2026 at 11:45:00 AM UTC+1",
        "submittedAt": "Mar 20, 2026 at 11:45:00 AM UTC+1",
        "verifiedAt": null,
      },
      {
        "name": "Mason le Petit Clinic",
        "submittedBy": "0I3DqFm1z1fAwuwdnrpIeMYlt292",
        "phoneNumber": "+234 803 675 8726",
        "address": "Zone 1",
        "district": "Lugbe",
        "type": "Private Clinic",
        "status": true,
        "latitude": 8.9734,
        "longitude": 7.3812,
        "createdAt": "Apr 01, 2026 at 08:20:00 AM UTC+1",
        "submittedAt": "Apr 01, 2026 at 08:20:00 AM UTC+1",
        "verifiedAt": "Apr 05, 2026 at 10:10:00 AM UTC+1",
      },
    ];

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
                      const Flexible(child: CustomSearchTextField()),
                      const SizedBox(
                        width: 20,
                      ),
                      const Flexible(
                        child: CustomAppButton(
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
                    itemCount: hospitalsList.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final hospital = hospitalsList[index];
                      final bool isVerified = (hospital["status"] as bool?) ?? false;

                      final String address = hospital["address"] ?? "";
                      final String district = hospital["district"] ?? "";

                      final List<String> locationParts = [
                        if (address.isNotEmpty) address,
                        if (district.isNotEmpty) district,
                      ];

                      final Map<String, String> additionalDetails = {};
                      if ((hospital["type"] ?? "").toString().trim().isNotEmpty) {
                        additionalDetails["Facility Type"] = (hospital["type"] as String).trim();
                      }
                      if (address.isNotEmpty) {
                        additionalDetails["Address"] = address;
                      }
                      if (district.isNotEmpty) {
                        additionalDetails["District"] = district;
                      }
                      if (hospital["latitude"] != null && hospital["longitude"] != null) {
                        additionalDetails["Coordinates"] =
                            "${hospital["latitude"]}° N, ${hospital["longitude"]}° E";
                      }
                      if ((hospital["submittedBy"] ?? "").toString().isNotEmpty) {
                        additionalDetails["Submitted By"] = hospital["submittedBy"].toString();
                      }
                      if ((hospital["createdAt"] ?? "").toString().isNotEmpty) {
                        additionalDetails["Created At"] = hospital["createdAt"].toString();
                      }
                      if ((hospital["verifiedAt"] ?? "").toString().isNotEmpty) {
                        additionalDetails["Verified At"] = hospital["verifiedAt"].toString();
                      }

                      return UsersExpandableWidget(
                        userName: hospital["name"] ?? hospital["userName"] ?? "",
                        userId: hospital["submittedBy"] ?? hospital["userId"] ?? "",
                        userRole: "Hospital",
                        status: isVerified ? "Active" : "Pending",
                        phoneNumber: hospital["phoneNumber"],
                        registrationDate: hospital["createdAt"]?.toString(),
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
