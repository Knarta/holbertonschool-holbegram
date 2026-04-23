import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;
  final ImagePicker _picker = ImagePicker();

  void selectImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  void selectImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  Widget _buildActionIcon({
    required String assetPath,
    required IconData fallbackIcon,
  }) {
    return Image.asset(
      assetPath,
      width: 34,
      height: 34,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Icon(fallbackIcon, size: 30);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Picture')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                width: 120,
                height: 120,
                child: _image != null
                    ? Image.memory(
                        _image!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/next.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, size: 60);
                        },
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: selectImageFromCamera,
                  icon: _buildActionIcon(
                    assetPath:
                        'assets/images/WhatsApp_Image_2022-11-26_at_15.51.35_30.jpg',
                    fallbackIcon: Icons.camera_alt,
                  ),
                  tooltip: 'Camera',
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: selectImageFromGallery,
                  icon: _buildActionIcon(
                    assetPath: 'assets/images/aaaaaaaaaaaaaaaaaaaaaaa.png',
                    fallbackIcon: Icons.photo_library,
                  ),
                  tooltip: 'Gallery',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
