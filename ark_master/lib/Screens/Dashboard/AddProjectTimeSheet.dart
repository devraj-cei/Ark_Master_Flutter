import 'dart:convert';
import 'dart:io';

import 'package:ark_master/Screens/Dashboard/Dashboard.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';

class AddProjectTimeSheet extends StatefulWidget {
  const AddProjectTimeSheet({Key? key}) : super(key: key);

  @override
  State<AddProjectTimeSheet> createState() => _AddProjectTimeSheetState();
}

class _AddProjectTimeSheetState extends State<AddProjectTimeSheet> {
  //String
  String title = "Add Project Timesheet";

  //Integer
  int projectId = 0;
  int clientCompanyId = 0;

  //DatePicker
  DateTime date = DateTime.now();
  Duration initialTimer = const Duration();
  var time;

  String? _selectedTime;
  String? hour;
  String? minutes;

  //List
  List clientCompany = [];
  List projectList = [];

  //Map
  Map<String, dynamic> projectDetails = {};

  //TEXT EDITING CONTROLLER
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    getClientCompanyList();
    super.initState();
  }

  void getClientCompanyList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final token = await Global.services.getToken();

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
          clientCompany = obj;

          if (clientCompanyId == 0) {
            clientCompanyId = clientCompany[0]['id'];
          }
        });
        getProjectList();
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

  void getProjectList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final token = await Global.services.getToken();

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_PROJECT_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          projectList = obj;

          if (projectId == 0) {
            projectId = projectList[0]['id'];
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

  void saveProject() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "clientCompanyId": clientCompanyId,
      "projectId": projectId,
      "date": dateController.text.toString(),
      "hours": hour.toString(),
      "minute": minutes.toString()
    });

    if (projectId > 0) {
      bodyParam.addAll({"id": projectId});
    }

    final token = await Global.services.getToken();
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.SAVE_TIME_SHEET),
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
        EasyLoading.dismiss();
      } else {
        var obj = responseBody['obj'];
        print(obj.toString());
        Fluttertoast.showToast(
            msg: obj.toString(),
            fontSize: 11.sp,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            textColor: AppColors.yellowButton,
            backgroundColor: AppColors.darkGrey);
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
      throw Exception(response.reasonPhrase);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        dateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _show() async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _selectedTime = result.format(context);
        hour = result.hour.toString();
        minutes = result.minute.toString();
        timeController.text = _selectedTime!;
      });
    }
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
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          height: 6.h,
          decoration: BoxDecoration(
              color: AppColors.yellowButton,
              border: Border.all(color: Colors.white, width: 0.15.h),
              borderRadius: BorderRadius.circular(1.h)),
          child: InkWell(
            onTap: () {
              saveProject();
            },
            child: Padding(
              padding: EdgeInsets.all(1.5.h),
              child: Center(
                  child: Text(
                "SAVE",
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: Colors.black),
              )),
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            title.toUpperCase(),
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
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
              Column(
                children: [
                  //Client company
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Client Company",
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5.w, color: Colors.black45),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5.w, color: Colors.black54),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    isExpanded: true,
                    hint: Text(
                      'Select company',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.w500)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        clientCompanyId = value as int;
                      });
                    },
                    value: clientCompanyId,
                    items: clientCompany.map((item) {
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
                  Gap(1.5.h),
                  //Project List
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Project List",
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5.w, color: Colors.black45),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5.w, color: Colors.black54),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    isExpanded: true,
                    hint: Text(
                      'Project List',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.w500)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        projectId = value as int;
                      });
                    },
                    value: projectId,
                    items: projectList.map((item) {
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
                  Gap(1.5.h),
                  //Date of Expense TextField
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () {
                      if (Platform.isAndroid) {
                        _selectDate(context);
                      }
                      if (Platform.isIOS) {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 30.h,
                              child: CupertinoDatePicker(
                                initialDateTime: date,
                                backgroundColor: Colors.white,
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(
                                    () {
                                      dateController.text =
                                          newDate.toString().split(' ')[0];
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                    style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp),
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit_calendar),
                        suffixIconColor: AppColors.darkGrey,
                        hintText: "Select Date",
                        labelText: "Select Date",
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
                  Gap(1.5.h),
                  TextFormField(
                    controller: timeController,
                    readOnly: true,
                    onTap: () {
                      if (Platform.isAndroid) {
                        _show();
                      }
                      if (Platform.isIOS) {
                        CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.hms,
                          minuteInterval: 1,
                          secondInterval: 1,
                          initialTimerDuration: initialTimer,
                          onTimerDurationChanged: (Duration changeTimer) {
                            setState(() {
                              initialTimer = changeTimer;
                              time =
                                  '${changeTimer.inHours} hrs ${changeTimer.inMinutes % 60} mins ${changeTimer.inSeconds % 60} secs';
                            });
                          },
                        );
                      }
                    },
                    style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp),
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.timer_outlined),
                        suffixIconColor: AppColors.darkGrey,
                        hintText: "Select time",
                        labelText: "Select time",
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
