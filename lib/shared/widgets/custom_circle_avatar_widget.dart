import 'package:firebase_storage/firebase_storage.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import 'cached_network_image_widget.dart';

class CustomCircleAvatarWidget extends StatefulWidget {
  final String? imageUrl;
  final double? radius;

  const CustomCircleAvatarWidget({Key? key, this.imageUrl, this.radius})
      : super(key: key);

  @override
  State<CustomCircleAvatarWidget> createState() =>
      _CustomCircleAvatarWidgetState();
}

class _CustomCircleAvatarWidgetState extends State<CustomCircleAvatarWidget> {
  late String _source;
  Future<String>? _storageUrl;
  late bool _isDirectNetworkUrl;
  late bool _isFirebaseStorageUrl;

  @override
  void initState() {
    super.initState();
    _updateSource();
  }

  @override
  void didUpdateWidget(covariant CustomCircleAvatarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) _updateSource();
  }

  void _updateSource() {
    _source = widget.imageUrl?.trim() ?? '';
    final uri = Uri.tryParse(_source);
    final isNetworkImage =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    _isFirebaseStorageUrl =
        uri?.host.toLowerCase() == 'firebasestorage.googleapis.com';
    _isDirectNetworkUrl = isNetworkImage && !_isFirebaseStorageUrl;

    _storageUrl = _source.isNotEmpty &&
            !_isDirectNetworkUrl &&
            !_source.startsWith('assets/')
        ? _resolveStorageUrl(_source)
        : null;
  }

  Future<String> _resolveStorageUrl(String source) async {
    final reference = source.startsWith('gs://') || source.startsWith('http')
        ? FirebaseStorage.instance.refFromURL(source)
        : FirebaseStorage.instance.ref(source.replaceFirst(RegExp(r'^/+'), ''));
    return reference.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.radius ?? 30;

    return CircleAvatar(
      backgroundColor: AppColors.primary,
      radius: size,
      child: ClipOval(
        child: _source.isEmpty
            ? _placeholder(size)
            : _isDirectNetworkUrl
                ? _networkImage(_source, size)
                : _source.startsWith('assets/')
                    ? Image.asset(
                        _source,
                        width: size * 2,
                        height: size * 2,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _placeholder(size),
                      )
                    : FutureBuilder<String>(
                        future: _storageUrl,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            debugPrint(
                              'Unable to resolve profile image: ${snapshot.error}',
                            );
                            if (_isFirebaseStorageUrl) {
                              return _networkImage(_source, size);
                            }
                            return _placeholder(size);
                          }
                          if (!snapshot.hasData) return _placeholder(size);
                          return _networkImage(snapshot.data!, size);
                        },
                      ),
      ),
    );
  }

  Widget _networkImage(String url, double size) {
    return CachedNetworkImageWidget(
      imageUrl: url,
      width: size * 2,
      height: size * 2,
      placeholder: _placeholder(size),
      errorWidget: _placeholder(size),
    );
  }

  Widget _placeholder(double size) {
    return Icon(
      Icons.person_outline_rounded,
      size: size,
      color: Colors.white,
    );
  }
}
