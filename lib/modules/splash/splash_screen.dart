import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onxam_scanner/modules/home/home_screen.dart';
import 'package:onxam_scanner/modules/local_db/local_db_controller.dart';
import 'package:onxam_scanner/modules/login/login_controller.dart';
import 'package:onxam_scanner/modules/login/login_screen.dart';

class SplashScreen extends StatefulWidget {




  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var controller = Get.put(loginController());


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Image.asset('images/2023-02-26.png'),
        splashIconSize: 300.sp,
        nextScreen: controller.checkLoginStatus(),
      backgroundColor: Color.fromRGBO(0,0,128,0.3),
      duration: 1,
    );
  }
}

