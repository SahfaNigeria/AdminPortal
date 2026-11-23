import 'dart:math' as math;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/section_title_widget.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import 'app_text.dart';
import 'dashboard_container_widget.dart';

class PieChartSectionData {
  final String label;
  final double value;
  final Color color;
  final FaIconData icon;

  const PieChartSectionData({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
}

class CustomPieChartWidget extends StatefulWidget {
  final List<PieChartSectionData>? sections;

  final double mothersCount;
  final double healthcareCount;
  final double adminCount;
  final double hospitalsCount;

  final String mothersLabel;
  final String healthcareLabel;
  final String adminLabel;
  final String hospitalsLabel;

  final Color? mothersColor;
  final Color? healthcareColor;
  final Color? adminColor;
  final Color? hospitalsColor;

  final String title;
  final String? subtitle;

  final bool showLegend;
  final bool showPercentages;

  final double height;
  final double strokeWidth;

  final ValueChanged<int?>? onSectionSelected;

  const CustomPieChartWidget({
    Key? key,
    this.sections,
    this.mothersCount = 0,
    this.healthcareCount = 0,
    this.adminCount = 0,
    this.hospitalsCount = 0,
    this.mothersLabel = "Mothers",
    this.healthcareLabel = "Healthcare",
    this.adminLabel = "Admins",
    this.hospitalsLabel = "Hospitals",
    this.mothersColor,
    this.healthcareColor,
    this.adminColor,
    this.hospitalsColor,
    this.title = "User Distribution",
    this.subtitle =
        "Distribution of mothers, healthcare professionals, admins and hospitals",
    this.showLegend = true,
    this.showPercentages = true,
    this.height = 220,
    this.strokeWidth = 28,
    this.onSectionSelected,
  }) : super(key: key);

  @override
  State<CustomPieChartWidget> createState() => _CustomPieChartWidgetState();
}

class _CustomPieChartWidgetState extends State<CustomPieChartWidget> {
  int? selectedIndex;

  List<PieChartSectionData> get effectiveSections {
    if (widget.sections != null && widget.sections!.isNotEmpty) {
      return widget.sections!;
    }

    return [
      PieChartSectionData(
        label: widget.mothersLabel,
        value: widget.mothersCount,
        color: widget.mothersColor ?? const Color(0xFFEC4899),
        icon: FontAwesomeIcons.personBreastfeeding,
      ),
      PieChartSectionData(
        label: widget.healthcareLabel,
        value: widget.healthcareCount,
        color: widget.healthcareColor ?? const Color(0xFF0EA5E9),
        icon: FontAwesomeIcons.userNurse,
      ),
      PieChartSectionData(
        label: widget.adminLabel,
        value: widget.adminCount,
        color: widget.adminColor ?? const Color(0xFF10B981),
        icon: FontAwesomeIcons.userGroup,
      ),
      PieChartSectionData(
        label: widget.hospitalsLabel,
        value: widget.hospitalsCount,
        color: widget.hospitalsColor ?? const Color(0xFFF59E0B),
        icon: FontAwesomeIcons.hospital,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final sections = effectiveSections;

    final double total = sections.fold(
      0.0,
      (sum, item) => sum + item.value,
    );

    return DashboardContainerWidget(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionTitleWidget(
            title: widget.title,
            subtitle: widget.subtitle,
            icon: FontAwesomeIcons.chartPie,
          ),
          SizedBox(
            height: widget.height,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, animValue, child) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final double size = math.min(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );

                    final Offset center = Offset(
                      constraints.maxWidth / 2,
                      constraints.maxHeight / 2,
                    );

                    return GestureDetector(
                      onTapDown: (details) {
                        final Offset localPos = details.localPosition;

                        final double dx = localPos.dx - center.dx;
                        final double dy = localPos.dy - center.dy;

                        final double distance = math.sqrt(dx * dx + dy * dy);

                        final double outerRadius = size / 2;

                        final double innerRadius =
                            outerRadius - widget.strokeWidth - 10;

                        if (distance >= innerRadius &&
                            distance <= outerRadius + 10) {
                          double angle = math.atan2(dy, dx);

                          angle += math.pi / 2;

                          if (angle < 0) {
                            angle += 2 * math.pi;
                          }

                          double accumulatedAngle = 0.0;

                          int? tappedIndex;

                          for (int i = 0; i < sections.length; i++) {
                            final double sectionAngle = total > 0
                                ? (sections[i].value / total) * 2 * math.pi
                                : 0;

                            if (angle >= accumulatedAngle &&
                                angle <= accumulatedAngle + sectionAngle) {
                              tappedIndex = i;
                              break;
                            }

                            accumulatedAngle += sectionAngle;
                          }

                          setState(() {
                            if (tappedIndex != null) {
                              selectedIndex = selectedIndex == tappedIndex
                                  ? null
                                  : tappedIndex;
                            } else {
                              selectedIndex = null;
                            }

                            widget.onSectionSelected?.call(selectedIndex);
                          });
                        } else {
                          setState(() {
                            selectedIndex = null;
                            widget.onSectionSelected?.call(null);
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: Size(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            ),
                            painter: _PieChartPainter(
                              sections: sections,
                              strokeWidth: widget.strokeWidth,
                              progress: animValue,
                              selectedIndex: selectedIndex,
                            ),
                          ),

// Donut Center Text
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                text: selectedIndex != null &&
                                        selectedIndex! < sections.length
                                    ? "${(total > 0 ? (sections[selectedIndex!].value / total) * 100 : 0).toStringAsFixed(1)}%"
                                    : "${total.toInt()}",
                                size: 22,
                                fontWeight: FontWeight.bold,
                                color: selectedIndex != null &&
                                        selectedIndex! < sections.length
                                    ? sections[selectedIndex!].color
                                    : AppColors.textPrimary,
                              ),
                              AppText(
                                text: selectedIndex != null &&
                                        selectedIndex! < sections.length
                                    ? sections[selectedIndex!].label
                                    : "Total",
                                size: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (widget.showLegend) ...[
            const SizedBox(height: 24),

// Responsive Legend
            LayoutBuilder(
              builder: (context, constraints) {
                final double itemWidth = constraints.maxWidth >= 600
                    ? (constraints.maxWidth - 12) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: sections.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final item = entry.value;

                    final double percentage =
                        total > 0 ? (item.value / total) * 100 : 0.0;

                    final bool isSelected = selectedIndex == index;

                    return SizedBox(
                      width: itemWidth,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex =
                                selectedIndex == index ? null : index;

                            widget.onSectionSelected?.call(selectedIndex);
                          });
                        },
                        child: _buildLegendTile(
                          label: item.label,
                          count: item.value.toInt(),
                          percentage: percentage,
                          color: item.color,
                          icon: item.icon,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendTile({
    required String label,
    required int count,
    required double percentage,
    required Color color,
    required FaIconData icon,
    required bool isSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: isSelected ? 0.14 : 0.05,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(
            alpha: isSelected ? 0.6 : 0.2,
          ),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              icon,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  text: label,
                  size: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: "$count total",
                  size: 11,
                  color: AppColors.textSecondary,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          if (widget.showPercentages)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: AppText(
                text: "${percentage.toStringAsFixed(1)}%",
                size: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<PieChartSectionData> sections;
  final double strokeWidth;
  final double progress;
  final int? selectedIndex;

  _PieChartPainter({
    required this.sections,
    required this.strokeWidth,
    required this.progress,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double total = sections.fold(
      0.0,
      (sum, item) => sum + item.value,
    );

    if (total <= 0) return;

    final Offset center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final double chartSize = math.min(
      size.width,
      size.height,
    );

    final double baseRadius = (chartSize - strokeWidth - 16) / 2;

    const double startAngleOffset = -math.pi / 2;

    final double totalSweep = 2 * math.pi * progress;

    const double gap = 0.04;

    double currentAngle = startAngleOffset;

    for (int i = 0; i < sections.length; i++) {
      final item = sections[i];

// Ignore zero or negative values.
      if (item.value <= 0) continue;

      final double ratio = item.value / total;

      final double sweep = math.max(
        0,
        (totalSweep * ratio) - gap,
      );

      final bool isSelected = selectedIndex == i;

      final double currentStroke = isSelected ? strokeWidth + 6 : strokeWidth;

      final double radius = isSelected ? baseRadius + 3 : baseRadius;

      final Paint paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = currentStroke
        ..strokeCap = StrokeCap.round;

      final Rect rect = Rect.fromCircle(
        center: center,
        radius: radius,
      );

      canvas.drawArc(
        rect,
        currentAngle + (gap / 2),
        sweep,
        false,
        paint,
      );

      currentAngle += totalSweep * ratio;
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.sections != sections ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}
