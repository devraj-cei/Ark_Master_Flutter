import 'dart:convert';

import 'package:ark_master/API/ApiEndPoint.dart';
import 'package:ark_master/Screens/Dashboard/Dashboard.dart';
import 'package:ark_master/Screens/Login/ForgetPassword.dart';
import 'package:ark_master/Utils/AppConstants.dart';
import 'package:ark_master/Utils/easyLoading.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../Utils/App_Colors.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Checkbox
  bool rememberMe = false;

  //ObscureText
  bool obscure = true;

  //Token
  String? token;

  //TextEditingController
  TextEditingController usernameController =
      TextEditingController(text: "mihir@gmail.com");
  TextEditingController passwordController =
      TextEditingController(text: "mihir@123");

  //LoginAPI
  void loginApi(String username, password) async {
    await EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    try {
      var response = await http.post(
          Uri.parse(
              ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.LOGIN_VERIFICATION),
          body: {
            'username': username,
            'password': password,
          });

      if (response.statusCode == 200) {
        setState(() {
          token = response.headers['token'].toString();
        });

        var responseJSON = json.decode(response.body);

        var responseCode = responseJSON['response_code'];

        if (responseCode == "200") {
          // Obtain shared preferences.
          var obj = responseJSON['obj'];
          await Global.services
              .setToken(AppConstants.STORAGE_USER_TOKEN, token!);
          debugPrint(obj.toString());
          Fluttertoast.showToast(
              msg: "Login Successfully",
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_SHORT,
              textColor: AppColors.yellowButton,
              backgroundColor: AppColors.darkGrey);
          getProfile();
          EasyLoading.dismiss();
        } else {
          var errorObj = responseJSON['obj'];
          debugPrint(errorObj);
          EasyLoading.dismiss();
        }
      } else {
        print(response.body);
        debugPrint('failed');
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
    }
  }

  //GetProfile_API
  void getProfile() async {
    final token = Global.services.getToken();
    await EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);
    var response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_PROFILE),
        headers: {"token": token!});

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];

        int appClientId = obj['appClientId'];

        await Global.services
            .setUserProfile(AppConstants.STORAGE_USER_PROFILE, jsonEncode(obj));

        await Global.services.setUserProfile(
            AppConstants.STORAGE_PROFILE_PICTURE, obj['profilePic']);

        await Global.services
            .setAppClientId(AppConstants.STORAGE_APP_CLIENT_ID, appClientId);
        debugPrint(obj.toString());
        EasyLoading.dismiss();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        var obj = responseBody['obj'];
        debugPrint(obj.toString());
        EasyLoading.dismiss();
      }
    } else {
      print(response.body);
      EasyLoading.dismiss();
      throw Exception("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100.h,
              width: 100.w,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    AppColors.yellowButton,
                    Colors.black,
                    Colors.black,
                    Colors.black,
                    Colors.black
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        Gap(7.h),
                        Text(
                          "Welcome Back",
                          style: GoogleFonts.quicksand(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          "Please enter your login details",
                          style: GoogleFonts.quicksand(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Gap(5.h),
                        Image(
                          image: const AssetImage("assets/logo/logo.png"),
                          height: 15.h,
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.h),
                          child: Column(
                            children: [
                              Gap(3.h),
                              //Username
                              TextFormField(
                                controller: usernameController,
                                style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp),
                                decoration: InputDecoration(
                                    hintText: "Enter username",
                                    prefixIcon: const Icon(Icons.mail),
                                    prefixIconColor: Colors.black,
                                    fillColor: Colors.white,
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(1.h)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(1.h))),
                              ),
                              Gap(1.5.h),
                              //Password
                              TextFormField(
                                controller: passwordController,
                                obscureText: obscure,
                                style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp),
                                decoration: InputDecoration(
                                    suffixIconColor: Colors.black,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscure = !obscure;
                                        });
                                      },
                                      icon: Icon(CupertinoIcons.eye_solid),
                                    ),
                                    hintText: "Enter password",
                                    prefixIcon: const Icon(Icons.lock),
                                    prefixIconColor: Colors.black,
                                    fillColor: Colors.white,
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(1.h)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(1.h))),
                              ),

                              //Check box and Forget Password Text
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                          checkColor: Colors.white,
                                          value: rememberMe,
                                          activeColor: Colors.yellow.shade800,
                                          side: const BorderSide(
                                              color: Colors.white),
                                          onChanged: (value) {
                                            setState(() {
                                              rememberMe = value as bool;
                                            });
                                          }),
                                      Text(
                                        "Remember me",
                                        style: GoogleFonts.quicksand(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgetPassword()));
                                    },
                                    child: Text(
                                      "Forget Password ?",
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(2.h),
                              InkWell(
                                onTap: () {
                                  var username =
                                      usernameController.text.toString();
                                  var password =
                                      passwordController.text.toString();
                                  loginApi(username, password);
                                  easyLoading();
                                },
                                child: Container(
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      color: AppColors.yellowButton,
                                      border: Border.all(
                                          color: Colors.white, width: 0.15.h),
                                      borderRadius: BorderRadius.circular(1.h)),
                                  child: Padding(
                                    padding: EdgeInsets.all(1.5.h),
                                    child: Center(
                                        child: Text(
                                      "Login",
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          color: Colors.black),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Powered By",
                          style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        Gap(2.w),
                        Image(
                          image: const AssetImage("assets/logo/logo.png"),
                          height: 3.h,
                        ),
                        Gap(2.w),
                        Text(
                          "NOVUS ARK",
                          style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
