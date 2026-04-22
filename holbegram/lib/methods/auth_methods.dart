import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'dart:typed_data';
import 'package:holbegram/models/user.dart' as model;

class AuthMethode {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    } on fb_auth.FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed';
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

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fb_auth.User? user = userCredential.user;
      if (user == null) {
        return 'Signup failed';
      }

      final model.User users = model.User(
        uid: user.uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: '',
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username.isNotEmpty ? username[0].toUpperCase() : '',
      );

      await _firestore.collection('users').doc(user.uid).set(users.toJson());
      return 'success';
    } on fb_auth.FirebaseAuthException catch (e) {
      return e.message ?? 'Signup failed';
    } catch (_) {
      return 'Signup failed';
    }
  }
}
