import 'package:material_ui/material_ui.dart';
import 'package:easy_animated_indexed_stack/easy_animated_indexed_stack.dart';

class CustomIndexedStack extends StatelessWidget {
  final List<Widget>? children;
  final int? index;
  final Curve? curve;
  final Widget Function(BuildContext, Animation<double>, Widget?)?
      animationBuilder;
  const CustomIndexedStack(
      {Key? key, this.children, this.index, this.curve, this.animationBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyAnimatedIndexedStack(
      index: index,
      clipBehavior: Clip.hardEdge,
      duration: Duration(
        milliseconds: 300,
      ),
      curve: curve ?? Curves.easeInOut,
      animationBuilder: animationBuilder ??
          (context, animation, child) {
            // final curved = CurvedAnimation(
            //   parent: animation,
            //   curve: Curves.easeInOut,
            // );
            //
            // return FadeTransition(
            //   opacity: curved,
            //   child: ScaleTransition(
            //     scale: Tween<double>(begin: 0.9, end: 1.0).animate(curved),
            //     child: child,
            //   ),
            // );

            // final curved = CurvedAnimation(
            //   parent: animation,
            //   curve: Curves.fastOutSlowIn,
            // );
            //
            // return SlideTransition(
            //   position: Tween<Offset>(
            //     begin: const Offset(0.2, 0),
            //     end: Offset.zero,
            //   ).animate(curved),
            //   child: FadeTransition(
            //     opacity: curved,
            //     child: child,
            //   ),
            // );
            // final curved = CurvedAnimation(
            //   parent: animation,
            //   curve: Curves.easeInOutBack,
            // );
            //
            // return RotationTransition(
            //   turns: Tween<double>(begin: 0.95, end: 1.0).animate(curved), // small rotation
            //   child: FadeTransition(
            //     opacity: curved,
            //     child: child,
            //   ),
            // );

            // final curved = CurvedAnimation(
            //   parent: animation,
            //   curve: Curves.fastOutSlowIn,
            // );
            //
            // return SlideTransition(
            //   position: Tween<Offset>(
            //     begin: const Offset(0.2, 0), // from right
            //     end: Offset.zero,
            //   ).animate(curved),
            //   child: child,
            // );
            //
            // final curved = CurvedAnimation(
            //   parent: animation,
            //   curve: Curves.easeInOutBack, // smoother easing
            // );
            //
            // return RotationTransition(
            //   turns: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
            //   child: child,
            // );
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut, // smooth easing
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(curved),
              child: FadeTransition(
                opacity: curved,
                child: child,
              ),
            );
          },
      children: children ?? [],
    );
  }
}
