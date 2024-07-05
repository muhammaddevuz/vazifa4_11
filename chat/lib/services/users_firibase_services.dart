import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UsersFiribaseServices {
  final userCollection = FirebaseFirestore.instance.collection('users');
  final _userImageStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getUsers() async* {
    yield* userCollection.snapshots();
  }
  Future<DocumentSnapshot> getCurrentUsers() async {
    return userCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
  }

  Future<void> addUser(String id, String name, File? imageUrl) async {
    if (imageUrl != null) {
      final imageReference = _userImageStorage
          .ref()
          .child("users")
          .child("images")
          .child("$name.jpg");

      final uploadTask = imageReference.putFile(imageUrl);

      await uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();
        await userCollection.doc(id).set({
          "name": name,
          "imageUrl": imageUrl,
        });
      });
    } else {
      await userCollection.doc(id).set({
        "name": name,
        // "imageUrl": null, // Agar URL ni to'g'ri kiritmoqchi bo'lsangiz, shuni qo'shing.
      });
    }
  }
  Future<void> editUser(String id, String name,String? imageUrl, File? imageFile) async {
    if (imageFile != null) {
      final imageReference = _userImageStorage
          .ref()
          .child("users")
          .child("images")
          .child("${UniqueKey()}.jpg");

      final uploadTask = imageReference.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        final imageUrl2 = await imageReference.getDownloadURL();
        await userCollection.doc(id).update({
          "name": name,
          "imageUrl": imageUrl2,
        });
      });
    } else if(imageUrl!=null) {
      await userCollection.doc(id).update({
        "name": name,
        "imageUrl": imageUrl,
      });
    }else{
      await userCollection.doc(id).update({
        "name": name,
      });
    }
  }
}
