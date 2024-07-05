import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class OtherUserInfoScreen extends StatelessWidget {
  Users users;
  OtherUserInfoScreen({super.key, required this.users});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(users.name),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Container(
                    width: 250.w,
                    height: 250.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 218, 214, 214)),
                    clipBehavior: Clip.hardEdge,
                    child: users.imageUrl == null
                        ? Image.asset("assets/profile_logo.png",
                            fit: BoxFit.cover)
                        : CachedNetworkImage(
                            placeholder: (context, url) =>
                                Image.asset('assets/blur_load.gif'),
                            imageUrl: users.imageUrl!,
                            fit: BoxFit.cover,
                          )),
              ],
            ),
          ),
        ));
  }
}
