import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomBreakPoint extends StatelessWidget {
  final Widget? tablet;
  final Widget? desktop;
  final Widget mobile;

  final ScreenBreakpoints? breakpoints;
  const CustomBreakPoint({
    Key? key,
    this.tablet,
    this.desktop,
    required this.mobile,
    this.breakpoints = const ScreenBreakpoints(
      desktop: 1024,
      tablet: 768,
      watch: 10,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: breakpoints,
      mobile: (_) {
        return mobile;
      },
      desktop: (_) {
        return desktop??Container();
      },
      tablet: (_) {
        return tablet??desktop??SizedBox();
      },
    );
  }
}
