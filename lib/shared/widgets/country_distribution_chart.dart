import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/theme/colors.dart';
import 'app_text.dart';
import 'dashboard_container_widget.dart';

enum CountryUserCategory { mothers, healthProfessionals, admins }

class CountryDataPoint {
  final String rawCountry;
  final String countryName;
  final String flagEmoji;
  final int count;
  final double percentage;

  const CountryDataPoint({
    required this.rawCountry,
    required this.countryName,
    required this.flagEmoji,
    required this.count,
    required this.percentage,
  });
}

class CountryDistributionChart extends StatefulWidget {
  final List<CountryDataPoint> mothersData;
  final List<CountryDataPoint> healthProfessionalsData;
  final List<CountryDataPoint> adminsData;
  final String title;
  final String subtitle;
  final CountryUserCategory initialCategory;

  const CountryDistributionChart({
    Key? key,
    required this.mothersData,
    required this.healthProfessionalsData,
    required this.adminsData,
    this.title = "Geographic Distribution",
    this.subtitle = "Country breakdown for mothers, health professionals, and admins",
    this.initialCategory = CountryUserCategory.mothers,
  }) : super(key: key);

  @override
  State<CountryDistributionChart> createState() =>
      _CountryDistributionChartState();
}

class _CountryDistributionChartState extends State<CountryDistributionChart> {
  late CountryUserCategory activeCategory;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    activeCategory = widget.initialCategory;
  }

  List<CountryDataPoint> get currentDataset {
    switch (activeCategory) {
      case CountryUserCategory.mothers:
        return widget.mothersData;
      case CountryUserCategory.healthProfessionals:
        return widget.healthProfessionalsData;
      case CountryUserCategory.admins:
        return widget.adminsData;
    }
  }

  Color get activeColor {
    switch (activeCategory) {
      case CountryUserCategory.mothers:
        return const Color(0xFFEC4899); // Pink
      case CountryUserCategory.healthProfessionals:
        return const Color(0xFF0EA5E9); // Blue
      case CountryUserCategory.admins:
        return const Color(0xFF10B981); // Emerald
    }
  }

  FaIconData get activeIcon {
    switch (activeCategory) {
      case CountryUserCategory.mothers:
        return FontAwesomeIcons.personBreastfeeding;
      case CountryUserCategory.healthProfessionals:
        return FontAwesomeIcons.userNurse;
      case CountryUserCategory.admins:
        return FontAwesomeIcons.userGroup;
    }
  }

  String get activeRoleName {
    switch (activeCategory) {
      case CountryUserCategory.mothers:
        return "Mothers";
      case CountryUserCategory.healthProfessionals:
        return "Health Professionals";
      case CountryUserCategory.admins:
        return "Admins";
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataset = currentDataset;
    final color = activeColor;
    final totalCount = dataset.fold<int>(0, (sum, item) => sum + item.count);
    final topCountry = dataset.isNotEmpty ? dataset.first : null;
    final countryCount = dataset.length;

    return DashboardContainerWidget(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title and Category Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.globe,
                        size: 18,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: widget.title,
                            size: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(height: 2),
                          AppText(
                            text: widget.subtitle,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Role Switcher Segmented Control
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCategoryTab(
                        label: "Mothers",
                        category: CountryUserCategory.mothers,
                        tabColor: const Color(0xFFEC4899),
                      ),
                      _buildCategoryTab(
                        label: "Professionals",
                        category: CountryUserCategory.healthProfessionals,
                        tabColor: const Color(0xFF0EA5E9),
                      ),
                      _buildCategoryTab(
                        label: "Admins",
                        category: CountryUserCategory.admins,
                        tabColor: const Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Summary Metric Cards Banner
          Row(
            children: [
              Expanded(
                child: _buildMetricBadge(
                  label: "Total $activeRoleName",
                  value: "$totalCount",
                  icon: activeIcon,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricBadge(
                  label: "Top Country",
                  value: topCountry != null
                      ? "${topCountry.flagEmoji} ${topCountry.countryName}"
                      : "N/A",
                  icon: FontAwesomeIcons.crown,
                  color: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricBadge(
                  label: "Countries Covered",
                  value: "$countryCount ${countryCount == 1 ? 'Country' : 'Countries'}",
                  icon: FontAwesomeIcons.earthAfrica,
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Main Country Content: List of progress bars or Empty State
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: dataset.isEmpty
                ? _buildEmptyState(color)
                : _buildCountryList(dataset, color, totalCount),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab({
    required String label,
    required CountryUserCategory category,
    required Color tabColor,
  }) {
    final isSelected = activeCategory == category;
    return GestureDetector(
      onTap: () {
        if (activeCategory != category) {
          setState(() {
            activeCategory = category;
            selectedIndex = null;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? tabColor : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: tabColor.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: AppText(
          text: label,
          size: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildMetricBadge({
    required String label,
    required String value,
    required FaIconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              icon,
              size: 13,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: label,
                  size: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: value,
                  size: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color color) {
    return Container(
      key: ValueKey("empty_${activeCategory.name}"),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              FontAwesomeIcons.earthAfrica,
              size: 28,
              color: color,
            ),
          ),
          const SizedBox(height: 14),
          AppText(
            text: "No country data available for $activeRoleName",
            size: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: 4),
          AppText(
            text: "Registered users in this category do not have country information assigned yet.",
            size: 12,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCountryList(
    List<CountryDataPoint> dataset,
    Color color,
    int totalCount,
  ) {
    final maxCount = dataset.first.count;

    return Column(
      key: ValueKey("list_${activeCategory.name}"),
      children: List.generate(dataset.length, (index) {
        final item = dataset[index];
        final isSelected = selectedIndex == index;
        final relativeFraction = maxCount > 0 ? item.count / maxCount : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = isSelected ? null : index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.08)
                    : AppColors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? color.withValues(alpha: 0.5)
                      : Colors.grey.withValues(alpha: 0.15),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row: Rank + Flag + Country Name + Count Badge + Percentage Pill
                  Row(
                    children: [
                      // Rank Badge (#1, #2, #3, ...)
                      _buildRankBadge(index, color),
                      const SizedBox(width: 10),

                      // Flag Emoji
                      AppText(
                        text: item.flagEmoji,
                        size: 18,
                      ),
                      const SizedBox(width: 8),

                      // Country Name
                      Expanded(
                        child: AppText(
                          text: item.countryName,
                          size: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Count Badge
                      AppText(
                        text: "${item.count} ${item.count == 1 ? 'user' : 'users'}",
                        size: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 10),

                      // Percentage Badge Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppText(
                          text: "${item.percentage.toStringAsFixed(1)}%",
                          size: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Progress Bar
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: relativeFraction),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, animValue, child) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              // Background Track
                              Container(
                                height: 8,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),

                              // Animated Gradient Bar
                              Container(
                                height: 8,
                                width: constraints.maxWidth * animValue,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      color.withValues(alpha: 0.7),
                                      color,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  // Expanded Details when selected
                  if (isSelected) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: "Share of Total $activeRoleName:",
                            size: 11,
                            color: AppColors.textSecondary,
                          ),
                          AppText(
                            text: "${item.count} out of $totalCount (${item.percentage.toStringAsFixed(1)}%)",
                            size: 11,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRankBadge(int index, Color color) {
    Color badgeColor;
    Color textColor = Colors.white;

    if (index == 0) {
      badgeColor = const Color(0xFFF59E0B); // Gold
    } else if (index == 1) {
      badgeColor = const Color(0xFF94A3B8); // Silver
    } else if (index == 2) {
      badgeColor = const Color(0xFFD97706); // Bronze
    } else {
      badgeColor = color.withValues(alpha: 0.15);
      textColor = color;
    }

    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
      ),
      child: AppText(
        text: "${index + 1}",
        size: 11,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
