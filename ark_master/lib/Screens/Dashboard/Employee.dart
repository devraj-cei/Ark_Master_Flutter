import 'dart:convert';

import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Dashboard.dart';
import 'EmployeeAdd.dart';
import 'EmployeeEmergencyDetailsList.dart';
import 'EmployeeProfile.dart';
import 'EmployeeTimeSheet.dart';

class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  //String
  String? token = Global.services.getToken()!;
  String imageUrl = "http://arkledger.techregnum.com/assets/Employees/";

  //Integer
  var selectedCompanyId;
  int appClientId = Global.services.getAppClientId()!;
  int employeeId = 0;

  //List
  List listOfCompany = [];
  List employeeList = [];

  //Map
  Map<String, dynamic> employeeDetails = {};

  @override
  void initState() {
    getClientCompanyList();
    super.initState();
  }

  void getClientCompanyList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_CLIENT_COMPANIES_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];

        setState(() {
          listOfCompany = obj;
          listOfCompany.insertAll(0, [
            {"id": 0, "name": "ALL"}
          ]);
        });
        if (listOfCompany.isNotEmpty) {
          selectedCompanyId = listOfCompany[0]['id'];
        }

        getEmployeeList();
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

  void getEmployeeList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    if (selectedCompanyId > 0) {
      bodyParam.addAll({"clientCompanyId": selectedCompanyId});
    }
    bodyParam.addAll({"appClientId": appClientId});

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_EMPLOYEE_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];

        setState(() {
          employeeList = obj;
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

  //ENABLE EMPLOYEE API
  void enableEmployee_API() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");

    bodyParam.addAll({"id": employeeId, "status": true});
    print(bodyParam);

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.ENABLE_EMPLOYEE),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        print(obj.toString());
        Fluttertoast.showToast(
            msg: obj.toString(),
            fontSize: 11.sp,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            textColor: AppColors.yellowButton,
            backgroundColor: AppColors.darkGrey);
        getEmployeeList();
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

  //DISABLE EMPLOYEE API
  void disableEmployee_API() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");

    bodyParam.addAll({"id": employeeId, "status": true});
    print(bodyParam);

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.DISABLE_EMPLOYEE),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        print(obj.toString());
        Fluttertoast.showToast(
            msg: obj.toString(),
            fontSize: 11.sp,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            textColor: AppColors.yellowButton,
            backgroundColor: AppColors.darkGrey);
        getEmployeeList();
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
    getClientCompanyList();
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
    return false;
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
            "Employee",
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmployeeAdd(
                                employeeDetails: {},
                              )));
                },
                icon: Icon(Icons.add_circle, size: 2.5.h))
          ],
          leading: IconButton(
            icon: Image(
              image: const AssetImage('assets/utils/menu.png'),
              height: 3.h,
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
                        //List of Company Dropdown
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: selectedCompanyId,
                            items: listOfCompany.map((e) {
                              return DropdownMenuItem(
                                child: Text(e['name']),
                                value: e['id'],
                              );
                            }).toList(),
                            onChanged: (Object? value) {
                              setState(() {
                                selectedCompanyId = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(1.h),
            //LIST OF EMPLOYEES
            Expanded(
                child: RefreshIndicator(
              color: AppColors.yellowButton,
              onRefresh: refreshIndicator,
              child: ListView.builder(
                  itemCount: employeeList.length,
                  itemBuilder: (build, index) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.h),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black45,
                                blurRadius: 2)
                          ]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("UID : ${employeeList[index]['uid']}"),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EmployeeProfile(
                                              employeeDetails:
                                                  employeeList[index])));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.5.h, horizontal: 0.5.h),
                                  decoration: BoxDecoration(
                                      color: AppColors.darkGrey,
                                      borderRadius: BorderRadius.circular(1.h)),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 1.5.h,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Gap(1.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.5.h, horizontal: 1.5.w),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(1.h),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 0.5),
                                          color: Colors.black45,
                                          blurRadius: 1)
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1.h),
                                  child: Image(
                                    height: 8.h,
                                    width: 18.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                          height: 8.h,
                                          width: 16.w,
                                          child: Icon(
                                            FontAwesomeIcons.image,
                                            color: AppColors.darkGrey,
                                            size: 4.h,
                                          ));
                                    },
                                    image: NetworkImage(imageUrl +
                                        employeeList[index]['profilePic']),
                                  ),
                                ),
                              ),
                              Gap(5.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${employeeList[index]['firstName']} ${employeeList[index]['lastName']} ${employeeList[index]['lastName']}",
                                      style: GoogleFonts.quicksand(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold)),
                                  Gap(0.5.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.mail,
                                        size: 2.h,
                                      ),
                                      Gap(1.w),
                                      Text(
                                        employeeList[index]['personalEmail'],
                                        style: GoogleFonts.quicksand(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Gap(0.5.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.call,
                                        size: 2.h,
                                      ),
                                      Gap(1.w),
                                      Text(
                                        employeeList[index]['mobile'],
                                        style: GoogleFonts.quicksand(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Gap(0.5.h),
                                ],
                              )
                            ],
                          ),
                          Gap(2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //EMERGENCY DETAILS
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    employeeDetails.addAll({
                                      "id": employeeList[index]['id'],
                                      "firstName": employeeList[index]
                                          ['firstName'],
                                      "lastName": employeeList[index]
                                          ['lastName'],
                                      "middleName": employeeList[index]
                                          ['middleName']
                                    });
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmployeeEmergencyDetailsList(
                                                  employeeDetails:
                                                      employeeDetails)));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.5.w, vertical: 0.7.h),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2.h),
                                      border:
                                          Border.all(color: AppColors.darkGrey),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 0.5),
                                            color: Colors.black26,
                                            blurRadius: 2)
                                      ]),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_rounded),
                                      Gap(0.5.h),
                                      Text(
                                        "Emergency Details",
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 8.5.sp),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Gap(1.w),
                              //EMPLOYEE TIME SHEET
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    employeeDetails.addAll({
                                      "id": employeeList[index]['id'],
                                      "firstName": employeeList[index]
                                          ['firstName'],
                                      "lastName": employeeList[index]
                                          ['lastName'],
                                      "middleName": employeeList[index]
                                          ['middleName']
                                    });
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmployeeTimeSheet(
                                                  employeeDetails:
                                                      employeeDetails)));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.5.w, vertical: 0.7.h),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(2.h),
                                      border:
                                          Border.all(color: AppColors.darkGrey),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 0.5),
                                            color: Colors.black26,
                                            blurRadius: 2)
                                      ]),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_filled,
                                        color: Colors.green,
                                      ),
                                      Gap(1.h),
                                      Text(
                                        "Time Sheet",
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 8.5.sp,
                                            color: Colors.green),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //PLATFORM SWITCH
                              Transform.scale(
                                scale: 0.8,
                                child: PlatformSwitch(
                                    activeColor: AppColors.yellowButton,
                                    value: employeeList[index]['status'],
                                    onChanged: (value) {
                                      setState(() {
                                        setState(() {
                                          employeeId =
                                              employeeList[index]['id'];
                                        });
                                        if (employeeList[index]['status'] ==
                                            true) {
                                          disableEmployee_API();
                                        } else {
                                          enableEmployee_API();
                                        }
                                      });
                                    }),
                              )
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
