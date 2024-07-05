import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatFirebaseServices {
  final chatCollection = FirebaseFirestore.instance.collection('chats');
  final _messageImageStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getChats() async* {
    yield* chatCollection.snapshots();
  }

  void addChats(String title) {
    chatCollection.doc(title).set({
      "title": title,
    });
  }

  void editChats(String id, List messages) {
    chatCollection.doc(id).update({
      "messages": messages,
    });
  }

  void editImageChats(String id, List messages, File imageFile) async {
    final imageReference = _messageImageStorage
        .ref()
        .child("messages")
        .child("images")
        .child("${UniqueKey()}.jpg");
    final uploadTask = imageReference.putFile(
      imageFile,
    );

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();
      messages.add({
        'id': FirebaseAuth.instance.currentUser!.uid,
        'type': "image",
        'text': imageUrl,
        "time": "${DateTime.now().hour}:${DateTime.now().minute}"
      });
      await chatCollection.doc(id).set({
        "messages": messages,
      });
    });
  }
}
