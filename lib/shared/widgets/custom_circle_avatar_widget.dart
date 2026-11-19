import 'package:material_ui/material_ui.dart';
import 'package:jambomama_nigeria_admin_portal/core/theme/colors.dart';

class CustomCircleAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final double? radius;
  const CustomCircleAvatarWidget({Key? key, this.imageUrl, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.primary,
      radius: radius ?? 30,
      backgroundImage: NetworkImage(
        imageUrl ??
            "https://images.unsplash.com/photo-1582137808224-de22c65933c0?q=80&w=388&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      ),
    );
  }
}
