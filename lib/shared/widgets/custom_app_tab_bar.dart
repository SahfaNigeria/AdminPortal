import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import 'custom_indexed_stack.dart';

class CustomAppTabBar extends StatelessWidget {
  final TabController? controller;
  final List<SegmentTab> tabs;
  final List<Widget> tabChildren;

  final double? fontSize;
  final double? selectedFontSize;
  final EdgeInsets? tabPadding;
  final EdgeInsets? indicatorPadding;

  final BoxDecoration? barDecoration;
  final BoxDecoration? indicatorDecoration;

  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;

  final Color? selectedTabTextColor;
  final Color? tabTextColor;

  final double? height;
  final double? spacingBelow;
  final String? fontFamily;

  final ScrollPhysics? physics;

  const CustomAppTabBar({
    Key? key,
    this.controller,
    required this.tabs,
    required this.tabChildren,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.fontSize,
    this.selectedFontSize,
    this.tabPadding,
    this.indicatorPadding,
    this.selectedTextStyle,
    this.textStyle,
    this.selectedTabTextColor,
    this.tabTextColor,
    this.indicatorDecoration,
    this.barDecoration,
    this.height,
    this.spacingBelow,
    this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double defaultFontSize = fontSize ?? 14.0;
    final double defaultSelectedFontSize = selectedFontSize ?? defaultFontSize;

    final EdgeInsets defaultTabPadding = tabPadding ??
        const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 4,
        );

    final EdgeInsets defaultIndicatorPadding = indicatorPadding ??
        const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 4,
        );

    final Color defaultTabTextColor = tabTextColor ?? AppColors.textSecondary;
    final Color defaultSelectedTabTextColor =
        selectedTabTextColor ?? Colors.white;

    final TextStyle defaultTextStyle = textStyle ??
        (fontFamily != null && fontFamily!.isNotEmpty
            ? GoogleFonts.getFont(
                fontFamily!,
                fontSize: defaultFontSize,
                fontWeight: FontWeight.w500,
                color: defaultTabTextColor,
              )
            : GoogleFonts.poppins(
                fontSize: defaultFontSize,
                fontWeight: FontWeight.w500,
                color: defaultTabTextColor,
              ));

    final TextStyle defaultSelectedTextStyle = selectedTextStyle ??
        (fontFamily != null && fontFamily!.isNotEmpty
            ? GoogleFonts.getFont(
                fontFamily!,
                fontSize: defaultSelectedFontSize,
                fontWeight: FontWeight.w600,
                color: defaultSelectedTabTextColor,
              )
            : GoogleFonts.poppins(
                fontSize: defaultSelectedFontSize,
                fontWeight: FontWeight.w600,
                color: defaultSelectedTabTextColor,
              ));

    final BoxDecoration defaultBarDecoration = barDecoration ??
        BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        );

    final BoxDecoration defaultIndicatorDecoration = indicatorDecoration ??
        BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedTabControl(
          height: height ?? 50.0,
          tabPadding: defaultTabPadding,
          indicatorPadding: defaultIndicatorPadding,
          tabTextColor: defaultTabTextColor,
          controller: controller,
          selectedTabTextColor: defaultSelectedTabTextColor,
          barDecoration: defaultBarDecoration,
          textStyle: defaultTextStyle,
          selectedTextStyle: defaultSelectedTextStyle,
          indicatorDecoration: defaultIndicatorDecoration,
          tabs: tabs,
        ),
        SizedBox(height: spacingBelow ?? 20.0),
        Expanded(
          child: AnimatedBuilder(
            animation: controller!,
            builder: (context, child) {
              return CustomIndexedStack(
                index: controller!.index,
                children: tabChildren,
              );
            },
          ),
        ),
      ],
    );
  }
}
