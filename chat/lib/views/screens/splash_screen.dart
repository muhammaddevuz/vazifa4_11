import 'package:chat/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 240.h,
                width: 240.h,
                decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("assets/logo.png"))),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Connect easily with your family and friends over countries",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.h, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 100.h),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.fromLTRB(20.h, 10.h, 20.h, 10.h)),
                  child: Text(
                    "Start Messaging",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.h,
                        color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
