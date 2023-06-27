import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../../Utils/global.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Dashboard.dart';

class AppClientHSN_SAC extends StatefulWidget {
  const AppClientHSN_SAC({Key? key}) : super(key: key);

  @override
  State<AppClientHSN_SAC> createState() => _AppClientHSN_SACState();
}

class _AppClientHSN_SACState extends State<AppClientHSN_SAC> {
  //Integer
  int appClienthsnsacId = 0;
  int selectedHSNSACId = 0;

  //List for Storing Data
  List appClienthsnsacList = [];
  List HSNSACCODELIST = [];
  List searchClienthsnsacList = [];

  //TextEditingController
  TextEditingController SearchUserController = TextEditingController();

  @override
  void initState() {
    getAppClienthsnsacList_API();
    super.initState();
  }

  //Search Filter
  void runFilter(String enteredKeyword) async {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = appClienthsnsacList;
    } else {
      results = appClienthsnsacList
          .where((user) => user['code']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      searchClienthsnsacList = results;
    });
  }

  //GET APP CLIENT HSN SAC LIST
  void getAppClienthsnsacList_API() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final token = await Global.services.getToken();

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_APP_CLIENT_HSN_SAC_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          appClienthsnsacList = obj;
        });
        setState(() {
          searchClienthsnsacList = appClienthsnsacList;
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

  void GET_HSNSACCODELIST() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final token = await Global.services.getToken();
    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_HSNSACCODELIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          HSNSACCODELIST = obj;
          selectedHSNSACId = HSNSACCODELIST[0]['id'];
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

  void SAVE_APPCLIENT_HSNSACCODE() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final token = await Global.services.getToken();
    final appClientId = await Global.services.getAppClientId();

    bodyParam.addAll({
      "appClientId": appClientId,
      "status": true,
      "HsnSacId": selectedHSNSACId
    });

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.SAVE_APPCLIENT_HSNSACCODE),
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
        getAppClienthsnsacList_API();
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

  //DELETE APP CLIENT HSN SAC CODE
  void deleteAppClienthsnsac() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    if (appClienthsnsacId > 0) {
      bodyParam.addAll({"id": appClienthsnsacId});
    }

    final token = await Global.services.getToken();
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.DELETE_APPCLIENT_HSNSACCODE),
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
        getAppClienthsnsacList_API();
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

  //ENABLE APP CLIENT HSN SAC CODE
  void enableAppClientHsnSac() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    if (appClienthsnsacId > 0) {
      bodyParam.addAll({"id": appClienthsnsacId});
    }

    final token = await Global.services.getToken();
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.ENABLE_APP_CLIENT_HSN_SAC),
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
        getAppClienthsnsacList_API();
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

  //DISABLE APP CLIENT HSN SAC CODE
  void disableAppClientHsnSac() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    if (appClienthsnsacId > 0) {
      bodyParam.addAll({"id": appClienthsnsacId});
    }

    final token = await Global.services.getToken();
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.DISABLE_APP_CLIENT_HSN_SAC),
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
        getAppClienthsnsacList_API();
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

  Future refreshIndicator() async {
    getAppClienthsnsacList_API();
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
            "HSN/ SAC CODE",
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            IconButton(
                onPressed: () {
                  GET_HSNSACCODELIST();
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3.h),
                              topRight: Radius.circular(3.h))),
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 2.h),
                          child: Wrap(
                            children: [
                              Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "Add HSN Code",
                                      style: GoogleFonts.quicksand(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Gap(2.h),
                                ],
                              ),
                              Column(
                                children: [
                                  //Client company
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: "HSN SAC Code",
                                      labelStyle: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                      fillColor: Colors.white,
                                      filled: true,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2.h, horizontal: 5.w),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0.5.w,
                                              color: Colors.black45),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0.5.w,
                                              color: Colors.black54),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    isExpanded: true,
                                    hint: Text(
                                      'HSN SAC Code',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedHSNSACId = value as int;
                                      });
                                    },
                                    value: selectedHSNSACId,
                                    items: HSNSACCODELIST.map((item) {
                                      return DropdownMenuItem(
                                        child: new Text(
                                          item['code'].toString(),
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
                                  Gap(2.h),
                                  Container(
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                        color: AppColors.yellowButton,
                                        border: Border.all(
                                            color: Colors.white, width: 0.15.h),
                                        borderRadius:
                                            BorderRadius.circular(1.h)),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        SAVE_APPCLIENT_HSNSACCODE();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(1.5.h),
                                        child: Center(
                                            child: Text(
                                          "Add HSN SAC Code",
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                              color: Colors.black),
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
              ],
            ),
            Expanded(
                child: RefreshIndicator(
              onRefresh: refreshIndicator,
              color: AppColors.yellowButton,
              child: ListView.builder(
                  itemCount: searchClienthsnsacList.length,
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
                                    left: 8.w, top: 2.h, bottom: 2.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      searchClienthsnsacList[index]['code']
                                          .toString()
                                          .toUpperCase(),
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11.sp),
                                    ),
                                    Gap(0.5.h),
                                    Text(
                                      searchClienthsnsacList[index]
                                          ['description'],
                                      style: GoogleFonts.quicksand(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return PlatformAlertDialog(
                                                title: Text("Alert!!"),
                                                content: Text(
                                                    'Are you sure you want to Delete HSN/ SAC Code'),
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
                                                          appClienthsnsacId =
                                                              searchClienthsnsacList[
                                                                  index]['id'];
                                                        });
                                                        Navigator.pop(context);
                                                        deleteAppClienthsnsac();
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
                                        value: searchClienthsnsacList[index]
                                            ['status'],
                                        onChanged: (value) {
                                          setState(() {
                                            appClienthsnsacId =
                                                searchClienthsnsacList[index]
                                                    ['id'];
                                          });
                                          if (searchClienthsnsacList[index]
                                                  ['status'] ==
                                              false) {
                                            enableAppClientHsnSac();
                                          } else {
                                            disableAppClientHsnSac();
                                          }
                                        },
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          left: 1.5.w,
                          top: 2.5.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 3.w),
                            margin: EdgeInsets.symmetric(vertical: 1.h),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.yellowButton),
                            child: Text(
                              "${searchClienthsnsacList[index]['percentage']}%"
                                  .toString()
                                  .toUpperCase(),
                              style: GoogleFonts.quicksand(
                                fontSize: 10.sp,
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
