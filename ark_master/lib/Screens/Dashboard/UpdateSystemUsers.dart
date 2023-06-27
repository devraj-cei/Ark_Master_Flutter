import 'dart:convert';

import 'package:ark_master/Screens/Dashboard/SystemUsers.dart';
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

class UpdateSystemUsers extends StatefulWidget {
  UpdateSystemUsers({Key? key, required this.userId, required this.systemUser})
      : super(key: key);

  int userId = 0;
  Map<String, dynamic> systemUser;

  @override
  State<UpdateSystemUsers> createState() => _UpdateSystemUsersState();
}

class _UpdateSystemUsersState extends State<UpdateSystemUsers> {
  //String
  String? title;
  String? buttonText;
  String? token = Global.services.getToken()!;

  //List
  List clientCompany = [];

  //Map
  Map<String, dynamic> systemUser = {};

  //Integer
  int clientCompanyId = 0;
  int userId = 0;
  int appClientId = Global.services.getAppClientId()!;
  //TextEditingController
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    if (widget.userId != 0) {
      setState(() {
        nameController.text = widget.systemUser['name'];
        mobileController.text = widget.systemUser['mobile'];
        emailController.text = widget.systemUser['email'];
        userId = widget.userId;
        title = "Edit System User";
        buttonText = "Update System User";
        clientCompanyId = widget.systemUser['appClientCompaniesId'];
      });
    } else {
      title = "Add User";
      buttonText = "Save User";
    }
    getClientCompanyList();
    super.initState();
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

        setState(() {
          clientCompany = obj;

          if (clientCompanyId == 0) {
            clientCompanyId = clientCompany[0]['id'];
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

  void saveAppClientUser() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "status": true,
      "appClientId": appClientId,
      "name": nameController.text.toString(),
      "mobile": mobileController.text.toString(),
      "email": emailController.text.toString(),
      "appClientCompaniesId": clientCompanyId,
    });
    if (userId != 0) {
      bodyParam.addAll({"id": userId});
    }
    print(bodyParam);
    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.SAVE_APP_CLIENT_USERS),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        print(obj.toString());
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: obj.toString(),
            fontSize: 11.sp,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            textColor: AppColors.yellowButton,
            backgroundColor: AppColors.darkGrey);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SystemUsers()));
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
        context, MaterialPageRoute(builder: (context) => SystemUsers()));
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
            title!.toUpperCase(),
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => SystemUsers()));
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  //Client company
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Client Company",
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5.w, color: Colors.black45),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5.w, color: Colors.black54),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    isExpanded: true,
                    hint: Text(
                      'Select company',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.w500)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        clientCompanyId = value as int;
                      });
                    },
                    value: clientCompanyId,
                    items: clientCompany.map((item) {
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
                  //Mobile TextField
                  TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.call),
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
                  //Email TextField
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
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
                            borderRadius: BorderRadius.circular(1.h)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1.h))),
                  ),
                  Gap(1.5.h),
                ],
              ),
              InkWell(
                onTap: () {
                  saveAppClientUser();
                },
                child: Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                      color: AppColors.yellowButton,
                      border: Border.all(color: Colors.white, width: 0.15.h),
                      borderRadius: BorderRadius.circular(1.h)),
                  child: Padding(
                    padding: EdgeInsets.all(1.5.h),
                    child: Center(
                        child: Text(
                      buttonText.toString(),
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
      ),
    );
  }
}
