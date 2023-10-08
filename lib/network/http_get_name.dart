import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart'as httpp;
class HttpGetName extends GetxController{

  var formattedResult;
  RxBool getRequest = false.obs ;

  Future getStudentName({required String weekId , required String studentId})async{

    getRequest.value = true;

    var request = httpp.MultipartRequest('POST', Uri.parse('https://mrmohamedhafez.com/apis/getName.php'));
    request.fields.addAll({
      'auth': 'getName',
      'weekid': '${weekId}',
      'studentid': '${studentId}'
    });


    httpp.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
       formattedResult = jsonDecode(result);
      print(formattedResult['msg']);
      print('my name');
      getRequest.value = false;
    }
    else {
      print(response.reasonPhrase);
      getRequest.value = false;
    }

  }
}














