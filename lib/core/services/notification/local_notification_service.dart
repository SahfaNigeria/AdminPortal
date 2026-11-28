// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:js_notifications/core/core.dart';
// import 'package:js_notifications/interop/interop.dart';
// import 'package:js_notifications/js_notifications.dart';
//
// /// Service for handling HTML5 Web Notifications using `js_notifications` package.
// class LocalNotificationService {
//   static final LocalNotificationService _instance =
//       LocalNotificationService._internal();
//
//   /// Singleton instance of [LocalNotificationService].
//   static LocalNotificationService get instance => _instance;
//
//   factory LocalNotificationService() => _instance;
//
//   LocalNotificationService._internal();
//
//   bool _isInitialized = false;
//
//   /// Whether the notification service worker is initialized.
//   bool get isInitialized => _isInitialized;
//
//   /// Check if notifications are supported on the current browser.
//   bool get isSupported => kIsWeb && JsNotifications.instance.isSupported;
//
//   /// Check if notification permissions are currently granted.
//   bool get hasPermission => kIsWeb && JsNotifications.instance.hasPermissions;
//
//   /// Initialize the notification service worker.
//   Future<bool> initialize() async {
//     if (!kIsWeb) {
//       debugPrint('[LocalNotificationService] Not running on Web platform.');
//       return false;
//     }
//
//     if (_isInitialized) return true;
//
//     try {
//       _isInitialized = await JsNotifications.instance.initialize();
//       debugPrint('[LocalNotificationService] Initialized: $_isInitialized');
//       return _isInitialized;
//     } catch (e) {
//       debugPrint('[LocalNotificationService] Initialization error: $e');
//       return false;
//     }
//   }
//
//   /// Request notification permissions from the browser.
//   Future<bool> requestPermission() async {
//     if (!kIsWeb) return false;
//
//     if (!isSupported) {
//       debugPrint(
//           '[LocalNotificationService] Web notifications are not supported in this browser.');
//       return false;
//     }
//
//     try {
//       final granted = await JsNotifications.instance.requestPermissions();
//       debugPrint('[LocalNotificationService] Permission granted: $granted');
//       return granted;
//     } catch (e) {
//       debugPrint('[LocalNotificationService] Error requesting permission: $e');
//       return false;
//     }
//   }
//
//   /// Ensures service is initialized and permission is granted before showing notifications.
//   Future<bool> _ensurePermissionAndInitialized() async {
//     if (!kIsWeb) return false;
//
//     if (!_isInitialized) {
//       await initialize();
//     }
//
//     if (!hasPermission) {
//       final granted = await requestPermission();
//       if (!granted) {
//         debugPrint(
//             '[LocalNotificationService] Cannot show notification: permission denied.');
//         return false;
//       }
//     }
//     return true;
//   }
//
//   /// Base function to display a browser notification with full customization.
//   Future<void> showNotification({
//     required String title,
//     String? body,
//     String? icon,
//     String? image,
//     String? badge,
//     String? tag,
//     Map<String, dynamic>? data,
//     List<JSNotificationAction>? actions,
//     JSNotificationDirection? dir,
//     bool requireInteraction = false,
//     bool renotify = false,
//     bool silent = false,
//   }) async {
//     final ready = await _ensurePermissionAndInitialized();
//     if (!ready) return;
//
//     try {
//       await JsNotifications.instance.showNotification(
//         title,
//         body: body,
//         icon: icon,
//         image: image,
//         badge: badge,
//         tag: tag,
//         data: data,
//         actions: actions,
//         dir: dir,
//         requireInteraction: requireInteraction,
//         renotify: renotify,
//         silent: silent,
//       );
//     } catch (e) {
//       debugPrint('[LocalNotificationService] Failed to show notification: $e');
//     }
//   }
//
//   // ===========================================================================
//   // REUSABLE NOTIFICATION FUNCTIONS
//   // ===========================================================================
//
//   /// Show a **Success** web notification.
//   Future<void> showSuccess({
//     required String title,
//     String? body,
//     String? icon,
//     String? tag,
//     Map<String, dynamic>? data,
//   }) async {
//     await showNotification(
//       title: title,
//       body: body,
//       icon: icon ?? 'assets/images/success_icon.png',
//       tag: tag ?? 'success_notification',
//       data: data ?? {'type': 'success'},
//     );
//   }
//
//   /// Show an **Error** web notification (requires interaction so it stays on screen).
//   Future<void> showError({
//     required String title,
//     String? body,
//     String? icon,
//     String? tag,
//     Map<String, dynamic>? data,
//   }) async {
//     await showNotification(
//       title: title,
//       body: body,
//       icon: icon ?? 'assets/images/error_icon.png',
//       tag: tag ?? 'error_notification',
//       requireInteraction: true,
//       data: data ?? {'type': 'error'},
//     );
//   }
//
//   /// Show an **Info** web notification.
//   Future<void> showInfo({
//     required String title,
//     String? body,
//     String? icon,
//     String? tag,
//     Map<String, dynamic>? data,
//   }) async {
//     await showNotification(
//       title: title,
//       body: body,
//       icon: icon ?? 'assets/images/info_icon.png',
//       tag: tag ?? 'info_notification',
//       data: data ?? {'type': 'info'},
//     );
//   }
//
//   /// Show a **Warning** web notification.
//   Future<void> showWarning({
//     required String title,
//     String? body,
//     String? icon,
//     String? tag,
//     Map<String, dynamic>? data,
//   }) async {
//     await showNotification(
//       title: title,
//       body: body,
//       icon: icon ?? 'assets/images/warning_icon.png',
//       tag: tag ?? 'warning_notification',
//       requireInteraction: true,
//       data: data ?? {'type': 'warning'},
//     );
//   }
//
//   /// Show an **Interactive** web notification with action buttons.
//   Future<void> showInteractive({
//     required String title,
//     String? body,
//     required List<JSNotificationAction> actions,
//     String? icon,
//     String? tag,
//     Map<String, dynamic>? data,
//     bool requireInteraction = true,
//   }) async {
//     await showNotification(
//       title: title,
//       body: body,
//       actions: actions,
//       icon: icon,
//       tag: tag ?? 'interactive_notification',
//       requireInteraction: requireInteraction,
//       data: data ?? {'type': 'interactive'},
//     );
//   }
//
//   /// Show a **Rich Media** web notification with large image preview.
//   Future<void> showRichMedia({
//     required String title,
//     required String body,
//     required String image,
//     String? icon,
//     String? badge,
//     String? tag,
//     Map<String, dynamic>? data,
//   }) async {
//     await showNotification(
//       title: title,
//       body: body,
//       image: image,
//       icon: icon,
//       badge: badge,
//       tag: tag ?? 'rich_media_notification',
//       data: data ?? {'type': 'rich_media'},
//     );
//   }
//
//   // ===========================================================================
//   // DISMISSAL & CLEANUP
//   // ===========================================================================
//
//   /// Dismiss a specific notification by tag or ID.
//   Future<void> dismiss(String id) async {
//     if (!kIsWeb) return;
//     try {
//       await JsNotifications.instance.dismissNotification(id: id);
//     } catch (e) {
//       debugPrint('[LocalNotificationService] Error dismissing notification: $e');
//     }
//   }
//
//   /// Clear all active web notifications.
//   Future<void> clearAll() async {
//     if (!kIsWeb) return;
//     try {
//       await JsNotifications.instance.clearNotifications();
//     } catch (e) {
//       debugPrint('[LocalNotificationService] Error clearing notifications: $e');
//     }
//   }
//
//   // ===========================================================================
//   // EVENT STREAMS & LISTENERS
//   // ===========================================================================
//
//   /// Stream of notification tap (click) events.
//   Stream<NotificationActionResult>? get onTapStream =>
//       kIsWeb ? JsNotifications.instance.tapStream : null;
//
//   /// Stream of notification action button click events.
//   Stream<NotificationActionResult>? get onActionStream =>
//       kIsWeb ? JsNotifications.instance.actionStream : null;
//
//   /// Stream of notification dismiss events.
//   Stream<NotificationActionResult>? get onDismissStream =>
//       kIsWeb ? JsNotifications.instance.dismissStream : null;
//
//   /// Listen to notification tap events.
//   StreamSubscription<NotificationActionResult>? listenToTap(
//     void Function(NotificationActionResult result) onTap,
//   ) {
//     return onTapStream?.listen(onTap);
//   }
//
//   /// Listen to notification action button click events.
//   StreamSubscription<NotificationActionResult>? listenToAction(
//     void Function(NotificationActionResult result) onAction,
//   ) {
//     return onActionStream?.listen(onAction);
//   }
//
//   /// Listen to notification dismiss events.
//   StreamSubscription<NotificationActionResult>? listenToDismiss(
//     void Function(NotificationActionResult result) onDismiss,
//   ) {
//     return onDismissStream?.listen(onDismiss);
//   }
// }
