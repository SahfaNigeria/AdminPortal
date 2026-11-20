import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/theme/colors.dart';
import 'app_text.dart';
import 'dashboard_container_widget.dart';

enum ChartTimeFrame { monthly, yearly }

class NewUserDataPoint {
  final String label;
  final double value;
  final int? month; // 1 to 12
  final int? year;  // e.g. 2025
  final String? note;

  const NewUserDataPoint({
    required this.label,
    required this.value,
    this.month,
    this.year,
    this.note,
  });
}

class NewUsersChart extends StatefulWidget {
  final List<NewUserDataPoint>? monthlyData;
  final List<NewUserDataPoint>? yearlyData;
  final String title;
  final String? subtitle;
  final Color? primaryColor;
  final double height;
  final ChartTimeFrame initialTimeFrame;
  final ValueChanged<NewUserDataPoint?>? onPointSelected;

  const NewUsersChart({
    Key? key,
    this.monthlyData,
    this.yearlyData,
    this.title = "User Reach & Growth",
    this.subtitle = "Track new users reached over months and years",
    this.primaryColor,
    this.height = 360,
    this.initialTimeFrame = ChartTimeFrame.monthly,
    this.onPointSelected,
  }) : super(key: key);

  @override
  State<NewUsersChart> createState() => _NewUsersChartState();
}

class _NewUsersChartState extends State<NewUsersChart> {
  late ChartTimeFrame activeTimeFrame;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    activeTimeFrame = widget.initialTimeFrame;
  }

  List<NewUserDataPoint> get _effectiveMonthlyData {
    if (widget.monthlyData != null && widget.monthlyData!.isNotEmpty) {
      return widget.monthlyData!;
    }
    // Default sample data for 12 months with realistic growth numbers
    final now = DateTime.now();
    final months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    final defaultValues = [
      320.0, 410.0, 480.0, 590.0, 720.0, 850.0,
      940.0, 1100.0, 1280.0, 1420.0, 1600.0, 1850.0
    ];

    return List.generate(12, (index) {
      return NewUserDataPoint(
        label: months[index],
        value: defaultValues[index],
        month: index + 1,
        year: now.year,
      );
    });
  }

  List<NewUserDataPoint> get _effectiveYearlyData {
    if (widget.yearlyData != null && widget.yearlyData!.isNotEmpty) {
      return widget.yearlyData!;
    }
    final currentYear = DateTime.now().year;
    return [
      NewUserDataPoint(label: "${currentYear - 4}", value: 1200, year: currentYear - 4),
      NewUserDataPoint(label: "${currentYear - 3}", value: 2400, year: currentYear - 3),
      NewUserDataPoint(label: "${currentYear - 2}", value: 4100, year: currentYear - 2),
      NewUserDataPoint(label: "${currentYear - 1}", value: 7800, year: currentYear - 1),
      NewUserDataPoint(label: "$currentYear", value: 12500, year: currentYear),
    ];
  }

  List<NewUserDataPoint> get currentDataset =>
      activeTimeFrame == ChartTimeFrame.monthly
          ? _effectiveMonthlyData
          : _effectiveYearlyData;

  int _findCurrentIndex(List<NewUserDataPoint> dataset) {
    final now = DateTime.now();
    if (activeTimeFrame == ChartTimeFrame.monthly) {
      return dataset.indexWhere((dp) => dp.month == now.month);
    } else {
      return dataset.indexWhere((dp) => dp.year == now.year);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataset = currentDataset;
    final Color effectiveColor = widget.primaryColor ?? AppColors.primary;
    final int currentIndex = _findCurrentIndex(dataset);

    // Summary Statistics
    final double totalReached = dataset.fold(0, (sum, dp) => sum + dp.value);
    final double avgValue = dataset.isNotEmpty ? totalReached / dataset.length : 0;
    
    // Find current active point or selected point
    final int highlightedIndex = selectedIndex ?? (currentIndex >= 0 ? currentIndex : dataset.length - 1);
    final NewUserDataPoint highlightedPoint = dataset.isNotEmpty
        ? dataset[math.min(highlightedIndex, dataset.length - 1)]
        : const NewUserDataPoint(label: "", value: 0);

    return DashboardContainerWidget(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with Title and TimeFrame Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Subtitle
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: effectiveColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.chartLine,
                        size: 18,
                        color: effectiveColor,
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
                          if (widget.subtitle != null) ...[
                            const SizedBox(height: 2),
                            AppText(
                              text: widget.subtitle!,
                              size: 12,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Monthly / Yearly Segmented Control
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTimeFrameTab(
                      label: "Monthly",
                      timeFrame: ChartTimeFrame.monthly,
                      color: effectiveColor,
                    ),
                    _buildTimeFrameTab(
                      label: "Yearly",
                      timeFrame: ChartTimeFrame.yearly,
                      color: effectiveColor,
                    ),
                  ],
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
                  label: "Total Reached",
                  value: "${totalReached.toInt()}",
                  icon: Icons.people_rounded,
                  color: effectiveColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricBadge(
                  label: "Average / ${activeTimeFrame == ChartTimeFrame.monthly ? 'Month' : 'Year'}",
                  value: "${avgValue.toInt()}",
                  icon: Icons.calculate_rounded,
                  color: const Color(0xFF0EA5E9),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricBadge(
                  label: selectedIndex != null
                      ? "Selected: ${highlightedPoint.label}"
                      : (currentIndex >= 0 ? "Current Period" : "Latest"),
                  value: "${highlightedPoint.value.toInt()} users",
                  icon: Icons.event_available_rounded,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Main Chart Canvas with Interaction
          SizedBox(
            height: widget.height - 140,
            width: double.infinity,
            child: TweenAnimationBuilder<double>(
              key: ValueKey(activeTimeFrame),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, animProgress, child) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onTapDown: (details) {
                        _handleChartTap(
                          details.localPosition,
                          constraints.maxWidth,
                          constraints.maxHeight,
                          dataset,
                        );
                      },
                      child: CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: _AreaLineChartPainter(
                          dataset: dataset,
                          primaryColor: effectiveColor,
                          progress: animProgress,
                          selectedIndex: selectedIndex,
                          currentIndex: currentIndex,
                          timeFrame: activeTimeFrame,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFrameTab({
    required String label,
    required ChartTimeFrame timeFrame,
    required Color color,
  }) {
    final isSelected = activeTimeFrame == timeFrame;
    return GestureDetector(
      onTap: () {
        if (activeTimeFrame != timeFrame) {
          setState(() {
            activeTimeFrame = timeFrame;
            selectedIndex = null;
            if (widget.onPointSelected != null) {
              widget.onPointSelected!(null);
            }
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
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
    required IconData icon,
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
            child: Icon(
              icon,
              size: 14,
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
                ),
                const SizedBox(height: 2),
                AppText(
                  text: value,
                  size: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleChartTap(
    Offset localPosition,
    double width,
    double height,
    List<NewUserDataPoint> dataset,
  ) {
    if (dataset.isEmpty) return;

    const double paddingLeft = 45.0;
    const double paddingRight = 20.0;

    final double chartWidth = width - paddingLeft - paddingRight;
    if (chartWidth <= 0) return;

    final double xStep = dataset.length > 1
        ? chartWidth / (dataset.length - 1)
        : chartWidth;

    double minDistance = double.infinity;
    int nearestIndex = -1;

    for (int i = 0; i < dataset.length; i++) {
      final double pointX = paddingLeft + (i * xStep);
      final double dx = (localPosition.dx - pointX).abs();
      if (dx < minDistance) {
        minDistance = dx;
        nearestIndex = i;
      }
    }

    if (nearestIndex >= 0 && minDistance < xStep / 1.5) {
      setState(() {
        if (selectedIndex == nearestIndex) {
          selectedIndex = null;
        } else {
          selectedIndex = nearestIndex;
        }
        if (widget.onPointSelected != null) {
          widget.onPointSelected!(
              selectedIndex != null ? dataset[selectedIndex!] : null);
        }
      });
    }
  }
}

class _AreaLineChartPainter extends CustomPainter {
  final List<NewUserDataPoint> dataset;
  final Color primaryColor;
  final double progress;
  final int? selectedIndex;
  final int currentIndex;
  final ChartTimeFrame timeFrame;

  _AreaLineChartPainter({
    required this.dataset,
    required this.primaryColor,
    required this.progress,
    required this.selectedIndex,
    required this.currentIndex,
    required this.timeFrame,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataset.isEmpty) return;

    const double paddingLeft = 45.0;
    const double paddingRight = 20.0;
    const double paddingTop = 30.0;
    const double paddingBottom = 30.0;

    final double chartWidth = size.width - paddingLeft - paddingRight;
    final double chartHeight = size.height - paddingTop - paddingBottom;

    if (chartWidth <= 0 || chartHeight <= 0) return;

    // Find Max Value for scaling
    double maxValue = dataset.fold(0.0, (max, dp) => math.max(max, dp.value));
    if (maxValue <= 0) maxValue = 100;
    // Add 15% top margin space
    maxValue = maxValue * 1.15;

    // Grid lines (4 horizontal steps)
    const int gridSteps = 4;
    final Paint gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final TextPainter textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
    );

    for (int i = 0; i <= gridSteps; i++) {
      final double ratio = i / gridSteps;
      final double y = paddingTop + (chartHeight * (1 - ratio));

      // Draw Grid line
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        gridPaint,
      );

      // Y-Axis label
      final double val = maxValue * ratio;
      final String labelText = val >= 1000
          ? "${(val / 1000).toStringAsFixed(1)}k"
          : "${val.toInt()}";

      textPainter.text = TextSpan(
        text: labelText,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(paddingLeft - textPainter.width - 8, y - textPainter.height / 2),
      );
    }

    // Calculate Points
    final double xStep = dataset.length > 1
        ? chartWidth / (dataset.length - 1)
        : chartWidth;

    final List<Offset> points = [];
    for (int i = 0; i < dataset.length; i++) {
      final double x = paddingLeft + (i * xStep);
      final double normalizedY = (dataset[i].value / maxValue) * progress;
      final double y = paddingTop + (chartHeight * (1 - normalizedY));
      points.add(Offset(x, y));
    }

    // Build Spline (Cubic Bezier Path)
    final Path linePath = Path();
    final Path areaPath = Path();

    if (points.isNotEmpty) {
      linePath.moveTo(points[0].dx, points[0].dy);
      areaPath.moveTo(points[0].dx, size.height - paddingBottom);
      areaPath.lineTo(points[0].dx, points[0].dy);

      for (int i = 0; i < points.length - 1; i++) {
        final Offset p0 = points[i];
        final Offset p1 = points[i + 1];

        final double controlX1 = p0.dx + (p1.dx - p0.dx) / 2;
        final double controlY1 = p0.dy;
        final double controlX2 = p0.dx + (p1.dx - p0.dx) / 2;
        final double controlY2 = p1.dy;

        linePath.cubicTo(controlX1, controlY1, controlX2, controlY2, p1.dx, p1.dy);
        areaPath.cubicTo(controlX1, controlY1, controlX2, controlY2, p1.dx, p1.dy);
      }

      areaPath.lineTo(points.last.dx, size.height - paddingBottom);
      areaPath.close();
    }

    // Draw Gradient Area Fill
    final Paint areaPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, paddingTop),
        Offset(0, size.height - paddingBottom),
        [
          primaryColor.withValues(alpha: 0.25),
          primaryColor.withValues(alpha: 0.0),
        ],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(areaPath, areaPaint);

    // Draw Main Line Path
    final Paint linePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    // Draw Points and X-Axis Labels
    for (int i = 0; i < points.length; i++) {
      final Offset pt = points[i];
      final bool isSelected = selectedIndex == i;
      final bool isCurrent = currentIndex == i;

      // Draw X-Axis Label
      textPainter.text = TextSpan(
        text: dataset[i].label,
        style: TextStyle(
          color: isSelected
              ? primaryColor
              : (isCurrent ? AppColors.textPrimary : AppColors.textSecondary),
          fontSize: 11,
          fontWeight: isSelected || isCurrent ? FontWeight.bold : FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(pt.dx - textPainter.width / 2, size.height - paddingBottom + 8),
      );

      // Current Month/Year Indicator Pin Badge (e.g. "NOW")
      if (isCurrent && !isSelected) {
        _drawBadgePin(canvas, pt, "NOW", primaryColor);
      }

      // Draw Dot
      if (isSelected) {
        // Selected Point Glow Effect
        canvas.drawCircle(
          pt,
          10,
          Paint()..color = primaryColor.withValues(alpha: 0.25),
        );
        canvas.drawCircle(
          pt,
          6,
          Paint()..color = primaryColor,
        );
        canvas.drawCircle(
          pt,
          3,
          Paint()..color = Colors.white,
        );

        // Tooltip Popup above point
        _drawTooltip(
          canvas,
          pt,
          "${dataset[i].label}: ${dataset[i].value.toInt()} users",
          primaryColor,
        );
      } else if (isCurrent) {
        // Current Period Highlight Point
        canvas.drawCircle(
          pt,
          7,
          Paint()..color = primaryColor,
        );
        canvas.drawCircle(
          pt,
          3,
          Paint()..color = Colors.white,
        );
      } else {
        // Regular Point
        canvas.drawCircle(
          pt,
          4,
          Paint()..color = Colors.white,
        );
        canvas.drawCircle(
          pt,
          4,
          Paint()
            ..color = primaryColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  void _drawTooltip(Canvas canvas, Offset point, String text, Color color) {
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    const double hp = 10.0;
    const double vp = 6.0;
    final double rectWidth = tp.width + (hp * 2);
    final double rectHeight = tp.height + (vp * 2);

    final double rectLeft = point.dx - (rectWidth / 2);
    final double rectTop = point.dy - rectHeight - 12;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight),
      const Radius.circular(8),
    );

    // Draw Tooltip Shadow & Background
    canvas.drawRRect(
      rrect.shift(const Offset(0, 2)),
      Paint()..color = Colors.black.withValues(alpha: 0.2),
    );
    canvas.drawRRect(rrect, Paint()..color = color);

    // Draw Tooltip Triangle Arrow
    final Path arrowPath = Path()
      ..moveTo(point.dx - 5, rectTop + rectHeight)
      ..lineTo(point.dx + 5, rectTop + rectHeight)
      ..lineTo(point.dx, rectTop + rectHeight + 5)
      ..close();
    canvas.drawPath(arrowPath, Paint()..color = color);

    tp.paint(canvas, Offset(rectLeft + hp, rectTop + vp));
  }

  void _drawBadgePin(Canvas canvas, Offset point, String label, Color color) {
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    const double hp = 6.0;
    const double vp = 2.0;
    final double width = tp.width + (hp * 2);
    final double height = tp.height + (vp * 2);

    final double left = point.dx - (width / 2);
    final double top = point.dy - height - 10;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, width, height),
      const Radius.circular(6),
    );

    canvas.drawRRect(
      rrect,
      Paint()..color = color.withValues(alpha: 0.15),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = color.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    tp.paint(canvas, Offset(left + hp, top + vp));
  }

  @override
  bool shouldRepaint(covariant _AreaLineChartPainter oldDelegate) {
    return oldDelegate.dataset != dataset ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.currentIndex != currentIndex ||
        oldDelegate.timeFrame != timeFrame;
  }
}
