import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/screens/home.dart';
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
        (route) => false,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Holbegram',
                  style: TextStyle(
                    fontFamily: 'Billabong',
                    fontSize: 58,
                  ),
                ),
              ),
              const Center(
                child: Icon(
                  Icons.blur_circular,
                  color: Color.fromARGB(218, 226, 37, 24),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Hello, $username Welcome to Holbegram.',
                style: const TextStyle(
                  fontSize: 34,
                  fontFamily: 'Billabong',
                ),
              ),
              const Text(
                'Choose an image from your gallery or take a new one.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 28),
              Center(
                child: ClipOval(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: _image != null
                        ? Image.memory(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.person_outline, size: 150),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: selectImageFromGallery,
                    icon: const Icon(
                      Icons.photo_library_outlined,
                      size: 38,
                      color: Color.fromARGB(218, 226, 37, 24),
                    ),
                    tooltip: 'Gallery',
                  ),
                  const SizedBox(width: 80),
                  IconButton(
                    onPressed: selectImageFromCamera,
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 38,
                      color: Color.fromARGB(218, 226, 37, 24),
                    ),
                    tooltip: 'Camera',
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Center(
                child: SizedBox(
                  width: 130,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(218, 226, 37, 24),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isLoading ? null : _handleNext,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Next',
                            style: TextStyle(fontSize: 22),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
