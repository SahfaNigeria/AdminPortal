import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import 'app_text.dart';

class CustomListTileWidget extends StatelessWidget {
  final String? text;
  final double? textSize;
  final void Function()? onTap;
  final double? iconSize;
  final FaIconData? iconData;
  final Widget? widget;
  final Widget? trailing;
  final bool enabled;
  final bool? selected;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? title;
  final BorderRadius? borderRadius;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeTileColor;

  const CustomListTileWidget({
    Key? key,
    this.text,
    this.textSize,
    this.iconData,
    this.widget,
    this.iconSize,
    this.onTap,
    this.title,
    this.enabled = false,
    this.selected,
    this.trailing,
    this.contentPadding,
    this.borderRadius,
    this.activeColor,
    this.inactiveColor,
    this.activeTileColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool active = selected ?? enabled;
    final Color primaryColor = activeColor ?? AppColors.primary;
    final Color secondaryColor = inactiveColor ?? AppColors.textSecondary;
    final double effectiveTextSize = textSize ?? 12;
    final double effectiveIconSize = iconSize ?? 14;
    final BorderRadius effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: active
              ? (activeTileColor ?? primaryColor.withValues(alpha: 0.10))
              : Colors.transparent,
          borderRadius: effectiveBorderRadius,
          border: active
              ? Border.all(
                  color: primaryColor.withValues(alpha: 0.25),
                  width: 1,
                )
              : Border.all(color: Colors.transparent, width: 1),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: effectiveBorderRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveBorderRadius,
            splashColor: primaryColor.withValues(alpha: 0.15),
            highlightColor: primaryColor.withValues(alpha: 0.08),
            child: Padding(
              padding: contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  // Active Left Pill Indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: active ? 4 : 0,
                    height: active ? 22 : 0,
                    decoration: BoxDecoration(
                      color: active ? primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  if (active) const SizedBox(width: 10),

                  // Leading Icon or Custom Widget
                  if (widget != null)
                    widget!
                  else if (iconData != null)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: active
                            ? primaryColor.withValues(alpha: 0.15)
                            : Colors.grey.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FaIcon(
                        iconData,
                        size: effectiveIconSize,
                        color: active ? primaryColor : secondaryColor,
                      ),
                    ),

                  const SizedBox(width: 12),

                  // Title Text
                  Expanded(
                    child: title ??
                        AppText(
                          text: text ?? "Analytics",
                          color: active ? primaryColor : secondaryColor,
                          size: effectiveTextSize,
                          fontWeight:
                              active ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),

                  // Trailing Widget or Active Dot Indicator
                  if (trailing != null)
                    trailing!
                  else if (active)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
