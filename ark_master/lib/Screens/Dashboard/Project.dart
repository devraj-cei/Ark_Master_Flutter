import 'dart:convert';

import 'package:ark_master/Screens/Dashboard/ProjectAdd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Dashboard.dart';

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  //Bool
  bool? projectStatus;

  //Integer
  int projectId = 0;
  int selectedCompanyId = 0;

  //List
  List clientCompanyList = [];
  List projectsList = [];

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

  //GET TIMESHEET REPORT
  void getProjectList() async {
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
          projectsList = obj;
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

  //ENABLE / DISABLE PROJECT
  void enableDisableProject_API() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");
    bodyParam.addAll({"id": projectId});

    var enableDisable;

    if (projectStatus == true) {
      enableDisable = ApiEndPoint.DISABLE_PROJECT;
    } else {
      enableDisable = ApiEndPoint.ENABLE_PROJECT;
    }

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + enableDisable),
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

  //REFRESH INDICATOR
  Future refreshIndicator() async {
    getProjectList();
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
            "Projects".toUpperCase(),
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
                          builder: (context) =>
                              ProjectAdd(projectDetails: {})));
                },
                icon: Icon(Icons.add_circle))
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
                                    getProjectList();
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
                  itemCount: projectsList.length,
                  itemBuilder: (build, index) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black45)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.h)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(1.h),
                              Row(
                                children: [
                                  Text(
                                    "Title:",
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.sp),
                                  ),
                                  Gap(2.w),
                                  Text(
                                    projectsList[index]['title'],
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.sp),
                                  )
                                ],
                              ),
                              Gap(1.5.h),
                              Row(
                                children: [
                                  Text(
                                    "Description:",
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.sp),
                                  ),
                                  Gap(2.w),
                                  SizedBox(
                                    width: 35.w,
                                    child: Text(
                                      projectsList[index]['description'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.sp),
                                    ),
                                  )
                                ],
                              ),
                              Gap(1.h),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Map<String, dynamic> projectDetails =
                                      projectsList[index];

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProjectAdd(
                                              projectDetails: projectDetails)));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.darkGrey),
                                  child: Icon(
                                    Icons.edit_rounded,
                                    color: Colors.white,
                                    size: 2.h,
                                  ),
                                ),
                              ),
                              Transform.scale(
                                  scale: 0.8,
                                  child: PlatformSwitch(
                                    activeColor: AppColors.yellowButton,
                                    value: projectsList[index]['status'],
                                    onChanged: (value) {
                                      setState(() {
                                        projectId = projectsList[index]['id'];
                                        projectStatus =
                                            projectsList[index]['status'];
                                        enableDisableProject_API();
                                      });
                                    },
                                  ))
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
