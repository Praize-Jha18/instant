import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A picked image as bytes (works on web, where `File` is unavailable).
class PickedImage {
  const PickedImage({required this.bytes, required this.filename, required this.contentType});

  final Uint8List bytes;
  final String filename;
  final String contentType;
}

/// Uploads are capped by the backend at 2 MB.
const int maxImageBytes = 2 * 1024 * 1024;

/// Lets the user choose gallery or camera (camera hidden on web/desktop) and
/// returns the image bytes.
Future<PickedImage?> pickImage(BuildContext context) async {
  final picker = ImagePicker();
  ImageSource? source = ImageSource.gallery;
  final canUseCamera = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
  if (canUseCamera) {
    source = await AppBottomSheet.show<ImageSource>(
      context,
      title: 'Add photo',
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppListTile(
            leadingIcon: Icons.photo_library_outlined,
            title: 'Choose from gallery',
            onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
          ),
          AppListTile(
            leadingIcon: Icons.photo_camera_outlined,
            title: 'Take a photo',
            onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
          ),
        ],
      ),
    );
    if (source == null) return null;
  }
  final file = await picker.pickImage(source: source, maxWidth: 1600, imageQuality: 85);
  if (file == null) return null;
  final bytes = await file.readAsBytes();
  final name = file.name.isEmpty ? 'image.jpg' : file.name;
  final lower = name.toLowerCase();
  final type = file.mimeType ??
      (lower.endsWith('.png')
          ? 'image/png'
          : lower.endsWith('.webp')
              ? 'image/webp'
              : 'image/jpeg');
  return PickedImage(bytes: bytes, filename: name, contentType: type);
}
