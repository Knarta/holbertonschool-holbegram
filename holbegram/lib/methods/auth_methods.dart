// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:holbegram/models/user.dart';
import 'package:holbegram/screens/auth/methods/user_storage.dart';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Userd> getUserDetails() async {
    final User currentUser = _auth.currentUser!;
    final DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return Userd.fromSnap(snap);
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Please fill all the fields';
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'success';
    } on FirebaseAuthException catch (e) {
      return '${e.code}: ${e.message ?? 'Login failed'}';
    } catch (_) {
      return 'Login failed';
    }
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      return 'Please fill all the fields';
    }
    if (file == null) {
      return 'Please select an image';
    }

    try {
      String photoUrl = '';
      final StorageMethods storageMethods = StorageMethods();
      try {
        photoUrl = await storageMethods.uploadImageToStorage(
          false,
          'profilePics',
          file,
        );
      } catch (_) {
        photoUrl = '';
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        return 'Signup failed';
      }

      final Users users = Users(
        uid: user.uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: photoUrl,
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username.isNotEmpty ? username[0].toUpperCase() : '',
      );

      await _firestore.collection('users').doc(user.uid).set(users.toJson());
      return 'success';
    } on FirebaseAuthException catch (e) {
      return '${e.code}: ${e.message ?? 'Signup failed'}';
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}
