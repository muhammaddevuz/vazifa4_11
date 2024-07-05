import 'package:chat/controllers/chat_controller.dart';
import 'package:chat/models/chat.dart';
import 'package:chat/models/user.dart';
import 'package:chat/views/widgets/chat_item_me.dart';
import 'package:chat/views/widgets/chat_item_other_users.dart';
import 'package:chat/views/widgets/send_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  Users user;
  ChatScreen({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  List chatBox = [];
  String chatId = '';

  @override
  void initState() {
    super.initState();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chatController.getChats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                final chats = snapshot.data!.docs;
                if (chats.isEmpty) {
                  chatController.addChats(
                      widget.user.id + FirebaseAuth.instance.currentUser!.uid);
                }
                Chat? chat;
                for (var i = 0; i < chats.length; i++) {
                  Chat box = Chat.fromJson(chats[i]);
                  if (box.id ==
                          widget.user.id +
                              FirebaseAuth.instance.currentUser!.uid ||
                      box.id ==
                          FirebaseAuth.instance.currentUser!.uid +
                              widget.user.id) {
                    chat = box;
                    chatBox = chat.messages;
                    chatId = chat.id;
                    break;
                  }
                }
                if (chat == null) {
                  chatController.addChats(
                      widget.user.id + FirebaseAuth.instance.currentUser!.uid);
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  controller: _scrollController,
                  itemCount: chat?.messages.length,
                  itemBuilder: (context, index) {
                    Map message = chat!.messages[index];
                    chatId = chat.id;
                    if (message['id'] ==
                        FirebaseAuth.instance.currentUser!.uid) {
                      return ChatItemMe(
                        message: message,
                      );
                    } else {
                      return ChatItemOtherUsers(
                        message: message,
                      );
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) {
                if (messageController.text.trim().isNotEmpty) {
                  chatBox.add({
                    'id': FirebaseAuth.instance.currentUser!.uid,
                    'type': "text",
                    'text': messageController.text.trim(),
                    "time": "${DateTime.now().hour}:${DateTime.now().minute}"
                  });
                  chatController.editChats(chatId, chatBox);
                }
                messageController.text = '';
              },
              controller: messageController,
              decoration: InputDecoration(
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              SendImage(id: chatId, messages: chatBox),
                        );
                      },
                      icon: Icon(
                        Icons.image,
                        size: 25.h,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (messageController.text.trim().isNotEmpty) {
                          chatBox.add({
                            'id': FirebaseAuth.instance.currentUser!.uid,
                            'type': "text",
                            'text': messageController.text,
                            "time":
                                "${DateTime.now().hour}:${DateTime.now().minute}"
                          });
                          chatController.editChats(chatId, chatBox);
                        }
                        messageController.text = '';
                      },
                      icon: Icon(
                        Icons.telegram,
                        size: 25.h,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                hintText: 'Message',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
