import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/app_customized_bg.dart';
import '../../../shared/widgets/custom_listview_scrollable.dart';
import '../../../shared/widgets/mobile_drawer_widget.dart';
import '../header/header_content_mobile.dart';

class AdminShellMobile extends StatelessWidget {

  final Widget? shell;

  const AdminShellMobile({Key? key, this.shell}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCustomizedBg(
      drawer: AppDrawer(),
      body: Center(
        child: CustomListViewScrollable(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            Builder(
                builder: (context) {
                  return HeaderContentMobile(
                    onMenuPressed: () => Scaffold.of(context).openDrawer(),
                  );
                }
            ),
            shell??SizedBox(),
          ],
        ),
      ),
    );
  }
}
