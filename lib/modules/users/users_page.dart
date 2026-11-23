import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/health_professional/health_professional_tab.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/mothers/mothers_tab.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/users_logic.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import '../../shared/widgets/custom_app_tab_bar.dart';
import '../../shared/widgets/custom_responsive_builder.dart';
import '../../shared/widgets/dash_board_section_widget.dart';

class UsersPage extends GetView<UsersLogic> {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomResponsiveBuilder(
      builder: (p0, p1) {
        return Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Obx(() {
              return DashBoardSectionWidget(
                title: "Users Overview",
                subtitle: "Overview of users on the platform",
                icon: FontAwesomeIcons.users,

                child: CustomAppTabBar(
                  tabs: [
                    SegmentTab(
                      label: 'Mothers (${controller.mothersController.filteredMothers.length==0?controller.mothersController.mothers.length: controller.mothersController.filteredMothers.length})',
                      selectedTextColor: AppColors.surface,
                    ),
                    SegmentTab(
                      label: 'Health Professionals',
                      selectedTextColor: AppColors.surface,
                    ),
                    SegmentTab(
                      label: 'Admin',
                      selectedTextColor: AppColors.surface,
                    ),
                  ],
                  tabChildren: [
                    MothersTab(),
                    HealthProfessionalTab(),
                    Container(
                      color: Colors.blue,
                    )
                  ],
                  controller: controller.tabController,
                ),
              );
            })
          ],
        );
      },
    );
  }
}
