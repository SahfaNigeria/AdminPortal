import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/section_title_widget.dart';
import 'package:material_ui/material_ui.dart';

import 'dashboard_container_widget.dart';

class DashBoardSectionWidget extends StatelessWidget {
  final FaIconData? icon;
  final String? subtitle;
  final String? title;
  final Widget? child;
  const DashBoardSectionWidget({Key? key, this.icon, this.subtitle, this.title, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return       DashboardContainerWidget(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [

           SectionTitleWidget(
            title: title??"Analytics Overview",
            subtitle: subtitle??"Overview of platform statistics",
            icon: icon??FontAwesomeIcons.chartPie,
          ),

          child??SizedBox()


        ],
      ),
    );
  }
}
