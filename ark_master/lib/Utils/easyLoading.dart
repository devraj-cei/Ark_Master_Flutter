import 'package:ark_master/Utils/App_Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

void easyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 5.h
    ..radius = 1.h
    ..progressColor = AppColors.yellowButton
    ..backgroundColor = Colors.white
    ..indicatorColor = AppColors.yellowButton
    ..textColor = Colors.black
    ..textStyle = GoogleFonts.quicksand(
        textStyle: TextStyle(
            color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold))
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
