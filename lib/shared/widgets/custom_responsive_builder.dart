import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, SizingInformation) builder;

  final ScreenBreakpoints? breakpoints;
  const CustomResponsiveBuilder({Key? key, required this.builder, this.breakpoints = const ScreenBreakpoints(
    desktop: 1024,
    tablet: 1280,
    watch: 10,
  ) })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: builder,
      breakpoints: breakpoints,
    );
  }
}
