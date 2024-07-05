import 'package:chat/controllers/user_controller.dart';
import 'package:chat/models/user.dart';
import 'package:chat/views/screens/other_user_info_screen.dart';
import 'package:chat/views/screens/profile_screen.dart';
import 'package:chat/views/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
          style: TextStyle(fontSize: 25.h, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
        child: StreamBuilder(
          stream: userController.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                Users user = Users.fromJson(users[index]);
                return InkWell(
                    onLongPress: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return OtherUserInfoScreen(users: user);
                        },
                      ));
                    },
                    child: UserItem(user: user));
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.home,
                  size: 35.h,
                  color: Colors.blue,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ));
                },
                icon: Icon(
                  Icons.person,
                  size: 35.h,
                )),
          ],
        ),
      ),
    );
  }
}
