import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import '../widgets/app_text.dart';


enum ToastType {
  success,
  error,
  info,
  warning,
}

/// A modern, reusable, easy-to-use Toast notification utility for the Admin Portal.
class AppToast {
  /// Displays a custom toast notification on the screen.
  ///
  /// Automatically uses [Get.context] if [context] is not provided.
  static void show({
    required String message,
    String? title,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    BuildContext? context,
    VoidCallback? onTap,
  }) {
    final BuildContext? targetContext = context ?? Get.context;
    if (targetContext == null) return;

    final ToastConfig config = _getToastConfig(type);

    ScaffoldMessenger.of(targetContext).hideCurrentSnackBar();
    ScaffoldMessenger.of(targetContext).showSnackBar(
      SnackBar(
        duration: duration,
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        content: CustomToastWidget(
          title: title,
          message: message,
          icon: config.icon,
          backgroundColor: config.backgroundColor,
          borderColor: config.borderColor,
          iconColor: config.iconColor,
          textColor: config.textColor,
          onTap: onTap,
        ),
      ),
    );
  }

  /// Displays a Success Toast
  static void success(
    String message, {
    String? title = "Success",
    Duration duration = const Duration(seconds: 3),
    BuildContext? context,
  }) {
    show(
      message: message,
      title: title,
      type: ToastType.success,
      duration: duration,
      context: context,
    );
  }

  /// Displays an Error Toast
  static void error(
    String message, {
    String? title = "Error",
    Duration duration = const Duration(seconds: 4),
    BuildContext? context,
  }) {
    show(
      message: message,
      title: title,
      type: ToastType.error,
      duration: duration,
      context: context,
    );
  }

  /// Displays an Information Toast
  static void info(
    String message, {
    String? title = "Notice",
    Duration duration = const Duration(seconds: 3),
    BuildContext? context,
  }) {
    show(
      message: message,
      title: title,
      type: ToastType.info,
      duration: duration,
      context: context,
    );
  }

  /// Displays a Warning Toast
  static void warning(
    String message, {
    String? title = "Warning",
    Duration duration = const Duration(seconds: 3),
    BuildContext? context,
  }) {
    show(
      message: message,
      title: title,
      type: ToastType.warning,
      duration: duration,
      context: context,
    );
  }

  static ToastConfig _getToastConfig(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const ToastConfig(
          icon: FontAwesomeIcons.circleCheck,
          backgroundColor: Color(0xFFE8F5E9),
          borderColor: Color(0xFF81C784),
          iconColor: Color(0xFF2E7D32),
          textColor: Color(0xFF1B5E20),
        );
      case ToastType.error:
        return const ToastConfig(
          icon: FontAwesomeIcons.circleXmark,
          backgroundColor: Color(0xFFFDE8E8),
          borderColor: Color(0xFFE57373),
          iconColor: AppColors.primary,
          textColor: Color(0xFFB71C1C),
        );
      case ToastType.warning:
        return const ToastConfig(
          icon: FontAwesomeIcons.triangleExclamation,
          backgroundColor: Color(0xFFFFF8E1),
          borderColor: Color(0xFFFFD54F),
          iconColor: Color(0xFFED6C02),
          textColor: Color(0xFFE65100),
        );
      case ToastType.info:
        return const ToastConfig(
          icon: FontAwesomeIcons.circleInfo,
          backgroundColor: Color(0xFFE3F2FD),
          borderColor: Color(0xFF64B5F6),
          iconColor: Color(0xFF0288D1),
          textColor: Color(0xFF01579B),
        );
    }
  }
}

class ToastConfig {
  final dynamic icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;

  const ToastConfig({
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
  });
}

/// Modern floating card toast widget.
class CustomToastWidget extends StatelessWidget {
  final String? title;
  final String message;
  final dynamic icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final VoidCallback? onTap;

  const CustomToastWidget({
    Key? key,
    this.title,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: icon is IconData
                  ? Icon(
                      icon as IconData,
                      size: 16,
                      color: iconColor,
                    )
                  : FaIcon(
                      icon,
                      size: 16,
                      color: iconColor,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null && title!.isNotEmpty) ...[
                    AppText(
                      text: title!,
                      size: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                    const SizedBox(height: 2),
                  ],
                  AppText(
                    text: message,
                    size: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor.withValues(alpha: 0.9),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
