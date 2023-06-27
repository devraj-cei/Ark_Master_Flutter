import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Dashboard.dart';

class ProductCategory extends StatefulWidget {
  const ProductCategory({Key? key}) : super(key: key);

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  //String
  String imageUrl = "http://arkledger.techregnum.com/assets/ProductCategories/";

  //Integer
  int selectedCompanyId = 0;
  int selectedProductCategoryId = 0;
  int productCategoryId = 0;

  //Bool
  bool visible = false;

  //List
  List listOfCompany = [];
  List productCategoryList = [];

  @override
  void initState() {
    getClientCompanyList();
    super.initState();
  }

  void getClientCompanyList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;
    Map<String, dynamic> bodyParam = {};
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_CLIENT_COMPANIES_LIST),
        headers: {"token": token, 'Content-Type': 'application/json'},
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
        getProductCategoryList();
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

  void getProductCategoryList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;
    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({"appClientCompanyId": selectedCompanyId});
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_MAP_PRODUCT_CATEGORY_LIST),
        headers: {"token": token, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          productCategoryList = obj;

          if (productCategoryList.isNotEmpty) {
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

  //ENABLE PRODUCT API
  void enableProduct() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");

    bodyParam.addAll({"id": productCategoryId, "status": true});
    print(bodyParam);

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.ENABLE_PRODUCT_SUBCATEGORY_CLIENT_MAPPING_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        getProductCategoryList();
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

  //ENABLE PRODUCT API
  void disableProduct() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");

    bodyParam.addAll({"id": productCategoryId, "status": true});
    print(bodyParam);

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.DISABLE_PRODUCT_SUBCATEGORY_CLIENT_MAPPING_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        getProductCategoryList();
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

  //Refresh Indicator
  Future refreshIndicator() async {
    getProductCategoryList();
  }

  //ON BACK PRESSED FUNCTION
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
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Product Category",
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
                        //List of Company Dropdown
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            onChanged: (value) {
                              setState(() {
                                selectedCompanyId = value as int;
                                getProductCategoryList();
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
                    onTap: () {},
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
                            "Add Product Category",
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
                  itemCount: productCategoryList.length,
                  itemBuilder: (build, index) {
                    var productCategory = productCategoryList[index];
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
                                          productCategory['imageFile']),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productCategory['title'],
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
                                  productCategory['description'],
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
                                                      productCategoryId =
                                                          productCategoryList[
                                                              index]['id'];
                                                    });
                                                    Navigator.of(context).pop();
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
                                    value: productCategory['status'],
                                    onChanged: (value) {
                                      setState(() {
                                        productCategoryId = productCategory[
                                            'productCategorySubCategoryClientMapId'];
                                      });
                                      print(productCategory['status']);
                                      if (productCategory['status'] == true) {
                                        disableProduct();
                                      } else {
                                        enableProduct();
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
