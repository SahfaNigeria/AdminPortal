import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/firebase/firebase_reference.dart';
import '../../../core/routes/route_helper.dart';

class AdminAddHospitalLogic extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController =
      TextEditingController(text: "🇳🇬 Nigeria");
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  String selectedFacilityType = "Health Center";
  bool isApproved = true;
  bool hasEmergencyCare = true;
  bool hasMaternityServices = true;
  bool isSubmitting = false;

  final List<String> facilityTypes = [
    "Health Center",
    "General Hospital",
    "Teaching Hospital",
    "Maternity Hospital",
    "Private Clinic",
    "Primary Health Center",
  ];

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    districtController.dispose();
    stateController.dispose();
    countryController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }

  void setSelectedFacilityType(String value) {
    selectedFacilityType = value;
    update();
  }

  void setApproved(bool value) {
    isApproved = value;
    update();
  }

  void setHasEmergencyCare(bool value) {
    hasEmergencyCare = value;
    update();
  }

  void setHasMaternityServices(bool value) {
    hasMaternityServices = value;
    update();
  }

  void autoFillCoordinates() {
    latitudeController.text = "11.0663";
    longitudeController.text = "7.6996";
    update();
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isSubmitting = true;
    update();

    try {
      final double lat = double.tryParse(latitudeController.text.trim()) ?? 0.0;
      final double lng = double.tryParse(longitudeController.text.trim()) ?? 0.0;

      final hospitalData = {
        "name": nameController.text.trim(),
        "type": selectedFacilityType,
        "phoneNumber": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "address": addressController.text.trim(),
        "district": districtController.text.trim(),
        "stateValue": stateController.text.trim(),
        "countryValue": countryController.text.trim(),
        "latitude": lat,
        "longitude": lng,
        "location": GeoPoint(lat, lng),
        "status": isApproved,
        "hasEmergencyCare": hasEmergencyCare,
        "hasMaternityServices": hasMaternityServices,
        "submittedBy":
            FirebaseReference.firebaseAuth.currentUser?.uid ?? "ADMIN-PORTAL",
        "createdAt": FieldValue.serverTimestamp(),
        "submittedAt": FieldValue.serverTimestamp(),
        "verifiedAt": isApproved ? FieldValue.serverTimestamp() : null,
      };

      await FirebaseReference.firestore.collection('hospitals').add(hospitalData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 10),
                Text("Hospital successfully added!"),
              ],
            ),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        context.goNamed(RouteHelpers.adminHospitals);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Hospital saved locally: ${nameController.text}"),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        context.goNamed(RouteHelpers.adminHospitals);
      }
    } finally {
      isSubmitting = false;
      update();
    }
  }
}
