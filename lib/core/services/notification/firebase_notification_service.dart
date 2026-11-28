import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:jambomama_nigeria_admin_portal/shared/constants/app_constants.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/toast.dart';

class FirebaseNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? fid;
  static String? get fidValue =>  fid;

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
      if (kReleaseMode) {
        final messaging = FirebaseMessaging.instance;

        // Listen before registering because FID arrives asynchronously.
        final fidFuture = messaging.onRegistered.first;

        await messaging.register(
          vapidKey: AppConstants.vapidKey,
          serviceWorkerScriptPath: 'firebase-messaging-sw.js',
        );

        final fid = await fidFuture.timeout(
          const Duration(seconds: 30),
        );

        log('Retrieved FID: $fid');

        return fid;
      }else{
        return await Future.value("Debug");
      }
    } catch (e, stackTrace) {
      log('Failed to retrieve FID: $e');
      log(stackTrace.toString());
      return null;
    }
  }


  // static Future<void> initialize() async {
  //   try {
  //     final messaging = FirebaseMessaging.instance;
  //
  //     final bool supported = await messaging.isSupported();
  //
  //     if (supported) {
  //       log('Firebase Messaging is not supported by this browser.');
  //       return;
  //     }
  //
  //     messaging.onRegistered.listen(
  //           (String fid) {
  //         log('Firebase Installation ID: $fid');
  //
  //         // Save FID to Firestore here.
  //       },
  //       onError: (error) {
  //         log('FCM registration stream error: $error');
  //       },
  //     );
  //
  //     await messaging.register(
  //       vapidKey: AppConstants.vapidKey,
  //       serviceWorkerScriptPath: 'firebase-messaging-sw.js',
  //     );
  //
  //     log('Firebase Messaging registration completed.');
  //   } catch (e, stackTrace) {
  //     log('Firebase Messaging error: $e');
  //     log(stackTrace.toString());
  //   }
  // }

  static Future<void> initialize() async {
    final permissionGranted = await requestFcmPermission();

    if (!permissionGranted) return;

    final installationId = await getInstallationId();


    if (installationId != null) {

      fid = installationId;
    } else {
      log("No Device FID");
    };

    log("Device registered successfully");

// Save installationId to Firestore here.
  }


}
