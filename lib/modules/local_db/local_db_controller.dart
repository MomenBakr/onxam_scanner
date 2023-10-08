import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onxam_scanner/modules/barcode_scanner/barcode_scanner_controller.dart';

class checker extends GetxController {

  RxBool hasNetwork = RxBool(false);

  var controller = Get.put(BarCodeScannerController());

  String homeWork = '';

  @override
  void onInit() {
    super.onInit();
    checkNetwork();
  }

  bool containsOnlyDigits(String inputString) {
    final RegExp digitPattern = RegExp(r'^\d+$');
    return digitPattern.hasMatch(inputString);
  }


  Future<void> localDataBase ({required String hw,required String weekid,required String studentId , required String groupid})async{

    final box = GetStorage();
    //box.write('localData', []);

    var data = box.read('localData');

     if(data!=null){
       if(studentId.length > 0 && studentId.length <5 &&  containsOnlyDigits(studentId))

     { data.add({'"studentid"':'"${studentId}"',
        '"weekid"' : '"${weekid}"',
        '"hw"' : '"${hw}"',
        '"groupid"' : '"${groupid}"'
      });
     box.write('localData', data);
     print(box.read('localData'));
     };

    }else {
       data = [];
       if (studentId.length > 0 && studentId.length < 5  && containsOnlyDigits(studentId))

       {
         data.add({'"studentid"': '"${studentId}"',
           '"weekid"': '"${weekid}"',
           '"hw"': '"${hw}"',
           '"groupid"': '"${groupid}"'
         });
         box.write('localData', data);
         print(box.read('localData'));
       }
     }
  }

  Future<void> checkNetwork() async {


    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
      hasNetwork.value = true;
    } else {
      hasNetwork.value = false;
    }
  }
}
