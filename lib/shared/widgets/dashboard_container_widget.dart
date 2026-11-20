import 'package:material_ui/material_ui.dart';

class DashboardContainerWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Decoration? decoration;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final Color? color;
  const DashboardContainerWidget({Key? key, this.child, this.padding, this.borderRadius, this.decoration, this.boxShadow, this.border, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding??EdgeInsets.all(20),
      child: child,
      decoration: decoration??BoxDecoration(
        color: color??Colors.white,
        borderRadius: borderRadius??BorderRadius.circular(18),
        border: border??Border.all(
          color: Colors.grey.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow:boxShadow?? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),


    );
  }
}
