import 'dart:io';

import 'package:chat/services/chat_firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  final ChatFirebaseServices chatFirebaseServices = ChatFirebaseServices();

  Stream<QuerySnapshot> getChats() {
    return chatFirebaseServices.getChats();
  }

  void addChats(String title) {
    chatFirebaseServices.addChats(title);
  }

  void editChats(String id, List messages) {
    chatFirebaseServices.editChats(id, messages);
  }
  void editImageChats(String id, List messages,File imageFile) {
    chatFirebaseServices.editImageChats(id, messages, imageFile);
  }
}
