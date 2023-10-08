import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as httpp ;
class HttpEduLevels extends GetxController{

  var formattedResult;
  List body = [];
  var eduId;

  Future eduLevels()async{
    var request = httpp.MultipartRequest('POST', Uri.parse('https://mrmohamedhafez.com/apis/edulevels.php'));
    request.fields.addAll({
      'auth': 'edulevels'
    });

    httpp.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      formattedResult=jsonDecode(result);
      // var group = formattedResult['msg']['day1'];
      // print(formattedResult['msg']['id']);
      body.addAll(formattedResult['msg']);


      update();
      print(body.length);
      print(body);
      //print(body.length);
      // print(formattedResult['msg'][0]['id']);
      // print(formattedResult['status']);
    }
    else {
      print(response.reasonPhrase);
    }


  }

}