import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_app_tab_bar.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/dash_board_section_widget.dart';

void main() {
  testWidgets('dashboard tab content receives bounded height',
      (WidgetTester tester) async {
    await tester.pumpWidget(const _UsersLayoutHarness());

    expect(tester.takeException(), isNull);
    expect(find.text('Mothers list'), findsOneWidget);
  });
}

class _UsersLayoutHarness extends StatefulWidget {
  const _UsersLayoutHarness();

  @override
  State<_UsersLayoutHarness> createState() => _UsersLayoutHarnessState();
}

class _UsersLayoutHarnessState extends State<_UsersLayoutHarness>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 420,
          child: DashBoardSectionWidget(
            title: 'Users Overview',
            child: Expanded(
              child: CustomAppTabBar(
                tabs: const [
                  SegmentTab(label: 'Mothers'),
                  SegmentTab(label: 'Health Professionals'),
                  SegmentTab(label: 'Admin'),
                ],
                tabChildren: const [
                  Text('Mothers list'),
                  Text('Health professionals list'),
                  SizedBox.shrink(),
                ],
                controller: _tabController,
                textStyle: const TextStyle(),
                selectedTextStyle: const TextStyle(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
