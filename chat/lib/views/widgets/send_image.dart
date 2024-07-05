import 'dart:io';
import 'package:chat/controllers/chat_controller.dart';
import 'package:chat/utils/messages.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SendImage extends StatefulWidget {
  String id;
  List messages;
  SendImage({super.key, required this.id, required this.messages});

  @override
  State<SendImage> createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  File? imageFile;

  void sendImage() async {
    Messages.showLoadingDialog(context);
    context
        .read<ChatController>()
        .editImageChats(widget.id, widget.messages, imageFile!);

    if (context.mounted) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Send Image"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Choose Image",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: openCamera,
                label: const Text("Camera"),
                icon: const Icon(Icons.camera),
              ),
              TextButton.icon(
                onPressed: openGallery,
                label: const Text("Gallery"),
                icon: const Icon(Icons.image),
              ),
            ],
          ),
          if (imageFile != null)
            SizedBox(
              child: Image.file(
                imageFile!,
                fit: BoxFit.cover,
                height: 200,
                width: 200,
              ),
            )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            if (imageFile != null) {
              sendImage();
            }
          },
          child: const Text("Send"),
        ),
      ],
    );
  }
}
