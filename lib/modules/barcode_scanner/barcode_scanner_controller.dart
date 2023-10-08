//
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:onxam_scanner/modules/home/home_screen.dart';
import 'package:onxam_scanner/modules/local_db/local_db_controller.dart';
import 'package:onxam_scanner/modules/login/login_screen.dart';
import 'package:onxam_scanner/network/http_get_name.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';


class BarCodeScannerController extends GetxController{


  RxBool isScanCompleted = false.obs;
  //bool isScanning = false;

  late String Code ;

  Future<void> launchURL() async {
    Uri url = Uri.parse('https://onxameg.com/?fbclid=IwAR2spgR8LmlkA4_2ITGmXjgsf5uY_2aSWdSNE6gr4Zr46iTq7zXgiViSB_s');
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  void updateUI(){
    update();
  }


  // void handleBarcodeDetected(String barcode) async {
  //   // Stop scanning to avoid further detection
  //   isScanning = false;
  //   // Show the quick alert dialog
  //   // ...
  //
  //   // Wait for user response (Yes/No)
  //   // ...
  //
  //   // After the user response, resume scanning
  //   isScanning = true;
  // }

  void CloseScreen(){
    isScanCompleted = false.obs;

  }
}

