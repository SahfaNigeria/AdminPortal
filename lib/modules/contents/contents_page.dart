import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/modules/contents/content_controller.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/dash_board_section_widget.dart';
import 'package:material_ui/material_ui.dart';

class ContentsPage extends GetView<ContentController> {
  const ContentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        DashBoardSectionWidget(
          title: 'Contents',
          subtitle: 'Content management',
          icon: FontAwesomeIcons.pen,
          child: SizedBox(
            height: 220,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 42,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const AppText(
                    text: 'Content management will be available here.',
                    size: 14,
                    color: Colors.grey,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
