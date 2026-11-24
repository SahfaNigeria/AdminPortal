import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  const CachedNetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final trimmedUrl = imageUrl.trim();
    final image = trimmedUrl.isEmpty
        ? _errorWidget()
        : CachedNetworkImage(
            key: ValueKey(trimmedUrl),
            imageUrl: trimmedUrl,
            width: width,
            height: height,
            fit: fit,
            placeholder: (context, url) =>
                placeholder ?? const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) {
              debugPrint('Unable to load network image $url: $error');
              return errorWidget ?? _errorWidget();
            },
          );

    if (borderRadius == null) return image;

    return ClipRRect(
      borderRadius: borderRadius!,
      child: image,
    );
  }

  Widget _errorWidget() {
    return  errorWidget ??
        Icon(
          Icons.broken_image_outlined,
          color: AppColors.textSecondary,
          size: 32,
        );
  }
}
