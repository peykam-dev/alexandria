import 'package:alexandria/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _userModel(User? fuser) {
    return fuser != null ? UserModel(userId: fuser.uid) : null;
  }

  Future signInWithEmailAndPass(String email, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User fUser = result.user!;
      return _userModel(fUser);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String pass) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User fUser = result.user!;
      return _userModel(fUser);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
