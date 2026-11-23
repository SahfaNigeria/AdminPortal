import 'package:material_ui/material_ui.dart';

import '../../../../shared/widgets/custom_search_text_field.dart';
import '../../../../shared/widgets/users_expandable_widget.dart';

class MothersTab extends StatelessWidget {
  const MothersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mothersList = [
      {
        "full name": "Joy Emordi",
        "motherId": "0I3DqFm1z1fAwuwdnrpIeMYlt292",
        "email": "joy@gmail.com",
        "phone number": "803 675 8726",
        "dateOfBirth": "2002-09-23",
        "hospital": "Mason le Petit ",
        "address": "Zone 1",
        "villageTown": "Lugbe",
        "cityValue": "Abuja",
        "stateValue": "Federal Capital Territory",
        "countryValue": "🇳🇬 Nigeria",
        "profileImage": "assets/images/hijab.jpg",
        "profileImageType": "hijab",
      },
      {
        "full name": "Amina Bello",
        "motherId": "MTH-00124",
        "email": "amina.bello@gmail.com",
        "phone number": "803 123 4567",
        "dateOfBirth": "1998-05-14",
        "hospital": "Lagos Island Maternity Hospital",
        "address": "Plot 12 Marina",
        "villageTown": "Lagos Island",
        "cityValue": "Ikeja",
        "stateValue": "Lagos State",
        "countryValue": "🇳🇬 Nigeria",
        "profileImage": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=300&auto=format&fit=crop",
        "profileImageType": "url",
      },
      {
        "full name": "Chioma Okeke",
        "motherId": "MTH-00125",
        "email": "chioma.okeke@yahoo.com",
        "phone number": "802 987 6543",
        "dateOfBirth": "1995-11-30",
        "hospital": "Enugu State University Teaching Hospital",
        "address": "No 5 Independence Layout",
        "villageTown": "Ogbete",
        "cityValue": "Enugu",
        "stateValue": "Enugu State",
        "countryValue": "🇳🇬 Nigeria",
        "profileImage": "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=300&auto=format&fit=crop",
        "profileImageType": "url",
      },
      {
        "full name": "Fatima Abubakar",
        "motherId": "MTH-00126",
        "email": "fatima.abubakar@gmail.com",
        "phone number": "805 456 7890",
        "dateOfBirth": "2000-01-18",
        "hospital": "Aminu Kano Teaching Hospital",
        "address": "Zaria Road",
        "villageTown": "Gwale",
        "cityValue": "Kano",
        "stateValue": "Kano State",
        "countryValue": "🇳🇬 Nigeria",
        "profileImage": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=300&auto=format&fit=crop",
        "profileImageType": "url",
      },
      {
        "full name": "Grace Danjuma",
        "motherId": "MTH-00127",
        "email": "grace.danjuma@gmail.com",
        "phone number": "810 555 4433",
        "dateOfBirth": "1997-08-05",
        "hospital": "National Hospital Abuja",
        "address": "Central Business District",
        "villageTown": "Maitama",
        "cityValue": "Abuja",
        "stateValue": "Federal Capital Territory",
        "countryValue": "🇳🇬 Nigeria",
        "profileImage": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=300&auto=format&fit=crop",
        "profileImageType": "url",
      },
    ];

    return Column(
      children: [
        CustomSearchTextField(
          fieldTitle: "Mothers",
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mothersList.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final mother = mothersList[index];

            final String address = mother["address"] ?? "";
            final String villageTown = mother["villageTown"] ?? "";
            final String cityValue = mother["cityValue"] ?? "";
            final String stateValue = mother["stateValue"] ?? "";
            final String countryValue = mother["countryValue"] ?? "";

            final List<String> locationParts = [
              if (address.isNotEmpty) address,
              if (villageTown.isNotEmpty) villageTown,
              if (cityValue.isNotEmpty) cityValue,
              if (stateValue.isNotEmpty) stateValue,
              if (countryValue.isNotEmpty) countryValue,
            ];

            final Map<String, String> additionalDetails = {};
            if ((mother["dateOfBirth"] ?? "").toString().isNotEmpty) {
              additionalDetails["Date of Birth"] = mother["dateOfBirth"];
            }
            if ((mother["hospital"] ?? "").toString().trim().isNotEmpty) {
              additionalDetails["Hospital"] = (mother["hospital"] as String).trim();
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
            if ((mother["profileImageType"] ?? "").toString().isNotEmpty) {
              additionalDetails["Profile Image Type"] = mother["profileImageType"];
            }

            return UsersExpandableWidget(
              userName: mother["full name"] ?? mother["userName"] ?? "",
              userId: mother["motherId"] ?? mother["userId"] ?? "",
              userRole: "Mother",
              status: "Active",
              email: mother["email"],
              phoneNumber: mother["phone number"] ?? mother["phoneNumber"],
              location: locationParts.isNotEmpty ? locationParts.join(", ") : null,
              imageUrl: mother["profileImage"] ?? mother["imageUrl"],
              additionalDetails: additionalDetails,
              isApproved: true,
            );
          },
        ),
      ],
    );
  }
}
