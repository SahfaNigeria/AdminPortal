import 'dart:math' as math;

import 'package:country_picker/country_picker.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:material_ui/material_ui.dart';

final _countryService = CountryService();

String _countryFlag(String countryCode) {
  final code = countryCode.toUpperCase();
  if (code.length != 2) {
    return '🌍';
  }

  return String.fromCharCodes(
    code.codeUnits.map((unit) => unit + 0x1F1A5),
  );
}

class CountryFilterButton extends StatelessWidget {
  const CountryFilterButton({
    Key? key,
    required this.selectedCountry,
    required this.onChanged,
  }) : super(key: key);

  final String? selectedCountry;
  final ValueChanged<String?> onChanged;

  Future<void> _openCountryPicker(BuildContext context) async {
    final country = await showDialog<Country>(
      context: context,
      builder: (_) => _CountryPickerDialog(selectedCountry: selectedCountry),
    );
    if (country != null) {
      onChanged(country.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedCountry != null;
    final selectedCountryCode =
        _countryService.findByName(selectedCountry)?.countryCode;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => _openCountryPicker(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: hasSelection
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasSelection
                    ? AppColors.primary.withValues(alpha: 0.55)
                    : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedCountryCode == null
                      ? '🌍'
                      : _countryFlag(selectedCountryCode),
                  style: const TextStyle(fontSize: 17),
                ),
                const SizedBox(width: 8),
                AppText(
                  text: selectedCountry ?? 'Country',
                  color:
                      hasSelection ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (hasSelection) ...[
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Clear country filter',
            onPressed: () => onChanged(null),
            icon: const Icon(Icons.close, size: 18),
            color: AppColors.textSecondary,
            splashRadius: 18,
          ),
        ],
      ],
    );
  }
}

class _CountryPickerDialog extends StatefulWidget {
  const _CountryPickerDialog({required this.selectedCountry});

  final String? selectedCountry;

  @override
  State<_CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<_CountryPickerDialog> {
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Choose a country',
                          size: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(height: 3),
                        AppText(
                          text: 'Narrow the user list by country',
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
                                      _countryFlag(country.countryCode),
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
