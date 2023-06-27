import 'dart:convert';

import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Dashboard.dart';

class EmployeeLeaveRequest extends StatefulWidget {
  const EmployeeLeaveRequest({Key? key}) : super(key: key);

  @override
  State<EmployeeLeaveRequest> createState() => _EmployeeLeaveRequestState();
}

class _EmployeeLeaveRequestState extends State<EmployeeLeaveRequest> {
  //String
  String? token = Global.services.getToken()!;

  //Integer
  int leaveRequestId = 0;

  //List
  List employeeLeaveList = [];
  List searchEmployeeLeave = [];
  List reasonList = [
    "You have already used leave",
    "You didn’t meticulously plan for your leave applications in advance.",
    "You didn’t deliver on a project schedule.",
    "You didn’t discuss your leave applications with your team."
  ];

  //String
  String reasonString = "You have already used leave";

  //TEXT EDITING CONTROLLER
  TextEditingController searchLeaveController = TextEditingController();
  TextEditingController otherReasonController = TextEditingController();

  @override
  void initState() {
    getEmployeeLeaveRequestList();
    super.initState();
  }

  //GET APP CLIENT USER LIST
  void getEmployeeLeaveRequestList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_EMPLOYEE_LEAVE_REQUEST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          employeeLeaveList = obj;
        });
        setState(() {
          searchEmployeeLeave = employeeLeaveList;
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

  void rejectLeaveRequest() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "id": leaveRequestId,
      "rejectionNote": otherReasonController.text.toString()
    });
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.REJECT_EMPLOYEE_LEAVES_REQUEST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        print(obj.toString());
        Navigator.pop(context);
        EasyLoading.dismiss();
        getEmployeeLeaveRequestList();
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

  void acceptLeaveRequest() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "id": leaveRequestId,
    });
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.APPROVE_EMPLOYEE_LEAVES_REQUEST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        print(obj.toString());
        Navigator.pop(context);
        EasyLoading.dismiss();
        getEmployeeLeaveRequestList();
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

  //Search Filter
  void runFilter(String enteredKeyword) async {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = employeeLeaveList;
    } else {
      results = employeeLeaveList
          .where((user) => user['employee']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      searchEmployeeLeave = results;
    });
  }

  Future refreshIndicator() async {
    getEmployeeLeaveRequestList();
  }

  //BackPressed
  Future<bool> onBackPressed() async {
    Navigator.push(
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
            "Employee Leave Request".toUpperCase(),
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
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
            Column(
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
                                left: 5.w, bottom: 0.2.h, right: 1.w),
                            child: TextFormField(
                              onChanged: (value) {
                                runFilter(value);
                              },
                              controller: searchLeaveController,
                              style: GoogleFonts.quicksand(
                                  fontSize: 11.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  suffixIconColor: Colors.black,
                                  hintText: "Search",
                                  hintStyle: GoogleFonts.quicksand(
                                      fontSize: 11.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(1.h),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.yellowButton,
                onRefresh: refreshIndicator,
                child: ListView.builder(
                  itemCount: searchEmployeeLeave.length,
                  itemBuilder: (build, index) {
                    //Variables
                    var leaveList = searchEmployeeLeave[index];
                    var labelDate;
                    bool? approvalStatus = null;
                    bool rl_1 = false;
                    bool rl_2 = false;
                    bool rl_3 = false;

                    if (leaveList.toString().contains("approvalStatus")) {
                      approvalStatus = leaveList['approvalStatus'];
                    }
                    if (approvalStatus == null) {
                      rl_1 = true;
                      rl_2 = false;
                      rl_3 = false;
                    } else if (approvalStatus == true) {
                      rl_1 = false;
                      rl_2 = true;
                      rl_3 = false;
                    } else {
                      rl_3 = true;
                    }
                    if (leaveList['fromDate'] == leaveList['toDate']) {
                      labelDate = searchEmployeeLeave[index]['fromDate'];
                    } else {
                      labelDate =
                          leaveList['fromDate'] + " To " + leaveList['toDate'];
                    }

                    var leaveType;
                    if (leaveList['type'] == 1) {
                      leaveType = "Single Day";
                    } else if (leaveList['type'] == 2) {
                      leaveType = "Multiple Day";
                    } else {
                      leaveType = "Half Day";
                    }

                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black45,
                                blurRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(2.h)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                leaveList['employee'].toString(),
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp),
                              ),
                              Text(
                                leaveType,
                                style: GoogleFonts.quicksand(
                                    color: AppColors.yellowButton,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.sp),
                              ),
                            ],
                          ),
                          Gap(1.h),
                          Text(
                            "Reason: " + leaveList['reason'],
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600, fontSize: 10.sp),
                          ),
                          Text(
                            "Leave Date: " + labelDate,
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600, fontSize: 10.sp),
                          ),
                          Gap(1.5.h),
                          Visibility(
                            visible: rl_1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        isDismissible: false,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(2.h),
                                                topLeft: Radius.circular(2.h))),
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 2.h),
                                            child: Wrap(
                                              children: [
                                                Row(
                                                  children: [
                                                    Spacer(),
                                                    Text(
                                                      'Reject Leave Request',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12.sp),
                                                    ),
                                                    Spacer(),
                                                    InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            Icon(Icons.cancel))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Gap(2.h),
                                                    //Reason
                                                    DropdownButtonFormField(
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Reason",
                                                        labelStyle: GoogleFonts.quicksand(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        2.h,
                                                                    horizontal:
                                                                        2.w),
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 0.5.w,
                                                                color: Colors
                                                                    .black45),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 0.5.w,
                                                                color: Colors
                                                                    .black54),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                      isExpanded: true,
                                                      hint: Text(
                                                        'Select Reason',
                                                        style: GoogleFonts.quicksand(
                                                            textStyle: TextStyle(
                                                                fontSize: 11.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      ),
                                                      value: reasonString,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          reasonString =
                                                              value as String;
                                                        });
                                                      },
                                                      items: reasonList
                                                          .map((e) =>
                                                              DropdownMenuItem(
                                                                child: Text(e),
                                                                value: e,
                                                              ))
                                                          .toList(),
                                                    ),
                                                    Gap(1.5.h),
                                                    //Other Reason TextField
                                                    TextFormField(
                                                      controller:
                                                          otherReasonController,
                                                      maxLines: 2,
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 11.sp),
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Other Reason",
                                                          labelText:
                                                              "Other Reason",
                                                          labelStyle: GoogleFonts
                                                              .quicksand(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      11.sp),
                                                          fillColor:
                                                              Colors.white,
                                                          filled: true,
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          1.h)),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      1.h))),
                                                    ),
                                                    Gap(1.5.h),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          leaveRequestId =
                                                              leaveList['id'];
                                                        });
                                                        rejectLeaveRequest();
                                                      },
                                                      child: Container(
                                                        width: 100.w,
                                                        decoration: BoxDecoration(
                                                            color: AppColors
                                                                .yellowButton,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.1.h),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        1.h)),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  1.5.h),
                                                          child: Center(
                                                              child: Text(
                                                            "Reject Leave"
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .quicksand(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: Colors
                                                                        .black),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(2.h),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 0.5),
                                              blurRadius: 1,
                                              color: Colors.black45)
                                        ]),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 2.5.h,
                                        ),
                                        Gap(1.w),
                                        Text(
                                          'Reject',
                                          style: GoogleFonts.quicksand(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    PlatformAlertDialog(
                                      title: Text("Alert!!"),
                                      content: Text(
                                          'Are you sure you want to Delete Client User'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
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
                                                leaveRequestId =
                                                    leaveList['id'];
                                              });
                                              Navigator.of(context).pop();
                                              acceptLeaveRequest();
                                            },
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(fontSize: 12.sp),
                                            ))
                                      ],
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(2.h),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 0.5),
                                              blurRadius: 1,
                                              color: Colors.black45)
                                        ]),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Accept',
                                          style: GoogleFonts.quicksand(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                        Gap(1.w),
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 2.5.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: rl_2,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 2.5.h,
                                ),
                                Gap(1.w),
                                Text(
                                  'Accepted',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: rl_3,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 2.5.h,
                                ),
                                Gap(1.w),
                                Text(
                                  'Rejected:- ',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                SizedBox(
                                  width: 52.w,
                                  child: Text(
                                    leaveList['rejectionNote'],
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: GoogleFonts.quicksand(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
