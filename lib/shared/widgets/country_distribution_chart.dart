import 'package:world_flags/world_flags.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/theme/colors.dart';
import 'app_text.dart';
import 'dashboard_container_widget.dart';

enum CountryUserCategory { all, mothers, healthProfessionals, admins }

final CountryService _countryService = CountryService();

String cleanCountryName(String name) {
  if (name.isEmpty) return "Unspecified";

  String cleaned = name
      .replaceAll(RegExp(r'(\uD83C[\uDDE6-\uDDFF]{2})'), '')
      .replaceAll(RegExp(r'[\u{1F1E6}-\u{1F1FF}]', unicode: true), '')
      .trim();

  cleaned = cleaned.replaceAll(RegExp(r'^[^\w\s]+'), '').trim();

  if (cleaned.isEmpty || cleaned.toLowerCase() == "unspecified") {
    return "Unspecified";
  }
  return cleaned;
}

String? getIsoCode(String countryName, String rawCountry) {
  final RegExp flagRegExp = RegExp(r'(\uD83C[\uDDE6-\uDDFF]{2})');
  final match = flagRegExp.firstMatch(rawCountry.isNotEmpty ? rawCountry : countryName);
  if (match != null) {
    final flag = match.group(0)!;
    if (flag.runes.length >= 2) {
      final codeUnits = flag.runes.toList();
      final char1 = String.fromCharCode(codeUnits[0] - 0x1F1A5);
      final char2 = String.fromCharCode(codeUnits[1] - 0x1F1A5);
      final iso = "$char1$char2".toUpperCase();
      if (iso.length == 2) return iso;
    }
  }

  final cleanName = cleanCountryName(countryName);
  if (cleanName.isEmpty || cleanName.toLowerCase() == "unspecified") {
    return null;
  }

  final country = _countryService.findByName(cleanName);
  if (country != null) {
    return country.countryCode.toUpperCase();
  }

  final lower = cleanName.toLowerCase();
  if (lower.contains("nigeria")) return "NG";
  if (lower.contains("ghana")) return "GH";
  if (lower.contains("kenya")) return "KE";
  if (lower.contains("uganda")) return "UG";
  if (lower.contains("south africa")) return "ZA";
  if (lower.contains("united states") || lower == "usa" || lower == "us") return "US";
  if (lower.contains("united kingdom") || lower == "uk") return "GB";
  if (lower.contains("canada")) return "CA";
  if (lower.contains("cameroon")) return "CM";
  if (lower.contains("niger")) return "NE";
  if (lower.contains("benin")) return "BJ";
  if (lower.contains("togo")) return "TG";
  if (lower.contains("senegal")) return "SN";
  if (lower.contains("rwanda")) return "RW";
  if (lower.contains("tanzania")) return "TZ";
  if (lower.contains("ethiopia")) return "ET";
  if (lower.contains("egypt")) return "EG";
  if (lower.contains("morocco")) return "MA";
  if (lower.contains("ivory coast") || lower.contains("cote")) return "CI";
  if (lower.contains("zimbabwe")) return "ZW";
  if (lower.contains("zambia")) return "ZM";
  if (lower.contains("malawi")) return "MW";
  if (lower.contains("germany")) return "DE";
  if (lower.contains("france")) return "FR";
  if (lower.contains("india")) return "IN";
  if (lower.contains("china")) return "CN";
  if (lower.contains("brazil")) return "BR";
  if (lower.contains("australia")) return "AU";

  return null;
}

class AppCountryFlag extends StatelessWidget {
  final String countryName;
  final String? rawFlag;
  final double width;
  final double height;

  const AppCountryFlag({
    Key? key,
    required this.countryName,
    this.rawFlag,
    this.width = 22,
    this.height = 15,
  }) : super(key: key);

  WorldCountry? _getWorldCountry() {
    final code = getIsoCode(countryName, rawFlag ?? '');
    if (code != null) {
      final countryByCode = WorldCountry.maybeFromAnyCode(code);
      if (countryByCode != null) return countryByCode;
    }

    final cleanName = cleanCountryName(countryName);
    if (cleanName.isNotEmpty && cleanName.toLowerCase() != "unspecified") {
      for (final c in WorldCountry.list) {
        if (c.name.common.toLowerCase() == cleanName.toLowerCase()) {
          return c;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final worldCountry = _getWorldCountry();

    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: worldCountry == null ? const Color(0xFFF1F5F9) : Colors.transparent,
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          borderRadius: BorderRadius.circular(3),
        ),
        child: worldCountry != null
            ? CountryFlag.simplified(
                worldCountry,
                height: height,
                width: width,
              )
            : FaIcon(
                FontAwesomeIcons.globe,
                size: (height - 2).clamp(8.0, 14.0),
                color: const Color(0xFF64748B),
              ),
      ),
    );
  }
}

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
  final List<CountryDataPoint>? allData;
  final List<CountryDataPoint> mothersData;
  final List<CountryDataPoint> healthProfessionalsData;
  final List<CountryDataPoint> adminsData;
  final String title;
  final String subtitle;
  final CountryUserCategory initialCategory;

  const CountryDistributionChart({
    Key? key,
    this.allData,
    required this.mothersData,
    required this.healthProfessionalsData,
    required this.adminsData,
    this.title = "Geographic Distribution",
    this.subtitle = "Country breakdown across platform user roles",
    this.initialCategory = CountryUserCategory.all,
  }) : super(key: key);

  @override
  State<CountryDistributionChart> createState() =>
      _CountryDistributionChartState();
}

class _CountryDistributionChartState extends State<CountryDistributionChart> {
  late CountryUserCategory activeCategory;
  int touchedIndex = -1;

  final List<Color> donutPalette = const [
    AppColors.primary,        // Crimson / Primary Theme
    Color(0xFF0EA5E9),       // Sky Blue
    Color(0xFF10B981),       // Emerald
    Color(0xFFF59E0B),       // Amber
    Color(0xFFEC4899),       // Rose
    Color(0xFF6366F1),       // Indigo
    Color(0xFF8B5CF6),       // Purple
    Color(0xFF14B8A6),       // Teal
    Color(0xFF64748B),       // Slate
  ];

  @override
  void initState() {
    super.initState();
    activeCategory = widget.initialCategory;
  }

  List<CountryDataPoint> get currentDataset {
    switch (activeCategory) {
      case CountryUserCategory.all:
        if (widget.allData != null && widget.allData!.isNotEmpty) {
          return widget.allData!;
        }
        return _aggregateAllData();
      case CountryUserCategory.mothers:
        return widget.mothersData;
      case CountryUserCategory.healthProfessionals:
        return widget.healthProfessionalsData;
      case CountryUserCategory.admins:
        return widget.adminsData;
    }
  }

  List<CountryDataPoint> _aggregateAllData() {
    final Map<String, int> countMap = {};
    final Map<String, String> flagMap = {};
    final Map<String, String> nameMap = {};

    final allItems = [
      ...widget.mothersData,
      ...widget.healthProfessionalsData,
      ...widget.adminsData,
    ];

    if (allItems.isEmpty) return [];

    int grandTotal = 0;
    for (final item in allItems) {
      final cleanName = cleanCountryName(item.countryName);
      final key = cleanName.toLowerCase();
      countMap[key] = (countMap[key] ?? 0) + item.count;
      flagMap[key] = item.flagEmoji;
      nameMap[key] = cleanName;
      grandTotal += item.count;
    }

    final sortedEntries = countMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.map((entry) {
      final key = entry.key;
      final count = entry.value;
      final pct = grandTotal > 0 ? (count / grandTotal) * 100 : 0.0;
      return CountryDataPoint(
        rawCountry: key,
        countryName: nameMap[key] ?? key,
        flagEmoji: flagMap[key] ?? "🌐",
        count: count,
        percentage: pct,
      );
    }).toList();
  }

  Color get activeColor {
    switch (activeCategory) {
      case CountryUserCategory.all:
        return AppColors.primary;
      case CountryUserCategory.mothers:
        return const Color(0xFFEC4899);
      case CountryUserCategory.healthProfessionals:
        return const Color(0xFF0EA5E9);
      case CountryUserCategory.admins:
        return const Color(0xFF10B981);
    }
  }

  String get activeRoleName {
    switch (activeCategory) {
      case CountryUserCategory.all:
        return "All Users";
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
    final themeColor = activeColor;
    final totalCount = dataset.fold<int>(0, (sum, item) => sum + item.count);
    final topCountry = dataset.isNotEmpty ? dataset.first : null;
    final countryCount = dataset.length;

    return DashboardContainerWidget(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Section & Category Switcher Tabs
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isCompact = constraints.maxWidth < 650;
              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderTitle(themeColor),
                    const SizedBox(height: 16),
                    _buildCategorySegmentedControl(),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildHeaderTitle(themeColor)),
                  const SizedBox(width: 16),
                  _buildCategorySegmentedControl(),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // 2. Metric Summary Strip
          _buildMetricBanner(totalCount, topCountry, countryCount, themeColor),

          const SizedBox(height: 24),

          // 3. FL_CHART Donut Chart View
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: dataset.isEmpty
                ? _buildEmptyState()
                : Column(
                    key: ValueKey("donut_${activeCategory.name}"),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: _buildDonutChartView(dataset, totalCount),
                      ),

                      const SizedBox(height: 24),

                      // 4. Country Leaderboard & Breakdown List
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.listOl,
                                size: 14,
                                color: themeColor,
                              ),
                              const SizedBox(width: 8),
                              AppText(
                                text: "Country Rankings & Breakdown",
                                size: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: AppText(
                              text: "$countryCount ${countryCount == 1 ? 'country' : 'countries'}",
                              size: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      _buildCountryListTable(dataset, themeColor),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const FaIcon(
            FontAwesomeIcons.earthAfrica,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: widget.title,
                size: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 2),
              AppText(
                text: widget.subtitle,
                size: 12,
                color: const Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCategoryTabItem("All", CountryUserCategory.all),
          _buildCategoryTabItem("Mothers", CountryUserCategory.mothers),
          _buildCategoryTabItem("Professionals", CountryUserCategory.healthProfessionals),
          _buildCategoryTabItem("Admins", CountryUserCategory.admins),
        ],
      ),
    );
  }

  Widget _buildCategoryTabItem(String label, CountryUserCategory category) {
    final isSelected = activeCategory == category;
    return GestureDetector(
      onTap: () {
        if (activeCategory != category) {
          setState(() {
            activeCategory = category;
            touchedIndex = -1;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: AppText(
          text: label,
          size: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? AppColors.textPrimary : const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildMetricBanner(
    int totalCount,
    CountryDataPoint? topCountry,
    int countryCount,
    Color accentColor,
  ) {
    final cleanTopName = topCountry != null ? cleanCountryName(topCountry.countryName) : "N/A";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMetricTile(
              icon: FontAwesomeIcons.users,
              label: "TOTAL ${activeRoleName.toUpperCase()}",
              value: "$totalCount",
              accentColor: accentColor,
            ),
          ),
          Container(
            height: 28,
            width: 1,
            color: const Color(0xFFE2E8F0),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.crown,
                      size: 13,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppText(
                          text: "TOP MARKET",
                          size: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 0.5,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            if (topCountry != null) ...[
                              AppCountryFlag(
                                countryName: cleanTopName,
                                rawFlag: topCountry.flagEmoji,
                                width: 20,
                                height: 14,
                              ),
                              const SizedBox(width: 6),
                            ],
                            Expanded(
                              child: AppText(
                                text: cleanTopName,
                                size: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (topCountry != null) ...[
                          const SizedBox(height: 1),
                          AppText(
                            text: "${topCountry.percentage.toStringAsFixed(1)}% of category",
                            size: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                            maxLines: 1,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 28,
            width: 1,
            color: const Color(0xFFE2E8F0),
          ),
          Expanded(
            child: _buildMetricTile(
              icon: FontAwesomeIcons.earthAfrica,
              label: "COUNTRIES REACHED",
              value: "$countryCount",
              accentColor: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required dynamic icon,
    required String label,
    required String value,
    String? subtitle,
    required Color accentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(
              icon,
              size: 13,
              color: accentColor,
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
                  size: 9,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF94A3B8),
                  letterSpacing: 0.5,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: value,
                  size: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  AppText(
                    text: subtitle,
                    size: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                    maxLines: 1,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Donut Chart Implementation (`fl_chart.PieChart`)
  Widget _buildDonutChartView(List<CountryDataPoint> dataset, int totalCount) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 620;

        final chartWidget = SizedBox(
          height: 230,
          width: 230,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sectionsSpace: 3,
                  centerSpaceRadius: 56,
                  startDegreeOffset: -90,
                  sections: List.generate(dataset.length, (index) {
                    final item = dataset[index];
                    final isTouched = index == touchedIndex;
                    final sliceColor =
                        donutPalette[index % donutPalette.length];

                    return PieChartSectionData(
                      color: sliceColor,
                      value: item.count.toDouble(),
                      title: isTouched
                          ? "${item.percentage.toStringAsFixed(1)}%"
                          : "",
                      radius: isTouched ? 28 : 22,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: "$totalCount",
                    size: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 1),
                  AppText(
                    text: "Total Users",
                    size: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ],
          ),
        );

        final legendWidget = _buildDonutLegend(dataset);

        if (isCompact) {
          return Column(
            children: [
              Center(child: chartWidget),
              const SizedBox(height: 24),
              legendWidget,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            chartWidget,
            const SizedBox(width: 36),
            Expanded(child: legendWidget),
          ],
        );
      },
    );
  }

  Widget _buildDonutLegend(List<CountryDataPoint> dataset) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: List.generate(dataset.length, (index) {
        final item = dataset[index];
        final cleanName = cleanCountryName(item.countryName);
        final isSelected = touchedIndex == index;
        final color = donutPalette[index % donutPalette.length];

        return GestureDetector(
          onTap: () {
            setState(() {
              touchedIndex = isSelected ? -1 : index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? color : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                AppCountryFlag(
                  countryName: cleanName,
                  rawFlag: item.flagEmoji,
                  width: 18,
                  height: 12,
                ),
                const SizedBox(width: 6),
                AppText(
                  text: cleanName,
                  size: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: 8),
                AppText(
                  text: "${item.count}",
                  size: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                const SizedBox(width: 4),
                AppText(
                  text: "(${item.percentage.toStringAsFixed(1)}%)",
                  size: 10,
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Country Rankings Breakdown List Table
  Widget _buildCountryListTable(
    List<CountryDataPoint> dataset,
    Color themeColor,
  ) {
    final maxCount = dataset.isNotEmpty ? dataset.first.count : 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        children: List.generate(dataset.length, (index) {
          final item = dataset[index];
          final cleanName = cleanCountryName(item.countryName);
          final isSelected = touchedIndex == index;
          final relativeFraction = maxCount > 0 ? item.count / maxCount : 0.0;
          final isLast = index == dataset.length - 1;

          final Color rankBadgeColor = index == 0
              ? const Color(0xFFF59E0B) // Gold
              : index == 1
                  ? const Color(0xFF94A3B8) // Silver
                  : index == 2
                      ? const Color(0xFFD97706) // Bronze
                      : const Color(0xFFCBD5E1);

          return InkWell(
            onTap: () {
              setState(() {
                touchedIndex = isSelected ? -1 : index;
              });
            },
            borderRadius: BorderRadius.vertical(
              top: index == 0 ? const Radius.circular(14) : Radius.zero,
              bottom: isLast ? const Radius.circular(14) : Radius.zero,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? themeColor.withValues(alpha: 0.05)
                    : Colors.transparent,
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(
                          color: Color(0xFFF1F5F9),
                          width: 1,
                        ),
                      ),
              ),
              child: Row(
                children: [
                  // Rank Badge
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: rankBadgeColor.withValues(alpha: index < 3 ? 0.15 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: AppText(
                      text: "${index + 1}",
                      size: 11,
                      fontWeight: FontWeight.bold,
                      color: index < 3 ? rankBadgeColor : const Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Single Country Flag Image from world_flags
                  AppCountryFlag(
                    countryName: cleanName,
                    rawFlag: item.flagEmoji,
                    width: 24,
                    height: 16,
                  ),

                  const SizedBox(width: 10),

                  // Clean Country Name
                  Expanded(
                    flex: 3,
                    child: AppText(
                      text: cleanName,
                      size: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Relative Progress Bar Track
                  Expanded(
                    flex: 4,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Container(
                              height: 6,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              height: 6,
                              width: constraints.maxWidth * relativeFraction,
                              decoration: BoxDecoration(
                                color: isSelected ? themeColor : themeColor.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  // User Count
                  AppText(
                    text: "${item.count}",
                    size: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),

                  const SizedBox(width: 12),

                  // Percentage Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: AppText(
                      text: "${item.percentage.toStringAsFixed(1)}%",
                      size: 11,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      key: ValueKey("empty_${activeCategory.name}"),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(
              FontAwesomeIcons.earthAfrica,
              size: 24,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 14),
          AppText(
            text: "No Geographic Data for $activeRoleName",
            size: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: 4),
          AppText(
            text: "Registered users in this category have not assigned country location details yet.",
            size: 12,
            color: const Color(0xFF64748B),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
