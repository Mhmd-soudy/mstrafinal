import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Do something with the selected image
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image selected: ${pickedFile.path}')),
      );
      // You can use pickedFile.path to get the image file path
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  Future<void> pickImageFromCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Do something with the captured image
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image captured: ${pickedFile.path}')),
      );
      // You can use pickedFile.path to get the image file path
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image captured')),
      );
    }
  }
}
