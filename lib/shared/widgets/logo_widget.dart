import 'package:material_ui/material_ui.dart';

import '../../generated/assets.dart';

class LogoWidget extends StatelessWidget {
  final Size? size;
  const LogoWidget({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Assets.images.logoJamboMama.image(
      height: size?.height ?? 150,
      fit: BoxFit.cover,
      width: size?.width ?? 150,
    );
  }
}
