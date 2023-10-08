import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onxam_scanner/modules/splash/splash_screen.dart';

class FirstSplashScreen extends StatefulWidget {
  const FirstSplashScreen({Key? key}) : super(key: key);

  @override
  State<FirstSplashScreen> createState() => _FirstSplashScreenState();
}

class _FirstSplashScreenState extends State<FirstSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: EasySplashScreen(
        logo: Image.asset(
          'images/2023-02-26.png',
        ),
        backgroundColor: Color.fromRGBO(0,0,128,0.1),
        showLoader: false,
        navigator: SplashScreen(),
        logoWidth: 100.w,
        durationInSeconds: 1,
      ),
    );
  }
}
