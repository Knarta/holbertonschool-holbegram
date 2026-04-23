import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holbegram/models/post.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';
import 'package:uuid/uuid.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    try {
      final String postId = const Uuid().v1();
      final StorageMethods storageMethods = StorageMethods();
      final String postUrl = await storageMethods.uploadImageToCloudinary(
        true,
        'posts',
        image,
      );

      final Post post = Post(
        caption: caption,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profImage,
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());
      return 'Ok';
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  Future<void> deletePost(String postId, String publicId) async {
    if (publicId.isNotEmpty) {
      // publicId is kept for Cloudinary deletion compatibility.
    }
    await _firestore.collection('posts').doc(postId).delete();
  }
}
