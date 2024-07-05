import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/models/user.dart';
import 'package:chat/views/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class UserItem extends StatelessWidget {
  Users user;
  UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(user: user),
            ));
      },
      child: ListTile(
        leading: Container(
            width: 50.w,
            height: 60.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.hardEdge,
            child: user.id == FirebaseAuth.instance.currentUser!.uid
                ? Container(
                    color: Colors.blue,
                    child: Center(
                        child: Icon(
                      Icons.bookmark_border_outlined,
                      size: 29.h,
                      color: Colors.white,
                    )),
                  )
                : user.imageUrl != null
                    ? CachedNetworkImage(
                      imageUrl: user.imageUrl!,
                          fit: BoxFit.cover,
                    )
                    : Container(
                        color: Colors.grey,
                        child: Center(
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.h),
                          ),
                        ),
                      )),
        title: Text(
          user.id == FirebaseAuth.instance.currentUser!.uid
              ? "Saved Message"
              : user.name,
          style: TextStyle(fontSize: 20.h, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          "Chat user",
          style: TextStyle(fontSize: 12.h, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
