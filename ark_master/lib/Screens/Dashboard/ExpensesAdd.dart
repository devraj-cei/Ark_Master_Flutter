import 'dart:convert';
import 'dart:io';

import 'package:ark_master/Screens/Dashboard/Expenses.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:flutter/cupertino.dart';
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

class ExpensesAdd extends StatefulWidget {
  ExpensesAdd({Key? key, required this.expenseDetails}) : super(key: key);

  Map<String, dynamic> expenseDetails = {};

  @override
  State<ExpensesAdd> createState() => _ExpensesAddState();
}

class _ExpensesAddState extends State<ExpensesAdd> {
  //String
  String title = "";
  String buttonText = "";
  String token = Global.services.getToken()!;

  //List
  List clientCompanyList = [];
  List expenseTypeList = [];

  //Integer
  int clientCompanyId = 0;
  int expenseTypeId = 0;
  int expenseId = 0;

  //DatePicker
  DateTime date = DateTime.now();

  //TextEditingController
  TextEditingController amountController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    setData();
    getClientCompanyList();
    super.initState();
  }

  void setData() {
    if (widget.expenseDetails.isNotEmpty) {
      title = "Edit Expense";
      expenseId = widget.expenseDetails['id'];
      clientCompanyId = widget.expenseDetails['clientCompanyId'];
      expenseTypeId = widget.expenseDetails['typeId'];
      amountController.text = widget.expenseDetails['amount'].toString();
      notesController.text = widget.expenseDetails['notes'];
      dateController.text = widget.expenseDetails['date'];
      buttonText = "Update Expense";
    } else {
      title = "Add Expense";
      buttonText = "Update Expense";
    }
  }

  void getClientCompanyList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

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
          clientCompanyList = obj;

          if (clientCompanyId == 0) {
            clientCompanyId = clientCompanyList[0]['id'];
          }
        });

        getExpenseTypeList();
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

  void getExpenseTypeList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_EXPENSES_TYPE_LIST),
        headers: {"token": token, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          expenseTypeList = obj;

          if (expenseTypeId == 0) {
            expenseTypeId = expenseTypeList[0]['id'];
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

  void saveExpense() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "clientCompanyId": clientCompanyId,
      "amount": amountController.text,
      "notes": notesController.text,
      "typeId": expenseTypeId,
      "date": dateController.text
    });

    if (widget.expenseDetails.isNotEmpty) {
      bodyParam.addAll({"id": expenseId});
    }

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.SAVE_EXPENSES),
        headers: {"token": token, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        print(obj.toString());
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Expenses()));
        EasyLoading.dismiss();
      } else {
        var obj = responseBody['obj'];
        print(obj.toString());
        Fluttertoast.showToast(
            msg: obj.toString(),
            fontSize: 11.sp,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            textColor: AppColors.yellowButton,
            backgroundColor: AppColors.darkGrey);
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
      throw Exception(response.reasonPhrase);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        dateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  //Back Function
  Future<bool> onBackPressed() async {
    Navigator.pop(context, MaterialPageRoute(builder: (context) => Expenses()));
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
          bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            height: 6.h,
            decoration: BoxDecoration(
                color: AppColors.yellowButton,
                border: Border.all(color: Colors.white, width: 0.15.h),
                borderRadius: BorderRadius.circular(1.h)),
            child: InkWell(
              onTap: () {
                saveExpense();
              },
              child: Padding(
                padding: EdgeInsets.all(1.5.h),
                child: Center(
                    child: Text(
                  buttonText,
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.black),
                )),
              ),
            ),
          ),
          drawer: NavigationDrawerLayout(),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              title.toUpperCase(),
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold, fontSize: 12.sp),
            ),
            backgroundColor: AppColors.darkGrey,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => Expenses()));
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
                  //Client company
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Client Company",
                      labelStyle: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500)),
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
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
                  Gap(1.5.h),
                  //Date of Expense TextField
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () {
                      if (Platform.isAndroid) {
                        _selectDate(context);
                      }
                      if (Platform.isIOS) {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 30.h,
                              child: CupertinoDatePicker(
                                initialDateTime: date,
                                backgroundColor: Colors.white,
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(
                                    () {
                                      dateController.text =
                                          newDate.toString().split(' ')[0];
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                    style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp),
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit_calendar),
                        suffixIconColor: AppColors.darkGrey,
                        hintText: "Select Date",
                        labelText: "Select Date",
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
                  //Client company
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Expense Type",
                      labelStyle: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500)),
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
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
                      'Select Expense Type',
                      style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.w500)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        expenseTypeId = value as int;
                      });
                    },
                    value: expenseTypeId,
                    items: expenseTypeList.map((item) {
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
                  Gap(1.5.h),
                  //Amount TextField
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.numberWithOptions(),
                    style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp),
                    decoration: InputDecoration(
                        hintText: "Enter Amount",
                        labelText: "Enter Amount",
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
                  //Amount TextField
                  TextFormField(
                    controller: notesController,
                    maxLines: 2,
                    keyboardType: TextInputType.numberWithOptions(),
                    style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp),
                    decoration: InputDecoration(
                        hintText: "Enter notes",
                        labelText: "Enter notes",
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
                ],
              ),
            ),
          ),
        ));
  }
}
