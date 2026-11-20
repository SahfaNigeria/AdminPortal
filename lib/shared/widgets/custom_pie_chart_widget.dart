import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jambomama_nigeria_admin_portal/shared/widgets/section_title_widget.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/theme/colors.dart';
import 'app_text.dart';
import 'dashboard_container_widget.dart';

class CustomPieChartWidget extends StatefulWidget {
  final double maleCount;
  final double femaleCount;
  final String maleLabel;
  final String femaleLabel;
  final Color? maleColor;
  final Color? femaleColor;
  final String title;
  final String? subtitle;
  final bool showLegend;
  final bool showPercentages;
  final double height;
  final double strokeWidth;
  final ValueChanged<int?>? onSectionSelected;

  const CustomPieChartWidget({
    Key? key,
    this.maleCount = 60,
    this.femaleCount = 40,
    this.maleLabel = "Men",
    this.femaleLabel = "Women",
    this.maleColor,
    this.femaleColor,
    this.title = "Gender Distribution",
    this.subtitle = "Percentage of platform users by gender",
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

  @override
  Widget build(BuildContext context) {
    final double total = widget.maleCount + widget.femaleCount;
    final double malePercentage =
        total > 0 ? (widget.maleCount / total) * 100 : 0;
    final double femalePercentage =
        total > 0 ? (widget.femaleCount / total) * 100 : 0;

    final Color effectiveMaleColor =
        widget.maleColor ?? const Color(0xFF0EA5E9);
    final Color effectiveFemaleColor = widget.femaleColor ?? AppColors.primary;

    return DashboardContainerWidget(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          SectionTitleWidget(

            title: widget.title,
            subtitle: widget.subtitle,
            icon: FontAwesomeIcons.chartPie,
          ),

          // Pie / Donut Chart Container
          SizedBox(
            height: widget.height,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, animValue, child) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final double size = math.min(
                        constraints.maxWidth, constraints.maxHeight);
                    final Offset center = Offset(
                        constraints.maxWidth / 2, constraints.maxHeight / 2);

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
                          // Normalize angle to [0, 2*pi) starting from top (-pi/2)
                          angle = angle + math.pi / 2;
                          if (angle < 0) angle += 2 * math.pi;

                          final double maleAngle =
                              total > 0 ? (widget.maleCount / total) * 2 * math.pi : math.pi;

                          setState(() {
                            if (angle <= maleAngle) {
                              selectedIndex = (selectedIndex == 0) ? null : 0;
                            } else {
                              selectedIndex = (selectedIndex == 1) ? null : 1;
                            }
                            if (widget.onSectionSelected != null) {
                              widget.onSectionSelected!(selectedIndex);
                            }
                          });
                        } else {
                          setState(() {
                            selectedIndex = null;
                            if (widget.onSectionSelected != null) {
                              widget.onSectionSelected!(null);
                            }
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: Size(constraints.maxWidth, constraints.maxHeight),
                            painter: _PieChartPainter(
                              maleCount: widget.maleCount,
                              femaleCount: widget.femaleCount,
                              maleColor: effectiveMaleColor,
                              femaleColor: effectiveFemaleColor,
                              strokeWidth: widget.strokeWidth,
                              progress: animValue,
                              selectedIndex: selectedIndex,
                            ),
                          ),
                          // Donut Center Text Display
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                text: selectedIndex == 0
                                    ? "${malePercentage.toStringAsFixed(1)}%"
                                    : selectedIndex == 1
                                        ? "${femalePercentage.toStringAsFixed(1)}%"
                                        : "${total.toInt()}",
                                size: 22,
                                fontWeight: FontWeight.bold,
                                color: selectedIndex == 0
                                    ? effectiveMaleColor
                                    : selectedIndex == 1
                                        ? effectiveFemaleColor
                                        : AppColors.textPrimary,
                              ),
                              AppText(
                                text: selectedIndex == 0
                                    ? widget.maleLabel
                                    : selectedIndex == 1
                                        ? widget.femaleLabel
                                        : "Total Users",
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
            // Legend Cards
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = (selectedIndex == 0) ? null : 0;
                        if (widget.onSectionSelected != null) {
                          widget.onSectionSelected!(selectedIndex);
                        }
                      });
                    },
                    child: _buildLegendTile(
                      label: widget.maleLabel,
                      count: widget.maleCount.toInt(),
                      percentage: malePercentage,
                      color: effectiveMaleColor,
                      icon: Icons.male_rounded,
                      isSelected: selectedIndex == 0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = (selectedIndex == 1) ? null : 1;
                        if (widget.onSectionSelected != null) {
                          widget.onSectionSelected!(selectedIndex);
                        }
                      });
                    },
                    child: _buildLegendTile(
                      label: widget.femaleLabel,
                      count: widget.femaleCount.toInt(),
                      percentage: femalePercentage,
                      color: effectiveFemaleColor,
                      icon: Icons.female_rounded,
                      isSelected: selectedIndex == 1,
                    ),
                  ),
                ),
              ],
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
    required IconData icon,
    required bool isSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isSelected ? 0.14 : 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: isSelected ? 0.6 : 0.2),
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
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: label,
                  size: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: 2),
                AppText(
                  text: "$count users",
                  size: 11,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
  final double maleCount;
  final double femaleCount;
  final Color maleColor;
  final Color femaleColor;
  final double strokeWidth;
  final double progress;
  final int? selectedIndex;

  _PieChartPainter({
    required this.maleCount,
    required this.femaleCount,
    required this.maleColor,
    required this.femaleColor,
    required this.strokeWidth,
    required this.progress,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double total = maleCount + femaleCount;
    if (total <= 0) return;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double chartSize = math.min(size.width, size.height);
    final double radius = (chartSize - strokeWidth - 16) / 2;

    const double startAngle = -math.pi / 2; // top center
    final double totalSweep = 2 * math.pi * progress;

    final double maleRatio = maleCount / total;
    final double femaleRatio = femaleCount / total;

    // Gap between slices (in radians)
    const double gap = 0.04;

    // Male Arc
    final double maleSweep = math.max(0, (totalSweep * maleRatio) - gap);
    final double maleStroke = selectedIndex == 0 ? strokeWidth + 6 : strokeWidth;
    final Paint malePaint = Paint()
      ..color = maleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = maleStroke
      ..strokeCap = StrokeCap.round;

    final Rect maleRect = Rect.fromCircle(
      center: center,
      radius: selectedIndex == 0 ? radius + 3 : radius,
    );

    canvas.drawArc(maleRect, startAngle + (gap / 2), maleSweep, false, malePaint);

    // Female Arc
    final double femaleStartAngle = startAngle + (totalSweep * maleRatio) + (gap / 2);
    final double femaleSweep = math.max(0, (totalSweep * femaleRatio) - gap);
    final double femaleStroke = selectedIndex == 1 ? strokeWidth + 6 : strokeWidth;
    final Paint femalePaint = Paint()
      ..color = femaleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = femaleStroke
      ..strokeCap = StrokeCap.round;

    final Rect femaleRect = Rect.fromCircle(
      center: center,
      radius: selectedIndex == 1 ? radius + 3 : radius,
    );

    canvas.drawArc(femaleRect, femaleStartAngle, femaleSweep, false, femalePaint);
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.maleCount != maleCount ||
        oldDelegate.femaleCount != femaleCount ||
        oldDelegate.maleColor != maleColor ||
        oldDelegate.femaleColor != femaleColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}
