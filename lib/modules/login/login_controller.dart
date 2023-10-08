import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onxam_scanner/modules/home/home_screen.dart';
import 'package:onxam_scanner/modules/levels/levels_screen.dart';
import 'package:onxam_scanner/modules/login/login_screen.dart';

class loginController extends GetxController{

  // IconData suffix = Icons.visibility_outlined;
  // RxBool isPasswordShown = true.obs;



  RxBool isPasswordVisible = true.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value =! isPasswordVisible.value;
  }

  // dynamic changePasswordVisibility (){
  //   isPasswordShown.value != isPasswordShown.value;
  //   suffix = isPasswordShown.value ? Icons.visibility_off_outlined : Icons.visibility_outlined;
  //
  // }

  dynamic handleLogin()  {
    // Code to handle user login, you'll typically have your authentication logic here.

    // After successful login, save the login status to GetStorage.
    final box = GetStorage();

     box.write('isLoggedIn', true);

     Get.off(LevelsScreen());
     update();


  }


  dynamic checkLoginStatus() {
    final box = GetStorage();


    if(box.read('isLoggedIn') == true)
      {

        //return HomeScreen();
        return LevelsScreen();

      }else{

      return LoginScreen();

    };

  }

  dynamic handleLogout() {
    // Code to handle user logout.

    // Sve the login status from GetStorage.
    final box = GetStorage();
    box.write('isLoggedIn',false);
    Get.off(LoginScreen());
  }



}