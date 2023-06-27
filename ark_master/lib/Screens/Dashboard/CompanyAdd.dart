import 'dart:convert';
import 'dart:io';

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
import '../../Utils/Global.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Company.dart';

class CompanyAdd extends StatefulWidget {
  CompanyAdd({Key? key, required this.companyDetails}) : super(key: key);

  Map<String, dynamic> companyDetails = {};

  @override
  State<CompanyAdd> createState() => _CompanyAddState();
}

class _CompanyAddState extends State<CompanyAdd> {
  String token = Global.services.getToken()!;
  String logo = "";
  String imageUrl = "http://arkledger.techregnum.com/assets/CompaniesLogo/";

  //Integer
  int companyId = 0;
  int selectedCountryId = 0;
  int selectedStateId = 0;
  int selectedCurrencyId = 0;
  int selectedBusinessCategoryId = 0;
  int selectedBusinessSubcategoryId = 0;
  int appClientId = Global.services.getAppClientId()!;

  //Bool
  bool gstApplicable = false;
  bool showQuantity = false;
  bool showRate = false;
  bool allowCustomerToAddCredit = false;
  bool allowSearch = false;

  //List
  List listOfCountry = [];
  List listOfState = [];
  List listOfCurrency = [];
  List listOfBusinessCategory = [];
  List listOfBusinessSubcategory = [];

  //Map
  Map<String, dynamic> companyDetails = {};

  //File
  File? _image;

  //TextEditingController
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController employeePrefixController = TextEditingController();

  @override
  void initState() {
    func();
    super.initState();
  }

  void func() {
    prefs();
    getCountryList();
    getBusinessCategoryList();
  }

  //Shared Preference
  void prefs() async {
    setState(() {
      companyDetails = widget.companyDetails;
    });
    if (widget.companyDetails.isNotEmpty) {
      setState(() {
        companyId = widget.companyDetails['id'];
        nameController.text = widget.companyDetails['name'];
        selectedCountryId = widget.companyDetails['countryId'];
        selectedStateId = widget.companyDetails['stateId'];
        selectedBusinessCategoryId =
            widget.companyDetails['businessCatgeoryId'];
        selectedBusinessSubcategoryId =
            widget.companyDetails['businessSubCatgeoryId'];
        descriptionController.text = widget.companyDetails['description'];
        employeePrefixController.text = widget.companyDetails['employeePrefix'];
        gstApplicable = widget.companyDetails['gstApplicable'];
        showQuantity = widget.companyDetails['showQty'];
        showRate = widget.companyDetails['showRate'];
        allowCustomerToAddCredit =
            widget.companyDetails['allowCustomerToAddCredit'];
        allowSearch = widget.companyDetails['allowSearch'];
        logo = widget.companyDetails['logo'];
      });
    }
  }

  //Get Country List
  void getCountryList() async {
    EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_COUNTRY_LIST),
        headers: {"token": token, 'Content-Type': 'application/json'},
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
          getCurrencyList();
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

  //Get Currency List
  void getCurrencyList() async {
    EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_COUNTRY_LIST),
        headers: {"token": token, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          listOfCurrency = obj;
          if (listOfCurrency.length > 0) {
            if (selectedCurrencyId == 0) {
              selectedCurrencyId = listOfCurrency[0]['id'];
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
    if (widget.companyDetails.isEmpty) {
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
        headers: {"token": token, 'Content-Type': 'application/json'},
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

  //Get BusinessCategory List
  void getBusinessCategoryList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_BUSINESS_CATEGORY_LIST),
        headers: {"token": token, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          listOfBusinessCategory = obj;

          if (listOfBusinessCategory.length > 0) {
            if (selectedBusinessCategoryId == 0) {
              selectedBusinessCategoryId = listOfBusinessCategory[0]['id'];
            }
          }
          getBusinessSubcategoryList_API();
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

  //Get BusinessSubCategory List
  void getBusinessSubcategoryList_API() async {
    if (selectedBusinessSubcategoryId > 0) {
      listOfBusinessSubcategory.clear();
      setState(() {
        selectedBusinessSubcategoryId = 0;
      });
    }
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};
    bodyParam.addAll({"businessCategoryId": selectedBusinessCategoryId});

    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS +
            ApiEndPoint.GET_BUSINESS_SUBCATEGORY_LIST),
        headers: {"token": token, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];
        print(obj.toString());
        setState(() {
          listOfBusinessSubcategory = obj;

          if (listOfBusinessSubcategory.length > 0) {
            if (selectedBusinessSubcategoryId == 0) {
              selectedBusinessSubcategoryId =
                  listOfBusinessSubcategory[0]['id'];
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

  void saveClientCompany() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "appClientId": 10,
      "name": nameController.text,
      "description": descriptionController.text,
      "employeePrefix": employeePrefixController.text,
      "stateId": selectedStateId,
      "countryId": selectedCountryId,
      "gstApplicable": gstApplicable,
      "showQty": showQuantity,
      "showRate": showRate,
      "allowCustomerToAddCredit": allowCustomerToAddCredit,
      "allowSearch": allowSearch,
      "currencyId": selectedCurrencyId,
      "businessCatgeoryId": selectedBusinessCategoryId,
      "businessSubCatgeoryId": selectedBusinessSubcategoryId,
      "logo": logo,
    });
    if (widget.companyDetails.isNotEmpty) {
      bodyParam.addAll({"id": widget.companyDetails['id']});
    }

    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.SAVECLIENTCOMPANIES),
        headers: {"token": token, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        print(obj.toString());
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Company()));
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

  //ImagePicker
  Future getImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
      logo = _image!.path.split('/').last.toString();
    });
  }

  void uploadImage() async {
    var imagePath = _image!.path;
    print(imagePath);
    final request = await http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.BASE_URL_UPLOAD_IMAGE +
            ApiEndPoint.UPLOAD_CLIENT_COMPANY_LOGO));
    request.headers.addAll({"token": token});
    request.files
        .add(await http.MultipartFile.fromPath("profilePic", imagePath));

    var response = await request.send();
    if (response.statusCode == 200) {
      saveClientCompany();
      print("Uploaded Successfully");
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      print("ERROR");
    }
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context, MaterialPageRoute(builder: (context) => Company()));
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
                saveClientCompany();
              },
              child: Padding(
                padding: EdgeInsets.all(1.5.h),
                child: Center(
                    child: Text(
                  "Save Company",
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
              "Add Companies Details".toString().toUpperCase(),
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold, fontSize: 12.sp),
            ),
            backgroundColor: AppColors.darkGrey,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => Company()));
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.h),
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
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
                              : Image.network(imageUrl + logo,
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
                            'Add Company Logo',
                            style: GoogleFonts.quicksand(
                                fontSize: 11.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: Column(
                    children: [
                      Gap(1.h),
                      //Middle Name TextField
                      TextFormField(
                        controller: nameController,
                        style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp),
                        decoration: InputDecoration(
                            hintText: "Enter company name",
                            labelText: "Enter company name",
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
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black45),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black54),
                              borderRadius: BorderRadius.circular(10)),
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
                            selectedCountryId = value as int;
                            getCurrencyList();
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
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Select Currency",
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
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black45),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black54),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select Currency',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedCurrencyId = value as int;
                          });
                        },
                        value: selectedCurrencyId,
                        items: listOfCurrency.map((item) {
                          var currencyName = item['currencyName'] +
                              " " +
                              item['currencySymbol'].toString();
                          return DropdownMenuItem(
                            child: new Text(
                              currencyName.toString(),
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
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black45),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black54),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select state',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedStateId = value as int;
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
                      //Select Business Category
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Select Business Category",
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
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black45),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black54),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select Business Category',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedBusinessCategoryId = value as int;
                            getBusinessSubcategoryList_API();
                          });
                        },
                        value: selectedBusinessCategoryId,
                        items: listOfBusinessCategory.map((item) {
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
                      Gap(1.h),
                      //Select Business Subcategory
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Select Business Subcategory",
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
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black45),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.5.w, color: Colors.black54),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select Business Subcategory',
                          style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedBusinessSubcategoryId = value as int;
                          });
                        },
                        value: selectedBusinessSubcategoryId,
                        items: listOfBusinessSubcategory.map((item) {
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
                      Gap(1.h),
                      //Address TextField
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 3,
                        style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp),
                        decoration: InputDecoration(
                            hintText: "Enter description",
                            labelText: "Enter description",
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
                      TextFormField(
                        controller: descriptionController,
                        style: GoogleFonts.quicksand(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp),
                        decoration: InputDecoration(
                            hintText: "Enter employee prefix",
                            labelText: "Enter employee prefix",
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
                      //GST Applicable
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: gstApplicable,
                        onChanged: (value) {
                          setState(() {
                            gstApplicable = value as bool;
                          });
                        },
                        activeColor: AppColors.yellowButton,
                        title: Text(
                          "GST Applicable",
                          style: GoogleFonts.quicksand(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkGrey),
                        ),
                      ),
                      //Show Quantity
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: showQuantity,
                        onChanged: (value) {
                          setState(() {
                            showQuantity = value as bool;
                          });
                        },
                        activeColor: AppColors.yellowButton,
                        title: Text("Show Quantity",
                            style: GoogleFonts.quicksand(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkGrey)),
                      ),
                      //Show Rate
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: showRate,
                        onChanged: (value) {
                          setState(() {
                            showRate = value as bool;
                          });
                        },
                        activeColor: AppColors.yellowButton,
                        title: Text("Show Rate",
                            style: GoogleFonts.quicksand(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkGrey)),
                      ),
                      //Allow customer to add credit
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: allowCustomerToAddCredit,
                        onChanged: (value) {
                          setState(() {
                            allowCustomerToAddCredit = value as bool;
                          });
                        },
                        activeColor: AppColors.yellowButton,
                        title: Text("Allows customer to add Credit",
                            style: GoogleFonts.quicksand(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkGrey)),
                      ),
                      //Allow search
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: allowSearch,
                        onChanged: (value) {
                          setState(() {
                            allowSearch = value as bool;
                          });
                        },
                        activeColor: AppColors.yellowButton,
                        title: Text("Allows search",
                            style: GoogleFonts.quicksand(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkGrey)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
