import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/models/user.dart';
import 'package:holbegram/screens/home.dart';
import 'package:holbegram/screens/pages/methods/post_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _captionController = TextEditingController();
  final PostStorage _postStorage = PostStorage();
  final AuthMethode _authMethode = AuthMethode();
  Uint8List? _image;
  bool _isLoading = false;
  Userd? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final Userd user = await _authMethode.getUserDetails();
      if (!mounted) return;
      setState(() {
        _currentUser = user;
      });
    } catch (_) {}
  }

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

  Future<void> _handlePost() async {
    if (_isLoading) return;
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not loaded yet')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String res = await _postStorage.uploadPost(
      _captionController.text.trim(),
      _currentUser!.uid,
      _currentUser!.username,
      _currentUser!.photoUrl,
      _image!,
    );

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    if (res == 'Ok') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post uploaded')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Image',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handlePost,
            child: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Post',
                    style: TextStyle(
                      fontFamily: 'Billabong',
                      fontSize: 36,
                      color: Color.fromARGB(218, 226, 37, 24),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Add Image',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Billabong',
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Choose an image from your gallery or take a one.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _captionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  onTap: selectImageFromGallery,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 90),
                    width: 180,
                    height: 180,
                    color: const Color.fromARGB(255, 238, 238, 238),
                    child: _image != null
                        ? Image.memory(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.add_to_photos_outlined,
                            size: 72,
                            color: Color.fromARGB(255, 14, 33, 51),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: selectImageFromCamera,
                    icon: const Icon(Icons.camera_alt, size: 30),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: selectImageFromGallery,
                    icon: const Icon(Icons.photo_library, size: 30),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
