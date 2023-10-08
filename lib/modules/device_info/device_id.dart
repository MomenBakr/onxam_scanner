import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DeviceIdController extends GetxController{


  String? deviceId;
  String? deviceBrand;
  String? SerialNum;




  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();



  Future  getPhoneId() async {



    if(Platform.isAndroid){
      final info = await deviceInfo.androidInfo;

      final box = GetStorage();

      deviceId = info.id;
      deviceBrand = info.brand;
      SerialNum = info.serialNumber;

      print('This is the device id : ${deviceId.toString()}');
      print('This is the device Brand : ${deviceBrand}');
      print('This is the device Serial : ${SerialNum}');

      box.write('id', '${deviceId}');
      print(box.read('id'));


      return '${info.id.toString()}';
    }else{
      return null;
    }
  }

}