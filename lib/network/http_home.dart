import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as httpp ;
import 'package:onxam_scanner/network/http_levels.dart';
class HttpHome extends GetxController{

  var formattedResult;
  List body = [];
  var controller = Get.put(HttpEduLevels());
  var id;

   Future<void> HomeGroups({required dynamic eduLevelsId})async{
    var request = httpp.MultipartRequest('POST', Uri.parse('https://mrmohamedhafez.com/apis/groups2.php'));
    request.fields.addAll({
      'auth': 'groups',
      'edulevelid': '${eduLevelsId}'
    });

    httpp.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
       formattedResult=jsonDecode(result);
      // var group = formattedResult['msg']['day1'];
      // print(formattedResult['msg']['id']);
       if(formattedResult['status'] == true)
         {
           body.addAll(formattedResult['msg']);
         }
      update();

       //print(body.length);
      // print(body);
      //print(body.length);
      // print(formattedResult['msg'][0]['id']);
      // print(formattedResult['status']);
    }
    else {
      print(response.reasonPhrase);
    }


  }

}