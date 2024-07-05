import 'dart:io';
import 'package:chat/services/users_firibase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  final UsersFiribaseServices userFirebaseServices = UsersFiribaseServices();

  Stream<QuerySnapshot> getUsers() {
    return userFirebaseServices.getUsers();
  }

  void addUser(String id, String name, File? imageUrl) {
    userFirebaseServices.addUser(id, name,imageUrl);
  }
  void editUser(String id, String name,String? imageUrl, File? imageFile) {
    userFirebaseServices.editUser(id, name, imageUrl, imageFile);
  }

  Future<DocumentSnapshot> getCurrentUsers() async {
    return userFirebaseServices.getCurrentUsers();
  }


}
