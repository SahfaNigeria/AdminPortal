import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';

class AppTextField extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Color? fillColor;
  final Widget? prefix;
  final Widget? suffix;

  final bool obscureText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final GestureTapCallback? onTap;
  final bool enabled;
  final bool readOnly;

  final String? initialValue;

  final String? fontFamily;
  const AppTextField({
    Key? key,
    this.margin,
    this.fontFamily = "Poppins",
    this.onSaved,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.initialValue,
    this.fillColor,
    this.onTap,
    this.enabled = false,
    this.readOnly = false,
    this.prefix,
    this.obscureText = false,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColors.primary,
      onSaved: onSaved,
      onTap: onTap,
      enabled: enabled,
      obscureText: obscureText,
      obscuringCharacter: "·",
      readOnly: readOnly,
      validator: validator,
      controller: controller,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        filled: true,
        prefix: prefix,
        suffix: suffix,
        fillColor: fillColor ?? AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorMaxLines: 1,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.0),
        ),
      ),
      style: GoogleFonts.getFont(
        fontFamily!,
        fontSize: obscureText ? 16 : 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
