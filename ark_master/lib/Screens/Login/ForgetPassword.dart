import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../Utils/App_Colors.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController verifyNumberController = TextEditingController();

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
                          "Forget Password ?",
                          style: GoogleFonts.quicksand(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          "Please Enter your Mobile Number",
                          style: GoogleFonts.quicksand(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Gap(5.h),
                        Image(
                          image: const AssetImage(
                              "assets/icon/forgot-password.png"),
                          color: Colors.white,
                          height: 12.h,
                        ),
                        Gap(5.h),
                        //Username
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Column(
                            children: [
                              TextFormField(
                                textInputAction: TextInputAction.done,
                                maxLength: 10,
                                keyboardType: TextInputType.number,
                                controller: verifyNumberController,
                                style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp),
                                decoration: InputDecoration(
                                    hintText: "Enter mobile",
                                    prefixIcon: const Icon(Icons.phone),
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
                            ],
                          ),
                        ),
                        Gap(1.5.h),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: 100.w,
                        decoration: BoxDecoration(
                            color: AppColors.yellowButton,
                            border:
                                Border.all(color: Colors.white, width: 0.15.h),
                            borderRadius: BorderRadius.circular(1.h)),
                        child: Padding(
                          padding: EdgeInsets.all(1.5.h),
                          child: Center(
                              child: Text(
                            "Verify Number",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                                color: Colors.black),
                          )),
                        ),
                      ),
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
