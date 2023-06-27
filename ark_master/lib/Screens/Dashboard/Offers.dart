import 'dart:convert';

import 'package:ark_master/Screens/Dashboard/OfferAdd.dart';
import 'package:ark_master/Screens/Dashboard/OfferDetails.dart';
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

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  //String
  String imageUrl = "http://arkledger.techregnum.com/assets/Offers/";
  String? token = Global.services.getToken();

  //List
  List offersList = [];
  List searchOffersList = [];
  List categoryList = [];
  List subCategoryList = [];

  //Integer
  int offerId = 0;
  int categoryId = 0;
  int subCategoryId = 0;

  //TextEditingController
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getOffersList();
    super.initState();
  }

  //GET APP CLIENT HSN SAC LIST
  void getOffersList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};
    if (categoryId > 0) {
      bodyParam.addAll({"productCategoryId": categoryId});
    }
    if (subCategoryId > 0) {
      bodyParam.addAll({"productSubCategoryId": subCategoryId});
    }
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_OFFERS_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          offersList = obj;
        });
        setState(() {
          searchOffersList = offersList;
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

  //GET PENDING PRODUCT CATEGORY LIST
  void getCategoryList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_PENDING_PRODUCT_CATEGORY_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          categoryList = obj;
          categoryId = categoryList[0]['id'];
        });
        getSubCategoryList();
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

  //GET PENDING PRODUCT SUBCATEGORY LIST
  void getSubCategoryList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({"productCategoryId": categoryId});
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_PENDING_PRODUCT_SUBCATEGORY_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          subCategoryList = obj;
          subCategoryId = subCategoryList[0]['id'];
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

  //ENABLE OFFER
  void enableOffer_API() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({"id": offerId});
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.ENABLE_OFFERS),
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
        getOffersList();
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

  void disableOffer_API() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({"id": offerId});
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.DISABLE_OFFERS),
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
        getOffersList();
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
      results = offersList;
    } else {
      results = offersList
          .where((user) => user['title']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      searchOffersList = results;
    });
  }

  //RefreshIndicator
  Future refreshIndicator() async {
    getOffersList();
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
            "Offers",
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
                          builder: (context) => OfferAdd(offerDetails: {})));
                },
                icon: Icon(Icons.add_circle)),
            IconButton(
                onPressed: () {
                  getCategoryList();
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(3.h),
                              topLeft: Radius.circular(3.h))),
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 5.w),
                          child: Wrap(
                            children: [
                              Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "Offers Filter",
                                      style: GoogleFonts.quicksand(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Gap(2.h),
                                  //Category
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: "Category",
                                      labelStyle: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                      fillColor: Colors.white,
                                      filled: true,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2.h, horizontal: 2.w),
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
                                      'Category',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        categoryId = value as int;
                                        getSubCategoryList();
                                      });
                                    },
                                    value: categoryId,
                                    items: categoryList.map((item) {
                                      return DropdownMenuItem(
                                        child: new Text(
                                          item['title'].toString(),
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
                                  Gap(2.h),
                                  //Category
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: "Category",
                                      labelStyle: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                      fillColor: Colors.white,
                                      filled: true,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2.h, horizontal: 2.w),
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
                                      'Category',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        subCategoryId = value as int;
                                      });
                                    },
                                    value: subCategoryId,
                                    items: subCategoryList.map((item) {
                                      return DropdownMenuItem(
                                        child: new Text(
                                          item['title'].toString(),
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
                                  Gap(2.h),
                                  Container(
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                        color: AppColors.yellowButton,
                                        border: Border.all(
                                            color: Colors.white, width: 0.15.h),
                                        borderRadius:
                                            BorderRadius.circular(1.h)),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        getOffersList();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(1.5.h),
                                        child: Center(
                                            child: Text(
                                          "Apply Filter",
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                              color: Colors.black),
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                },
                icon: Icon(Icons.filter_list)),
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
                                left: 5.w, bottom: 0.2.h, right: 1.w),
                            child: TextFormField(
                              onChanged: (value) {
                                runFilter(value);
                              },
                              controller: searchController,
                              style: GoogleFonts.quicksand(
                                  fontSize: 11.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  suffixIconColor: Colors.black,
                                  hintText: "Search",
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
                Gap(2.h),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshIndicator,
                color: AppColors.yellowButton,
                child: ListView.builder(
                  itemCount: searchOffersList.length,
                  itemBuilder: (build, index) {
                    var discount =
                        searchOffersList[index]['discount'].toString();
                    var discountStr;
                    if (searchOffersList[index]['discountType'] == 1) {
                      discountStr = discount + " % off";
                    } else {
                      discountStr = "Flat " + "₹" + discount + " off";
                    }
                    return InkWell(
                      onTap: () {
                        Map<String, dynamic> offerDetails = offersList[index];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OfferDetails(offerDetails: offerDetails)));
                      },
                      child: Container(
                        height: 25.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.h)),
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.h),
                        child: Stack(
                          children: [
                            Container(
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: AppColors.darkGrey,
                                borderRadius: BorderRadius.circular(2.h),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                      color: Colors.black45)
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2.h),
                                child: Image(
                                  fit: BoxFit.cover,
                                  width: 100.w,
                                  image: NetworkImage(imageUrl +
                                      searchOffersList[index]['imageFile']),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              top: 15.h,
                              right: 0,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 1.5.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2.h),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 1.h,
                                        offset: Offset(0, 1),
                                        color: Colors.black26),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          searchOffersList[index]['title'],
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11.sp),
                                        ),
                                        Text(
                                          "Valid Till: ${searchOffersList[index]['endDate']}",
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10.sp),
                                        ),
                                        Text(
                                          discountStr,
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10.sp),
                                        )
                                      ],
                                    ),
                                    Transform.scale(
                                        scale: 0.8,
                                        child: PlatformSwitch(
                                          activeColor: AppColors.yellowButton,
                                          value: searchOffersList[index]
                                              ['status'],
                                          onChanged: (value) {
                                            setState(() {
                                              offerId =
                                                  searchOffersList[index]['id'];
                                            });

                                            if (searchOffersList[index]
                                                    ['status'] ==
                                                true) {
                                              disableOffer_API();
                                            } else {
                                              enableOffer_API();
                                            }
                                          },
                                        ))
                                  ],
                                ),
                              ),
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
