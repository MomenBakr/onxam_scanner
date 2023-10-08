import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as httpp ;
import 'package:onxam_scanner/modules/device_info/device_id.dart';
import 'package:onxam_scanner/modules/home/home_screen.dart';

import '../modules/login/login_controller.dart';
class HttpAuth extends GetxController{

  var formattedResult;
  var controller = Get.put(loginController());
  final box = GetStorage();

   Future login({required String username , required String password })async{


     box.write('Login', false);

    var request = httpp.MultipartRequest('POST', Uri.parse('https://mrmohamedhafez.com/apis/login.php'));
    request.fields.addAll({
      'auth': 'login',
      'username': '$username',
      'password': '$password',
      'deviceid': '${box.read('id')}'
      //'deviceid': 'a7b60a69-d6a5-45f4-b013-95abe307d302',
    });


    httpp.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var result = await response.stream.bytesToString();
      formattedResult=jsonDecode(result);
      print(box.read('id'));
      if(formattedResult['status']== true)
        {
          controller.handleLogin();
          print(box.read('isLoggedIn'));

          // return Fluttertoast.showToast(
          //   msg: "Success Login",
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //   timeInSecForIosWeb: 1,
          //   fontSize: 15.sp,
          // );

       }

    }
    else {
      print(response.reasonPhrase);
    }


  }





}

//deviceId
//a7b60a69-d6a5-45f4-b013-95abe307d302