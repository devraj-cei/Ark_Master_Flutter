import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Dashboard.dart';

class TimeSheetReport extends StatefulWidget {
  const TimeSheetReport({Key? key}) : super(key: key);

  @override
  State<TimeSheetReport> createState() => _TimeSheetReportState();
}

class _TimeSheetReportState extends State<TimeSheetReport> {
  //Integer
  int selectedCompanyId = 0;

  //List
  List clientCompanyList = [];
  List timeSheetReport = [];

  @override
  void initState() {
    getCompaniesList();
    super.initState();
  }

  //GET APP CLIENT USER LIST
  void getCompaniesList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    print(bodyParam);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");

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
        print(obj.toString());
        setState(() {
          clientCompanyList = obj;
          clientCompanyList.insertAll(0, [
            {"id": 0, "name": "ALL"}
          ]);
        });
        if (clientCompanyList.length > 0) {
          selectedCompanyId = clientCompanyList[0]['id'];
        }

        getTimeSheetReport();
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

  //GET TIMESHEET REPORT
  void getTimeSheetReport() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    print(bodyParam);

    if (selectedCompanyId > 0) {
      bodyParam.addAll({"clientCompanyId": selectedCompanyId});
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_TIME_SHEET_REPORTS_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          timeSheetReport = obj;
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

  //REFRESH INDICATOR
  Future refreshIndicator() async {
    getTimeSheetReport();
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
            "Time Sheet Report".toUpperCase(),
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
                                left: 5.w, bottom: 0.2.h, right: 3.w),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(
                                  'Select Company',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500)),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCompanyId = value as int;
                                    getTimeSheetReport();
                                  });
                                },
                                value: selectedCompanyId,
                                items: clientCompanyList.map((item) {
                                  return DropdownMenuItem(
                                    child: new Text(
                                      item['name'].toString(),
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
                  itemCount: timeSheetReport.length,
                  itemBuilder: (build, index) {
                    var dateString = timeSheetReport[index]['date'];
                    DateTime date =
                        DateFormat('mm/dd/yyyy hh:mm:ss').parse(dateString);
                    String formattedDate =
                        DateFormat('yyyy/MM/dd').format(date);
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.h),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black45),
                          ],
                          color: Colors.white),
                      child: Column(
                        children: [
                          Text(
                            timeSheetReport[index]['project'],
                            style: GoogleFonts.quicksand(
                                fontSize: 11.sp, fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            color: AppColors.darkGrey,
                            thickness: 0.2.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Spacer(),
                              //Date
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Date",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    formattedDate.toString(),
                                    style: GoogleFonts.quicksand(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Spacer(),
                              SizedBox(
                                height: 3.h,
                                child: VerticalDivider(
                                  color: AppColors.darkGrey,
                                  thickness: 0.2.w,
                                ),
                              ),
                              Spacer(),
                              //Hours
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Hours",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    timeSheetReport[index]['hours'].toString(),
                                    style: GoogleFonts.quicksand(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Spacer(),
                              SizedBox(
                                height: 3.h,
                                child: VerticalDivider(
                                  color: AppColors.darkGrey,
                                  thickness: 0.2.w,
                                ),
                              ),
                              Spacer(),
                              //Minutes
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Minutes",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    timeSheetReport[index]['minute'].toString(),
                                    style: GoogleFonts.quicksand(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Spacer(),
                            ],
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
