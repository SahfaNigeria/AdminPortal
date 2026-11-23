import 'package:material_ui/material_ui.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';

class CustomCircleAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final double? radius;
  const CustomCircleAvatarWidget({Key? key, this.imageUrl, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    final bool isNetworkImage =
        imageUrl != null &&
            (imageUrl!.startsWith('http://') ||
                imageUrl!.startsWith('https://'));
    return CircleAvatar(
      backgroundColor: AppColors.primary,
      radius: radius ?? 30,
      backgroundImage: imageUrl == null
          ? null
          : isNetworkImage
          ? NetworkImage(imageUrl!)
          : AssetImage(imageUrl!) as ImageProvider,
    );
  }
}
