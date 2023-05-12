import 'dart:async';

import 'package:contacts/services/session.dart';
import 'package:contacts/ui/FirebaseDatabase/contacts_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ui/auth/login_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    if (user == null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())));
    } else {
      SessionController().userId = user.uid.toString();
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ContactsScreen())));
    }
  }
}
