import 'dart:convert';

import 'package:ark_master/API/ApiEndPoint.dart';
import 'package:ark_master/Screens/Dashboard/AddProjectTimeSheet.dart';
import 'package:ark_master/Screens/Dashboard/AppClientHSN_Sac.dart';
import 'package:ark_master/Screens/Dashboard/BusinessCategory.dart';
import 'package:ark_master/Screens/Dashboard/Company.dart';
import 'package:ark_master/Screens/Dashboard/CreditLedger.dart';
import 'package:ark_master/Screens/Dashboard/Customer.dart';
import 'package:ark_master/Screens/Dashboard/EmployeeLeaveRequest.dart';
import 'package:ark_master/Screens/Dashboard/Expenses.dart';
import 'package:ark_master/Screens/Dashboard/InvoiceFormat.dart';
import 'package:ark_master/Screens/Dashboard/Invoices.dart';
import 'package:ark_master/Screens/Dashboard/Offers.dart';
import 'package:ark_master/Screens/Dashboard/ProductCategory.dart';
import 'package:ark_master/Screens/Dashboard/Project.dart';
import 'package:ark_master/Screens/Dashboard/SystemUsers.dart';
import 'package:ark_master/Screens/Dashboard/TimeSheetReport.dart';
import 'package:ark_master/Utils/App_Colors.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:ark_master/Utils/icons_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons_helper/flutter_icons_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../Dashboard/Employee.dart';

class NavigationDrawerLayout extends StatefulWidget {
  const NavigationDrawerLayout({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerLayout> createState() => _NavigationDrawerLayoutState();
}

class _NavigationDrawerLayoutState extends State<NavigationDrawerLayout>
    with WidgetsBindingObserver {
  //Header Text
  var headerName = jsonDecode(Global.services.getUserProfile()!)['name'];
  var headerEmail = jsonDecode(Global.services.getUserProfile()!)['email'];
  var headerMobile = jsonDecode(Global.services.getUserProfile()!)['mobile'];

  //Profile Picture
  var image_url = "http://arkledger.techregnum.com/assets/AppClientUsers/";
  var profilePic = Global.services.getProfilePic()!;

  //drawerList
  List drawerList = [];
  final helper = IconHelper();

  @override
  void initState() {
    hierarchyMenuList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    drawerList.clear;
  }

  void hierarchyMenuList() async {
    EasyLoading.show(
        status: "Please Wait", maskType: EasyLoadingMaskType.black);

    final token = Global.services.getToken();
    var response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_HIERARCHY_MENU_LIST),
        headers: {"token": token!});
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);

      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        if (drawerList.length == 0) {
          List obj = responseBody['obj'];
          setState(() {
            drawerList = obj;
          });
        } else {
          print("drawerList");
        }
      } else {
        var obj = responseBody['obj'];
        debugPrint(obj.toString());
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
      throw Exception("Error while Fetching API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              curve: Curves.bounceIn,
              decoration: BoxDecoration(
                  color: AppColors.darkGrey,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(3.h),
                      bottomRight: Radius.circular(3.h))),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.darkGrey,
                    borderRadius: BorderRadius.circular(2.h)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              shape: BoxShape.circle),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(image_url + profilePic),
                            radius: 4.h,
                          ),
                        ),
                        Gap(2.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              headerName,
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(
                              headerMobile,
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400)),
                            ),
                            Text(
                              headerEmail,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: drawerList.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  String icon = drawerList[index]['icon'];
                  String finalIcon =
                      icon.replaceAll("-", "_").replaceAll("fas ", "");

                  if (finalIcon.contains("fas ")) {
                    finalIcon = icon.replaceAll("-", "");
                  }
                  return ListTile(
                    onTap: () {
                      //Navigation Conditions
                      //Dashboard
                      if (drawerList[index]['title'] == "Dashboard") {
                        debugPrint("Dashboard");
                      }
                      //System Users
                      if (drawerList[index]['title'] == "System Users") {
                        //Navigation to System Users Screen
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SystemUsers()));
                      }
                      //Designation
                      if (drawerList[index]['title'] == "Designation") {
                        debugPrint("Designation");
                      }
                      //Employees
                      if (drawerList[index]['title'] == "Employees") {
                        //Navigation to System Users Screen
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Employee()));
                      }
                      //Company
                      if (drawerList[index]['title'] == "Company") {
                        //Navigation to System Users Screen
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Company()));
                      }
                      //Invoice
                      if (drawerList[index]['title'] == "Invoice") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Invoices()));
                      }
                      //Expense

                      if (drawerList[index]['title'] == "Expense") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Expenses()));
                      }

                      //App Client Hsn Sac
                      if (drawerList[index]['title'] == "App Client Hsn Sac") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppClientHSN_SAC()));
                      }
                      //Bank Account
                      if (drawerList[index]['title'] == "Bank Account") {
                        debugPrint("Bank Account");
                      }
                      //App Client Office
                      if (drawerList[index]['title'] == "App Client Office") {
                        debugPrint("App Client Office");
                      }
                      //Offers
                      if (drawerList[index]['title'] == "Offers") {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Offers()));
                      }
                      //Items
                      if (drawerList[index]['title'] == "Items") {
                        debugPrint("Items");
                      }
                      //Business Categories
                      if (drawerList[index]['title'] == "Business Categories") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BusinessCategory()));
                      }
                      //Product Categories
                      if (drawerList[index]['title'] == "Product Categories") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductCategory()));
                      }
                      //Yearly Holidays
                      if (drawerList[index]['title'] == "Yearly Holidays") {
                        debugPrint("Yearly Holidays");
                      }
                      //Customers
                      if (drawerList[index]['title'] == "Customers") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Customer()));
                      }
                      //Invoice Format
                      if (drawerList[index]['title'] == "Invoice Format") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvoiceFormat()));
                      }
                      //Employee Company
                      if (drawerList[index]['title'] == "Employee Company") {
                        debugPrint("Employee Company");
                      }
                      //Credit Ledger
                      if (drawerList[index]['title'] == "Credit Ledger") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreditLedger()));
                      }
                      //Business Store
                      if (drawerList[index]['title'] == "Business Store") {
                        debugPrint("Business Store");
                      }
                      //Leave Request
                      if (drawerList[index]['title'] == "Leave Request") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmployeeLeaveRequest()));
                      }
                      //Employee For Clients
                      if (drawerList[index]['title'] ==
                          "Employee For Clients") {
                        debugPrint("Employee For Clients");
                      }
                      //Employee Salary
                      if (drawerList[index]['title'] == "Employee Salary") {
                        debugPrint("Employee Salary");
                      }
                      //Project
                      if (drawerList[index]['title'] == "Project") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Projects()));
                      }
                      //Time Sheet Report
                      if (drawerList[index]['title'] == "Time Sheet Report") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimeSheetReport()));
                      }
                      //Salary History
                      if (drawerList[index]['title'] == "Salary History") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProjectTimeSheet()));
                      }
                    },
                    title: Text(
                      drawerList[index]['title'],
                      style: GoogleFonts.quicksand(
                          fontSize: 11.sp, fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(
                      getIconUsingPrefix(name: finalIcon),
                      size: 2.h,
                      color: AppColors.darkGrey,
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
