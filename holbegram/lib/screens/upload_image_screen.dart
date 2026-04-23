import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
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
  final AuthMethode _authMethode = AuthMethode();
  bool _isLoading = false;

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

  Future<void> _handleNext() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final String email = widget.email;
    final String username = widget.username;
    final String password = widget.password;

    final String res = await _authMethode.signUpUser(
      email: email,
      username: username,
      password: password,
      file: _image,
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('success')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String username = widget.username;

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
                        errorBuilder: (_, __, ___) {
                          return const Icon(Icons.person, size: 60);
                        },
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              username,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: selectImageFromCamera,
                  icon: const Icon(Icons.camera_alt, size: 30),
                  tooltip: 'Camera',
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: selectImageFromGallery,
                  icon: const Icon(Icons.photo_library, size: 30),
                  tooltip: 'Gallery',
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleNext,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
