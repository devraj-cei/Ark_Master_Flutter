import 'dart:convert';

import 'package:ark_master/Screens/Dashboard/ExpensesAdd.dart';
import 'package:ark_master/Utils/global.dart';
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
import '../Drawer/NavigationDrawer.dart';
import 'Dashboard.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  //String
  String? token = Global.services.getToken()!;

  //Integer
  int selectedCompanyId = 0;
  int expenseId = 0;

  //List
  List clientCompanyList = [];
  List expenseList = [];

  //TextEditingController
  TextEditingController companyNameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController notesController = TextEditingController();

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
        getExpenseHistory();
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

  //GET EXPENSES HISTORY LIST
  void getExpenseHistory() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_EXPENSES_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          expenseList = obj;
        });
        print(expenseList);
        EasyLoading.dismiss();
      } else {
        var obj = responseBody['obj'];
        print("ERROR: " + obj.toString());
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
      throw Exception(response.reasonPhrase);
    }
  }

  void deleteExpenseHistory() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    if (expenseId > 0) {
      bodyParam.addAll({"id": expenseId});
    }
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.DELETE_EXPENSES),
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
        getExpenseHistory();
        EasyLoading.dismiss();
      } else {
        var obj = responseBody['obj'];
        print("ERROR: " + obj.toString());
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
      throw Exception(response.reasonPhrase);
    }
  }

  Future refreshIndicator() async {
    getExpenseHistory();
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
            "Expenses".toUpperCase(),
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
                          builder: (context) => ExpensesAdd(
                                expenseDetails: {},
                              )));
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
                                    getExpenseHistory();
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
              ],
            ),
            Gap(1.h),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshIndicator,
                color: AppColors.yellowButton,
                child: ListView.builder(
                  itemCount: expenseList.length,
                  itemBuilder: (build, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 0.7.h),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black45)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.h)),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "₹ " +
                                      expenseList[index]["amount"].toString(),
                                  style: GoogleFonts.quicksand(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11.sp),
                                ),
                                Gap(0.5.h),
                                Text(
                                  expenseList[index]["type"],
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.sp),
                                ),
                                Gap(0.5.h),
                                Text(
                                  expenseList[index]["clientComapnyNm"],
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  expenseList[index]['date'],
                                  style: GoogleFonts.quicksand(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.darkGrey),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          companyNameController.text =
                                              expenseList[index]
                                                  ['clientComapnyNm'];
                                          typeController.text =
                                              expenseList[index]['type'];
                                          notesController.text =
                                              expenseList[index]['notes'];
                                        });
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(3.h),
                                                    topRight:
                                                        Radius.circular(3.h))),
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 2.h),
                                                child: Wrap(
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        'Expenses Details',
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                color: AppColors
                                                                    .darkGrey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    13.sp),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Gap(2.h),
                                                        Text(
                                                          'Company Name',
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontSize:
                                                                      11.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        Gap(1.h),
                                                        TextFormField(
                                                          controller:
                                                              companyNameController,
                                                          readOnly: true,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontSize:
                                                                      11.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(1
                                                                              .h),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              AppColors.darkGrey))),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Gap(2.h),
                                                        Text(
                                                          'Type',
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontSize:
                                                                      11.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        Gap(1.h),
                                                        TextFormField(
                                                          controller:
                                                              typeController,
                                                          readOnly: true,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontSize:
                                                                      11.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(1
                                                                              .h),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              AppColors.darkGrey))),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Gap(2.h),
                                                        Text(
                                                          'Note',
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontSize:
                                                                      11.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                        Gap(1.h),
                                                        TextFormField(
                                                          controller:
                                                              notesController,
                                                          readOnly: true,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontSize:
                                                                      11.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(1
                                                                              .h),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              AppColors.darkGrey))),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Icon(
                                        Icons.info_rounded,
                                        color: AppColors.darkGrey,
                                        size: 3.5.h,
                                      ),
                                    ),
                                    Gap(1.w),
                                    InkWell(
                                      onTap: () {
                                        Map<String, dynamic> expenseDetails =
                                            expenseList[index];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ExpensesAdd(
                                                        expenseDetails:
                                                            expenseDetails)));
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
                                    Gap(1.w),
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
                                                          expenseId =
                                                              expenseList[index]
                                                                  ['id'];
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                        deleteExpenseHistory();
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
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.w, vertical: 1.h),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.darkGrey),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 2.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
