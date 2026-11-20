import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/custom_break_point.dart';
import 'admin_shell_desktop.dart';
import 'admin_shell_mobile.dart';

class AdminShell extends StatelessWidget {
  final Widget? shell;
  const AdminShell({Key? key, this.shell}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBreakPoint(
      mobile: AdminShellMobile(
        shell: shell,
      ),
      tablet: AdminShellDesktop(
        shell: shell,
      ),
      desktop: AdminShellDesktop(
        shell: shell,
      ),
    );
  }
}
