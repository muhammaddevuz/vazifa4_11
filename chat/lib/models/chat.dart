import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id;
  List messages;

  Chat({
    required this.id,
    required this.messages,
  });

  factory Chat.fromJson(QueryDocumentSnapshot query) {
    final data = query.data() as Map<String, dynamic>;
    return Chat(
      id: query.id,
      messages: data.containsKey('messages') ? data['messages'] : [],
    );
  }
}
