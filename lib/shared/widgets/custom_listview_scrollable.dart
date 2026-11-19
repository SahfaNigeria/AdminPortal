import 'package:material_ui/material_ui.dart';

class CustomListViewScrollable extends StatelessWidget {
  final ScrollController? controller;
  final List<Widget> children;
  final bool shrinkWrap;
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;

  final
  ScrollPhysics? physics;

  final Axis scrollDirection;
  final EdgeInsets? padding;
  const CustomListViewScrollable(
      {Key? key,
        this.controller,
        this.padding = EdgeInsets.zero,
        required this.children,
        this.scrollDirection = Axis.vertical,
        this.shrinkWrap = false, this.physics, this.keyboardDismissBehavior})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding,
      shrinkWrap: shrinkWrap,
      keyboardDismissBehavior: keyboardDismissBehavior??ScrollViewKeyboardDismissBehavior.onDrag,
      physics: physics?? BouncingScrollPhysics(),
      controller: controller,
      scrollDirection: scrollDirection,
      children: children,
    );
  }
}
