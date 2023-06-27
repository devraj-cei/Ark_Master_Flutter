import 'dart:convert';

import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'CustomerLedger.dart';
import 'Dashboard.dart';
import 'PendingInvoiceDetails.dart';

class CreditLedger extends StatefulWidget {
  const CreditLedger({Key? key}) : super(key: key);

  @override
  State<CreditLedger> createState() => _CreditLedgerState();
}

class _CreditLedgerState extends State<CreditLedger>
    with SingleTickerProviderStateMixin {
  //String
  var selectedYear;
  var yearStr = "ALL";
  var monthStr = "ALL";
  var selectedMonth = "ALL";
  String? token = Global.services.getToken();

  //List
  List years = [];
  List months = [];

  //TabController
  late TabController tabController;

  //List
  List creditLedgerListForCompany = [];
  List creditLedgerListForClient = [];
  List invoiceDetailList = [];

  //Integer
  int appClientId = Global.services.getAppClientId()!;
  int? index;

  //Bool
  bool companyWiseList = true;

  @override
  void initState() {
    super.initState();
    getYears();
    getCreditLedgerListForCompany();
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (tabController.indexIsChanging) {
          getCreditLedgerListForCompany();
        } else {
          getPendingInvoiceList();
        }
        print(tabController.index);
      });
  }

  //Years List
  getYears() {
    int currentYear = DateTime.now().year;
    for (int i = 0; i < 22; i++) {
      years.add(currentYear - i);
    }
    years.insertAll(0, ["ALL"]);
    setState(() {
      selectedYear = years[0];
      months.addAll([
        "JAN",
        "FEB",
        "MAR",
        "APR",
        "MAY",
        "JUN",
        "JUL",
        "AUG",
        "SEP",
        "OCT",
        "NOV",
        "DEC"
      ]);
      months.insertAll(0, ["ALL"]);
    });
  }

  void getCreditLedgerListForCompany() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    print(bodyParam);
    if (yearStr != "ALL") {
      bodyParam.addAll({'year': yearStr});
    }
    if (monthStr != "ALL") {
      bodyParam.addAll({'year': monthStr});
    }
    final token = Global.services.getToken();

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_PENDING_CREDIT_LEDGRE_FOR_CLIENT_COMPANIES),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          creditLedgerListForCompany = obj;
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

  void getCreditLedgerListForAllClient() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    print(bodyParam);
    if (yearStr != "ALL") {
      bodyParam.addAll({'year': yearStr});
    }
    if (monthStr != "ALL") {
      bodyParam.addAll({'year': monthStr});
    }

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_CREDIT_LEDGRE_FOR_CLIENT),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          creditLedgerListForClient = obj;
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

  void getPendingInvoiceList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({
      'isPaid': 0,
      'appClientId': appClientId,
    });
    if (yearStr != "ALL") {
      bodyParam.addAll({'year': yearStr});
    }
    if (monthStr != "ALL") {
      bodyParam.addAll({'year': monthStr});
    }
    print(bodyParam);

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_INVOICES_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          invoiceDetailList = obj;
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

  void sendPaymentReminder() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};

    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.SEND_PAYMENT_REMINDER),
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
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
      throw Exception(response.reasonPhrase);
    }
  }

  Future refreshIndicator() async {
    getCreditLedgerListForCompany();
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
          title: Text(
            "Credit Ledger".toUpperCase(),
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            Row(
              children: [
                Text(yearStr.toString()),
                SizedBox(
                  height: 2.h,
                  child: VerticalDivider(
                    color: Colors.white,
                  ),
                ),
                Text(monthStr.toString()),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(3.h),
                                  topLeft: Radius.circular(3.h))),
                          builder: (context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter myState) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 2.h),
                                child: Wrap(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Ledger Filter",
                                          style: GoogleFonts.quicksand(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Gap(2.h),
                                        DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              labelText: "Year",
                                              labelStyle: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 2.h,
                                                      horizontal: 2.w),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.5.w,
                                                      color:
                                                          AppColors.darkGrey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.h)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.5.w,
                                                      color:
                                                          AppColors.darkGrey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.h)),
                                            ),
                                            hint: Text(
                                              'Select Year',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedYear = value;
                                              });
                                            },
                                            value: selectedYear,
                                            items: years.map((value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList()),
                                        Gap(2.h),
                                        DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              labelText: "Month",
                                              labelStyle: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 2.h,
                                                      horizontal: 2.w),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.5.w,
                                                      color:
                                                          AppColors.darkGrey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.h)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.5.w,
                                                      color:
                                                          AppColors.darkGrey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.h)),
                                            ),
                                            hint: Text(
                                              'Select Month',
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedMonth = value as String;
                                              });
                                            },
                                            value: selectedMonth,
                                            items: months.map((value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList()),
                                        Gap(2.h),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (selectedYear == null) {
                                                yearStr = "ALL";
                                              } else {
                                                yearStr =
                                                    selectedYear.toString();
                                              }
                                              monthStr = selectedMonth;
                                            });
                                            setState(() {
                                              index = tabController.index;
                                              if (index == 0) {
                                                getCreditLedgerListForCompany();
                                              } else {
                                                getPendingInvoiceList();
                                              }
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                                color: AppColors.yellowButton,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 0.15.h),
                                                borderRadius:
                                                    BorderRadius.circular(1.h)),
                                            child: Padding(
                                              padding: EdgeInsets.all(1.5.h),
                                              child: Center(
                                                  child: Text(
                                                "Apply",
                                                style: GoogleFonts.quicksand(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.sp,
                                                    color: Colors.black),
                                              )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                          });
                    },
                    icon: Icon(
                      Icons.filter_list_rounded,
                      size: 2.5.h,
                    ))
              ],
            )
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
                            borderRadius: BorderRadius.circular(1.h),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10.h,
                                  offset: const Offset(0, 10),
                                  color: Colors.black12.withOpacity(0.10))
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            child: TabBar(
                              controller: tabController,
                              unselectedLabelColor: AppColors.darkGrey,
                              labelColor: AppColors.darkGrey,
                              indicatorColor: AppColors.yellowButton,
                              indicator: BoxDecoration(
                                  color: AppColors.yellowButton,
                                  borderRadius: BorderRadius.circular(1.h)),
                              tabs: [
                                Tab(
                                  child: Text(
                                    'LEDGER',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.darkGrey),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'PENDING INVOICE',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.darkGrey),
                                  ),
                                ),
                              ],
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
              child: TabBarView(
                controller: tabController,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "View Company Wise".toString().toUpperCase(),
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: PlatformSwitch(
                                      value: companyWiseList,
                                      activeColor: AppColors.yellowButton,
                                      onChanged: (value) {
                                        setState(() {
                                          companyWiseList = value;
                                        });
                                        if (companyWiseList == true) {
                                          getCreditLedgerListForCompany();
                                        } else {
                                          getCreditLedgerListForAllClient();
                                        }
                                      }),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(1.h)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 2.h,
                                  ),
                                  Gap(1.w),
                                  Text(
                                    'Add Credit',
                                    style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: companyWiseList,
                        child: Expanded(
                          child: RefreshIndicator(
                            onRefresh: refreshIndicator,
                            color: AppColors.yellowButton,
                            child: ListView.builder(
                                itemCount: creditLedgerListForCompany.length,
                                itemBuilder: (build, index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 1.h),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 1.h),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.h),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 1),
                                              blurRadius: 2,
                                              color: Colors.black45),
                                        ],
                                        color: Colors.white),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              creditLedgerListForCompany[index]
                                                      ['customer']
                                                  .toString(),
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                            Gap(2.h),
                                            Text(
                                              "Pending Amount:- ".toString(),
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  creditLedgerListForCompany[
                                                          index]['mobile']
                                                      .toString(),
                                                  style: GoogleFonts.quicksand(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                                Gap(2.h),
                                                Text(
                                                  "₹ " +
                                                      creditLedgerListForCompany[
                                                              index]['amount']
                                                          .toString(),
                                                  style: GoogleFonts.quicksand(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Gap(3.w),
                                            InkWell(
                                              onTap: () {
                                                Map<String, dynamic>
                                                    companyInvoiceDetails =
                                                    creditLedgerListForCompany[
                                                        index];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CustomerLedger(
                                                                companyInvoiceDetails:
                                                                    companyInvoiceDetails,
                                                                customerInvoiceDetails: {})));
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 1.w,
                                                      vertical: 0.5.h),
                                                  decoration: BoxDecoration(
                                                      color: AppColors.darkGrey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.5.h)),
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white,
                                                    size: 2.h,
                                                  )),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !companyWiseList,
                        child: Expanded(
                          child: RefreshIndicator(
                            onRefresh: refreshIndicator,
                            color: AppColors.yellowButton,
                            child: ListView.builder(
                                itemCount: creditLedgerListForClient.length,
                                itemBuilder: (build, index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 1.h),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 1.h),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.h),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 1),
                                              blurRadius: 2,
                                              color: Colors.black45),
                                        ],
                                        color: Colors.white),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              creditLedgerListForClient[index]
                                                      ['customer']
                                                  .toString(),
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                            Gap(2.h),
                                            Text(
                                              "Pending Amount:- ".toString(),
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  creditLedgerListForClient[
                                                          index]['mobile']
                                                      .toString(),
                                                  style: GoogleFonts.quicksand(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                                Gap(2.h),
                                                Text(
                                                  "₹ " +
                                                      creditLedgerListForClient[
                                                              index]['amount']
                                                          .toString(),
                                                  style: GoogleFonts.quicksand(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Gap(3.w),
                                            InkWell(
                                              onTap: () {
                                                Map<String, dynamic>
                                                    customerInvoiceDetails =
                                                    creditLedgerListForClient[
                                                        index];
                                                print(customerInvoiceDetails);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CustomerLedger(
                                                                companyInvoiceDetails: {},
                                                                customerInvoiceDetails:
                                                                    customerInvoiceDetails)));
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 1.w,
                                                      vertical: 0.5.h),
                                                  decoration: BoxDecoration(
                                                      color: AppColors.darkGrey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.5.h)),
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white,
                                                    size: 2.h,
                                                  )),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.h),
                        child: InkWell(
                          onTap: () {
                            sendPaymentReminder();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Send Payment Reminder"
                                    .toString()
                                    .toUpperCase(),
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.sp,
                                ),
                              ),
                              Gap(2.w),
                              Icon(FontAwesomeIcons.bell)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          color: AppColors.yellowButton,
                          onRefresh: refreshIndicator,
                          child: ListView.builder(
                            itemCount: invoiceDetailList.length,
                            itemBuilder: (context, index) {
                              var invoice = invoiceDetailList[index];
                              double amount = invoice['amount'] == null
                                  ? 0.0
                                  : invoice['amount'].toDouble();
                              bool isPaid = invoice['isPaid'];
                              var paymentStatus;
                              if (isPaid == true) {
                                paymentStatus = "Paid";
                              } else {
                                paymentStatus = "Unpaid";
                              }
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PendingInvoiceDetails(
                                                  pendingInvoiceDetails:
                                                      invoiceDetailList[
                                                          index])));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 1.h),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            invoice['clientCustomerName'],
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11.sp),
                                          ),
                                          Text(
                                            invoice['clientCompanyName'],
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11.sp),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: AppColors.darkGrey,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Invoice No.",
                                                style: GoogleFonts.quicksand(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10.sp),
                                              ),
                                              Gap(1.h),
                                              Text(
                                                invoice['invoiceNo'],
                                                style: GoogleFonts.quicksand(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10.sp),
                                              ),
                                            ],
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                VerticalDivider(
                                                  color: AppColors.darkGrey,
                                                  width: 0.2.w,
                                                ),
                                                Gap(3.w),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Amount",
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 10.sp),
                                                    ),
                                                    Gap(1.h),
                                                    Text(
                                                      amount.toString(),
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 10.sp),
                                                    ),
                                                  ],
                                                ),
                                                Gap(3.w),
                                                VerticalDivider(
                                                    color: AppColors.darkGrey,
                                                    width: 0.2.w),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                invoice['date'],
                                                style: GoogleFonts.quicksand(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10.sp),
                                              ),
                                              Gap(1.h),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.h),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.w,
                                                    vertical: 0.6.h),
                                                child: Text(
                                                  paymentStatus,
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: !isPaid
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontSize: 10.sp),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      )
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
