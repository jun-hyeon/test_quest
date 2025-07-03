import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final _picker = ImagePicker();

  static Future<XFile?> pickFromGallery() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  static Future<XFile?> pickFromCamera() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }

  static Future<XFile?> pickAndSet({
    required ImageSource source,
    required void Function(XFile image) onImagePicked,
  }) async {
    final image = await _picker.pickImage(source: source);
    if (image != null) {
      onImagePicked(image);
    }
    return image;
  }
}
