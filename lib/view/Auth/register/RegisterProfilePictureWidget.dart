import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterProfilePictureWidget extends StatefulWidget {
  final void Function(File?) onImagePicked; // Callback to notify parent

  RegisterProfilePictureWidget({required this.onImagePicked});

  @override
  _RegisterProfilePictureWidgetState createState() =>
      _RegisterProfilePictureWidgetState();
}

class _RegisterProfilePictureWidgetState
    extends State<RegisterProfilePictureWidget> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      widget.onImagePicked(_imageFile); // Notify parent about the picked image
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage, // Call _pickImage on tap
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 161, 216, 185),
                  const Color.fromARGB(255, 124, 202, 237),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.height * 0.15,
                    )
                  : Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.height * 0.10,
                      color: Colors.white,
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Background color for the icon
              ),
              padding:
                  const EdgeInsets.all(4), // Padding for better icon appearance
              child: Icon(
                Icons.camera_alt,
                color: const Color.fromARGB(255, 82, 174, 88),
                size: MediaQuery.of(context).size.width *
                    0.1, // Adjust size as per your preference
              ),
            ),
          ),
        ],
      ),
    );
  }
}
