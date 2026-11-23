import 'package:material_ui/material_ui.dart';

import '../../../../shared/widgets/custom_search_text_field.dart';
import '../../../../shared/widgets/users_expandable_widget.dart';

class HealthProfessionalTab extends StatelessWidget {
  const HealthProfessionalTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> healthProfessionalsList = [
      {
        "fullName": "Abiodun",
        "midWifeId": "1YTZlLfobJdXJwHTVtb2AcDb64t1",
        "email": "gbengaemma22@gmail.com",
        "phoneNumber": "913 818 6491",
        "position": "Doctor ",
        "healthFacility": "nursing",
        "professional": "professional",
        "qualificationNumber": "75785858584884",
        "villageTown": "stone village",
        "cityValue": "Amassoma",
        "stateValue": "Bayelsa State",
        "countryValue": "🇳🇬 Nigeria",
        "midWifeImage": "https://firebasestorage.googleapis.com/v0/b/jambo-mama-nigeria.appspot.com/o/StoreMidWifeImages%2F1YTZlLfobJdXJwHTVtb2AcDb64t1?alt=media&token=c489913f-45e5-4873-a0c4-5e28437f5935",
        "approved": true,
        "createdAt": "July 9, 2025 at 1:14:19 PM UTC+1",
      },
      {
        "fullName": "Dr. Sarah Jenkins",
        "midWifeId": "HW-00234",
        "email": "sarah.jenkins@health.gov.ng",
        "phoneNumber": "+234 803 999 8877",
        "position": "Senior Obstetrician",
        "healthFacility": "Lagos Island Maternity Hospital",
        "professional": "Doctor",
        "qualificationNumber": "MD-882341-NG",
        "villageTown": "Ikoyi",
        "cityValue": "Lagos",
        "stateValue": "Lagos State",
        "countryValue": "🇳🇬 Nigeria",
        "midWifeImage": "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=300&auto=format&fit=crop",
        "approved": true,
        "createdAt": "July 9, 2025 at 1:14:19 PM UTC+1",
      },
      {
        "fullName": "Nurse Miriam Musa",
        "midWifeId": "HW-00235",
        "email": "miriam.musa@yahoo.com",
        "phoneNumber": "+234 806 111 4455",
        "position": "Midwife",
        "healthFacility": "Aminu Kano Teaching Hospital",
        "professional": "Nurse Midwife",
        "qualificationNumber": "NM-554210-NG",
        "villageTown": "Sabon Gari",
        "cityValue": "Kano",
        "stateValue": "Kano State",
        "countryValue": "🇳🇬 Nigeria",
        "midWifeImage": "https://images.unsplash.com/photo-1594824813566-88855ce78907?q=80&w=300&auto=format&fit=crop",
        "approved": false,
        "createdAt": "July 9, 2025 at 1:14:19 PM UTC+1",
      },
      {
        "fullName": "Dr. Emmanuel Okafor",
        "midWifeId": "HW-00236",
        "email": "e.okafor@esut.edu.ng",
        "phoneNumber": "+234 812 333 9900",
        "position": "Gynecologist",
        "healthFacility": "Enugu State University Teaching Hospital",
        "professional": "Doctor",
        "qualificationNumber": "MD-443912-NG",
        "villageTown": "Independence Layout",
        "cityValue": "Enugu",
        "stateValue": "Enugu State",
        "countryValue": "🇳🇬 Nigeria",
        "midWifeImage": "https://images.unsplash.com/photo-1622253692010-333f2da6031d?q=80&w=300&auto=format&fit=crop",
        "approved": true,
        "createdAt": "July 9, 2025 at 1:14:19 PM UTC+1",
      },
      {
        "fullName": "Fatima Usman",
        "midWifeId": "HW-00237",
        "email": "fatima.usman@nationalhospital.org",
        "phoneNumber": "+234 809 777 3322",
        "position": "Community Health Officer",
        "healthFacility": "National Hospital Abuja",
        "professional": "CHO",
        "qualificationNumber": "CHO-998124-NG",
        "villageTown": "Lugbe",
        "cityValue": "Abuja",
        "stateValue": "Federal Capital Territory",
        "countryValue": "🇳🇬 Nigeria",
        "midWifeImage": "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=300&auto=format&fit=crop",
        "approved": false,
        "createdAt": "July 9, 2025 at 1:14:19 PM UTC+1",
      },
    ];

    return Column(
      children: [
        CustomSearchTextField(
          fieldTitle: "Health Professionals",
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: healthProfessionalsList.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final pro = healthProfessionalsList[index];
            final bool isApproved = (pro["approved"] as bool?) ?? false;

            final String villageTown = pro["villageTown"] ?? "";
            final String cityValue = pro["cityValue"] ?? "";
            final String stateValue = pro["stateValue"] ?? "";
            final String countryValue = pro["countryValue"] ?? "";

            final List<String> locationParts = [
              if (villageTown.isNotEmpty) villageTown,
              if (cityValue.isNotEmpty) cityValue,
              if (stateValue.isNotEmpty) stateValue,
              if (countryValue.isNotEmpty) countryValue,
            ];

            final Map<String, String> additionalDetails = {};
            if ((pro["position"] ?? "").toString().trim().isNotEmpty) {
              additionalDetails["Position"] = (pro["position"] as String).trim();
            }
            if ((pro["healthFacility"] ?? "").toString().trim().isNotEmpty) {
              additionalDetails["Health Facility"] = (pro["healthFacility"] as String).trim();
            }
            if ((pro["professional"] ?? "").toString().trim().isNotEmpty) {
              additionalDetails["Professional Type"] = (pro["professional"] as String).trim();
            }
            if ((pro["qualificationNumber"] ?? "").toString().trim().isNotEmpty) {
              additionalDetails["Qualification Number"] = (pro["qualificationNumber"] as String).trim();
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
            if ((pro["createdAt"] ?? "").toString().isNotEmpty) {
              additionalDetails["Created At"] = pro["createdAt"].toString();
            }

            return UsersExpandableWidget(
              userName: pro["fullName"] ?? pro["userName"] ?? "",
              userId: pro["midWifeId"] ?? pro["userId"] ?? "",
              userRole: "Health Professional",
              status: isApproved ? "Approved" : "Pending",
              email: pro["email"],
              phoneNumber: pro["phoneNumber"],
              registrationDate: pro["createdAt"]?.toString(),
              location: locationParts.isNotEmpty ? locationParts.join(", ") : null,
              imageUrl: pro["midWifeImage"] ?? pro["imageUrl"],
              additionalDetails: additionalDetails,
              isApproved: isApproved,
              onApprovalChanged: (value) {

              },
            );
          },
        ),
      ],
    );
  }
}
