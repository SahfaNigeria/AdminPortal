import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import 'app_text.dart';
import 'custom_animated_digit_widget.dart';

class StatisticsCardWidget extends StatelessWidget {
  final String title;
  final dynamic value;
  final String? subtitle;
  final FaIconData? icon;
  final Color? accentColor;
  final String? trendPercentage;
  final bool isTrendPositive;
  final String? digitPrefix;
  final String? digitSuffix;
  final int fractionDigits;
  final VoidCallback? onTap;

  const StatisticsCardWidget({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.accentColor,
    this.trendPercentage,
    this.isTrendPositive = true,
    this.digitPrefix,
    this.digitSuffix,
    this.fractionDigits = 0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color effectiveAccentColor = accentColor ?? AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: HoverAnimatedContainer(
        duration: const Duration(milliseconds: 200),
        cursor: SystemMouseCursors.click,
        transform: Matrix4.translationValues(0, 0, 0),
        hoverTransform: Matrix4.translationValues(0, -4, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        hoverDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: effectiveAccentColor.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: effectiveAccentColor.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Icon and Optional Trend Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: effectiveAccentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: FaIcon(
                    icon ?? FontAwesomeIcons.chartSimple,
                    size: 20,
                    color: effectiveAccentColor,
                  ),
                ),

                // Optional Trend Percentage Badge
                if (trendPercentage != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isTrendPositive
                          ? const Color(0xFF10B981).withValues(alpha: 0.12)
                          : const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          isTrendPositive
                              ? FontAwesomeIcons.arrowUp
                              : FontAwesomeIcons.arrowDown,
                          size: 10,
                          color: isTrendPositive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          text: trendPercentage!,
                          size: 11,
                          fontWeight: FontWeight.w600,
                          color: isTrendPositive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Animated Digit Value
            CustomAnimatedDigitWidget(
              value: value,
              size: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              prefix: digitPrefix,
              suffix: digitSuffix,
              fractionDigits: fractionDigits,
            ),

            const SizedBox(height: 4),

            // Title
            AppText(
              text: title,
              size: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),

            if (subtitle != null) ...[
              const SizedBox(height: 8),
              AppText(
                text: subtitle!,
                size: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
