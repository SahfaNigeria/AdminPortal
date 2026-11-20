import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';

enum AnimatedTextType {
  typewriter,
  fade,
  scale,
  rotate,
  wavy,
  flicker,
  colorize,
}

class CustomAnimatedTextWidget extends StatelessWidget {
  final String? text;
  final List<String>? texts;
  final AnimatedTextType type;
  final TextStyle? style;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign textAlign;
  final Duration? speed;
  final Duration? pause;
  final bool repeatForever;
  final bool isRepeatingAnimation;
  final int totalRepeatCount;
  final List<Color>? colorizeColors;
  final VoidCallback? onTap;
  final VoidCallback? onFinished;
  final void Function(int, bool)? onNext;
  final void Function(int, bool)? onNextBefore;

  const CustomAnimatedTextWidget({
    Key? key,
    this.text,
    this.texts,
    this.type = AnimatedTextType.typewriter,
    this.style,
    this.color,
    this.size,
    this.fontWeight,
    this.fontFamily = "Poppins",
    this.textAlign = TextAlign.start,
    this.speed,
    this.pause,
    this.repeatForever = true,
    this.isRepeatingAnimation = true,
    this.totalRepeatCount = 3,
    this.colorizeColors,
    this.onTap,
    this.onFinished,
    this.onNext,
    this.onNextBefore,
  }) : super(key: key);

  List<String> get _effectiveTexts {
    if (texts != null && texts!.isNotEmpty) {
      return texts!;
    }
    if (text != null && text!.isNotEmpty) {
      return [text!];
    }
    return ["Animated Text"];
  }

  TextStyle _getEffectiveTextStyle() {
    if (style != null) return style!;
    final Color effectiveColor = color ?? AppColors.textPrimary;
    final double effectiveSize = size ?? 20;
    final FontWeight effectiveFontWeight = fontWeight ?? FontWeight.bold;

    if (fontFamily != null && fontFamily!.isNotEmpty) {
      return GoogleFonts.getFont(
        fontFamily!,
        color: effectiveColor,
        fontWeight: effectiveFontWeight,
        fontSize: effectiveSize,
      );
    }
    return TextStyle(
      color: effectiveColor,
      fontWeight: effectiveFontWeight,
      fontSize: effectiveSize,
    );
  }

  List<AnimatedText> _buildAnimatedTexts(TextStyle effectiveStyle) {
    final List<String> textList = _effectiveTexts;
    final Duration effectiveSpeed = speed ?? const Duration(milliseconds: 100);

    final List<Color> effectiveColorizeColors = colorizeColors ??
        [
          AppColors.primary,
          const Color(0xFFEC4899),
          const Color(0xFF0EA5E9),
          const Color(0xFF10B981),
        ];

    switch (type) {
      case AnimatedTextType.typewriter:
        return textList
            .map(
              (t) => TypewriterAnimatedText(
                t,
                textStyle: effectiveStyle,
                textAlign: textAlign,
                speed: effectiveSpeed,
              ),
            )
            .toList();

      case AnimatedTextType.fade:
        return textList
            .map(
              (t) => FadeAnimatedText(
                t,
                textStyle: effectiveStyle,
                textAlign: textAlign,
                duration: effectiveSpeed * 10,
              ),
            )
            .toList();

      case AnimatedTextType.scale:
        return textList
            .map(
              (t) => ScaleAnimatedText(
                t,
                textStyle: effectiveStyle,
                textAlign: textAlign,
                duration: effectiveSpeed * 10,
              ),
            )
            .toList();

      case AnimatedTextType.rotate:
        return textList
            .map(
              (t) => RotateAnimatedText(
                t,
                textStyle: effectiveStyle,
                textAlign: textAlign,
                duration: effectiveSpeed * 10,
              ),
            )
            .toList();

      case AnimatedTextType.wavy:
        return textList
            .map(
              (t) => WavyAnimatedText(
                t,
                textStyle: effectiveStyle,
                textAlign: textAlign,
                speed: effectiveSpeed,
              ),
            )
            .toList();

      case AnimatedTextType.flicker:
        return textList
            .map(
              (t) => FlickerAnimatedText(
                t,
                textStyle: effectiveStyle,
                textAlign: textAlign,
                speed: effectiveSpeed,
              ),
            )
            .toList();

      case AnimatedTextType.colorize:
        return textList
            .map(
              (t) => ColorizeAnimatedText(
                t,
                textStyle: effectiveStyle,
                textAlign: textAlign,
                colors: effectiveColorizeColors,
                speed: effectiveSpeed * 2,
              ),
            )
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle effectiveStyle = _getEffectiveTextStyle();
    final List<AnimatedText> animatedTexts =
        _buildAnimatedTexts(effectiveStyle);

    return AnimatedTextKit(
      animatedTexts: animatedTexts,
      repeatForever: repeatForever,
      isRepeatingAnimation: isRepeatingAnimation,
      totalRepeatCount: totalRepeatCount,
      pause: pause ?? const Duration(milliseconds: 1000),
      onTap: onTap,
      onFinished: onFinished,
      onNext: onNext,
    );
  }
}
