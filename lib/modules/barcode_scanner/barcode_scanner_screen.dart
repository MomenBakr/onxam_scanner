import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:onxam_scanner/modules/barcode_scanner/barcode_scanner_controller.dart';
import 'package:onxam_scanner/modules/local_db/local_db_controller.dart';
import 'package:onxam_scanner/network/http_attend.dart';
import 'package:onxam_scanner/network/http_barcode_scanner.dart';
import 'package:onxam_scanner/network/http_check_attend.dart';
import 'package:onxam_scanner/network/http_get_name.dart';
import 'package:onxam_scanner/network/http_home.dart';
import 'package:onxam_scanner/network/http_levels.dart';
import 'package:onxam_scanner/network/http_offline_attend.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class BarCodeScannerScreen extends StatefulWidget {
  const BarCodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<BarCodeScannerScreen> createState() => _BarCodeScannerScreenState();
}

class _BarCodeScannerScreenState extends State<BarCodeScannerScreen> {
  var httpController = Get.put(HttpWeek());
  var controller = Get.put(BarCodeScannerController());
  var getDataController = Get.put(HttpGetName());
  var studentAttendController = Get.put(HttpAttend());
  var checkNetController = Get.put(checker());
  var checkStudentAttendController = Get.put(HttpCheckAttend());
  var httpLevelsController = Get.put(HttpEduLevels());
  var httpHomeController = Get.put(HttpHome());

  final box = GetStorage();






  bool containsOnlyDigits(String inputString) {
    final RegExp digitPattern = RegExp(r'^\d+$');
    return digitPattern.hasMatch(inputString);
  }





  @override
  void initState()   {
      httpController.weekExistOrNoFun(context,eduLevelsId: httpLevelsController.eduId);
      checkNetController.checkNetwork();
      httpController.UpdateUI();
      httpController.update();
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkNetController.checkNetwork();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Image.asset(
          "images/2023-02-26.png",
          scale: 4.sp,
        ),
      ),
      body: Obx(
        () {
          return httpController.getRequest.value ?
          Center(child: CircularProgressIndicator(),) :
          ConditionalBuilder(
            condition: httpController.formattedResult['status'] == true,
            builder: (context) {
              return Container(
                height: double.infinity,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 20.h),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Text(
                                'Please, Scan the student code',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp,
                                ),
                              ),
                              SizedBox(height: 10.h,),
                              Text(
                                'Scanning will be started automatically',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(height: 20.h,),
                              Text(
                                  '${httpController.formattedResult['msg']['name']}',
                                style: GoogleFonts.cairo(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                ),

                              )
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 6,
                        child: Container(
                          color: Colors.red,

                          child: MobileScanner(
                              controller: MobileScannerController(
                                facing: CameraFacing.back,
                              ),
                              allowDuplicates: false,
                              onDetect: (barcode,args)async{
                                await checkNetController.checkNetwork();
                                //await httpController.weekExistOrNoFun(context);

                                if(checkNetController.hasNetwork.value){
                                  if(!controller.isScanCompleted.value)
                                  {
                                    controller.Code = barcode.rawValue ?? '---';
                                    controller.isScanCompleted = true.obs;
                                    // studentAttendController.checkStudentAttend();

                                    await checkStudentAttendController.checkStudentAtted(weekId: httpController.formattedResult['msg']['id'], studentId: controller.Code);
                                    await getDataController.getStudentName(weekId: httpController.formattedResult['msg']['id'],studentId: controller.Code);


                                    if(checkStudentAttendController.formattedResult['status']==true)
                                    {
                                      if(getDataController.formattedResult['status']==true)
                                      {
                                        if(httpController.formattedResult['msg']['hw']=='1')
                                          {
                                            controller.isScanCompleted = true.obs;

                                            await QuickAlert.show(
                                                cancelBtnTextStyle: TextStyle
                                                  (
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade700,
                                                  fontSize: 20.sp,
                                                ),
                                                context: context,
                                                type: QuickAlertType.confirm,
                                                backgroundColor:  Color.fromRGBO(0,0,128,0.3),
                                                widget: Obx(
                                                      () {
                                                    return getDataController.getRequest.value ? Text(''): RichText(
                                                        textAlign: TextAlign.center,
                                                        text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: 'Have Student ',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: '${getDataController.formattedResult['msg']} ',
                                                                style: TextStyle(
                                                                  color: Colors.green,
                                                                  fontSize: 20.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),

                                                              TextSpan(
                                                                text: 'done the Homework?',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ]
                                                        )
                                                    );
                                                  },
                                                ),
                                                cancelBtnText: 'No',
                                                confirmBtnText: 'Yes',
                                                showCancelBtn: true,
                                                barrierColor: Colors.transparent,
                                                confirmBtnColor: Colors.green,
                                                onCancelBtnTap: ()async{
                                                  await studentAttendController.StudentAttend(weekId: httpController.formattedResult['msg']['id'] ,barcode: controller.Code ,hw:  '0' ,groupId: httpHomeController.id);

                                                  // Start scanning again.
                                                  controller.isScanCompleted = false.obs;
                                                  Get.back();

                                                  controller.updateUI();

                                                  await Get.snackbar(
                                                    '',
                                                    '',
                                                    messageText: Obx(
                                                          () {
                                                        return studentAttendController.getRequest.value ?
                                                        Text('Unstable Network !',
                                                          style: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.white,
                                                          ),) :
                                                        Padding(
                                                          padding:  EdgeInsets.all(12.sp),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                //'${getDataController.formattedResult['msg']} ',
                                                                '',
                                                                style: TextStyle(
                                                                  fontSize: 15.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              Text(
                                                                '${studentAttendController.formattedResult['msg']} ',
                                                                textAlign: TextAlign.center,
                                                                maxLines: 3,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: 15.sp,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.white,
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                        );

                                                      },
                                                    ),
                                                    snackPosition: SnackPosition.TOP,
                                                    padding: EdgeInsets.all(10.sp),
                                                    backgroundColor: studentAttendController.formattedResult['status'] == true ?
                                                    Colors.green.shade700 : Colors.red.shade700 ,
                                                    animationDuration: Duration(seconds: 1),
                                                    //titleText: 'd',

                                                  );




                                                },
                                                onConfirmBtnTap: ()async{
                                                  await studentAttendController.StudentAttend(weekId: httpController.formattedResult['msg']['id'],barcode: controller.Code, hw: '1' , groupId: httpHomeController.id);
                                                  // Start scanning again.
                                                  controller.isScanCompleted = false.obs;
                                                  Get.back();

                                                  controller.updateUI();


                                                  await Get.snackbar(
                                                    '',
                                                    '',
                                                    messageText: Obx(
                                                          () {
                                                        return studentAttendController.getRequest.value ?
                                                        Text('Unstable Network !',
                                                          style: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.white,
                                                          ),) :
                                                        Row(
                                                          children: [
                                                            Text(
                                                             // '${getDataController.formattedResult['msg']} ',
                                                              '',
                                                              style: TextStyle(
                                                                fontSize: 15.sp,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${studentAttendController.formattedResult['msg']} ',
                                                              textAlign: TextAlign.center,
                                                              maxLines: 3,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 15.sp,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.white,
                                                              ),
                                                            ),

                                                          ],
                                                        );

                                                      },
                                                    ),
                                                    snackPosition: SnackPosition.TOP,
                                                    padding: EdgeInsets.all(10.sp),
                                                    backgroundColor: studentAttendController.formattedResult['status'] == true ?
                                                    Colors.green.shade700 : Colors.red.shade700 ,
                                                    animationDuration: Duration(seconds: 1),


                                                  );




                                                });
                                          }else{
                                          await studentAttendController.StudentAttend(weekId: httpController.formattedResult['msg']['id'] ,barcode: controller.Code ,hw:  '' , groupId: httpHomeController.id );

                                          // Start scanning again.
                                          controller.isScanCompleted = false.obs;

                                          await Get.snackbar(
                                            '',
                                            '',
                                            messageText: Obx(
                                                  () {
                                                return studentAttendController.getRequest.value ?
                                                Text('Unstable Network !',
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),) :
                                                Padding(
                                                  padding:  EdgeInsets.all(12.sp),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        //'${getDataController.formattedResult['msg']} ',
                                                        '',
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${studentAttendController.formattedResult['msg']} ',
                                                        textAlign: TextAlign.center,
                                                        maxLines: 3,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white,
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                );

                                              },
                                            ),
                                            snackPosition: SnackPosition.TOP,
                                            padding: EdgeInsets.all(10.sp),
                                            backgroundColor: studentAttendController.formattedResult['status'] == true ?
                                            Colors.green.shade700 : Colors.red.shade700 ,
                                            animationDuration: Duration(seconds: 1),
                                            //titleText: 'd',

                                          );
                                        }

                                      }
                                    }else

                                      {

                                        controller.isScanCompleted = false.obs;

                                       await Get.snackbar(
                                          '',
                                          '',
                                          messageText: Text(
                                            '${checkStudentAttendController.formattedResult['msg']}',
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                          snackPosition: SnackPosition.TOP,
                                          padding: EdgeInsets.all(10.sp),
                                          backgroundColor: Colors.red.shade700 ,
                                          animationDuration: Duration(seconds: 1),
                                          //titleText: 'd',

                                        );


                                      }



                                  }//if condition
                                }else{
                                  if(!controller.isScanCompleted.value)
                                    {
                                      controller.Code = barcode.rawValue ?? '---';


                                      controller.isScanCompleted = true.obs;

                                      if(controller.Code.length > 0 && controller.Code.length <5 &&  containsOnlyDigits(controller.Code) )

                                        {

                                          if(box.read('weekHw') == '1')
                                          {


                                            await QuickAlert.show(
                                                cancelBtnTextStyle:
                                                TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade700,
                                                  fontSize: 20.sp,
                                                ),
                                                context: context,
                                                type: QuickAlertType.confirm,
                                                backgroundColor:  Color.fromRGBO(0,0,128,0.3),
                                                widget: Text('${controller.Code}'),
                                                cancelBtnText: 'No',
                                                confirmBtnText: 'Yes',
                                                showCancelBtn: true,
                                                barrierColor: Colors.transparent,
                                                confirmBtnColor: Colors.green,
                                                onCancelBtnTap: ()async{

                                                  checkNetController.localDataBase(hw: '0',weekid: httpController.formattedResult['msg']['id'],studentId: '${controller.Code}',groupid: httpHomeController.id);
                                                  controller.isScanCompleted = false.obs;
                                                  Get.back();
                                                  controller.updateUI();
                                                  final box = GetStorage();
                                                  print('${box.read('localData')}');
                                                  // Start scanning again.

                                                  Get.snackbar(
                                                    '',
                                                    '',
                                                    messageText: Center(
                                                        child:
                                                        Text('Attended Succesfully',
                                                          style:TextStyle(
                                                              color: Colors.white
                                                          ) ,)),
                                                    snackPosition: SnackPosition.TOP,
                                                    padding: EdgeInsets.all(10.sp),
                                                    backgroundColor:  Colors.green.shade700,
                                                    animationDuration: Duration(seconds: 1),


                                                  );


                                                },
                                                onConfirmBtnTap: ()async{


                                                  checkNetController.localDataBase(hw: '1',weekid:  httpController.formattedResult['msg']['id'] ,studentId: '${controller.Code}',groupid: httpHomeController.id);
                                                  controller.isScanCompleted = false.obs;
                                                  Get.back();

                                                  final box = GetStorage();
                                                  print('${box.read('localData')}');
                                                  // Start scanning again.



                                                  controller.updateUI();

                                                  Get.snackbar(
                                                    '',
                                                    '',
                                                    messageText: Center(
                                                      child: Text(
                                                        'Attended Succesfully',
                                                        style:TextStyle(
                                                            color: Colors.white
                                                        ) ,
                                                      ),
                                                    ),
                                                    snackPosition: SnackPosition.TOP,
                                                    padding: EdgeInsets.all(10.sp),
                                                    backgroundColor: Colors.green.shade700 ,
                                                    animationDuration: Duration(seconds: 1),


                                                  );





                                                });

                                          }
                                          else{
                                            checkNetController.localDataBase(hw: '',weekid: httpController.formattedResult['msg']['id'],studentId: '${controller.Code}',groupid: httpHomeController.id);
                                            controller.isScanCompleted = false.obs;
                                            Get.snackbar(
                                              '',
                                              '',
                                              messageText: Center(
                                                  child:
                                                  Text('Attended Succesfully',
                                                    style:TextStyle(color: Colors.white) ,)),
                                              snackPosition: SnackPosition.TOP,
                                              padding: EdgeInsets.all(10.sp),
                                              backgroundColor:  Colors.green.shade700,
                                              animationDuration: Duration(seconds: 1),


                                            );

                                          }

                                        }else{

                                        controller.isScanCompleted = false.obs;

                                        Get.snackbar(
                                          '',
                                          '',
                                          messageText: Center(
                                              child:
                                              Text('Invalid Code',
                                                style:TextStyle(
                                                    color: Colors.white
                                                ) ,)),
                                          snackPosition: SnackPosition.TOP,
                                          padding: EdgeInsets.all(10.sp),
                                          backgroundColor:  Colors.red.shade700,
                                          animationDuration: Duration(seconds: 1),


                                        );




                                      }

                                    }
                                }

                              }),
                        ),
                      ),
                      Spacer(),
                      Container(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Developed by ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 18.sp,
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                controller.launchURL();
                              },
                              child: Text(
                                'Onxam',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //color: Color.fromRGBO(0,0,100,1),
              );
            },
            fallback: (context) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                        Icons.error,
                        size: 120.sp,
                        color: Colors.white,
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      '${httpController.formattedResult['msg']}',
                      style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
