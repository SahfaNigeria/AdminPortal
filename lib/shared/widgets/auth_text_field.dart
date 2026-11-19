import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text_field.dart';

class AuthTextField extends StatelessWidget {
  final String? Function(String?)? validator;
  final String fieldTitle;
  final EdgeInsetsGeometry? margin;
  final Widget? prefix;

  final Widget? suffix;

  final bool obscureText;
  final void Function(String?)? onSaved;
  final bool readOnly;
  final void Function()? onTap;
  final TextEditingController? controller;
  final String? initialValue;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  const AuthTextField({
    Key? key,
    this.validator,
    this.margin,
    this.controller,
    this.inputFormatters,
    this.onSaved,
    this.initialValue,
    this.fieldTitle = "no title",
    this.fillColor,
    this.readOnly = false,
    this.onTap,
    this.prefix,
    this.suffix,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: fieldTitle.toUpperCase(),
          size: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        SizedBox(
          height: 5,
        ),
        AppTextField(
          fillColor: fillColor ?? AppColors.surface,
          validator: validator,
          readOnly: readOnly,
          prefix: prefix,
          suffix: suffix,
          obscureText: obscureText,
          enabled: true,
          onTap: onTap,
          margin: margin,
          inputFormatters: inputFormatters,
          controller: controller,
          onSaved: onSaved,
          initialValue: initialValue,
        ),
      ],
    );
  }
}
