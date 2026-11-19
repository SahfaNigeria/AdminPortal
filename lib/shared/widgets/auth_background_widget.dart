import 'package:jambomama_nigeria_admin_portal/shared/widgets/custom_form_widget.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import 'app_text.dart';
import 'custom_single_child_scroll_view.dart';
import 'package:get/get.dart';

class AuthBackgroundWidget extends StatelessWidget {
  final List<Widget>? children;
  final String? pageTitle;

  final void Function()? onChanged;

  final Key? formKey;
  final String? pageSubTitle;
  final bool isScrollable;

  const AuthBackgroundWidget({
    Key? key,
    this.children,
    this.pageTitle,
    this.pageSubTitle,
    this.onChanged,
    this.formKey,
    this.isScrollable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardContent = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 36,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.35),
                spreadRadius: 2,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: CustomFormWidget(
            formKey: formKey,
            onChanged: onChanged,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                const SizedBox(height: 24),
                AppText(text: pageTitle??"Login Pageee", style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),),
                const SizedBox(height: 24),
                AppText(text: pageSubTitle??"Login Pageee", style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary.withValues(alpha: 0.8),
                ),),
                Column(
                  children: children??[],
                )
              ],
            ),
          ),
        ),
      ),
    );

    if (isScrollable) {
      return CustomSingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: cardContent,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: cardContent,
    );
  }
}
