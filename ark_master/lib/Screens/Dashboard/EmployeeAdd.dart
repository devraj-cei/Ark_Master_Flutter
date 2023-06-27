import 'dart:convert';
import 'dart:io';

import 'package:ark_master/Screens/Dashboard/Employee.dart';
import 'package:ark_master/Screens/Dashboard/EmployeeProfile.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';

class EmployeeAdd extends StatefulWidget {
  EmployeeAdd({Key? key, required this.employeeDetails}) : super(key: key);

  Map<String, dynamic> employeeDetails = {};

  @override
  State<EmployeeAdd> createState() => _EmployeeAddState();
}

class _EmployeeAddState extends State<EmployeeAdd> {
  //String
  String profilePicUrl = "http://arkledger.techregnum.com/assets/Employees/";
  String profilePic = "";
  String gender = "";
  String imagePath = "";
  String image = "";
  String? token = Global.services.getToken()!;

  //DatePicker
  DateTime date = DateTime.now();

  //Integer
  int selectedCountryId = 0;
  int selectedStateId = 0;
  int selectedCityId = 0;
  int clientCompanyId = 0;
  int employeeId = 0;

  //List
  List listOfCountry = [];
  List listOfState = [];
  List listOfCity = [];
  List clientCompany = [];

  Map<String, dynamic> employeeDetails = {};

  //File
  File? _image;

  bool showSpinner = false;

  //TextEditingController
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();

  @override
  void initState() {
    setData();
    getCountryList();
    getClientCompanyList();
    super.initState();
  }

  void setData() async {
    if (widget.employeeDetails.isNotEmpty) {
      setState(() {
        employeeId = widget.employeeDetails['id'];
        firstNameController.text = widget.employeeDetails['firstName'];
        middleNameController.text = widget.employeeDetails['middleName'];
        lastNameController.text = widget.employeeDetails['lastName'];
        mobileController.text = widget.employeeDetails['mobile'];
        emailController.text = widget.employeeDetails['personalEmail'];
        dateController.text = widget.employeeDetails['dob'];
        gender = widget.employeeDetails['gender'];
        addressController.text = widget.employeeDetails['street'];
        pinCodeController.text = widget.employeeDetails['pincode'];
        aadharController.text = widget.employeeDetails['aadharNo'];
        panController.text = widget.employeeDetails['panNo'];
        bloodGroupController.text = widget.employeeDetails['bloodGroup'];
        selectedCountryId = widget.employeeDetails['countryId'];
        selectedStateId = widget.employeeDetails['stateId'];
        selectedCityId = widget.employeeDetails['cityId'];
        profilePic = widget.employeeDetails['profilePic'];
      });
    }
  }

  //App Admin

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
          listOfCountry = obj;
          if (listOfCountry.length > 0) {
            if (selectedCountryId == 0) {
              selectedCountryId = listOfCountry[0]['id'];
            }
          }
          getStateList();
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

  //Get State List
  void getStateList() async {
    if (widget.employeeDetails.isEmpty) {
      if (listOfState.isNotEmpty) {
        setState(() {
          listOfState.clear();
          selectedStateId = 0;
        });
      }
    }
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({"countryId": selectedCountryId});

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_STATE_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          listOfState = obj;

          if (listOfState.length > 0) {
            if (selectedStateId == 0) {
              selectedStateId = listOfState[0]['id'];
              getCityList();
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

  //Get City List
  void getCityList() async {
    if (widget.employeeDetails.isEmpty) {
      if (listOfCity.isNotEmpty) {
        setState(() {
          listOfCity.clear();
          selectedCityId = 0;
        });
      }
    }
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({"stateId": selectedStateId});

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_CITY_LIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          listOfCity = obj;
          if (listOfCity.length > 0) {
            if (selectedCityId == 0) {
              selectedCityId = listOfCity[0]['id'];
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
        print(obj.toString());
        setState(() {
          clientCompany = obj;

          if (clientCompanyId == 0) {
            clientCompanyId = clientCompany[0]['id'];
          }
        });
        print("Country" + listOfCountry.toString());
        print(listOfState);
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

  void uploadImage() async {
    EasyLoading.show(
        status: "Please Wait !!", maskType: EasyLoadingMaskType.black);
    final request = await http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.BASE_URL_UPLOAD_IMAGE +
            ApiEndPoint.UPLOAD_EMPLOYEE_PROFILE_PIC_IMAGE));
    request.headers.addAll({"token": token!});
    request.files
        .add(await http.MultipartFile.fromPath("profilePic", _image!.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Uploaded Successfully");
      setState(() {
        image = _image!.path.split('/').last.toString();
      });
      saveEmployee();
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      print("ERROR");
    }
  }

  void saveEmployee() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "firstName": firstNameController.text,
      "middleName": middleNameController.text,
      "lastName": lastNameController.text,
      "personalEmail": emailController.text,
      "mobile": mobileController.text,
      "dob": dateController.text.toString(),
      "gender": gender,
      "street": addressController.text,
      "pincode": pinCodeController.text,
      "countryId": selectedCountryId,
      "stateId": selectedStateId,
      "cityId": selectedCityId,
      "panNo": panController.text,
      "aadharNo": aadharController.text,
      "clientCompanyId": clientCompanyId,
      "bloodGroup": bloodGroupController.text,
    });

    if (employeeId > 0) {
      bodyParam.addAll({"id": employeeId});
    }

    if (image != "") {
      bodyParam.addAll({"profilePic": image});
    }

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.SAVE_EMPLOYEE),
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
            context, MaterialPageRoute(builder: (context) => Employee()));
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

  //ImagePicker
  Future getImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EmployeeProfile(employeeDetails: widget.employeeDetails)));
    return false;
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
          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          height: 6.h,
          decoration: BoxDecoration(
              color: AppColors.yellowButton,
              border: Border.all(color: Colors.white, width: 0.15.h),
              borderRadius: BorderRadius.circular(1.h)),
          child: InkWell(
            onTap: () {
              uploadImage();
            },
            child: Padding(
              padding: EdgeInsets.all(1.5.h),
              child: Center(
                  child: Text(
                "Save Employee",
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: Colors.black),
              )),
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Add Employee",
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmployeeProfile(
                              employeeDetails: widget.employeeDetails)));
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                      height: 15.h,
                      width: 33.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black45)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.h),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1.h),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              )
                            : Image.network(profilePicUrl + profilePic,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                return Container(
                                    height: 8.h,
                                    width: 16.w,
                                    child: Icon(
                                      FontAwesomeIcons.image,
                                      color: AppColors.darkGrey,
                                      size: 4.h,
                                    ));
                              }),
                      )),
                  InkWell(
                    onTap: () {
                      getImage();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle),
                        Gap(1.w),
                        Text(
                          'Add Photos',
                          style: GoogleFonts.quicksand(
                              fontSize: 11.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  children: [
                    //First Name TextField
                    TextFormField(
                      controller: firstNameController,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter first name",
                          labelText: "Enter first name",
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
                    Gap(1.h),
                    //Middle Name TextField
                    TextFormField(
                      controller: middleNameController,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter middle name",
                          labelText: "Enter middle name",
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
                    Gap(1.h),
                    //Last Name TextField
                    TextFormField(
                      controller: lastNameController,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter last name",
                          labelText: "Enter last name",
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
                    Gap(1.h),
                    //Email TextField
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
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
                    Gap(1.h),
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
                    Gap(1.h),
                    //Date of Birth TextField
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
                    //Radio Button for Gender
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                              title: Text(
                                "Male",
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp),
                              ),
                              value: "Male",
                              activeColor: AppColors.yellowButton,
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = "Male";
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text("Female",
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp)),
                            value: "Female",
                            activeColor: AppColors.yellowButton,
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = "Female";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    //Address TextField
                    TextFormField(
                      controller: addressController,
                      maxLines: 3,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter address",
                          labelText: "Enter address",
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
                    Gap(1.h),
                    //PinCode TextField
                    TextFormField(
                      controller: pinCodeController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter pincode",
                          labelText: "Enter pincode",
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
                    Gap(1.h),
                    //Select Country
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "Select Country",
                        labelStyle: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500)),
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 5.w),
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
                        'Select Country',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontSize: 11.sp, fontWeight: FontWeight.w500)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedCountryId = value as int;
                          getStateList();
                        });
                      },
                      value: selectedCountryId,
                      items: listOfCountry.map((item) {
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
                    Gap(1.h),
                    //Select State
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "Select State",
                        labelStyle: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500)),
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 5.w),
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
                        'Select state',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontSize: 11.sp, fontWeight: FontWeight.w500)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedStateId = value as int;
                          getCityList();
                        });
                      },
                      value: selectedStateId,
                      items: listOfState.map((item) {
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
                    Gap(1.h),
                    //Select City
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "Select City",
                        labelStyle: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500)),
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 5.w),
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
                        'Select City',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontSize: 11.sp, fontWeight: FontWeight.w500)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedCityId = value as int;
                        });
                      },
                      value: selectedCityId,
                      items: listOfCity.map((item) {
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
                    Gap(1.h),
                    //PanCard TextField
                    TextFormField(
                      controller: panController,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter pan no.",
                          labelText: "Enter pan no.",
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
                    Gap(1.h),
                    //Aadhar No. TextField
                    TextFormField(
                      controller: aadharController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter Aadhar no.",
                          labelText: "Enter Aadhar no.",
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
                    Gap(1.h),
                    //Blood Group TextField
                    TextFormField(
                      controller: bloodGroupController,
                      maxLength: 3,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter Blood Group",
                          labelText: "Enter Blood Group",
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
                    Gap(1.h),
                    //Select Company
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "Select Company",
                        labelStyle: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500)),
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 5.w),
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
                        'Select Company',
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
