import 'dart:math' as math;

import 'package:country_picker/country_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/auth_text_field.dart';
import 'package:material_ui/material_ui.dart';

final CountryService _countryService = CountryService();

String countryFlag(String countryCode) {
  final code = countryCode.toUpperCase();
  if (code.length != 2) {
    return '🌍';
  }

  return String.fromCharCodes(
    code.codeUnits.map((unit) => unit + 0x1F1A5),
  );
}

class CountrySelectionWidget extends StatefulWidget {
  const CountrySelectionWidget({
    Key? key,
    this.controller,
    this.selectedCountry,
    this.onChanged,
    this.validator,
    this.fieldTitle = "Country",
    this.dialogTitle = "Choose a country",
    this.dialogSubtitle = "Select your country",
    this.margin,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? selectedCountry;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;
  final String fieldTitle;
  final String dialogTitle;
  final String dialogSubtitle;
  final EdgeInsetsGeometry? margin;

  @override
  State<CountrySelectionWidget> createState() => _CountrySelectionWidgetState();
}

class _CountrySelectionWidgetState extends State<CountrySelectionWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant CountrySelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openCountryPicker(BuildContext context) async {
    final currentCountry = widget.selectedCountry ?? widget.controller?.text;
    final country = await showDialog<Country>(
      context: context,
      builder: (_) => CountryPickerDialog(
        selectedCountry: currentCountry,
        title: widget.dialogTitle,
        subtitle: widget.dialogSubtitle,
      ),
    );
    if (country != null) {
      if (widget.controller != null) {
        widget.controller!.text = country.name;
      }
      widget.onChanged?.call(country.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final countryName = widget.selectedCountry ?? widget.controller?.text;
    final countryCode = (countryName != null && countryName.isNotEmpty)
        ? _countryService.findByName(countryName)?.countryCode
        : null;

    final String flag = countryCode != null ? countryFlag(countryCode) : '🌍';

    return AuthTextField(
      fieldTitle: widget.fieldTitle,
      controller: widget.controller,
      readOnly: true,
      onTap: () => _openCountryPicker(context),
      validator: widget.validator,
      margin: widget.margin,
      prefix: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
      suffix: const Padding(
        padding: EdgeInsets.all(8.0),
        child: FaIcon(FontAwesomeIcons.globe, size: 20),
      ),
    );
  }
}

class CountryPickerDialog extends StatefulWidget {
  const CountryPickerDialog({
    Key? key,
    this.selectedCountry,
    this.title = 'Choose a country',
    this.subtitle = 'Select your country',
  }) : super(key: key);

  final String? selectedCountry;
  final String title;
  final String subtitle;

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  final _searchController = TextEditingController();
  final _countries = CountryService().getAll()
    ..sort(
      (first, second) =>
          first.name.toLowerCase().compareTo(second.name.toLowerCase()),
    );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final countries = _countries
        .where((country) => country.name.toLowerCase().contains(query))
        .toList();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: AppColors.surface,
      elevation: 18,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        width: 460,
        height: math.min(560.0, MediaQuery.sizeOf(context).height * 0.72),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 14, 18),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🌍', style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: widget.title,
                          size: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(height: 3),
                        AppText(
                          text: widget.subtitle,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE9E9EC)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search countries',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close_rounded, size: 18),
                            color: AppColors.textSecondary,
                          ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 8),
              child: Row(
                children: [
                  const AppText(
                    text: 'COUNTRIES',
                    size: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                  const Spacer(),
                  AppText(
                    text: '${countries.length}',
                    size: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            Expanded(
              child: countries.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 30,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 8),
                          AppText(
                            text: 'No matching countries',
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                      itemCount: countries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final country = countries[index];
                        final isSelected =
                            country.name == widget.selectedCountry;
                        return Material(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.08)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            key: ValueKey('country-${country.countryCode}'),
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => Navigator.of(context).pop(country),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFE9E9EC),
                                      ),
                                    ),
                                    child: Text(
                                      countryFlag(country.countryCode),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: AppText(
                                      text: country.name,
                                      size: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  AppText(
                    text: '${countries.length} countries',
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
