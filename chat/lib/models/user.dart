import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String id;
  String name;
  String? imageUrl;

  Users({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Users.fromJson(QueryDocumentSnapshot query) {
    final data = query.data() as Map<String, dynamic>;
    return Users(
      id: query.id,
      name: data['name'],
      imageUrl: data.containsKey('imageUrl') ? data['imageUrl'] : null,
    );
  }
  factory Users.fromJsons(DocumentSnapshot query) {
    final data = query.data() as Map<String, dynamic>;
    return Users(
      id: query.id,
      name: data['name'],
      imageUrl: data.containsKey('imageUrl') ? data['imageUrl'] : null,
    );
  }
}
