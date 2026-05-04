import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService {
  Future<File?> pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      int fileSizeInBytes = await image.length();
      int maxSizeInBytes = 8 * 1024 * 1024;

      if (fileSizeInBytes > maxSizeInBytes) {

      } else {
        return File(image.path);
      }
    } catch (e) {
      print('Failed to pick image: $e');
      return null;
    }
    return null;
  }

  Future<File?> pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return null;
      int fileSizeInBytes = await image.length();
      int maxSizeInBytes = 8 * 1024 * 1024;

      if (fileSizeInBytes > maxSizeInBytes) {

      } else {
        return File(image.path);
      }
    } catch (e) {
      print('Failed to pick image: $e');
      return null;
    }
    return null;
  }
}