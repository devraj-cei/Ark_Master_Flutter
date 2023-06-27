import 'dart:convert';

import 'package:ark_master/Screens/Dashboard/EmployeeEmergencyDetailsList.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';

class EmployeeEmergencyDetails_Add extends StatefulWidget {
  EmployeeEmergencyDetails_Add(
      {Key? key, required this.employeeDetails, required this.emergencyDetail})
      : super(key: key);

  Map<String, dynamic> employeeDetails = {};
  Map<String, dynamic> emergencyDetail = {};

  @override
  State<EmployeeEmergencyDetails_Add> createState() =>
      _EmployeeEmergencyDetails_AddState();
}

class _EmployeeEmergencyDetails_AddState
    extends State<EmployeeEmergencyDetails_Add> {
  //Map
  Map<String, dynamic> employeeDetails = {};
  Map<String, dynamic> emergencyDetail = {};

  //String
  String firstName = "";
  String lastName = "";
  String middleName = "";
  String? token = Global.services.getToken()!;

  //Integer
  int employeeId = 0;
  int relationId = 0;
  int userId = 0;

  //List
  List relationList = [];

  //TextEditingController
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    if (widget.employeeDetails.isNotEmpty) {
      firstName = widget.employeeDetails['firstName'];
      lastName = widget.employeeDetails['lastName'];
      middleName = widget.employeeDetails['middleName'];
      employeeId = widget.employeeDetails['id'];
      print(firstName);
    }
    if (widget.emergencyDetail.isNotEmpty) {
      nameController.text = widget.emergencyDetail['personName'];
      emailController.text = widget.emergencyDetail['email'];
      mobileController.text = widget.emergencyDetail['mobile'];
      relationId = widget.emergencyDetail['relationId'];
      userId = widget.emergencyDetail['id'];
    }
    getRelationList();
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EmployeeEmergencyDetailsList(
                employeeDetails: widget.employeeDetails)));
    return false;
  }

  void getRelationList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_RELATION_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          relationList = obj;

          if (relationId == 0) {
            relationId = relationList[0]['id'];
          }
        });

        EasyLoading.dismiss();
      } else {
        var obj = responseBody['obj'];
        print(obj.toString());
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
      throw Exception(response.reasonPhrase);
    }
  }

  void saveEmployeeEmergencyDetails() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "status": true,
      "employeeId": employeeId,
      "personName": nameController.text.toString(),
      "mobile": mobileController.text.toString(),
      "email": emailController.text.toString(),
      "relationId": relationId,
    });
    if (userId != 0) {
      bodyParam.addAll({"id": userId});
    }
    print(bodyParam);
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.SAVE_EMPLOYEE_EMERGENCY_DETAILS),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        print(obj.toString());
        EasyLoading.dismiss();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EmployeeEmergencyDetailsList(
                      employeeDetails: widget.employeeDetails,
                    )));
      } else {
        var obj = responseBody['obj'];
        print(obj.toString());
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
      throw Exception(response.reasonPhrase);
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
              "Add Emergency Details",
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold, fontSize: 12.sp),
            ),
            backgroundColor: AppColors.darkGrey,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmployeeEmergencyDetailsList(
                                  employeeDetails: widget.employeeDetails,
                                )));
                  },
                  icon: Icon(Icons.arrow_back_ios, size: 2.5.h))
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
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: AppColors.darkGrey,
                            hintText: "Enter name",
                            labelText: "Enter name",
                            labelStyle: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp),
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.h)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.h))),
                      ),
                      Gap(1.h),
                      TextFormField(
                        controller: emailController,
                        style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: AppColors.darkGrey,
                            hintText: "Enter email",
                            labelText: "Enter email",
                            labelStyle: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp),
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.h)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.h))),
                      ),
                      Gap(1.h),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        controller: mobileController,
                        style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: AppColors.darkGrey,
                            hintText: "Enter mobile",
                            labelText: "Enter mobile",
                            labelStyle: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp),
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.h)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.h))),
                      ),
                      Gap(1.h),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Relation",
                          labelStyle: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500)),
                          prefixIcon: Icon(Icons.house),
                          prefixIconColor: Colors.black,
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 2.w),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black45),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black54),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select Relation',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            relationId = value as int;
                          });
                        },
                        value: relationId,
                        items: relationList.map((item) {
                          return DropdownMenuItem(
                            child: new Text(
                              item['title'].toString(),
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500)),
                            ),
                            value: item['id'],
                          );
                        }).toList(),
                      ),
                      Gap(1.h),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    saveEmployeeEmergencyDetails();
                  },
                  child: Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: AppColors.yellowButton,
                        border: Border.all(color: Colors.white, width: 0.15.h),
                        borderRadius: BorderRadius.circular(1.h)),
                    child: Padding(
                      padding: EdgeInsets.all(1.5.h),
                      child: Center(
                          child: Text(
                        "Save Emergency Details",
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
        ));
  }
}
