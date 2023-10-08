import 'dart:convert';



import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as httpp ;

import '../modules/barcode_scanner/barcode_scanner_controller.dart';
class HttpWeek extends GetxController{

  var controller = Get.put(BarCodeScannerController());

  var formattedResult ;
  // String? body ;
  RxBool getRequest = false.obs;
  final box = GetStorage();

  Future weekExistOrNoFun(BuildContext context,{required dynamic eduLevelsId})async{

    getRequest.value = true;

    var request = httpp.MultipartRequest('POST', Uri.parse('https://mrmohamedhafez.com/apis/week2.php'));
    request.fields.addAll({
      'auth': 'week',
      'edulevelid': '$eduLevelsId'
    });


    httpp.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      formattedResult = jsonDecode(result);
      //body = (formattedResult['msg']);
    // print(formattedResult['msg']['id']);
      //update();
      //UpdateUI();
      // if(formattedResult['msg']=='No Week')
      //   {
      //
      //   }

      print(formattedResult['status']);
      getRequest.value = false;
    }
    else {
      print(response.reasonPhrase);
      getRequest.value = false;
    }


  }

  void UpdateUI()async{
    update();
  }
}