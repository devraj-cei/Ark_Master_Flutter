import 'dart:convert';

import 'package:ark_master/Screens/Dashboard/Invoices.dart';
import 'package:ark_master/Screens/Drawer/NavigationDrawer.dart';
import 'package:ark_master/Utils/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';

class InvoiceDetails extends StatefulWidget {
  InvoiceDetails({Key? key, required this.invoiceDetails}) : super(key: key);

  Map<String, dynamic> invoiceDetails = {};

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  //String
  String? token = Global.services.getToken();

  //Map
  Map<String, dynamic> invoiceDetails = {};
  Map<String, dynamic> invoiceObj = {};

  //Integer
  int paymentMethodId = 0;

  //bool
  var isPaid;

  //List
  List invoiceItemsList = [];
  List paymentMethod = [];

  @override
  void initState() {
    if (widget.invoiceDetails.isNotEmpty) {
      invoiceDetails = widget.invoiceDetails;
      isPaid = widget.invoiceDetails['isPaid'];
    }

    getInvoiceDetails();
    super.initState();
  }

  void getInvoiceDetails() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({
      "id": invoiceDetails['id'],
      "clientcompanyId": invoiceDetails['clientCompanyId']
    });
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
          invoiceItemsList = invoiceObj['invoiceItemsList'];
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
    Navigator.pop(context, MaterialPageRoute(builder: (context) => Invoices()));
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
            "Invoice Details".toUpperCase(),
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => Invoices()));
                },
                icon: Icon(
                  Icons.arrow_back_ios,
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
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: invoiceItemsList.length,
                    itemBuilder: (build, index) {
                      return Container(
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'For Company',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        invoiceDetails['clientCompanyName'],
                                        style: GoogleFonts.quicksand(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'For Customer',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        widget.invoiceDetails[
                                            'clientCustomerName'],
                                        style: GoogleFonts.quicksand(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  )
                                ]),
                            Divider(
                              color: AppColors.darkGrey,
                              thickness: 0.1.h,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Invoice No',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        widget.invoiceDetails['invoiceNo'],
                                        style: GoogleFonts.quicksand(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Invoice Date',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        widget.invoiceDetails['date'],
                                        style: GoogleFonts.quicksand(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  )
                                ]),
                            Divider(
                              color: AppColors.darkGrey,
                              thickness: 0.1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Items',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Qty.',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Gap(2.w),
                                    Text(
                                      'Rate',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Gap(2.w),
                                    Text(
                                      'GST',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Gap(2.w),
                                    Text(
                                      'Amount',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              color: AppColors.darkGrey,
                              thickness: 0.1.h,
                            ),
                            Gap(1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  invoiceItemsList[index]['description'],
                                  style: GoogleFonts.quicksand(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      invoiceItemsList[index]['qty'].toString(),
                                      style: GoogleFonts.quicksand(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Gap(2.w),
                                    Text(
                                      invoiceItemsList[index]['rate']
                                          .toString(),
                                      style: GoogleFonts.quicksand(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Gap(2.w),
                                    Text(
                                      invoiceItemsList[index]['igstValue']
                                          .toString(),
                                      style: GoogleFonts.quicksand(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Gap(2.w),
                                    Text(
                                      invoiceItemsList[index]['amount']
                                          .toString(),
                                      style: GoogleFonts.quicksand(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Gap(1.h),
                            Divider(
                              color: AppColors.darkGrey,
                              thickness: 0.1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Notes',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Total Amount: ${invoiceItemsList[index]['total']}',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              Column(
                children: [
                  Divider(
                    color: AppColors.darkGrey,
                    thickness: 0.1.h,
                  ),
                  isPaid
                      ? InkWell(
                          onTap: () {},
                          child: Container(
                            width: 100.w,
                            decoration: BoxDecoration(
                                color: AppColors.yellowButton,
                                border: Border.all(
                                    color: Colors.white, width: 0.15.h),
                                borderRadius: BorderRadius.circular(1.h)),
                            child: Padding(
                              padding: EdgeInsets.all(1.5.h),
                              child: Center(
                                  child: Text(
                                "Payment Successfully",
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                    color: Colors.black),
                              )),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            DropdownButtonFormField(
                                decoration: InputDecoration(
                                  labelText: "Year",
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
                                      borderRadius: BorderRadius.circular(1.h)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0.5.w,
                                          color: AppColors.darkGrey),
                                      borderRadius: BorderRadius.circular(1.h)),
                                ),
                                hint: Text(
                                  'Select Year',
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500)),
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
                          ],
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
