import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/models/user.dart';

class UserProvider with ChangeNotifier {
  Userd _user = Users(
    uid: '',
    email: '',
    username: '',
    bio: '',
    photoUrl: '',
    followers: [],
    following: [],
    posts: [],
    saved: [],
    searchKey: '',
  );
  final AuthMethode _authMethode = AuthMethode();

  Userd get user => _user;

  Future refreshUser() async {
    final Userd user = await _authMethode.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
