import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? drawer;
  final bool shouldCheckInternetStatus;
  final bool extendBody;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Decoration? foregroundDecoration;
  final void Function()? onTap;

  final Widget? bottomSheet;

  final Color? backgroundColor;
  final Decoration? decoration;
  final double? width;

  final Color? systemNavigationBarColor;
  final double? height;
  final bool isDifferentStatusBar;

  final Widget? floatingActionButton;

  final bool? resizeToAvoidBottomInset;
  final Color? statusBarColor;

  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  const CustomScaffold(
      {Key? key,
      this.body,
      this.extendBody = false,
      this.bottomNavigationBar,
      this.resizeToAvoidBottomInset,
      this.floatingActionButton,
      this.backgroundColor,
      this.bottomSheet,
      this.margin,
      this.decoration,
      this.width,
      this.height,
      this.padding,
      this.appBar,
      this.isDifferentStatusBar = false,
      this.statusBarColor,
      this.foregroundDecoration,
      this.onTap,
      this.systemNavigationBarColor,
      this.shouldCheckInternetStatus = true, this.drawer})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap ?? () => Get.focusScope?.unfocus(),
      child: Scaffold(
        drawer: drawer,
        appBar: appBar,
        body: Container(
          width: width,
          foregroundDecoration: foregroundDecoration,
          height: height,
          margin: margin,
          padding: padding,
          decoration: decoration,
          child: body,
        ),
        backgroundColor: backgroundColor,
        bottomSheet: bottomSheet,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        extendBody: extendBody,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }
}
