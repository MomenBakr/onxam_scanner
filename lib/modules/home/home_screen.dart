import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onxam_scanner/modules/barcode_scanner/barcode_scanner_controller.dart';
import 'package:onxam_scanner/modules/barcode_scanner/barcode_scanner_screen.dart';
import 'package:onxam_scanner/modules/local_db/local_db_controller.dart';
import 'package:onxam_scanner/modules/login/login_controller.dart';
import 'package:onxam_scanner/network/http_barcode_scanner.dart';
import 'package:onxam_scanner/network/http_get_name.dart';
import 'package:onxam_scanner/network/http_home.dart';
import 'package:onxam_scanner/network/http_levels.dart';
import 'package:onxam_scanner/network/http_offline_attend.dart';

class HomeScreen extends StatefulWidget {



  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //var controller = Get.put(LocalDataBaseController());
  var barCodeController = Get.put(BarCodeScannerController());
  var httpGroupController = Get.put(HttpHome());
  var httpController = Get.put(HttpWeek());
  var authController = Get.put(loginController());
  var httpLevelsController = Get.put(HttpEduLevels());
  //var httpcontrollerr = Get.put(HttpOfflineAttend());

  final box = GetStorage();


  @override
  void initState() {


    httpController.weekExistOrNoFun(context,eduLevelsId: httpLevelsController.eduId);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leading: BackButton(color: Colors.white ,onPressed: () async {

          httpGroupController.body = [];
          Get.back();

        },),
        title: Image.asset(
          "images/2023-02-26.png",
          scale: 4.sp,
        ),

      ),

      body: Padding(
        padding:  EdgeInsets.all(20.sp),
        child: GetBuilder<HttpHome>(
          init: HttpHome(),
          builder: (controller)  {
            return ConditionalBuilder(
              condition: httpGroupController.body.length > 0,
              builder: (context) {
                return ListView.separated(
                  itemBuilder:(context,index) {
                    return InkWell(
                      onTap: () async {
                        //await httpController.weekExistOrNoFun(context);
                        httpGroupController.id = httpGroupController.formattedResult['msg'][index]['id'];
                        if(httpController.formattedResult['status']==true)
                          {
                            Get.to(BarCodeScannerScreen());
                            if(httpController.formattedResult['msg']['hw']=='1')
                            {
                              box.write('weekHw', '1');

                            }
                        }else if(httpController.formattedResult['status']==false){
                          Get.to(BarCodeScannerScreen());
                        }

                      },
                      child: Container(
                        width: double.infinity,
                        height: 320.h,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(46, 87, 167, 0.13),
                          borderRadius: BorderRadius.circular(5.sp),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_copy_outlined,color: Colors.white,size: 80.sp,),
                            SizedBox(height: 20.h,),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 10.sp),
                              child: Text(
                                '${httpGroupController.body[index]['name']}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                    fontSize: 30.sp,
                                    color: Colors.white,
                                ),

                              ),
                            ),
                            SizedBox(height: 20.h,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${httpGroupController.body[index]['day1']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Text(
                                  '${httpGroupController.body[index]['from1']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Text(
                                  '${httpGroupController.body[index]['to1']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            ConditionalBuilder(
                                condition: '${httpGroupController.body[index]['day2']}'!= 'null',
                                builder: (context) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${httpGroupController.body[index]['day2']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                      Text(
                                        '${httpGroupController.body[index]['from2']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 10.w,),
                                      Text(
                                        '${httpGroupController.body[index]['to2']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                fallback: (context) {
                                  return Text('');
                                },)
                          ],
                        ),
                      ),
                    );

                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      color: Colors.transparent,
                      height: 20.h,
                    );
                  },
                  itemCount:httpGroupController.body.length,
                  physics: BouncingScrollPhysics(),
                );
              },
              fallback: (context) {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          //Icons.do_not_disturb_on_outlined,
                          Icons.error,
                          size: 120.sp,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Text(
                          'No Groups',
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
      ),


    );
  }
}

