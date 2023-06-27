import 'dart:convert';

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
import 'CustomerAdd.dart';
import 'Dashboard.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  //String
  String? token = Global.services.getToken()!;
  //Blank BodyParam for API
  Map<String, dynamic> bodyParam = {};
  Map<String, dynamic> systemUser = {};

  //List for Storing Data
  List customerList = [];
  List searchCustomerList = [];

  //Integer
  int customerId = 0;

  //Text Editing Controller
  TextEditingController SearchCustomerController = TextEditingController();

  @override
  void initState() {
    getCustomerList();
    super.initState();
  }

  //Search Filter
  void runFilter(String enteredKeyword) async {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = customerList;
    } else {
      results = customerList
          .where((user) => user['customer']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      searchCustomerList = results;
    });
  }

  //GET APP CLIENT USER LIST
  void getCustomerList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_CUSTOMER_CLIENT_MAPPING_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          customerList = obj;
        });
        setState(() {
          searchCustomerList = customerList;
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

  //ENABLE CUSTOMER API
  void enableCustomer_API() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({"id": customerId, "status": true});
    print(bodyParam);

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.ENABLE_CUSTOMER_CLIENT_MAPPING),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        getCustomerList();
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

  //DISABLE CUSTOMER USER API
  void disableCustomer_API() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({"id": customerId, "status": true});
    print(bodyParam);

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.DISABLE_CUSTOMER_CLIENT_MAPPING),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        getCustomerList();
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

  Future<void> refreshIndicator() async {
    getCustomerList();
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
            "Customer",
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
                          builder: (context) => CustomerAdd(
                                customerDetails: {},
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
                                left: 5.w, bottom: 0.2.h, right: 1.w),
                            child: TextFormField(
                              onChanged: (value) {
                                runFilter(value);
                              },
                              controller: SearchCustomerController,
                              style: GoogleFonts.quicksand(
                                  fontSize: 11.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  suffixIconColor: Colors.black,
                                  hintText: "Search Customers",
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
                  itemCount: searchCustomerList.length,
                  itemBuilder: (build, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: 10.w,
                              top: 0.7.h,
                              right: 5.w,
                              bottom: 0.8.h),
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
                                      searchCustomerList[index]['customer']
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
                                          searchCustomerList[index]['mobile'],
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
                                            searchCustomerList[index]['email'],
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
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomerAdd(
                                                        customerDetails:
                                                            searchCustomerList[
                                                                index])));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.h, horizontal: 1.5.w),
                                        decoration: BoxDecoration(
                                            color: AppColors.darkGrey,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 1.5.h,
                                        ),
                                      )),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: PlatformSwitch(
                                      activeColor: AppColors.yellowButton,
                                      value: searchCustomerList[index]
                                          ['status'],
                                      onChanged: (value) {
                                        setState(() {
                                          customerId =
                                              searchCustomerList[index]['id'];
                                        });

                                        if (searchCustomerList[index]
                                                ['status'] ==
                                            true) {
                                          disableCustomer_API();
                                        } else {
                                          enableCustomer_API();
                                        }
                                      },
                                    ),
                                  )
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
                              searchCustomerList[index]['customer'][0]
                                  .toString()
                                  .toUpperCase(),
                              style: GoogleFonts.quicksand(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
