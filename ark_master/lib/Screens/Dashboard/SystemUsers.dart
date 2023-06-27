import 'dart:convert';

import 'package:ark_master/API/ApiEndPoint.dart';
import 'package:ark_master/Screens/Dashboard/UpdateSystemUsers.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Dashboard.dart';

class SystemUsers extends StatefulWidget {
  const SystemUsers({Key? key}) : super(key: key);

  @override
  State<SystemUsers> createState() => _SystemUsersState();
}

class _SystemUsersState extends State<SystemUsers> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  String? token = Global.services.getToken();

  //Blank BodyParam for API
  Map<String, dynamic> bodyParam = {};
  Map<String, dynamic> systemUser = {};

  //List for Storing Data
  List appClientUserList = [];
  List searchClientUserList = [];

  //Integer
  int userId = 0;

  //Text Editing Controller
  TextEditingController SearchUserController = TextEditingController();

  @override
  void initState() {
    getAppClientUsersList_API();
    super.initState();
  }

  //Search Filter
  void runFilter(String enteredKeyword) async {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = appClientUserList;
    } else {
      results = appClientUserList
          .where((user) => user['name']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      searchClientUserList = results;
    });
  }

  //GET APP CLIENT USER LIST
  void getAppClientUsersList_API() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final token = Global.services.getToken();

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_APP_CLIENT_USER_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];

        setState(() {
          appClientUserList = obj;
        });
        setState(() {
          searchClientUserList = appClientUserList;
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

  //ENABLE CLIENT USER API
  void enableClientUser_API() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({"id": userId, "status": true});
    print(bodyParam);

    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.ENABLE_CLIENT_USERS),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        getAppClientUsersList_API();
        var obj = responseBody['obj'];
        print(obj.toString());
        Fluttertoast.showToast(
            msg: obj.toString(),
            fontSize: 11.sp,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            textColor: AppColors.yellowButton,
            backgroundColor: AppColors.darkGrey);
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

  //DISABLE CLIENT USER API
  void disableClientUser_API() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({"id": userId, "status": true});
    print(bodyParam);

    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.DISABLE_CLIENT_USERS),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        getAppClientUsersList_API();
        var obj = responseBody['obj'];
        print(obj.toString());
        Fluttertoast.showToast(
            msg: obj.toString(),
            fontSize: 11.sp,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            textColor: AppColors.yellowButton,
            backgroundColor: AppColors.darkGrey);
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

  //DELETE CLIENT USER
  void deleteClientUser() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({"id": userId, "status": true});
    print(bodyParam);

    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.DELETE_CLIENT_USERS),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        getAppClientUsersList_API();
        var obj = responseBody['obj'];
        print(obj.toString());
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
    getAppClientUsersList_API();
  }

  //BackPressed
  Future<bool> onBackPressed() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
    return false;
  }

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
            "System Users",
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
                          builder: (context) => UpdateSystemUsers(
                                userId: 0,
                                systemUser: {},
                              )));
                },
                icon: Icon(
                  Icons.add_circle,
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
                              controller: SearchUserController,
                              style: GoogleFonts.quicksand(
                                  fontSize: 11.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  suffixIconColor: Colors.black,
                                  hintText: "Search Users",
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
              ],
            ),
            Gap(1.h),
            Expanded(
                child: RefreshIndicator(
              onRefresh: refreshIndicator,
              color: AppColors.yellowButton,
              child: ListView.builder(
                  itemCount: searchClientUserList.length,
                  itemBuilder: (build, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: 10.w, top: 1.5.h, right: 5.w),
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
                                padding: EdgeInsets.only(
                                    left: 11.w, top: 2.h, bottom: 2.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      searchClientUserList[index]['name']
                                          .toString()
                                          .toUpperCase(),
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11.sp),
                                    ),
                                    Gap(0.5.h),
                                    //Mobile Number
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.grey.shade700,
                                          size: 2.h,
                                        ),
                                        Gap(2.w),
                                        Text(
                                          searchClientUserList[index]['mobile'],
                                          style: GoogleFonts.quicksand(
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10.sp),
                                        )
                                      ],
                                    ),
                                    Gap(0.5.h),
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
                                          width: 37.w,
                                          child: Text(
                                            searchClientUserList[index]
                                                ['email'],
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
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          userId =
                                              searchClientUserList[index]['id'];
                                          systemUser.addAll({
                                            "name": searchClientUserList[index]
                                                ['name'],
                                            "mobile":
                                                searchClientUserList[index]
                                                    ['mobile'],
                                            "email": searchClientUserList[index]
                                                ['email'],
                                            "appClientCompaniesId":
                                                searchClientUserList[index]
                                                    ['appClientCompaniesId']
                                          });
                                        });

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateSystemUsers(
                                                        userId: userId,
                                                        systemUser:
                                                            systemUser)));
                                      },
                                      child: Icon(
                                        Icons.edit_rounded,
                                        size: 3.h,
                                      )),
                                  Gap(2.w),
                                  InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return PlatformAlertDialog(
                                                title: Text("Alert!!"),
                                                content: Text(
                                                    'Are you sure you want to Delete Client User'),
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
                                                              searchClientUserList[
                                                                  index]['id'];
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                        deleteClientUser();
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
                                  Transform.scale(
                                      scale: 0.8,
                                      child: PlatformSwitch(
                                        activeColor: AppColors.yellowButton,
                                        value: searchClientUserList[index]
                                            ['status'],
                                        onChanged: (value) {
                                          setState(() {
                                            userId = searchClientUserList[index]
                                                ['id'];
                                          });

                                          if (searchClientUserList[index]
                                                  ['status'] ==
                                              true) {
                                            disableClientUser_API();
                                          } else {
                                            enableClientUser_API();
                                          }
                                        },
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 1.h,
                          left: 4.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 5.w),
                            margin: EdgeInsets.symmetric(vertical: 2.h),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.yellowButton),
                            child: Text(
                              searchClientUserList[index]['name'][0]
                                  .toString()
                                  .toUpperCase(),
                              style: GoogleFonts.quicksand(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
            ))
          ],
        ),
      ),
    );
  }
}
