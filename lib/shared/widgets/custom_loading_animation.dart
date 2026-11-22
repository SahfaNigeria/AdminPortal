import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import '../../generated/assets.dart';
import 'app_text.dart';

class CustomLoadingAnimation extends StatefulWidget {
  /// Optional progress value between 0.0 and 1.0.
  /// If null, an indeterminate continuous loading spinner is displayed.
  final double? progress;

  /// Overall outer diameter of the loading animation widget.
  final double size;

  /// Inner logo size.
  final double logoSize;

  /// Primary color for the spinning arc.
  final Color? color;

  /// Track color for the spinner ring.
  final Color? trackColor;

  /// Optional main title text below the loader.
  final String? title;

  /// Optional subtitle text below the main title.
  final String? subtitle;

  /// Whether to show the percentage text when [progress] is specified.
  final bool showPercentage;

  /// Custom logo widget. If null, defaults to app logo.
  final Widget? logo;

  /// Thickness of the outer spinner ring.
  final double strokeWidth;

  const CustomLoadingAnimation({
    Key? key,
    this.progress,
    this.size = 190.0,
    this.logoSize = 100.0,
    this.color,
    this.trackColor,
    this.title,
    this.subtitle,
    this.showPercentage = true,
    this.logo,
    this.strokeWidth = 5.0,
  }) : super(key: key);

  @override
  State<CustomLoadingAnimation> createState() => _CustomLoadingAnimationState();
}

class _CustomLoadingAnimationState extends State<CustomLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = widget.color ?? AppColors.primary;
    final Color trackColor =
        widget.trackColor ?? primaryColor.withValues(alpha: 0.12);
    final bool isDeterminate = widget.progress != null;
    final double clampedProgress = (widget.progress ?? 0.0).clamp(0.0, 1.0);

    final double innerCircleSize = widget.size - 45;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double rotationAngle = _controller.value * 2 * math.pi * 2;
                final double pulseScale = 1.0 +
                    0.05 * math.sin(_controller.value * 2 * math.pi);

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Ring Painter (Spinner arc)
                    CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: _LoadingRingPainter(
                        progress: clampedProgress,
                        rotationAngle: rotationAngle,
                        primaryColor: primaryColor,
                        trackColor: trackColor,
                        strokeWidth: widget.strokeWidth,
                        isIndeterminate: !isDeterminate,
                      ),
                    ),

                    // Center Pulsating Circular Logo Container
                    Transform.scale(
                      scale: pulseScale,
                      child: Container(
                        width: innerCircleSize,
                        height: innerCircleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.18),
                              blurRadius: 25,
                              spreadRadius: 2,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: widget.logo ??
                              Assets.images.logoJamboMama.image(
                                width: widget.logoSize,
                                height: widget.logoSize,
                                fit: BoxFit.contain,
                              ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Percentage Text (if determinate progress provided)
          if (isDeterminate && widget.showPercentage) ...[
            const SizedBox(height: 16),
            AppText(
              text: "${(clampedProgress * 100).toInt()}%",
              size: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ],

          // Optional Title
          if (widget.title != null) ...[
            const SizedBox(height: 24),
            AppText(
              text: widget.title!,
              size: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              textAlign: TextAlign.center,
            ),
          ],

          // Optional Subtitle
          if (widget.subtitle != null) ...[
            const SizedBox(height: 6),
            AppText(
              text: widget.subtitle!,
              size: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _LoadingRingPainter extends CustomPainter {
  final double progress;
  final double rotationAngle;
  final Color primaryColor;
  final Color trackColor;
  final double strokeWidth;
  final bool isIndeterminate;

  _LoadingRingPainter({
    required this.progress,
    required this.rotationAngle,
    required this.primaryColor,
    required this.trackColor,
    required this.strokeWidth,
    required this.isIndeterminate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    // Draw background track ring
    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Draw active arc
    final Paint activePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    if (isIndeterminate) {
      const double sweepAngle = math.pi * 0.75; // ~135 degree arc
      canvas.drawArc(
        rect,
        rotationAngle,
        sweepAngle,
        false,
        activePaint,
      );
    } else {
      final double sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        rect,
        -math.pi / 2,
        sweepAngle,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LoadingRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.isIndeterminate != isIndeterminate;
  }
}
