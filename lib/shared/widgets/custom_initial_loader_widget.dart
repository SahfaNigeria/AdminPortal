import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import 'custom_circular_progress_indicator.dart';

class CustomInitialLoaderWidget extends StatelessWidget {
  const CustomInitialLoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
        ),
        Center(
          child: CustomCircularProgressIndicator(
            height: 20,
            color: AppColors.primary,
            width: 20,
          ),
        ),
      ],
    );
  }
}
