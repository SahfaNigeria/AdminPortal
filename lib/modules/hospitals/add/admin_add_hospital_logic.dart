import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/firebase/firebase_reference.dart';
import '../../../core/routes/route_helper.dart';
import '../../../shared/utils/firebase_error.dart';
import '../../../shared/utils/toast.dart';

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

  // CSV Batch Upload variables
  bool isUploadingCsv = false;
  String? csvFileName;
  List<Map<String, dynamic>> parsedCsvHospitals = [];

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

  void clearParsedCsv() {
    parsedCsvHospitals.clear();
    csvFileName = null;
    update();
  }

  Future<void> downloadSampleCsv(BuildContext context) async {
    try {
      const sampleContent =
          "name,type,phoneNumber,email,address,district,stateValue,countryValue,latitude,longitude,status,hasEmergencyCare,hasMaternityServices\n"
          "Gambo Sawaba General Hospital,General Hospital,+2348031234567,info@gambosawaba.org,Musa Yar Adua Street,Koforidua,Kaduna State,🇳🇬 Nigeria,11.0663,7.6996,true,true,true\n"
          "Zaria Maternity Clinic,Maternity Hospital,+2348098765432,contact@zariamaternity.org,Tudun Wada,Zaria,Kaduna State,🇳🇬 Nigeria,11.0821,7.7214,true,true,true\n"
          "Anchau Primary Health Center,Primary Health Center,+2348021112233,,Market Road,Anchau,Kaduna State,🇳🇬 Nigeria,10.9500,7.8500,true,false,true\n";

      final bytes = Uint8List.fromList(utf8.encode(sampleContent));

      final resultUri = await FilePicker.saveFile(
        fileName: "sample_hospitals.csv",
        bytes: bytes,
        mimeType: "text/csv",
        dialogTitle: "Save Sample CSV File",
      );

      if (resultUri != null && context.mounted) {
        AppToast.success(
          "Sample CSV saved successfully!",
          title: "Download Complete",
          context: context,
        );
      }
    } catch (e) {
      if (context.mounted) {
        FirebaseError.handle(
          e,
          title: "Download Failed",
          context: context,
        );
      }
    }
  }

  Future<void> pickAndParseCsv(BuildContext context) async {
    try {
      final List<PlatformFile> files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (files.isEmpty) {
        return;
      }

      final PlatformFile file = files.first;
      csvFileName = file.name;

      final bytes = await file.readAsBytes();
      final String csvContent = utf8.decode(bytes, allowMalformed: true);

      if (csvContent.trim().isEmpty) {
        if (context.mounted) {
          AppToast.error(
            "Selected CSV file is empty.",
            title: "Empty File",
            context: context,
          );
        }
        return;
      }

      final List<List<String>> rows = _parseCsvString(csvContent);
      if (rows.isEmpty) {
        if (context.mounted) {
          AppToast.error(
            "No data rows found in CSV file.",
            title: "Invalid CSV",
            context: context,
          );
        }
        return;
      }

      final Map<String, int> headerMap = {};
      int startIndex = 0;

      final firstRow = rows.first;
      bool hasHeader = false;
      for (int i = 0; i < firstRow.length; i++) {
        final col = firstRow[i].trim().toLowerCase();
        if (col.contains('name') ||
            col.contains('type') ||
            col.contains('phone') ||
            col.contains('address') ||
            col.contains('district') ||
            col.contains('state') ||
            col.contains('lat') ||
            col.contains('status')) {
          hasHeader = true;
          break;
        }
      }

      if (hasHeader) {
        startIndex = 1;
        for (int i = 0; i < firstRow.length; i++) {
          final col = firstRow[i].trim().toLowerCase();
          if (col.contains('name')) {
            headerMap['name'] = i;
          } else if (col.contains('type') || col.contains('category')) {
            headerMap['type'] = i;
          } else if (col.contains('phone') ||
              col.contains('contact') ||
              col.contains('mobile')) {
            headerMap['phoneNumber'] = i;
          } else if (col.contains('email')) {
            headerMap['email'] = i;
          } else if (col.contains('address') || col.contains('street')) {
            headerMap['address'] = i;
          } else if (col.contains('district') ||
              col.contains('lga') ||
              col.contains('town') ||
              col.contains('city')) {
            headerMap['district'] = i;
          } else if (col.contains('state')) {
            headerMap['stateValue'] = i;
          } else if (col.contains('country')) {
            headerMap['countryValue'] = i;
          } else if (col == 'lat' || col.contains('latitude')) {
            headerMap['latitude'] = i;
          } else if (col == 'lng' ||
              col == 'long' ||
              col.contains('longitude')) {
            headerMap['longitude'] = i;
          } else if (col.contains('status') ||
              col.contains('approved') ||
              col.contains('verified')) {
            headerMap['status'] = i;
          } else if (col.contains('emergency')) {
            headerMap['hasEmergencyCare'] = i;
          } else if (col.contains('maternity')) {
            headerMap['hasMaternityServices'] = i;
          }
        }
      }

      final List<Map<String, dynamic>> hospitalsList = [];
      for (int i = startIndex; i < rows.length; i++) {
        final row = rows[i];
        if (row.isEmpty || row.every((element) => element.trim().isEmpty)) {
          continue;
        }

        final hospitalMap = _rowToHospitalMap(row, headerMap, hasHeader);
        if ((hospitalMap['name'] as String).isNotEmpty) {
          hospitalsList.add(hospitalMap);
        }
      }

      if (hospitalsList.isEmpty) {
        if (context.mounted) {
          AppToast.error(
            "Could not parse any valid hospital entries. Ensure hospital name column is present.",
            title: "Parsing Failed",
            context: context,
          );
        }
        return;
      }

      parsedCsvHospitals = hospitalsList;
      update();

      if (context.mounted) {
        AppToast.success(
          "Parsed ${parsedCsvHospitals.length} hospitals from $csvFileName",
          title: "CSV File Ready",
          context: context,
        );
      }
    } catch (e) {
      if (context.mounted) {
        FirebaseError.handle(
          e,
          title: "Failed to read CSV file",
          context: context,
        );
      }
    }
  }

  Future<void> uploadCsvHospitalsToFirebase(BuildContext context) async {
    if (parsedCsvHospitals.isEmpty) return;

    isUploadingCsv = true;
    update();

    try {
      final int total = parsedCsvHospitals.length;
      const int batchSize = 400;

      for (int i = 0; i < total; i += batchSize) {
        final batch = FirebaseReference.firestore.batch();
        final chunk = parsedCsvHospitals.skip(i).take(batchSize);

        for (final hospitalData in chunk) {
          final docRef = FirebaseReference.hospitals.doc();
          batch.set(docRef, hospitalData);
        }

        await batch.commit();
      }

      if (context.mounted) {
        AppToast.success(
          "Successfully uploaded $total hospitals to database!",
          title: "Batch Upload Complete",
          context: context,
        );
        clearParsedCsv();
        context.goNamed(RouteHelpers.adminHospitals);
      }
    } catch (e) {
      if (context.mounted) {
        FirebaseError.handle(
          e,
          title: "CSV Upload Failed",
          context: context,
        );
      }
    } finally {
      isUploadingCsv = false;
      update();
    }
  }

  Map<String, dynamic> _rowToHospitalMap(
    List<String> row,
    Map<String, int> headerMap,
    bool hasHeader,
  ) {
    String getValue(String field, int defaultIndex) {
      final index = hasHeader ? headerMap[field] : defaultIndex;
      if (index != null && index < row.length) {
        return row[index].trim();
      }
      return "";
    }

    final name = getValue("name", 0);
    final type = getValue("type", 1);
    final phone = getValue("phoneNumber", 2);
    final email = getValue("email", 3);
    final address = getValue("address", 4);
    final district = getValue("district", 5);
    final state = getValue("stateValue", 6);
    final country = getValue("countryValue", 7);
    final latStr = getValue("latitude", 8);
    final lngStr = getValue("longitude", 9);
    final statusStr = getValue("status", 10);

    final double lat = double.tryParse(latStr) ?? 0.0;
    final double lng = double.tryParse(lngStr) ?? 0.0;

    final statusVal = statusStr.toLowerCase();
    final bool status = statusVal.isEmpty ||
        statusVal == "true" ||
        statusVal == "yes" ||
        statusVal == "1" ||
        statusVal == "approved";

    final emergencyVal = getValue("hasEmergencyCare", 11).toLowerCase();
    final bool hasEmergencyCare = emergencyVal.isEmpty ||
        emergencyVal == "true" ||
        emergencyVal == "yes" ||
        emergencyVal == "1";

    final maternityVal = getValue("hasMaternityServices", 12).toLowerCase();
    final bool hasMaternityServices = maternityVal.isEmpty ||
        maternityVal == "true" ||
        maternityVal == "yes" ||
        maternityVal == "1";

    final currentUid =
        FirebaseReference.firebaseAuth.currentUser?.uid ?? "ADMIN-PORTAL";

    return {
      "name": name,
      "type": type.isNotEmpty ? type : "Health Center",
      "phoneNumber": phone,
      "email": email,
      "address": address,
      "district": district,
      "stateValue": state,
      "countryValue": country.isNotEmpty ? country : "🇳🇬 Nigeria",
      "latitude": lat,
      "longitude": lng,
      "location": GeoPoint(lat, lng),
      "status": status,
      "hasEmergencyCare": hasEmergencyCare,
      "hasMaternityServices": hasMaternityServices,
      "submittedBy": currentUid,
      "createdAt": FieldValue.serverTimestamp(),
      "submittedAt": FieldValue.serverTimestamp(),
      "verifiedAt": status ? FieldValue.serverTimestamp() : null,
    };
  }

  List<List<String>> _parseCsvString(String csvContent) {
    final List<List<String>> rows = [];
    List<String> currentCell = [];
    final StringBuffer sb = StringBuffer();
    bool insideQuotes = false;

    for (int i = 0; i < csvContent.length; i++) {
      final String char = csvContent[i];

      if (char == '"') {
        if (insideQuotes &&
            i + 1 < csvContent.length &&
            csvContent[i + 1] == '"') {
          sb.write('"');
          i++;
        } else {
          insideQuotes = !insideQuotes;
        }
      } else if (char == ',' && !insideQuotes) {
        currentCell.add(sb.toString().trim());
        sb.clear();
      } else if ((char == '\n' || char == '\r') && !insideQuotes) {
        if (char == '\r' &&
            i + 1 < csvContent.length &&
            csvContent[i + 1] == '\n') {
          i++;
        }
        currentCell.add(sb.toString().trim());
        sb.clear();
        if (currentCell.any((c) => c.isNotEmpty)) {
          rows.add(List.from(currentCell));
        }
        currentCell.clear();
      } else {
        sb.write(char);
      }
    }

    if (sb.isNotEmpty || currentCell.isNotEmpty) {
      currentCell.add(sb.toString().trim());
      if (currentCell.any((c) => c.isNotEmpty)) {
        rows.add(currentCell);
      }
    }

    return rows;
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

      await FirebaseReference.hospitals.add(hospitalData);

      if (context.mounted) {
        AppToast.success(
          "Hospital successfully registered!",
          title: "Hospital Added",
          context: context,
        );
        context.goNamed(RouteHelpers.adminHospitals);
      }
    } catch (e) {
      if (context.mounted) {
        FirebaseError.handle(
          e,
          title: "Failed to Add Hospital",
          context: context,
        );
      }
    } finally {
      isSubmitting = false;
      update();
    }
  }
}
