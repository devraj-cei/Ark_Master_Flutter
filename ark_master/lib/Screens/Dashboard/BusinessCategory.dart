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
import '../../Utils/Global.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Dashboard.dart';

class BusinessCategory extends StatefulWidget {
  const BusinessCategory({Key? key}) : super(key: key);

  @override
  State<BusinessCategory> createState() => _BusinessCategoryState();
}

class _BusinessCategoryState extends State<BusinessCategory> {
  //String
  String imageUrl =
      "http://arkledger.techregnum.com/assets/BusinessCategories/";

  //Integer
  int appClientId = 0;
  int selectedCompanyId = 0;
  int companyId = 0;
  int businessCategoryId = 0;
  int pendingBusinessCategoryId = 0;

  //Bool
  bool visible = false;

  //List
  List listOfCompany = [];
  List companyList = [];
  List businessCategoryList = [];
  List pendingBusinessCategoryList = [];
  List searchBusinessCategoryList = [];

  //Text Editing Controller
  TextEditingController SearchCategoryController = TextEditingController();

  @override
  void initState() {
    getClientCompanyList();
    super.initState();
  }

  void getClientCompanyList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    final token = await Global.services.getToken();
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
        print(obj.toString());
        setState(() {
          listOfCompany = obj;
          listOfCompany.insertAll(0, [
            {"id": 0, "name": "Select Company"}
          ]);
        });
        if (listOfCompany.isNotEmpty) {
          selectedCompanyId = listOfCompany[1]['id'];
        }
        getBusinessCategoryList();
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

  void getCompanyList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    final token = await Global.services.getToken();
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
        print(obj.toString());
        setState(() {
          companyList = obj;
        });
        if (companyList.isNotEmpty) {
          companyId = companyList[0]['id'];
        }
        getPendingCategoryList();
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

  void getPendingCategoryList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    final token = await Global.services.getToken();
    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({"appClientCompanyId": selectedCompanyId});
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_PENDING_BUSINESS_CATEGORY_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          pendingBusinessCategoryList = obj;
          if (pendingBusinessCategoryList.length > 0) {
            pendingBusinessCategoryId = pendingBusinessCategoryList[0]['id'];
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

  void getBusinessCategoryList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    final token = await Global.services.getToken();
    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({"appClientCompanyId": selectedCompanyId});
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_MAP_BUSINESS_CATEGORY_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          businessCategoryList = obj;
          searchBusinessCategoryList = businessCategoryList;

          if (searchBusinessCategoryList.isNotEmpty) {
            visible = true;
          } else {
            visible = false;
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

  //DELETE APP CLIENT HSN SAC CODE
  void deleteBusinessCategory() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    if (businessCategoryId > 0) {
      bodyParam.addAll({"id": businessCategoryId});
    }

    print(bodyParam);
    final token = await Global.services.getToken();
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.DELETE_BUSINESS_CATEGORY_CLIENT_MAPPING_LIST),
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
        getBusinessCategoryList();
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
  void enableBusinessCategory() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    if (businessCategoryId > 0) {
      bodyParam.addAll({"id": businessCategoryId, "status": true});
    }

    final token = await Global.services.getToken();
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint
                .ENABLE_BUSINESS_CATEGORY_SUBCATEGORY_CLIENT_MAPPING_LIST),
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
        getBusinessCategoryList();
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
  void disableBusinessCategory() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    if (businessCategoryId > 0) {
      bodyParam.addAll({"id": businessCategoryId, "status": false});
    }

    final token = await Global.services.getToken();
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint
                .DISABLE_BUSINESS_CATEGORY_SUBCATEGORY_CLIENT_MAPPING_LIST),
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
        getBusinessCategoryList();
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

  //SavePendingCategory
  void SavePendingCategory() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "appClientId": Global.services.getAppClientId(),
      "appClientCompanyId": companyId,
      "businessCategoryId": pendingBusinessCategoryId
    });

    print(bodyParam);
    final token = await Global.services.getToken();
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.SAVE_BUSINESS_CATEGORY_CLIENT_MAPPING_LIST),
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
        Navigator.pop(context);
        getClientCompanyList();
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

  //Search Filter
  void runFilter(String enteredKeyword) async {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = businessCategoryList;
    } else {
      results = businessCategoryList
          .where((user) => user['title']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      searchBusinessCategoryList = results;
    });
  }

  Future refreshIndicator() async {
    getBusinessCategoryList();
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
        floatingActionButton: FloatingActionButton(
          splashColor: AppColors.yellowButton,
          backgroundColor: AppColors.darkGrey,
          onPressed: () {
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.h),
                      topRight: Radius.circular(3.h))),
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      child: Wrap(
                        children: [
                          Column(
                            children: [
                              Text(
                                "Search Business Category",
                                style: GoogleFonts.quicksand(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGrey),
                              ),
                              Gap(2.h),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 70.w,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        runFilter(value);
                                      },
                                      controller: SearchCategoryController,
                                      style: GoogleFonts.quicksand(
                                          fontSize: 11.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                      decoration: InputDecoration(
                                          hintText: "Search Users",
                                          hintStyle: GoogleFonts.quicksand(
                                              fontSize: 11.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2.h),
                                              borderSide: BorderSide(
                                                  color: AppColors.darkGrey)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2.h),
                                              borderSide: BorderSide(
                                                  color: AppColors.darkGrey))),
                                    ),
                                  ),
                                  Gap(2.w),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 15.w,
                                      height: 7.h,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.h),
                                      decoration: BoxDecoration(
                                          color: AppColors.darkGrey,
                                          borderRadius:
                                              BorderRadius.circular(2.h)),
                                      child: Icon(
                                        Icons.search,
                                        color: AppColors.yellowButton,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Gap(2.h),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Icon(
            Icons.search,
            color: AppColors.yellowButton,
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Business Categories",
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
            //AppBar & Dropdown
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
                            onChanged: (value) {
                              setState(() {
                                selectedCompanyId = value as int;
                                getBusinessCategoryList();
                              });
                            },
                            value: selectedCompanyId,
                            items: listOfCompany
                                .map((e) => DropdownMenuItem(
                                      child: Text(
                                        e['name'].toString(),
                                        style: GoogleFonts.quicksand(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      value: e['id'],
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(1.h),
            visible
                ? InkWell(
                    onTap: () {
                      getCompanyList();
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(3.h),
                                topLeft: Radius.circular(3.h))),
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h),
                            child: Wrap(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Add Category",
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp),
                                    ),
                                    Gap(2.h),
                                    Container(
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          labelText: "Company",
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
                                          'Select Company',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            companyId = value as int;
                                            getPendingCategoryList();
                                            print(companyId);
                                          });
                                        },
                                        value: companyId,
                                        items: companyList.map((item) {
                                          return DropdownMenuItem(
                                            child: new Text(
                                              item['name'].toString(),
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            value: item['id'],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Gap(2.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 65.w,
                                          child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              labelText:
                                                  "Pending Business Category",
                                              labelStyle: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              fillColor: Colors.white,
                                              filled: true,
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 2.h,
                                                      horizontal: 5.w),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.5.w,
                                                      color: Colors.black45),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.5.w,
                                                      color: Colors.black54),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            isExpanded: true,
                                            hint: Text(
                                              'Select Pending Business Category',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                pendingBusinessCategoryId =
                                                    value as int;
                                                print(
                                                    pendingBusinessCategoryId);
                                              });
                                            },
                                            value: pendingBusinessCategoryId,
                                            items: pendingBusinessCategoryList
                                                .map((item) {
                                              return DropdownMenuItem(
                                                child: new Text(
                                                  item['title'].toString(),
                                                  style: GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                                value: item['id'],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            SavePendingCategory();
                                          },
                                          child: Container(
                                            width: 22.w,
                                            height: 7.h,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w,
                                                vertical: 0.5.h),
                                            decoration: BoxDecoration(
                                                color: AppColors.darkGrey,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        1.5.h)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  "Add",
                                                  style: GoogleFonts.quicksand(
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 52.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                          color: AppColors.darkGrey,
                          borderRadius: BorderRadius.circular(1.5.h)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            "Add Business Category",
                            style: GoogleFonts.quicksand(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            Gap(1.h),
            Expanded(
                child: RefreshIndicator(
              color: AppColors.yellowButton,
              onRefresh: refreshIndicator,
              child: ListView.builder(
                  itemCount: searchBusinessCategoryList.length,
                  itemBuilder: (build, index) {
                    var businessCategory = searchBusinessCategoryList[index];
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      margin:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.h),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black45)
                          ]),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 6.h,
                                width: 13.w,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 1.h),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(2.h),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                          color: Colors.black45)
                                    ]),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2.h),
                                    child: Image(
                                      image: NetworkImage(imageUrl +
                                          businessCategory['imageFile']),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    businessCategory['title'],
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 65.w,
                                child: Text(
                                  businessCategory['description'],
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 9.sp),
                                ),
                              ),
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
                                                      businessCategoryId =
                                                          searchBusinessCategoryList[
                                                                  index][
                                                              'businessCategorySubCategoryClientMapId'];
                                                    });
                                                    Navigator.of(context).pop();
                                                    deleteBusinessCategory();
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
                              //PLATFORM SWITCH
                              Transform.scale(
                                scale: 0.8,
                                child: PlatformSwitch(
                                    activeColor: AppColors.yellowButton,
                                    value: businessCategory['status'],
                                    onChanged: (value) {
                                      setState(() {
                                        businessCategoryId = businessCategory[
                                            'businessCategorySubCategoryClientMapId'];
                                      });
                                      print(businessCategory['status']);
                                      if (businessCategory['status'] == true) {
                                        disableBusinessCategory();
                                      } else {
                                        enableBusinessCategory();
                                      }
                                    }),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            )),
          ],
        ),
      ),
    );
  }
}
