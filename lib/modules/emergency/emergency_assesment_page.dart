import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

import '../../shared/widgets/custom_responsive_builder.dart';
import '../../shared/widgets/dash_board_section_widget.dart';

class EmergencyAssessmentPage extends StatelessWidget {
  const EmergencyAssessmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomResponsiveBuilder(
      builder: (p0, p1) {
        return Column(
          children: [
            SizedBox(
              height: 24,
            ),
            DashBoardSectionWidget(
              title: "Emergency Assessment Overview",
              subtitle: "Overview of emergencies on the platform",
              icon: FontAwesomeIcons.triangleExclamation,

              child: Column(
                children: [

                ],
              ),
            )
          ],
        );
      },
    );
  }
}
