import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onxam_scanner/modules/device_info/device_id.dart';
import 'package:onxam_scanner/modules/home/home_screen.dart';
import 'package:onxam_scanner/modules/local_db/local_db_controller.dart';
import 'package:onxam_scanner/modules/login/login_controller.dart';
import 'package:onxam_scanner/network/http_login.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var loginControllerr = Get.put(HttpAuth());
  var controller = Get.put(loginController());
  var IdController = Get.put(DeviceIdController());
  final formKey = GlobalKey<FormState>();
  bool isEmpty = false ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h,),
                    Container(
                      height: 100.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("images/2023-02-26.png"),
                        ),
                      ),
                    ),
                    SizedBox(height: 100.h,),
                    Container(
                      width: double.infinity,
                      height: 250.h,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                        borderRadius: BorderRadius.circular(20.sp),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 18.h,horizontal: 13.w),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.sp),
                                color: Color.fromRGBO(191, 191, 191, 1),
                              ),
                              child: TextFormField(
                                cursorColor: Colors.indigo,
                                controller: userNameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.person),
                                  label: Text('Username'),
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                  ),
                                ),
                                validator: (String? value) {
                                  if(value!.isEmpty){
                                    return '    Please enter your name';
                                  };
                                },
                              ),
                            ),
                            SizedBox(height: 10.h,),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.sp),
                                color: Color.fromRGBO(191, 191, 191, 1),
                              ),
                              child: Obx(
                                () {
                                  return  TextFormField(
                                    cursorColor: Colors.indigo,
                                    controller: passwordController,
                                    obscureText: controller.isPasswordVisible.value,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                          onPressed: (){
                                            controller.togglePasswordVisibility();
                                          },icon: Icon(controller.isPasswordVisible.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),),
                                      label: Text('Password'),
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if(value!.isEmpty){
                                        return '    Please enter your password';
                                      };
                                    },
                                  );
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 70.h,),
                    InkWell(
                      onTap: ()async{


                        if (formKey.currentState!.validate()) {

                          await loginControllerr.login(username: userNameController.text, password: passwordController.text);

                         if(loginControllerr.formattedResult['status']==false)
                           {
                             if(loginControllerr.formattedResult['msg']=='Invalid username or password')
                               {
                                 Fluttertoast.showToast(
                                     msg: "Invalid username or password",
                                     toastLength: Toast.LENGTH_SHORT,
                                     gravity: ToastGravity.CENTER,
                                     timeInSecForIosWeb: 1,
                                     fontSize: 15.sp,
                                 );
                               }else{
                               Fluttertoast.showToast(
                                 msg: "Please login from your device",
                                 toastLength: Toast.LENGTH_SHORT,
                                 gravity: ToastGravity.CENTER,
                                 timeInSecForIosWeb: 1,
                                 fontSize: 15.sp,
                               );}
                           }else(
                             Fluttertoast.showToast(
                               msg: "Success Login",
                               toastLength: Toast.LENGTH_SHORT,
                               gravity: ToastGravity.CENTER,
                               timeInSecForIosWeb: 1,
                               fontSize: 15.sp,
                             )
                         );


                        }

                      },
                      child: Container(
                        height: 50.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(46, 87, 167, 0.3),
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        child: Center(
                          child: Text(
                              'Login',
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
