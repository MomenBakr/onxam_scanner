import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as httpp ;
import 'package:fluttertoast/fluttertoast.dart';
class HttpOfflineAttend extends GetxController{



  static Future offlineAttend () async{

    final box = GetStorage();


    print(box.read('localData'));

    var request = httpp.MultipartRequest('POST', Uri.parse('https://mrmohamedhafez.com/apis/offlineAttend2.php'));
    request.fields.addAll({
      'auth': 'attend',
       'data': '${box.read('localData')}'

    });


    httpp.StreamedResponse response = await request.send();



    if (response.statusCode == 200) {

      var result = await response.stream.bytesToString();
      var formattedResult = jsonDecode(result);
      if(formattedResult['status']== true)
        {

          print(result);
          print(formattedResult);

          print(box.read('localData').toString());

          box.remove('localData');

          print('Data uploaded and deleted succ');
          box.read('localData');
          return Fluttertoast.showToast(
             // msg: "students uploaded successfully",
            msg: '${formattedResult['msg']}',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              fontSize: 25.sp,
          );
        }
    }
    else {
      print(response.reasonPhrase);
    }


  }
}