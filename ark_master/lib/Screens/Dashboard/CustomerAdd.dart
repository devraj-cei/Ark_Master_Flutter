import 'dart:convert';

import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Customer.dart';

class CustomerAdd extends StatefulWidget {
  CustomerAdd({Key? key, required this.customerDetails}) : super(key: key);

  Map<String, dynamic> customerDetails = {};

  @override
  State<CustomerAdd> createState() => _CustomerAddState();
}

class _CustomerAddState extends State<CustomerAdd> {
  //String
  String title = "";
  String? token = Global.services.getToken()!;

  //Integer
  int countryId = 0;
  int stateId = 0;
  int cityId = 0;
  int customerId = 0;
  int type = 1;

  //List
  List countryList = [];
  List stateList = [];
  List cityList = [];

  //Bool
  bool mobileColumn = true;
  bool mobileRow = false;
  bool includeBusiness = false;
  bool searchButton = true;
  bool otherColumn = false;
  bool saveButton = false;

  //TextEditingController
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() {
    if (widget.customerDetails.isNotEmpty) {
      searchButton = false;
      otherColumn = true;
      saveButton = true;
      title = "Update Customer";
      getCountryList();
      customerId = widget.customerDetails['id'];
      nameController.text = widget.customerDetails['personName'];
      mobileController.text = widget.customerDetails['mobile'];
      emailController.text = widget.customerDetails['email'];
      addressController.text = widget.customerDetails['address'];
      pinController.text = widget.customerDetails['pincode'];
      businessNameController.text = widget.customerDetails['businessName'];
      panNoController.text = widget.customerDetails['panNo'];
      gstNoController.text = widget.customerDetails['gstIn'];
      countryId = widget.customerDetails['countryId'];
      stateId = widget.customerDetails['stateId'];
      cityId = widget.customerDetails['cityId'];
    } else {
      setState(() {
        title = "Add Customer";
      });
    }
  }

  void getCustomerDetails() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "personName": nameController.text,
      "mobile": mobileController.text.toString()
    });

    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_CUSTOMERS_DETAILS),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        Map<String, dynamic> obj = responseBody['obj'];

        if (obj.isNotEmpty) {
          Fluttertoast.showToast(
              msg: "Customer Already Exist",
              fontSize: 11.sp,
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_SHORT,
              textColor: AppColors.yellowButton,
              backgroundColor: AppColors.darkGrey);
          setState(() {
            mobileColumn = true;
            mobileRow = false;
          });
        } else {
          Fluttertoast.showToast(
              msg: "Customer Not Found",
              fontSize: 11.sp,
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_SHORT,
              textColor: AppColors.yellowButton,
              backgroundColor: AppColors.darkGrey);
          getCountryList();
          setState(() {
            mobileColumn = false;
            mobileRow = true;
            otherColumn = true;
            saveButton = true;
          });
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

  //Get Country List
  void getCountryList() async {
    EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_COUNTRY_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          countryList = obj;
          if (countryList.length > 0) {
            if (countryId == 0) {
              countryId = countryList[0]['id'];
            }
          }
        });
        getStateList();
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

  //Get Country List
  void getStateList() async {
    EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({"countryId": countryId});

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_STATE_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];
      if (stateList.length > 0) {
        setState(() {
          stateList.clear();
          stateId = 0;
        });
      }
      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          stateList = obj;
          if (stateList.length > 0) {
            if (stateId == 0) {
              stateId = stateList[0]['id'];
            }
          }
        });
        getCityList();
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

  //Get Country List
  void getCityList() async {
    EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({"stateId": stateId});

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_CITY_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (cityList.length > 0) {
        setState(() {
          cityList.clear();
          cityId = 0;
        });
      }
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          cityList = obj;
          if (cityList.length > 0) {
            if (cityId == 0) {
              cityId = cityList[0]['id'];
            }
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

  void saveCustomer() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "personName": nameController.text,
      "mobile": mobileController.text,
      "email": emailController.text,
      "address": addressController.text,
      "pincode": pinController.text,
      "countryId": countryId,
      "stateId": stateId,
      "cityId": cityId,
      "businessName": businessNameController.text,
      "panNo": panNoController.text,
      "gstIn": gstNoController.text,
      "type": type,
    });

    if (customerId > 0) {
      bodyParam.addAll({"id": customerId});
    }

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.SAVE_CUSTOMER_CLIENT_MAPPING),
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Customer()));
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
    Navigator.pop(context, MaterialPageRoute(builder: (context) => Customer()));
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
        bottomNavigationBar: Visibility(
          visible: saveButton,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            height: 6.h,
            decoration: BoxDecoration(
                color: AppColors.yellowButton,
                border: Border.all(color: Colors.white, width: 0.15.h),
                borderRadius: BorderRadius.circular(1.h)),
            child: InkWell(
              onTap: () {
                saveCustomer();
              },
              child: Padding(
                padding: EdgeInsets.all(1.5.h),
                child: Center(
                    child: Text(
                  "Save Customer",
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.black),
                )),
              ),
            ),
          ),
        ),
        drawer: NavigationDrawerLayout(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            title.toString(),
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => Customer()));
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
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Name TextField
                TextFormField(
                  controller: nameController,
                  style: GoogleFonts.quicksand(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      prefixIconColor: AppColors.darkGrey,
                      hintText: "Enter name",
                      labelText: "Enter name",
                      labelStyle: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.h)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1.h))),
                ),
                Gap(1.5.h),
                Visibility(
                  visible: mobileColumn,
                  child: Column(
                    children: [
                      //Mobile TextField
                      TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            prefixIconColor: AppColors.darkGrey,
                            hintText: "Enter mobile",
                            labelText: "Enter mobile",
                            labelStyle: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp),
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.h)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.h))),
                      ),
                      Gap(1.5.h),
                      Visibility(
                        visible: searchButton,
                        child: InkWell(
                          onTap: () {
                            getCustomerDetails();
                          },
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
                                  "Search Customer",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: otherColumn,
                  child: Column(
                    children: [
                      Visibility(
                        visible: mobileRow,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Mobile TextField
                            SizedBox(
                              width: 65.w,
                              child: TextFormField(
                                controller: mobileController,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp),
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.phone),
                                    prefixIconColor: AppColors.darkGrey,
                                    hintText: "Enter mobile",
                                    labelText: "Enter mobile",
                                    labelStyle: GoogleFonts.quicksand(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.sp),
                                    fillColor: Colors.white,
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(1.h)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(1.h))),
                              ),
                            ),
                            Gap(2.w),
                            InkWell(
                              onTap: () {
                                getCustomerDetails();
                              },
                              child: Container(
                                width: 22.w,
                                decoration: BoxDecoration(
                                    color: AppColors.yellowButton,
                                    border: Border.all(
                                        color: Colors.white, width: 0.15.h),
                                    borderRadius: BorderRadius.circular(1.h)),
                                child: Padding(
                                  padding: EdgeInsets.all(1.5.h),
                                  child: Center(
                                    child: Text(
                                      "Search",
                                      style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: otherColumn,
                          child: Column(
                            children: [
                              //TextFormFields
                              Column(
                                children: [
                                  Gap(1.5.h),
                                  //Email TextField
                                  TextFormField(
                                    controller: emailController,
                                    style: GoogleFonts.quicksand(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.sp),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.mail),
                                        prefixIconColor: AppColors.darkGrey,
                                        hintText: "Enter email",
                                        labelText: "Enter email",
                                        labelStyle: GoogleFonts.quicksand(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp),
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1.h)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1.h))),
                                  ),
                                  Gap(1.5.h),
                                  //Address TextField
                                  TextFormField(
                                    controller: addressController,
                                    maxLines: 2,
                                    style: GoogleFonts.quicksand(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.sp),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.home),
                                        prefixIconColor: AppColors.darkGrey,
                                        hintText: "Enter address",
                                        labelText: "Enter address",
                                        labelStyle: GoogleFonts.quicksand(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp),
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1.h)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1.h))),
                                  ),
                                  Gap(1.5.h),
                                  //PinCode TextField
                                  TextFormField(
                                    controller: pinController,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.quicksand(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.sp),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.home),
                                        prefixIconColor: AppColors.darkGrey,
                                        hintText: "Enter pincode",
                                        labelText: "Enter pincode",
                                        labelStyle: GoogleFonts.quicksand(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp),
                                        fillColor: Colors.white,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1.h)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1.h))),
                                  ),
                                ],
                              ),
                              //Dropdown
                              Column(
                                children: [
                                  Gap(1.5.h),
                                  //Country List
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: "Country",
                                      labelStyle: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                      prefixIcon: Icon(Icons.house),
                                      prefixIconColor: Colors.black,
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
                                      'Select Country',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        countryId = value as int;
                                        getStateList();
                                      });
                                    },
                                    value: countryId,
                                    items: countryList.map((item) {
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
                                  Gap(1.5.h),
                                  //State List
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: "State",
                                      labelStyle: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                      prefixIcon: Icon(Icons.house),
                                      prefixIconColor: Colors.black,
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
                                      'Select State',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        stateId = value as int;
                                        getCityList();
                                      });
                                    },
                                    value: stateId,
                                    items: stateList.map((item) {
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
                                  Gap(1.5.h),
                                  //City List
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      labelText: "City",
                                      labelStyle: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                      prefixIcon: Icon(Icons.house),
                                      prefixIconColor: Colors.black,
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
                                      'Select City',
                                      style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        cityId = value as int;
                                      });
                                    },
                                    value: cityId,
                                    items: cityList.map((item) {
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
                                ],
                              ),
                              Column(
                                children: [
                                  CheckboxListTile(
                                      title: Text(
                                        "Include Business Details",
                                        style: GoogleFonts.quicksand(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: AppColors.yellowButton,
                                      value: includeBusiness,
                                      onChanged: (value) {
                                        setState(() {
                                          includeBusiness = value as bool;
                                          if (includeBusiness == true) {
                                            setState(() {
                                              type = 2;
                                            });
                                          } else {
                                            type = 1;
                                          }
                                        });
                                      })
                                ],
                              ),
                              //TextFormField
                              Visibility(
                                visible: includeBusiness,
                                child: Column(
                                  children: [
                                    //Business Name TextField
                                    TextFormField(
                                      controller: businessNameController,
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.sp),
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          prefixIconColor: AppColors.darkGrey,
                                          hintText: "Enter business name",
                                          labelText: "Enter business name",
                                          labelStyle: GoogleFonts.quicksand(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.sp),
                                          fillColor: Colors.white,
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.h)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.h))),
                                    ),
                                    Gap(1.5.h),
                                    TextFormField(
                                      controller: panNoController,
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.sp),
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          prefixIconColor: AppColors.darkGrey,
                                          hintText: "Enter pancard no",
                                          labelText: "Enter pancard no",
                                          labelStyle: GoogleFonts.quicksand(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.sp),
                                          fillColor: Colors.white,
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.h)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.h))),
                                    ),
                                    Gap(1.5.h),
                                    TextFormField(
                                      controller: gstNoController,
                                      style: GoogleFonts.quicksand(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.sp),
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          prefixIconColor: AppColors.darkGrey,
                                          hintText: "Enter GST no",
                                          labelText: "Enter GST no",
                                          labelStyle: GoogleFonts.quicksand(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.sp),
                                          fillColor: Colors.white,
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.h)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.h))),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
