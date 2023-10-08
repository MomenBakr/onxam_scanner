import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart'as httpp;
class HttpCheckAttend extends GetxController{

  var formattedResult;

  Future checkStudentAtted({required String weekId , required String studentId})async{

    var request = httpp.MultipartRequest('POST', Uri.parse('https://mrmohamedhafez.com/apis/checkAttend.php'));
    request.fields.addAll({
      'auth': 'attend',
      'weekid': '${weekId}',
      'barcode': '${studentId}'
    });


    httpp.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
       formattedResult = jsonDecode(result);
      print(formattedResult['msg']);
    }
    else {
      print(response.reasonPhrase);
    }

  }

}