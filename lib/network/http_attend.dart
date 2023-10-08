import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart'as httpp;

class HttpAttend extends GetxController{

  var formattedResult;
  RxBool getRequest = false.obs ;

  dynamic StudentAttend ({required String weekId , required String barcode , required String hw , required String groupId})async{

    getRequest.value = true;

    var request = httpp.MultipartRequest('POST', Uri.parse('https://mrmohamedhafez.com/apis/newAttend2.php'));
    request.fields.addAll({
      'auth': 'attend',
      'weekid': '${weekId}',
      'barcode': '${barcode}',
      'hw': '${hw}',
      'groupid': '${groupId}'
    });


    httpp.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
       formattedResult = jsonDecode(result);
      print(formattedResult);
      print('memooo');
      getRequest.value = false;
    }
    else {
      print(response.reasonPhrase);
      getRequest.value = false;
    }

  }
}