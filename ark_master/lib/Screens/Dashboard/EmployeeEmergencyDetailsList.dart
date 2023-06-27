import 'dart:convert';

import 'package:ark_master/Screens/Dashboard/Employee.dart';
import 'package:ark_master/Screens/Dashboard/EmployeeEmergencyDetails_Add.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';

class EmployeeEmergencyDetailsList extends StatefulWidget {
  EmployeeEmergencyDetailsList({Key? key, required this.employeeDetails})
      : super(key: key);

  Map<String, dynamic> employeeDetails = {};

  @override
  State<EmployeeEmergencyDetailsList> createState() =>
      _EmployeeEmergencyDetailsListState();
}

class _EmployeeEmergencyDetailsListState
    extends State<EmployeeEmergencyDetailsList> {
  //String
  String? token = Global.services.getToken()!;
  String firstName = "";
  String lastName = "";
  String middleName = "";

  //Integer
  int employeeId = 0;
  int userId = 0;

  //List
  List employeeEmergencyDetailsList = [];

  @override
  void initState() {
    if (widget.employeeDetails.isNotEmpty) {
      setState(() {
        firstName = widget.employeeDetails['firstName'];
        lastName = widget.employeeDetails['lastName'];
        middleName = widget.employeeDetails['middleName'];
        employeeId = widget.employeeDetails['id'];
      });
    }

    getEmployeeEmergencyDetails();
    super.initState();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context, MaterialPageRoute(builder: (context) => Employee()));
    return false;
  }

  void getEmployeeEmergencyDetails() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};
    setState(() {
      bodyParam.addAll({"employeeId": employeeId});
    });
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_EMPLOYEE_EMERGENCY_DETAILS_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          employeeEmergencyDetailsList = obj;
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

  void deleteEmployeeEmergencyDetail() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};
    setState(() {
      bodyParam.addAll({"id": userId});
    });
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.DELETE_EMPLOYEE_EMERGENCY_DETAILS),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        print(obj.toString());
        getEmployeeEmergencyDetails();
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

  Future<void> refreshIndicator() async {
    getEmployeeEmergencyDetails();
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
            "Employee Emergency Details",
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => Employee()));
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 2.5.h,
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
            SizedBox(
              height: 5.h,
              child: Stack(
                children: [
                  Container(
                    height: 3.h,
                    decoration: BoxDecoration(
                        color: AppColors.darkGrey,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(3.h),
                            bottomRight: Radius.circular(3.h)),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 1,
                              color: Colors.black45)
                        ]),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    top: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.darkGrey),
                        borderRadius: BorderRadius.circular(2.h),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10.h,
                              offset: const Offset(0, 10),
                              color: Colors.black12.withOpacity(0.10))
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 5.w, bottom: 0.2.h, right: 3.w),
                        child: Center(
                          child: Text(
                            "${firstName} ${middleName} ${lastName}",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold, fontSize: 11.sp),
                          ),
                        ),
                        //List of Company Dropdown
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(1.h),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmployeeEmergencyDetails_Add(
                              employeeDetails: widget.employeeDetails,
                              emergencyDetail: {},
                            )));
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      color: AppColors.darkGrey,
                      borderRadius: BorderRadius.circular(2.h)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      ),
                      Gap(2.w),
                      Text(
                        "Add Emergency Details",
                        style: GoogleFonts.quicksand(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  )),
            ),
            Gap(1.h),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.yellowButton,
                onRefresh: refreshIndicator,
                child: ListView.builder(
                  itemCount: employeeEmergencyDetailsList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 0.5.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black45,
                                blurRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(2.h)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employeeEmergencyDetailsList[index]
                                          ['personName']
                                      .toString()
                                      .toUpperCase(),
                                  style: GoogleFonts.quicksand(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp),
                                ),
                                Gap(1.h),
                                //Email
                                Row(
                                  children: [
                                    Icon(
                                      Icons.mail,
                                      color: Colors.grey.shade700,
                                      size: 2.h,
                                    ),
                                    Gap(2.w),
                                    SizedBox(
                                      width: 40.w,
                                      child: Text(
                                        employeeEmergencyDetailsList[index]
                                                ['email']
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: GoogleFonts.quicksand(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                //Relation
                                Gap(1.h),
                                Text(
                                  "Relation: ${employeeEmergencyDetailsList[index]['relation'].toString()}",
                                  style: GoogleFonts.quicksand(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.sp),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Mobile Number
                              Text(
                                "Mo:- ${employeeEmergencyDetailsList[index]['mobile']}",
                                style: GoogleFonts.quicksand(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp),
                              ),
                              Gap(2.h),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return PlatformAlertDialog(
                                                title: Text("Alert!!"),
                                                content: Text(
                                                    'Are you sure you want to Delete Employee Emergency Details?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 12.sp),
                                                      )),
                                                  TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          userId =
                                                              employeeEmergencyDetailsList[
                                                                  index]['id'];
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                        deleteEmployeeEmergencyDetail();
                                                      },
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            fontSize: 12.sp),
                                                      ))
                                                ],
                                              );
                                            });
                                      },
                                      child: Icon(
                                        Icons.cancel_rounded,
                                        size: 3.h,
                                      )),
                                  Gap(3.w),
                                  InkWell(
                                      onTap: () {
                                        Map<String, dynamic> emergencyDetail = {
                                          "id": employeeEmergencyDetailsList[
                                              index]['id'],
                                          "personName":
                                              employeeEmergencyDetailsList[
                                                  index]['personName'],
                                          "mobile":
                                              employeeEmergencyDetailsList[
                                                  index]['mobile'],
                                          "email": employeeEmergencyDetailsList[
                                              index]['email'],
                                          "relationId":
                                              employeeEmergencyDetailsList[
                                                  index]['relationId'],
                                        };
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EmployeeEmergencyDetails_Add(
                                                        employeeDetails: widget
                                                            .employeeDetails,
                                                        emergencyDetail:
                                                            emergencyDetail)));
                                      },
                                      child: Icon(
                                        Icons.edit_rounded,
                                        size: 3.h,
                                      )),
                                  Transform.scale(
                                      scale: 0.8,
                                      child: PlatformSwitch(
                                        activeColor: AppColors.yellowButton,
                                        value:
                                            employeeEmergencyDetailsList[index]
                                                ['status'],
                                        onChanged: (value) {},
                                      ))
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
