import 'package:flutter_test/flutter_test.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/country_filter_button.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('opens the country selector and returns the selected country',
      (tester) async {
    String? selectedCountry;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CountryFilterButton(
            selectedCountry: selectedCountry,
            onChanged: (country) => selectedCountry = country,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Country'));
    await tester.pumpAndSettle();
    expect(find.text('Choose a country'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Nigeria');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('country-NG')));
    await tester.pumpAndSettle();

    expect(selectedCountry, 'Nigeria');
  });

  testWidgets('shows the selected country flag beside the country name',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CountryFilterButton(
            selectedCountry: 'Nigeria',
            onChanged: _ignoreCountryChange,
          ),
        ),
      ),
    );

    expect(find.text('🇳🇬'), findsOneWidget);
    expect(find.text('Nigeria'), findsOneWidget);
  });
}

void _ignoreCountryChange(String? country) {}
