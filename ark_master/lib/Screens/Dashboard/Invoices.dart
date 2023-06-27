import 'dart:convert';
import 'package:ark_master/Screens/Dashboard/InvoiceDetails.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Dashboard.dart';

class Invoices extends StatefulWidget {
  const Invoices({Key? key}) : super(key: key);

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  //Integer
  int selectedCompanyId = 0;
  int selectedCustomerId = 0;

  //Bool
  bool? payment;
  var selectedYear;

  //String
  var yearStr = "ALL";
  var monthStr = "ALL";
  var selectedMonth = "ALL";
  String? token = Global.services.getToken();

  //List
  List years = [];
  List months = [];
  List clientCompanyList = [];
  List invoiceHistoryList = [];
  List clientCustomerList = [];

  @override
  void initState() {
    getYears();
    getCompaniesList();
    super.initState();
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
        getInvoiceHistory();
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

  //GET INVOICE HISTORY LIST
  void getInvoiceHistory() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    if (selectedCompanyId == 0) {
    } else {
      bodyParam.addAll({"clientCompanyId": selectedCompanyId});
    }
    if (payment != null) {
      bodyParam.addAll({"isPaid": payment});
    }
    if (selectedYear != "ALL") {
      bodyParam.addAll({"year": selectedYear});
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
          invoiceHistoryList = obj;
        });

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

  //REFRESH INDICATOR
  Future<void> refreshIndicator() async {
    getInvoiceHistory();
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
            "Invoices",
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
                                height: 50.h,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                    color: AppColors.darkGrey),
                                                borderRadius:
                                                    BorderRadius.circular(1.h)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 0.5.w,
                                                    color: AppColors.darkGrey),
                                                borderRadius:
                                                    BorderRadius.circular(1.h)),
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
                                                    color: AppColors.darkGrey),
                                                borderRadius:
                                                    BorderRadius.circular(1.h)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 0.5.w,
                                                    color: AppColors.darkGrey),
                                                borderRadius:
                                                    BorderRadius.circular(1.h)),
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
                                      //ClientCustomerName
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          labelText: "Customer",
                                          labelStyle: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500)),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 2.h, horizontal: 2.w),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 0.5.w,
                                                  color: AppColors.darkGrey),
                                              borderRadius:
                                                  BorderRadius.circular(1.h)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 0.5.w,
                                                  color: AppColors.darkGrey),
                                              borderRadius:
                                                  BorderRadius.circular(1.h)),
                                        ),
                                        hint: Text(
                                          'Select Customer',
                                          style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                        onChanged: (value) {},
                                        value: selectedCustomerId,
                                        items: clientCustomerList.map((item) {
                                          return DropdownMenuItem(
                                            child: new Text(
                                              item['clientCustomerName']
                                                  .toString(),
                                              style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            value: item['clientCustomerId'],
                                          );
                                        }).toList(),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: RadioListTile(
                                              contentPadding: EdgeInsets.all(0),
                                              title: Text("Paid",
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11.sp)),
                                              value: true,
                                              groupValue: payment,
                                              activeColor:
                                                  AppColors.yellowButton,
                                              onChanged: (value) {
                                                myState(() {
                                                  payment = value;
                                                  print(payment);
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: RadioListTile(
                                              contentPadding: EdgeInsets.all(0),
                                              title: Text("Unpaid",
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11.sp)),
                                              value: false,
                                              activeColor:
                                                  AppColors.yellowButton,
                                              groupValue: payment,
                                              onChanged: (value) {
                                                myState(() {
                                                  payment = value;
                                                  print(payment);
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: RadioListTile(
                                              contentPadding: EdgeInsets.all(0),
                                              title: Text("ALL",
                                                  style: GoogleFonts.quicksand(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 11.sp)),
                                              value: null,
                                              activeColor:
                                                  AppColors.yellowButton,
                                              groupValue: payment,
                                              onChanged: (value) {
                                                myState(() {
                                                  payment = value;
                                                  print(payment);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (selectedYear == null) {
                                              yearStr = "ALL";
                                            } else {
                                              yearStr = selectedYear.toString();
                                            }
                                            monthStr = selectedMonth;
                                          });
                                          Navigator.of(context).pop();
                                          getInvoiceHistory();
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
                                    getInvoiceHistory();
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
                color: AppColors.yellowButton,
                onRefresh: refreshIndicator,
                child: ListView.builder(
                  itemCount: invoiceHistoryList.length,
                  itemBuilder: (context, index) {
                    var invoice = invoiceHistoryList[index];
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
                        Map<String, dynamic> invoiceDetails =
                            invoiceHistoryList[index];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvoiceDetails(
                                    invoiceDetails: invoiceDetails)));
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
                                              style: GoogleFonts.quicksand(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10.sp),
                                            ),
                                            Gap(1.h),
                                            Text(
                                              amount.toString(),
                                              style: GoogleFonts.quicksand(
                                                  fontWeight: FontWeight.w600,
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
                                              BorderRadius.circular(1.h),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 0.6.h),
                                        child: Text(
                                          paymentStatus,
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.w900,
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
                          )),
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
