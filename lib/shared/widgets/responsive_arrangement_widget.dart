import 'package:material_ui/material_ui.dart';

import 'custom_responsive_builder.dart';

class ResponsiveArrangementWidget extends StatelessWidget {
  final List<Widget>? children;
  final double? spacing;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final bool expandChildrenOnDesktop;

  const ResponsiveArrangementWidget({
    Key? key,
    this.children,
    this.spacing,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.expandChildrenOnDesktop = true,
  }) : super(key: key);

  Widget _unwrapExpanded(Widget widget) {
    if (widget is Expanded) {
      return widget.child;
    }
    if (widget is Flexible) {
      return widget.child;
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rawChildren = children ?? [];
    if (rawChildren.isEmpty) return const SizedBox.shrink();

    final double effectiveSpacing = spacing ?? 12.0;

    return CustomResponsiveBuilder(
      builder: (context, sizingInfo) {
        final bool isDesktop = sizingInfo.isDesktop || sizingInfo.isTablet;

        if (isDesktop) {
          final List<Widget> rowChildren = [];
          for (int i = 0; i < rawChildren.length; i++) {
            final Widget unwrapped = _unwrapExpanded(rawChildren[i]);
            final Widget item = expandChildrenOnDesktop
                ? Expanded(child: unwrapped)
                : unwrapped;
            rowChildren.add(item);
            if (i < rawChildren.length - 1 && effectiveSpacing > 0) {
              rowChildren.add(SizedBox(width: effectiveSpacing));
            }
          }

          return Row(
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment:
                crossAxisAlignment ?? CrossAxisAlignment.center,
            children: rowChildren,
          );
        }

        // Mobile / Small screen: Vertical Column
        final List<Widget> columnChildren = [];
        for (int i = 0; i < rawChildren.length; i++) {
          final Widget unwrapped = _unwrapExpanded(rawChildren[i]);
          columnChildren.add(unwrapped);
          if (i < rawChildren.length - 1 && effectiveSpacing > 0) {
            columnChildren.add(SizedBox(height: effectiveSpacing));
          }
        }

        return Column(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          crossAxisAlignment:
              crossAxisAlignment ?? CrossAxisAlignment.stretch,
          children: columnChildren,
        );
      },
    );
  }
}
