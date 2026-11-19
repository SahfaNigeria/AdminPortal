import 'package:material_ui/material_ui.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double? width;
  final Color? color;
  final double? height;
  final bool isHourlyGlass;
  final double? strokeWidth;
  const CustomCircularProgressIndicator(
      {Key? key,
      this.width,
      this.height,
      this.color,
      this.strokeWidth,
      this.isHourlyGlass = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 20,
      height: height ?? 20,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 2.5,
        color: color ?? AppColors.surface,
      ),
    );
  }
}
