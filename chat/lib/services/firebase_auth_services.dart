import 'dart:io';

import 'package:chat/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  UserController userController = UserController();

  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(
      String email, String pasword, String name, File? imageUrl) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pasword);
      userController.addUser(
          FirebaseAuth.instance.currentUser!.uid, name, imageUrl);
    } catch (e) {
      return;
    }
  }

  Future<void> resetPasword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
  }
}
