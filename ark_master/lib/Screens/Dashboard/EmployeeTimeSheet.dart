import 'dart:convert';

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
import 'Employee.dart';

class EmployeeTimeSheet extends StatefulWidget {
  EmployeeTimeSheet({Key? key, required this.employeeDetails})
      : super(key: key);

  Map<String, dynamic> employeeDetails = {};

  @override
  State<EmployeeTimeSheet> createState() => _EmployeeTimeSheetState();
}

class _EmployeeTimeSheetState extends State<EmployeeTimeSheet> {
  //Integer
  int employeeId = 0;

  //String
  String firstName = "";
  String lastName = "";
  String middleName = "";
  String token = Global.services.getToken()!;

  //List
  List checkInList = [];

  @override
  void initState() {
    if (widget.employeeDetails.isNotEmpty) {
      employeeId = widget.employeeDetails['id'];
      firstName = widget.employeeDetails['firstName'];
      lastName = widget.employeeDetails['lastName'];
      middleName = widget.employeeDetails['middleName'];
    }
    getEmployeeCheckInList();
    super.initState();
  }

  void getEmployeeCheckInList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({"employeeId": employeeId});
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_EMPLOYEE_CHECKIN_LIST),
        headers: {"token": token, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());

        setState(() {
          checkInList = obj;
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

  //ON BACK PRESSED METHOD
  Future<bool> onBackPressed() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Employee()));
    return false;
  }

  Future<void> refreshIndicator() async {
    getEmployeeCheckInList();
  }

  //GLOBAL KEY
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
            "Employee Time Sheet",
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Employee()));
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
                        border: Border.all(color: AppColors.darkGrey),
                        color: Colors.white,
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(1.h),
            Expanded(
                child: RefreshIndicator(
              color: AppColors.yellowButton,
              onRefresh: refreshIndicator,
              child: ListView.builder(
                  itemCount: checkInList.length,
                  itemBuilder: (build, index) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black45)
                          ],
                          borderRadius: BorderRadius.circular(2.h)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Check In Time: ",
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp,
                                    color: AppColors.darkGrey),
                              ),
                              Gap(2.w),
                              Text(
                                checkInList[index]['checkInTimestamp'],
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp,
                                    color: AppColors.darkGrey),
                              ),
                            ],
                          ),
                          Divider(
                            color: AppColors.darkGrey.withOpacity(0.3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Check Out Time: ",
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp,
                                    color: AppColors.darkGrey),
                              ),
                              Gap(2.w),
                              Text(
                                checkInList[index]['checkoutTimestamp'],
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp,
                                    color: AppColors.darkGrey),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ))
          ],
        ),
      ),
    );
  }
}
