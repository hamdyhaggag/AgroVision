import 'package:agro_vision/features/disease_detection/Ui/widgets/source_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourcePicker extends StatelessWidget {
  final Function(String) onImageSelected;
  final ImagePicker _picker = ImagePicker();

  ImageSourcePicker({
    super.key,
    required this.onImageSelected,
  });

  Future<void> _handleImagePick(ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source);
      if (image != null) {
        onImageSelected(image.path);
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'Select Image Source',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SYNE',
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SourceButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onPressed: () => _handleImagePick(ImageSource.gallery),
              ),
              SourceButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onPressed: () => _handleImagePick(ImageSource.camera),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
