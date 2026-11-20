import 'package:animated_digit/animated_digit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';

class CustomAnimatedDigitWidget extends StatelessWidget {
  final dynamic value;
  final TextStyle? textStyle;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final Duration? duration;
  final Curve? curve;
  final String? prefix;
  final String? suffix;
  final int? fractionDigits;
  final String? separateSymbol;
  final bool enableSeparator;
  final BoxDecoration? boxDecoration;
  final EdgeInsetsGeometry? padding;

  const CustomAnimatedDigitWidget({
    Key? key,
    required this.value,
    this.textStyle,
    this.color,
    this.size,
    this.fontWeight,
    this.fontFamily = "Poppins",
    this.duration,
    this.curve,
    this.prefix,
    this.suffix,
    this.fractionDigits,
    this.separateSymbol = ",",
    this.enableSeparator = true,
    this.boxDecoration,
    this.padding,
  }) : super(key: key);

  num _parseValue(dynamic val) {
    if (val is num) return val;
    if (val is String) {
      final cleanString = val.replaceAll(',', '').replaceAll(' ', '').trim();
      return num.tryParse(cleanString) ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final num numberValue = _parseValue(value);

    final TextStyle effectiveTextStyle = textStyle ??
        (fontFamily != null && fontFamily!.isNotEmpty
            ? GoogleFonts.getFont(
                fontFamily!,
                color: color ?? AppColors.textPrimary,
                fontWeight: fontWeight ?? FontWeight.bold,
                fontSize: size ?? 28,
              )
            : TextStyle(
                color: color ?? AppColors.textPrimary,
                fontWeight: fontWeight ?? FontWeight.bold,
                fontSize: size ?? 28,
              ));

    final child = AnimatedDigitWidget(
      value: numberValue,
      textStyle: effectiveTextStyle,
      duration: duration ?? const Duration(milliseconds: 500),
      curve: curve ?? Curves.easeInOut,
      prefix: prefix,
      suffix: suffix,
      fractionDigits: fractionDigits ?? 0,
      separateSymbol: separateSymbol ?? ",",
      enableSeparator: enableSeparator,
      boxDecoration: boxDecoration,
    );

    if (padding != null) {
      return Padding(
        padding: padding!,
        child: child,
      );
    }

    return child;
  }
}
