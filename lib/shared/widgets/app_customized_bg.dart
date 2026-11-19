import 'package:flutter/material.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';
import 'custom_scaffold.dart';

class AppCustomizedBg extends StatelessWidget {
  final Widget? body;
  final Widget? drawer;
  const AppCustomizedBg({Key? key, this.body, this.drawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      resizeToAvoidBottomInset: false,
      drawer: drawer,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/customized_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      body: Container(
        color: AppColors.surface.withValues(alpha: 0.5),
        child: body,
      ),
    );
  }
}
