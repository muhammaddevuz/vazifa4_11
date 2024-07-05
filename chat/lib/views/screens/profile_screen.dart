import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/controllers/user_controller.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/firebase_auth_services.dart';
import 'package:chat/views/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();

  String? name;
  bool isLoading = false;
  File? imageFile;

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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Register"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ));
              },
              icon: Icon(
                Icons.login,
                color: Colors.blue,
                size: 27.h,
              )),
          SizedBox(width: 5.w)
        ],
      ),
      body: FutureBuilder(
          future: userController.getCurrentUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            Users user = Users.fromJsons(snapshot.data!);
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.h),
                    Stack(
                      children: [
                        Container(
                            width: 150.w,
                            height: 150.h,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 218, 214, 214)),
                            clipBehavior: Clip.hardEdge,
                            child: user.imageUrl == null
                                ? imageFile == null
                                    ? Image.asset("assets/profile_logo.png",
                                        fit: BoxFit.cover)
                                    : Image.file(
                                        imageFile!,
                                        fit: BoxFit.cover,
                                      )
                                : imageFile != null
                                    ? Image.file(
                                        imageFile!,
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Image.asset('assets/blur_load.gif'),
                                        imageUrl: user.imageUrl!,
                                        fit: BoxFit.cover,
                                      )),
                        Positioned(
                          right: 0,
                          bottom: 5,
                          child: IconButton(
                              onPressed: openGallery,
                              icon: Icon(
                                Icons.edit_square,
                                color: Colors.black,
                                size: 30.h,
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: 50.h),
                    TextFormField(
                      initialValue: user.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Name",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please input Name";
                        }

                        return null;
                      },
                      onSaved: (newValue) {
                        //? save email
                        name = newValue;
                      },
                    ),
                    SizedBox(height: 20.h),
                    FilledButton(
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          userController.editUser(
                              user.id, name!, user.imageUrl, imageFile);
                        }
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text("Data saved successfully"),
                            );
                          },
                        );
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.h,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
