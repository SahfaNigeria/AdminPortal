import 'package:material_ui/material_ui.dart';

import '../../../../shared/widgets/users_expandable_widget.dart';

class MothersTab extends StatelessWidget {
  const MothersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data list of mothers for demonstration
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

    return ListView.builder(
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
          userRole: mother["userRole"],
          status: mother["status"],
          email: mother["email"],
          phoneNumber: mother["phoneNumber"],
          registrationDate: mother["registrationDate"],
          location: mother["location"],
          imageUrl: mother["imageUrl"],
          additionalDetails: Map<String, String>.from(mother["additionalDetails"]),
          onApprove: hasActions
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Approved registration for ${mother['userName']}"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              : null,
          onDisapprove: hasActions
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Disapproved registration for ${mother['userName']}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              : null,
        );
      },
    );
  }
}
