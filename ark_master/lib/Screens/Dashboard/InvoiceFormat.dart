import 'dart:convert';

import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Dashboard.dart';
import 'InvoiceFormatAdd.dart';

class InvoiceFormat extends StatefulWidget {
  const InvoiceFormat({Key? key}) : super(key: key);

  @override
  State<InvoiceFormat> createState() => _InvoiceFormatState();
}

class _InvoiceFormatState extends State<InvoiceFormat> {
  //String
  String? token = Global.services.getToken();
  String pdfUrl = "http://arkledger.techregnum.com/assets/InvoiceFormats/";
  String pdfFile = "";
  String finalUrl =
      "http://docs.google.com/gview?embedded=true&url=http://arkledger.techregnum.com/assets/InvoiceFormats/";
  String webViewURL = "http://docs.google.com/gview?embedded=true&url=";
  String title = "";

  InAppWebViewController? _webViewController;
  double _progress = 0;

  //Integer
  int selectedCompanyId = 0;
  int finalFormatId = 0;

  //List
  List clientCompanyList = [];
  List invoiceFormatList = [];

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
        getInvoiceFormatList();
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

  //GET INVOICE FORMAT LIST
  void getInvoiceFormatList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};

    if (selectedCompanyId > 0) {
      bodyParam.addAll({"clientCompanyId": selectedCompanyId});
    }
    print(bodyParam);

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_INVOICE_FORMATS_APP_COMPANY_MAPPING_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          invoiceFormatList = obj;
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

  void getFormatDetails() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({"id": finalFormatId});
    print(bodyParam);

    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_FORMAT_DETAILS),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        setState(() {
          pdfFile = obj['pdfFile'].toString();
          title = obj['title'].toString();
        });
        print(pdfFile);
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
  Future<void> refreshIndicator() async {
    getInvoiceFormatList();
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
            "Invoice Format".toUpperCase(),
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
                              InvoiceFormatAdd(invoiceFormatDetails: {})));
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
                                    getInvoiceFormatList();
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
                  itemCount: invoiceFormatList.length,
                  itemBuilder: (build, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.5.h),
                      margin: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 0.7.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.h),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black45,
                                blurRadius: 2)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                invoiceFormatList[index]['name'],
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp),
                              ),
                              Gap(0.5.h),
                              Text(
                                "Company Name: " +
                                    invoiceFormatList[index]['clientCompanies'],
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    finalFormatId =
                                        invoiceFormatList[index]['formatId'];
                                  });
                                  getFormatDetails();
                                  pdfViewer();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.darkGrey),
                                  child: Icon(
                                    Icons.remove_red_eye_rounded,
                                    color: Colors.white,
                                    size: 2.h,
                                  ),
                                ),
                              ),
                              Gap(2.w),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InvoiceFormatAdd(
                                                  invoiceFormatDetails:
                                                      invoiceFormatList[
                                                          index])));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.darkGrey),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 2.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  Future pdfViewer() {
    return showModalBottomSheet(
      isDismissible: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3.h), topRight: Radius.circular(3.h))),
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Text(
                        title.toString(),
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold, fontSize: 11.sp),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel),
                      ),
                    ],
                  ),
                  Gap(2.h),
                ],
              ),
              Container(
                height: 30.h,
                width: 100.w,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(
                          "https://docs.google.com/gview?embedded=true&url=http://arkledger.techregnum.com/assets/InvoiceFormats/" +
                              pdfFile.toString())),
                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      _progress = progress / 100;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
