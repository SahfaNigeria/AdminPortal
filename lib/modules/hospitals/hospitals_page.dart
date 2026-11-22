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

    final List<Map<String, dynamic>> mothersList = [
      {
        "userName": "Amina Bello",
        "userId": "MTH-00124",
        "userRole": "Mother",
        "status": "Active",
        "email": "amina.bello@gmail.com",
        "phoneNumber": "+234 803 123 4567",
        "registrationDate": "15 Feb 2024",
        "location": "Lagos, Nigeria",
        "imageUrl": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=300&auto=format&fit=crop",
        "additionalDetails": {
          "Expected Due Date": "15 Dec 2024",
          "Trimester": "2nd Trimester",
          "Assigned Facility": "Lagos Island Maternity Hospital",
          "Healthcare Provider": "Dr. Sarah Jenkins",
        },
        "hasApprovalActions": false,
      },
      {
        "userName": "Chioma Okeke",
        "userId": "MTH-00125",
        "userRole": "Mother",
        "status": "Pending",
        "email": "chioma.okeke@yahoo.com",
        "phoneNumber": "+234 802 987 6543",
        "registrationDate": "20 Feb 2024",
        "location": "Enugu, Nigeria",
        "imageUrl": "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=300&auto=format&fit=crop",
        "additionalDetails": {
          "Expected Due Date": "08 Jan 2025",
          "Trimester": "1st Trimester",
          "Assigned Facility": "Enugu State University Teaching Hospital",
        },
        "hasApprovalActions": true,
      },
      {
        "userName": "Fatima Abubakar",
        "userId": "MTH-00126",
        "userRole": "Mother",
        "status": "Active",
        "email": "fatima.abubakar@gmail.com",
        "phoneNumber": "+234 805 456 7890",
        "registrationDate": "10 Jan 2024",
        "location": "Kano, Nigeria",
        "imageUrl": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=300&auto=format&fit=crop",
        "additionalDetails": {
          "Expected Due Date": "02 Oct 2024",
          "Trimester": "3rd Trimester",
          "Assigned Facility": "Aminu Kano Teaching Hospital",
          "Healthcare Provider": "Dr. Ibrahim Musa",
        },
        "hasApprovalActions": false,
      },
      {
        "userName": "Grace Danjuma",
        "userId": "MTH-00127",
        "userRole": "Mother",
        "status": "Pending",
        "email": "grace.danjuma@gmail.com",
        "phoneNumber": "+234 810 555 4433",
        "registrationDate": "22 Feb 2024",
        "location": "Abuja, Nigeria",
        "imageUrl": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=300&auto=format&fit=crop",
        "additionalDetails": {
          "Expected Due Date": "18 Nov 2024",
          "Trimester": "2nd Trimester",
          "Assigned Facility": "National Hospital Abuja",
        },
        "hasApprovalActions": true,
      },
      {
        "userName": "Blessing Eze",
        "userId": "MTH-00128",
        "userRole": "Mother",
        "status": "Disapproved",
        "email": "blessing.eze@outlook.com",
        "phoneNumber": "+234 809 111 2233",
        "registrationDate": "01 Feb 2024",
        "location": "Port Harcourt, Nigeria",
        "imageUrl": "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=300&auto=format&fit=crop",
        "additionalDetails": {
          "Reason": "Incomplete verification documents",
          "Assigned Facility": "Port Harcourt Medical Centre",
        },
        "hasApprovalActions": false,
      },
    ];
    return CustomResponsiveBuilder(
      builder: (p0, p1) {
        return Column(
          children: [
            SizedBox(
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
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(child: CustomAppButton(
                        title: "Add Hospital",
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 20,

                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mothersList.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final mother = mothersList[index];
                      final bool hasActions = mother["hasApprovalActions"] as bool;

                      return UsersExpandableWidget(
                        userName: mother["userName"],
                        userId: mother["userId"],
                        userRole: "Hospital",
                        status: "Active",
                        email: mother["email"],
                        phoneNumber: mother["phoneNumber"],
                        registrationDate: mother["registrationDate"],
                        location: mother["location"],
                        leading:  Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:  FaIcon(
                            FontAwesomeIcons.hospital,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        additionalDetails: Map<String, String>.from(mother["additionalDetails"]),
                        isApproved: true,


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
