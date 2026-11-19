import 'package:material_ui/material_ui.dart';
import '../../../shared/widgets/app_customized_bg.dart';
import '../../../shared/widgets/custom_listview_scrollable.dart';
import '../../../shared/widgets/desktop_drawer_widget.dart';
import '../../theme/colors.dart';
import '../header/header_content.dart';

class AdminShellDesktop extends StatelessWidget {
  final Widget? shell;
  const AdminShellDesktop({Key? key, this.shell}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCustomizedBg(
      body: Column(
        children: [
          HeaderContent(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.25),
                          spreadRadius: 0,
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: DesktopDraweWidget(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),

                    child: CustomListViewScrollable(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: shell ?? SizedBox(),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
