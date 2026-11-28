import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jambomama_nigeria_admin_portal/shared/constants/app_constants.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/toast.dart';

class FirebaseNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static StreamSubscription<String>? _registrationSubscription;

  static Future<bool> requestFcmPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        provisional: false,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
      );

      final isGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;

      if (isGranted) {
        log("Notification permission granted");
        return true;
      }

      log("Notification permission not granted");

      AppToast.show(
        message: "Notification permission not granted",
      );

      return false;
    } catch (e) {
      log("Permission error: $e");
      return false;
    }
  }

  static Future<String?> getInstallationId() async {
    try {
      final installationIdFuture = _messaging.onRegistered.first;

      await _messaging.register(
        vapidKey:AppConstants.vapidKey,
      );

      final installationId = await installationIdFuture;

      log("Firebase Installation ID: $installationId");

      return installationId;
    } catch (e) {
      log("Notification registration error: $e");
      return null;
    }
  }

  static Future<void> initialize() async {
    final permissionGranted = await requestFcmPermission();

    if (!permissionGranted) return;

    final installationId = await getInstallationId();

    if (installationId == null) return;

    log("Device registered successfully");

// Save installationId to Firestore here.
  }
}
