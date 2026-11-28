import 'package:country_picker/country_picker.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/app_text.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/country_selection_widget.dart';
import 'package:material_ui/material_ui.dart';

final _countryService = CountryService();

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
      builder: (_) => CountryPickerDialog(
        selectedCountry: selectedCountry,
        subtitle: 'Narrow the user list by country',
      ),
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
                      : countryFlag(selectedCountryCode),
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
