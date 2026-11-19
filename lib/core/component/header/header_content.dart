import '../../../shared/widgets/custom_break_point.dart';
import 'header_content_desktop.dart';
import 'header_content_mobile.dart';
import 'package:material_ui/material_ui.dart';

class HeaderContent extends StatelessWidget {
  final void Function()? onMenuPressed;
  const HeaderContent({Key? key, this.onMenuPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBreakPoint(
      mobile: HeaderContentMobile(onMenuPressed: onMenuPressed),
      desktop: const HeaderContentDesktop(),
      tablet: const HeaderContentDesktop(),
    );
  }
}
