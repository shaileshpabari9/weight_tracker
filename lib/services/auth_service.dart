import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      final User? firebaseUser = await FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }
}

class FirebaseUser {}
