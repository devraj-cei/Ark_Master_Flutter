import 'dart:io';

import 'package:ark_master/Utils/App_Colors.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../Drawer/NavigationDrawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //Declaring Global Values
  DateTime pre_backPress = DateTime.now();

  //String
  String image_url = "http://arkledger.techregnum.com/assets/AppClientUsers/";
  String profilePic = Global.services.getProfilePic()!;

  @override
  void initState() {
    super.initState();
  }

  //Back Press Functionality
  Future<bool> onBackPressed() async {
    final timeGap = DateTime.now().difference(pre_backPress);

    final cantExit = timeGap >= Duration(seconds: 1);

    pre_backPress = DateTime.now();

    if (cantExit) {
      //show Snack bar
      final snack = SnackBar(
        content: Text('Press Back button again to Exit'),
        duration: Duration(seconds: 2),
      );

      ScaffoldMessenger.of(context).showSnackBar(snack);

      return false; // false will do nothing when back press
    } else {
      if (Platform.isIOS) {
        exit(0);
      } else {
        SystemNavigator.pop();
      }
      return true; // true will exit the app
    }
  }

  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        key: key,
        backgroundColor: Colors.grey.shade100,
        drawer: NavigationDrawerLayout(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Dashboard",
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white)),
                child: CircleAvatar(
                  radius: 1.5.h,
                  backgroundImage: NetworkImage(image_url + profilePic),
                ))
          ],
          leading: IconButton(
            icon: Image(
              image: const AssetImage('assets/utils/menu.png'),
              height: 3.5.h,
              color: Colors.white,
            ),
            onPressed: () {
              if (key.currentState != null) {
                key.currentState!.openDrawer();
              }
            },
          ),
        ),
        body: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 15.h,
                  child: Stack(
                    children: [
                      Container(
                        height: 10.h,
                        decoration: const BoxDecoration(
                            color: AppColors.darkGrey,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 1,
                                  color: Colors.black45)
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.h, vertical: 1.h),
                        child: Text(
                          "Invoice",
                          style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        top: 5.h,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2.h),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10.h,
                                  offset: const Offset(0, 10),
                                  color: Colors.black12.withOpacity(0.10))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  //Credit Ledger
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(1.h),
                      Text(
                        "Credit Ledger",
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold, fontSize: 12.sp),
                      ),
                      Gap(1.h),
                      Container(
                        height: 11.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.h),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10.h,
                                offset: const Offset(0, 10),
                                color: Colors.black12.withOpacity(0.10))
                          ],
                        ),
                      )
                    ],
                  ),
                  //Expenses
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(1.h),
                      Text(
                        "Expenses",
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold, fontSize: 12.sp),
                      ),
                      Gap(1.h),
                      Container(
                        height: 11.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.h),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10.h,
                                offset: const Offset(0, 10),
                                color: Colors.black12.withOpacity(0.10))
                          ],
                        ),
                      )
                    ],
                  ),
                  //Payroll
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(1.h),
                      Text(
                        "Payroll",
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold, fontSize: 12.sp),
                      ),
                      Gap(1.h),
                      Container(
                        height: 11.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.h),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10.h,
                                offset: const Offset(0, 10),
                                color: Colors.black12.withOpacity(0.10))
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
