import 'package:expandable/expandable.dart';
// expandable's InkWell requires Flutter's Material implementation.
// ignore: deprecated_member_use
import 'package:flutter/material.dart' as flutter;
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import 'app_text.dart';

/// A modern, customizable expandable tile widget built using `expandable: ^5.0.1`.
///
/// Features:
/// - Custom title, subtitle, leading, and trailing widgets.
/// - Smooth expand/collapse animations with configurable curves and duration.
/// - Customizable background colors, borders, shadows, and border radii (with expanded state highlights).
/// - Divider option between header and body when expanded.
/// - Supports both a single [expandedChild] or a list of [children].
/// - External or internal [ExpandableController] support.
class CustomExpandableTileWidget extends StatefulWidget {
  /// The title text to display in the header.
  final String? title;

  /// Custom widget for the title. If provided, [title] string is ignored.
  final Widget? titleWidget;

  /// Style for the [title] text.
  final TextStyle? titleStyle;

  /// Subtitle text to display below the title.
  final String? subtitle;

  /// Custom widget for the subtitle. If provided, [subtitle] string is ignored.
  final Widget? subtitleWidget;

  /// Style for the [subtitle] text.
  final TextStyle? subtitleStyle;

  /// Widget displayed before the title (e.g., Icon, Avatar).
  final Widget? leading;

  /// Custom trailing widget. If null and [showExpandIcon] is true, an animated expand/collapse icon is shown.
  final Widget? trailing;

  /// Main content widget to display when expanded.
  final Widget? expandedChild;

  /// List of widgets to display in a column when expanded (used if [expandedChild] is null).
  final List<Widget>? children;

  /// Optional content widget to display when collapsed.
  final Widget? collapsedChild;

  /// Optional controller to externally manage expansion state.
  final ExpandableController? controller;

  /// Initial expansion state if no controller is provided. Default is `false`.
  final bool initiallyExpanded;

  /// Callback when expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// Whether to show the expansion arrow icon when [trailing] is null. Default is `true`.
  final bool showExpandIcon;

  /// Icon to show when collapsed. Default is [Icons.keyboard_arrow_down_rounded].
  final IconData expandIcon;

  /// Icon to show when expanded. Default is [Icons.keyboard_arrow_up_rounded].
  final IconData collapseIcon;

  /// Color of the expansion icon.
  final Color? iconColor;

  /// Color of the expansion icon when expanded.
  final Color? expandedIconColor;

  /// Size of the expansion icon. Default is `22.0`.
  final double iconSize;

  /// Background color of the tile in collapsed state.
  final Color? backgroundColor;

  /// Background color of the tile in expanded state.
  final Color? expandedBackgroundColor;

  /// Border color of the tile.
  final Color? borderColor;

  /// Border color when expanded.
  final Color? expandedBorderColor;

  /// Border radius for the tile container. Default is `12.0`.
  final BorderRadius? borderRadius;

  /// Custom border for the tile.
  final BoxBorder? border;

  /// Custom border when expanded.
  final BoxBorder? expandedBorder;

  /// Box shadow for the tile container.
  final List<BoxShadow>? boxShadow;

  /// Box shadow when expanded.
  final List<BoxShadow>? expandedBoxShadow;

  /// Padding for the header section. Default is `EdgeInsets.symmetric(horizontal: 16, vertical: 14)`.
  final EdgeInsetsGeometry? headerPadding;

  /// Padding for the content section when expanded. Default is `EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8)`.
  final EdgeInsetsGeometry? contentPadding;

  /// Margin surrounding the tile container. Default is `EdgeInsets.symmetric(vertical: 6)`.
  final EdgeInsetsGeometry? margin;

  /// Whether to show a divider between the header and expanded content. Default is `false`.
  final bool showDivider;

  /// Color of the divider when [showDivider] is true.
  final Color? dividerColor;

  /// Thickness of the divider. Default is `1.0`.
  final double dividerThickness;

  /// Duration of the expansion animation. Default is `300ms`.
  final Duration animationDuration;

  /// Curve for fade animation. Default is [Curves.easeInOut].
  final Curve fadeCurve;

  /// Curve for size animation. Default is [Curves.fastOutSlowIn].
  final Curve sizeCurve;

  /// Whether tapping the header toggles expansion. Default is `true`.
  final bool tapHeaderToExpand;

  /// Whether tapping the body collapses it. Default is `false`.
  final bool tapBodyToCollapse;

  /// Whether tapping the body expands it. Default is `false`.
  final bool tapBodyToExpand;

  /// Whether to automatically scroll on expand. Default is `true`.
  final bool scrollOnExpand;

  /// Whether to automatically scroll on collapse. Default is `false`.
  final bool scrollOnCollapse;

  const CustomExpandableTileWidget({
    Key? key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.subtitle,
    this.subtitleWidget,
    this.subtitleStyle,
    this.leading,
    this.trailing,
    this.expandedChild,
    this.children,
    this.collapsedChild,
    this.controller,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.showExpandIcon = true,
    this.expandIcon = Icons.keyboard_arrow_down_rounded,
    this.collapseIcon = Icons.keyboard_arrow_up_rounded,
    this.iconColor,
    this.expandedIconColor,
    this.iconSize = 22.0,
    this.backgroundColor,
    this.expandedBackgroundColor,
    this.borderColor,
    this.expandedBorderColor,
    this.borderRadius,
    this.border,
    this.expandedBorder,
    this.boxShadow,
    this.expandedBoxShadow,
    this.headerPadding,
    this.contentPadding,
    this.margin,
    this.showDivider = false,
    this.dividerColor,
    this.dividerThickness = 1.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.fadeCurve = Curves.easeInOut,
    this.sizeCurve = Curves.fastOutSlowIn,
    this.tapHeaderToExpand = true,
    this.tapBodyToCollapse = false,
    this.tapBodyToExpand = false,
    this.scrollOnExpand = true,
    this.scrollOnCollapse = false,
  }) : super(key: key);

  @override
  State<CustomExpandableTileWidget> createState() => _CustomExpandableTileWidgetState();
}

class _CustomExpandableTileWidgetState extends State<CustomExpandableTileWidget> {
  ExpandableController? _internalController;

  ExpandableController get _controller => widget.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = ExpandableController(initialExpanded: widget.initiallyExpanded);
    }
    _controller.addListener(_handleExpandedChanged);
  }

  @override
  void didUpdateWidget(covariant CustomExpandableTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleExpandedChanged);
      _internalController?.removeListener(_handleExpandedChanged);
      
      if (widget.controller == null) {
        _internalController ??= ExpandableController(initialExpanded: widget.initiallyExpanded);
      } else {
        _internalController?.dispose();
        _internalController = null;
      }
      _controller.addListener(_handleExpandedChanged);
    }
  }

  void _handleExpandedChanged() {
    widget.onExpansionChanged?.call(_controller.expanded);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleExpandedChanged);
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpanded = _controller.expanded;
    final BorderRadius effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(12);

    final Color effectiveBgColor = isExpanded
        ? (widget.expandedBackgroundColor ?? widget.backgroundColor ?? AppColors.surface)
        : (widget.backgroundColor ?? AppColors.surface);

    final BoxBorder effectiveBorder = isExpanded
        ? (widget.expandedBorder ??
            Border.all(
              color: widget.expandedBorderColor ?? widget.borderColor ?? AppColors.border.withValues(alpha: 0.3),
              width: 1,
            ))
        : (widget.border ??
            Border.all(
              color: widget.borderColor ?? AppColors.border.withValues(alpha: 0.3),
              width: 1,
            ));

    final List<BoxShadow> effectiveShadow = isExpanded
        ? (widget.expandedBoxShadow ??
            widget.boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ])
        : (widget.boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ]);

    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 6),
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: widget.fadeCurve,
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: effectiveBorderRadius,
          border: effectiveBorder,
          boxShadow: effectiveShadow,
        ),
        child: flutter.Material(
          color: Colors.transparent,
          borderRadius: effectiveBorderRadius,
          clipBehavior: Clip.antiAlias,
          child: ExpandableNotifier(
            controller: _controller,
            child: ScrollOnExpand(
              scrollOnExpand: widget.scrollOnExpand,
              scrollOnCollapse: widget.scrollOnCollapse,
              child: ExpandablePanel(
                theme: ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapHeaderToExpand: widget.tapHeaderToExpand,
                  tapBodyToCollapse: widget.tapBodyToCollapse,
                  tapBodyToExpand: widget.tapBodyToExpand,
                  hasIcon: false,
                  animationDuration: widget.animationDuration,
                  fadeCurve: widget.fadeCurve,
                  sizeCurve: widget.sizeCurve,
                ),
                header: Padding(
                  padding: widget.headerPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      if (widget.leading != null) ...[
                        widget.leading!,
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.titleWidget != null)
                              widget.titleWidget!
                            else if (widget.title != null)
                              AppText(
                                text: widget.title!,
                                size: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                style: widget.titleStyle,
                              ),
                            if (widget.subtitleWidget != null) ...[
                              const SizedBox(height: 4),
                              widget.subtitleWidget!,
                            ] else if (widget.subtitle != null) ...[
                              const SizedBox(height: 4),
                              AppText(
                                text: widget.subtitle!,
                                size: 12,
                                color: AppColors.textSecondary,
                                style: widget.subtitleStyle,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.trailing != null) ...[
                        const SizedBox(width: 8),
                        widget.trailing!,
                      ] else if (widget.showExpandIcon) ...[
                        const SizedBox(width: 8),
                        ExpandableIcon(
                          theme: ExpandableThemeData(
                            expandIcon: widget.expandIcon,
                            collapseIcon: widget.collapseIcon,
                            iconColor: isExpanded
                                ? (widget.expandedIconColor ?? widget.iconColor ?? AppColors.primary)
                                : (widget.iconColor ?? AppColors.textSecondary),
                            iconSize: widget.iconSize,
                            iconRotationAngle: 3.141592653589793,
                            hasIcon: true,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                collapsed: widget.collapsedChild ?? const SizedBox.shrink(),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.showDivider)
                      Divider(
                        height: widget.dividerThickness,
                        thickness: widget.dividerThickness,
                        color: widget.dividerColor ?? AppColors.border.withValues(alpha: 0.2),
                      ),
                    Padding(
                      padding: widget.contentPadding ??
                          const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            top: 8,
                          ),
                      child: widget.expandedChild ??
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: widget.children ?? const [],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
