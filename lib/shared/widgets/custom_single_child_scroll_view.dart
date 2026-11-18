import 'package:flutter/material.dart';

class CustomSingleChildScrollView extends StatelessWidget {
  final ScrollPhysics? physics;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final bool? primary;

  final Color? indicatorColor;
  final Widget? child;
  final Axis? scrollDirection;

  const CustomSingleChildScrollView(
      {Key? key,
      this.physics,
      this.padding,
      this.controller,
      this.child,
      this.scrollDirection,
      this.indicatorColor,
      this.primary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            primary: primary,
            physics: physics ?? AlwaysScrollableScrollPhysics(),
            padding: padding ?? EdgeInsets.zero,
            controller: controller,
            scrollDirection: scrollDirection ?? Axis.vertical,
            child: child,
          );
  }
}
