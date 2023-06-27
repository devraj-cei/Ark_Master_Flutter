import 'dart:convert';

import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'CreditLedger.dart';

class CustomerLedger extends StatefulWidget {
  CustomerLedger(
      {Key? key,
      required this.companyInvoiceDetails,
      required this.customerInvoiceDetails})
      : super(key: key);

  Map<String, dynamic> companyInvoiceDetails = {};
  Map<String, dynamic> customerInvoiceDetails = {};

  @override
  State<CustomerLedger> createState() => _CustomerLedgerState();
}

class _CustomerLedgerState extends State<CustomerLedger> {
  //String
  String? token = Global.services.getToken();
  var selectedYear;
  var yearStr = "ALL";
  var monthStr = "ALL";
  var selectedMonth = "ALL";
  var customer;

  //Bool
  bool generateInvoice = false;

  //Integer
  int selectedCompanyId = 0;
  int appClientId = Global.services.getAppClientId()!;
  double amount = 0;

  //List
  List listOfCompany = [];
  List customerCreditLedgerList = [];
  List years = [];
  List months = [];

  @override
  void initState() {
    getYears();
    prefs();
    getClientCompanyList();
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

  void prefs() async {
    if (widget.companyInvoiceDetails.isNotEmpty) {
      setState(() {
        customer = widget.companyInvoiceDetails['customer'].toString();
        selectedCompanyId = widget.companyInvoiceDetails['clientCompanyId'];
      });
    } else {
      setState(() {
        customer = widget.customerInvoiceDetails['customer'].toString();
        print(selectedCompanyId);
      });
    }
  }

  void getClientCompanyList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

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
        });

        listOfCompany.insertAll(0, [
          {'id': 0, "name": 'ALL'}
        ]);

        if (listOfCompany.isNotEmpty) {
          if (selectedCompanyId == 0) {
            selectedCompanyId = listOfCompany[0]['id'];
          }
          if (widget.companyInvoiceDetails.isNotEmpty) {
            getCompanyCreditLedger();
          } else {
            getCustomerCreditLedger();
          }
        }
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

  void getCompanyCreditLedger() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll(
        {'clientCustomerId': widget.companyInvoiceDetails['clientCustomerId']});

    if (selectedCompanyId != 0) {
      bodyParam.addAll({
        'clientCompanyId': selectedCompanyId,
      });
    }

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_CREDIT_LEDGRE_DETAILS),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          customerCreditLedgerList = obj;

          if (customerCreditLedgerList.length > 0) {
            generateInvoice = true;
          }
        });

        for (int i = 0; i < customerCreditLedgerList.length; i++) {
          double total = customerCreditLedgerList[i]['price'];

          setState(() {
            amount = amount + total;
          });
        }
        print(amount);

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

  void getCustomerCreditLedger() async {
    if (amount > 0) {
      setState(() {
        amount = 0;
      });
    }
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({
      'clientCompanyId': selectedCompanyId,
      'clientCustomerId': widget.companyInvoiceDetails['clientCustomerId']
    });
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_CREDIT_LEDGRE_DETAILS),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          customerCreditLedgerList = obj;
          if (customerCreditLedgerList.length > 0) {
            generateInvoice = true;
          }
        });

        print(customerCreditLedgerList);

        if (amount > 0) {
          setState(() {
            amount = 0;
          });
        }

        for (int i = 0; i < customerCreditLedgerList.length; i++) {
          double total = customerCreditLedgerList[i]['price'] ?? 0;

          setState(() {
            amount = amount + total;
          });
        }
        print(amount);

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

  Future<bool> onBackPressed() async {
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => CreditLedger()));
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
        bottomNavigationBar: Visibility(
          visible: generateInvoice,
          child: Container(
            height: 8.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Divider(
                      thickness: 0.2.w,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount: ₹ $amount',
                        style: GoogleFonts.quicksand(
                            fontSize: 11.sp, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.yellowButton,
                            border:
                                Border.all(color: Colors.white, width: 0.15.h),
                            borderRadius: BorderRadius.circular(1.h)),
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(1.5.h),
                            child: Center(
                              child: Text(
                                "GENERATE INVOICE",
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.sp,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Customer Ledger".toString().toUpperCase(),
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
                                              Navigator.of(context).pop();
                                            });
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
                                getCustomerCreditLedger();
                              });
                            },
                            value: selectedCompanyId,
                            items: listOfCompany
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(
                                      e['name'].toString(),
                                      style: GoogleFonts.quicksand(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: e['id'],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'For Customer: ',
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                            color: AppColors.darkGrey),
                      ),
                      Text(
                        customer,
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                            color: AppColors.darkGrey),
                      ),
                    ],
                  ),
                  Divider(
                    color: AppColors.darkGrey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Date',
                            style: GoogleFonts.quicksand(
                                fontSize: 11.sp, fontWeight: FontWeight.w500),
                          ),
                          Gap(15.w),
                          Text(
                            'Item',
                            style: GoogleFonts.quicksand(
                                fontSize: 11.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Qty',
                            style: GoogleFonts.quicksand(
                                fontSize: 11.sp, fontWeight: FontWeight.w500),
                          ),
                          Gap(6.w),
                          Text(
                            'Amount',
                            style: GoogleFonts.quicksand(
                                fontSize: 11.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    color: AppColors.darkGrey,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: customerCreditLedgerList.length,
                itemBuilder: (build, index) {
                  var dateString = customerCreditLedgerList[index]['date'];
                  DateTime date =
                      DateFormat('mm/dd/yyyy hh:mm:ss').parse(dateString);
                  var dateStr = DateFormat('dd/MM/yyyy').format(date);
                  amount += customerCreditLedgerList[index]['price'];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(dateStr.toString()),
                                Gap(5.w),
                                Text(customerCreditLedgerList[index]
                                        ['clientItem']
                                    .toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(customerCreditLedgerList[index]['qty']
                                    .toString()),
                                Gap(12.w),
                                Text(customerCreditLedgerList[index]['price']
                                    .toString()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
