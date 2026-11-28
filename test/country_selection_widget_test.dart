import 'package:flutter_test/flutter_test.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/country_selection_widget.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders country selection field and opens dialog on tap',
      (tester) async {
    final controller = TextEditingController();
    String? selectedCountry;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: CountrySelectionWidget(
              controller: controller,
              onChanged: (country) => selectedCountry = country,
            ),
          ),
        ),
      ),
    );

    expect(find.text('COUNTRY'), findsOneWidget);

    await tester.tap(find.byType(TextFormField));
    await tester.pumpAndSettle();

    expect(find.text('Choose a country'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'Nigeria');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('country-NG')));
    await tester.pumpAndSettle();

    expect(controller.text, 'Nigeria');
    expect(selectedCountry, 'Nigeria');
    expect(find.text('Nigeria'), findsOneWidget);
  });
}
