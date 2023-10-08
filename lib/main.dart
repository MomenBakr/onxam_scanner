import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:onxam_scanner/modules/barcode_scanner/barcode_scanner_screen.dart';
import 'package:onxam_scanner/modules/device_info/device_id.dart';
import 'package:onxam_scanner/modules/home/home_screen.dart';
import 'package:onxam_scanner/modules/local_db/local_db_controller.dart';
import 'package:onxam_scanner/modules/login/login_controller.dart';
import 'package:onxam_scanner/modules/login/login_screen.dart';
import 'package:onxam_scanner/modules/splash/first_splash.dart';
import 'package:onxam_scanner/modules/splash/splash_screen.dart';
import 'package:onxam_scanner/network/http_attend.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:onxam_scanner/network/http_offline_attend.dart';



void main() async {
  var controller = Get.put(DeviceIdController());
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final box = GetStorage();
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
    // Got a new connectivity status!
    if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile)
      {
        var Data = box.read('localData');
        if(Data!=null)
          {
            await HttpOfflineAttend.offlineAttend();
          }
      }
  });

  box.remove('weekHw');

  print('box is ${box.read("isLoggedIn")}');
  await controller.getPhoneId();
  runApp(const MyApp());

  //await LocalDataBaseController.instance.CreateDatabase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: ((context, child) {

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Color.fromRGBO(0,0,128,0.3),
          ),
          home: child,
        );
      }),
      child: FirstSplashScreen(),
    );
  }
}

