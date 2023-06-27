import 'dart:convert';

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
import 'CreditLedger.dart';

class PendingInvoiceDetails extends StatefulWidget {
  PendingInvoiceDetails({Key? key, required this.pendingInvoiceDetails})
      : super(key: key);

  Map<String, dynamic> pendingInvoiceDetails = {};

  @override
  State<PendingInvoiceDetails> createState() => _PendingInvoiceDetailsState();
}

class _PendingInvoiceDetailsState extends State<PendingInvoiceDetails> {
  //String
  var yearStr = "ALL";
  var monthStr = "ALL";
  var companyName;
  var customerName;

  //Integer
  int companyId = 0;
  int invoiceId = 0;
  int paymentMethodId = 0;

  //List
  List years = [];
  List months = [];
  List paymentMethod = [];

  //Map
  Map<String, dynamic> invoiceObj = {};

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() {
    if (widget.pendingInvoiceDetails.isNotEmpty) {
      companyName = widget.pendingInvoiceDetails['clientCompanyName'];
      customerName = widget.pendingInvoiceDetails['clientCustomerName'];
      companyId = widget.pendingInvoiceDetails['clientCompanyId'];
      invoiceId = widget.pendingInvoiceDetails['id'];

      getInvoiceDetails();
    }
  }

  void getInvoiceDetails() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");
    if (widget.pendingInvoiceDetails.isNotEmpty) {
      bodyParam.addAll({"id": invoiceId, "clientcompanyId": companyId});
    }
    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_INVOICE_DETAIL),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        setState(() {
          invoiceObj = obj;
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
          bottomNavigationBar: Container(
            height: 8.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: SizedBox(
                width: 30.w,
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Payment Method",
                      labelStyle: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.5.w, color: AppColors.darkGrey),
                          borderRadius: BorderRadius.circular(1.h)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.5.w, color: AppColors.darkGrey),
                          borderRadius: BorderRadius.circular(1.h)),
                    ),
                    hint: Text(
                      'Select Payment Method',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.w500)),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                    value: paymentMethodId,
                    items: paymentMethod.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList()),
              ),
            ),
          ),
          appBar: AppBar(
            title: Text(
              "PENDING INVOICE".toString().toUpperCase(),
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
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 2.h,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'For Company',
                              style: GoogleFonts.quicksand(
                                  fontSize: 9.sp, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              companyName,
                              style: GoogleFonts.quicksand(
                                  fontSize: 11.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'For Customer',
                              style: GoogleFonts.quicksand(
                                  fontSize: 9.sp, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              customerName,
                              style: GoogleFonts.quicksand(
                                  fontSize: 11.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: AppColors.darkGrey,
                    ),
                    Gap(1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Invoice No.',
                              style: GoogleFonts.quicksand(
                                  fontSize: 11.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              invoiceObj['invoiceNo'].toString(),
                              style: GoogleFonts.quicksand(
                                  fontSize: 10.sp, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Invoice Date',
                              style: GoogleFonts.quicksand(
                                  fontSize: 11.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              invoiceObj['date'].toString(),
                              style: GoogleFonts.quicksand(
                                  fontSize: 10.sp, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: AppColors.darkGrey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Item',
                          style: GoogleFonts.quicksand(
                              fontSize: 11.sp, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            Text(
                              'Qty',
                              style: GoogleFonts.quicksand(
                                  fontSize: 11.sp, fontWeight: FontWeight.w500),
                            ),
                            Gap(3.w),
                            Text(
                              'Rate',
                              style: GoogleFonts.quicksand(
                                  fontSize: 11.sp, fontWeight: FontWeight.w500),
                            ),
                            Gap(4.w),
                            Text(
                              'GST',
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
                    Divider(
                      color: AppColors.darkGrey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notes',
                          style: GoogleFonts.quicksand(
                              fontSize: 11.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Total Amount: ',
                          style: GoogleFonts.quicksand(
                              fontSize: 11.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
