import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ChatItemMe extends StatelessWidget {
  Map message;
  ChatItemMe({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        message['type'] == "image"
            ? InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: CachedNetworkImage(
                          placeholder: (context, url) =>
                              Image.asset('assets/blur_load.gif'),
                          imageUrl: message['text'],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 200.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      SizedBox(
                          width: 200.w,
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                Image.asset('assets/blur_load.gif'),
                            imageUrl: message['text'],
                            fit: BoxFit.cover,
                          )),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          color: Colors.black54,
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            message['time'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.green),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message["text"],
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      message["time"],
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
        SizedBox(height: 10.h)
      ],
    );
  }
}
