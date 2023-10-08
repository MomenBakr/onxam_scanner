import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onxam_scanner/modules/home/home_screen.dart';
import 'package:onxam_scanner/modules/login/login_controller.dart';
import 'package:onxam_scanner/network/http_barcode_scanner.dart';
import 'package:onxam_scanner/network/http_home.dart';
import 'package:onxam_scanner/network/http_levels.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({Key? key}) : super(key: key);

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {

  var authController = Get.put(loginController());
  var httpGroupController = Get.put(HttpHome());
  var httpLevelsController = Get.put(HttpEduLevels());


  final box = GetStorage();

  @override
  void initState() {

    httpLevelsController.eduLevels();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Image.asset(
          "images/2023-02-26.png",
          scale: 4.sp,
        ),
        actions: [
          IconButton(onPressed: (){
            authController.handleLogout();
            httpGroupController.body = [];
            httpLevelsController.body = [];
            print(box.read('isLoggedIn'));
          }, icon:Icon(Icons.logout_outlined)),
        ],
      ),

      body: Padding(
        padding:  EdgeInsets.all(20.sp),
        child: GetBuilder<HttpEduLevels>(
          init: HttpEduLevels(),
          builder: (controller) {
            return ConditionalBuilder(
              condition: httpLevelsController.body.length > 0,
              builder: (context) {
                return ListView.separated(
                  itemBuilder:(context, index) {
                    return InkWell(
                      onTap: () async {

                        httpGroupController.body = [];
                        httpLevelsController.eduId = httpLevelsController.formattedResult['msg'][index]['id'];
                        await httpGroupController.HomeGroups(eduLevelsId: httpLevelsController.eduId );

                        Get.to(HomeScreen());

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
                            Icon(Icons.school_outlined,color: Colors.white,size: 150.sp,),
                            SizedBox(height: 40.h,),
                            Text(
                              '${httpLevelsController.body[index]['name']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 30.sp,
                                color: Colors.white,
                              ),
                            ),

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
                  itemCount:httpLevelsController.body.length,
                  physics: BouncingScrollPhysics(),
                );
              },
              fallback: (context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },

            );
          },
        ),
      ),


    );
  }

}
