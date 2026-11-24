import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/firebase/firebase_reference.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/model/admin_model.dart';
import '../../shared/utils/firebase_error.dart';
import '../../shared/utils/toast.dart';

class AdminProfileController extends GetxController {
  late final FlutterSecureStorage _storage;

  late TextEditingController usernameController;
  late TextEditingController emailController;

  final GlobalKey<FormState> profileFormStateKey = GlobalKey<FormState>();

  final adminModel = Rxn<AdminModel>();
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isUploadingImage = false.obs;

  final selectedImageBytes = Rxn<Uint8List>();
  final selectedImageName = RxnString();
  final selectedImageContentType = RxnString();

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _adminSubscription;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    _storage = Get.isRegistered<FlutterSecureStorage>()
        ? Get.find<FlutterSecureStorage>()
        : const FlutterSecureStorage();

    usernameController = TextEditingController();
    emailController = TextEditingController();
    super.onInit();
    listenToAdminProfile();
  }

  void listenToAdminProfile() async {
    try {
      isLoading.value = true;
      String? adminId = await _storage.read(key: AppConstants.adminIdKey);
      adminId ??= FirebaseReference.firebaseAuth.currentUser?.uid;

      if (adminId == null || adminId.isEmpty) {
        isLoading.value = false;
        AppToast.error("Admin session not found. Please log in again.");
        return;
      }

      _adminSubscription?.cancel();
      _adminSubscription =
          FirebaseReference.admins.doc(adminId).snapshots().listen(
        (snapshot) {
          isLoading.value = false;
          if (snapshot.exists && snapshot.data() != null) {
            final model = AdminModel.fromMap(snapshot.data()!, id: snapshot.id);
            adminModel.value = model;

            // Sync form controllers if user is not saving
            if (!isSaving.value) {
              usernameController.text = model.username;
              emailController.text = model.email;
            }
          }
        },
        onError: (error) {
          isLoading.value = false;
          FirebaseError.handle(error);
        },
      );
    } catch (e) {
      isLoading.value = false;
      log("Error initializing admin profile: $e");
    }
  }

  Future<void> pickProfileImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        selectedImageBytes.value = bytes;
        selectedImageName.value = pickedFile.name;
        selectedImageContentType.value =
            _imageContentType(pickedFile.mimeType, pickedFile.name);
        AppToast.info(
            "New profile image selected. Click 'Save Profile' to apply changes.");
      }
    } catch (e) {
      log("Error picking profile image: $e");
      AppToast.error("Failed to select image from gallery");
    }
  }

  void removeSelectedImage() {
    selectedImageBytes.value = null;
    selectedImageName.value = null;
    selectedImageContentType.value = null;
  }

  Future<void> updateProfile() async {
    if (profileFormStateKey.currentState != null &&
        !profileFormStateKey.currentState!.validate()) {
      return;
    }

    final currentAdmin = adminModel.value;
    final adminId =
        currentAdmin?.id ?? FirebaseReference.firebaseAuth.currentUser?.uid;

    if (adminId == null || adminId.isEmpty) {
      AppToast.error("Admin session invalid");
      return;
    }

    try {
      isSaving.value = true;
      String? photoUrl = currentAdmin?.displayPhoto;

      // Upload selected image if present
      if (selectedImageBytes.value != null) {
        isUploadingImage.value = true;
        final contentType = selectedImageContentType.value ?? 'image/jpeg';
        final extension = _imageExtension(contentType);
        final storageRef = FirebaseReference.storage.ref().child(
              'admins/profile_photos/${adminId}_${DateTime.now().millisecondsSinceEpoch}.$extension',
            );

        final uploadTask = await storageRef.putData(
          selectedImageBytes.value!,
          SettableMetadata(contentType: contentType),
        );
        photoUrl = await uploadTask.ref.getDownloadURL();
        isUploadingImage.value = false;
      }

      final updatedUsername = usernameController.text.trim();
      final updatedEmail = emailController.text.trim();

      final Map<String, dynamic> updateData = {
        'username': updatedUsername,
        'email': updatedEmail,
        if (photoUrl != null) 'displayPhoto': photoUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await FirebaseReference.admins.doc(adminId).update(updateData);

      // Update Firebase Auth user profile
      final currentUser = FirebaseReference.firebaseAuth.currentUser;
      if (currentUser != null) {
        if (updatedUsername.isNotEmpty &&
            currentUser.displayName != updatedUsername) {
          await currentUser.updateDisplayName(updatedUsername);
        }
        if (photoUrl != null &&
            photoUrl.isNotEmpty &&
            currentUser.photoURL != photoUrl) {
          await currentUser.updatePhotoURL(photoUrl);
        }
      }

      selectedImageBytes.value = null;
      selectedImageName.value = null;
      selectedImageContentType.value = null;
      isSaving.value = false;

      AppToast.success("Profile updated successfully!");
    } catch (e) {
      isSaving.value = false;
      isUploadingImage.value = false;
      log("Update Profile Error: $e");
      FirebaseError.handle(e);
    }
  }

  String _imageContentType(String? mimeType, String fileName) {
    if (mimeType != null && mimeType.startsWith('image/')) return mimeType;

    switch (fileName.split('.').last.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'heic':
        return 'image/heic';
      case 'heif':
        return 'image/heif';
      default:
        return 'image/jpeg';
    }
  }

  String _imageExtension(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'image/png':
        return 'png';
      case 'image/webp':
        return 'webp';
      case 'image/gif':
        return 'gif';
      case 'image/heic':
        return 'heic';
      case 'image/heif':
        return 'heif';
      default:
        return 'jpg';
    }
  }

  @override
  void onClose() {
    _adminSubscription?.cancel();
    usernameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
