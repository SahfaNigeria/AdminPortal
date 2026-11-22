import 'package:flutter_test/flutter_test.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_expandable_widget.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('expandable tile provides Material for its ink response',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomExpandableTileWidget(
          title: 'User',
          expandedChild: Text('Expanded details'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    await tester.tap(find.text('User'));
    await tester.pumpAndSettle();

    expect(find.text('Expanded details'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
