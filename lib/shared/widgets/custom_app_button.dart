import 'package:material_ui/material_ui.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:scale_button/scale_button.dart' show ScaleButton;

class CustomAppButton extends StatelessWidget {
  final VoidCallback? onTap;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final Color? textColor;
  final String? title;
  final bool isDisabled;
  final bool isLoading;

  final Widget? child;
  final Color? progressColor;
  final Widget? pButton;
  const CustomAppButton(
      {Key? key,
      this.onTap,
      this.color,
      this.title,
      this.borderRadius,
      this.child,
      this.textColor,
      this.isLoading = false,
      this.isDisabled = false,
      this.pButton,
      this.progressColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isDisabled
        ? Container(
            decoration: BoxDecoration(
              color: color ?? AppColors.primary.withOpacity(0.7),
              borderRadius: borderRadius ?? BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: child ??
                Center(
                  child: AppText(
                    maxLines: 1,
                    text: title ?? "LOGIN",
                    color: textColor ?? AppColors.textPrimary,
                    size: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
          )
        : ScaleButton(
            onTap: isLoading ? () {} : onTap,
            child: pButton ??
                Container(
                  decoration: BoxDecoration(
                    color: color ?? AppColors.primary,
                    borderRadius: borderRadius ?? BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: child ??
                      Center(
                        child: isLoading
                            ? CustomCircularProgressIndicator(
                                height: 20,
                                color: progressColor ?? AppColors.surface,
                                width: 20,
                              )
                            : AppText(
                                maxLines: 1,
                                text: title ?? "LOGIN",
                                color: textColor ?? AppColors.surface,
                                size: 16,
                                fontWeight: FontWeight.w700,
                              ),
                      ),
                ),
          );
  }
}
