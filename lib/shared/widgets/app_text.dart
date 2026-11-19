import 'package:auto_size_text/auto_size_text.dart';
import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? height;
  final List<Shadow>? shadows;
  final TextDecoration? decoration;

  final  TextOverflow textOverflow;

  final FontWeight? fontWeight;

  final String? fontFamily;

  final double? letterSpacing;

  final TextAlign? textAlign;

  final Color? decorationColor;
  final int? maxLines;

  final bool? softWrap;

  final TextStyle? style;

  final FontStyle? fontStyle;

  final double size;

  const AppText({
    Key? key,
    required this.text,
    this.color = const Color(0xFF000000),
    this.fontWeight = FontWeight.w400,
    this.size = 0,
    this.decoration,
    this.maxLines = 3,
    this.decorationColor,
    this.textOverflow = TextOverflow.ellipsis,
    this.textAlign,
    this.letterSpacing,
    this.height,
    this.fontStyle,
    this.softWrap,
    this.fontFamily = "Poppins",
    this.style, this.shadows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      maxLines: maxLines,
      overflow: textOverflow,

      textAlign: textAlign,
      softWrap: softWrap,
      style:  style ??
          (fontFamily != null && fontFamily!.isNotEmpty
              ? GoogleFonts.getFont(
            fontFamily!,
            color: color,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            fontSize: size == 0 ? 12 : size,
            letterSpacing: letterSpacing,
            height: height,
            decoration: decoration,
            decorationColor: decorationColor,
            shadows: shadows,
          )
              : TextStyle(
            color: color,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            fontSize: size == 0 ? 12 : size,
            letterSpacing: letterSpacing,
            height: height,
            decoration: decoration,
            decorationColor: decorationColor,
            shadows: shadows,
          )) ,
    );
  }
}
