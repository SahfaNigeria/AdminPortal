
import 'package:flutter/widgets.dart';

import '../../core/theme/colors.dart';
import 'app_text.dart';

class HeaderOptionsWidget extends StatelessWidget {
  final String? title;
  const HeaderOptionsWidget({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: title??"Analytics",
      fontWeight: FontWeight.w500,
      size: 18,
      color: AppColors.textSecondary,
    );
  }
}
