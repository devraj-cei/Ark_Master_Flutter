import 'dart:convert';
import 'dart:io';

import 'package:ark_master/Screens/Dashboard/InvoiceFormat.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';

class InvoiceFormatAdd extends StatefulWidget {
  InvoiceFormatAdd({Key? key, required this.invoiceFormatDetails})
      : super(key: key);

  Map<String, dynamic> invoiceFormatDetails = {};

  @override
  State<InvoiceFormatAdd> createState() => _InvoiceFormatAddState();
}

class _InvoiceFormatAddState extends State<InvoiceFormatAdd> {
  //String
  String title = "Add Invoice Format";
  String imagePath = "";
  String image = "";
  String webUrl =
      "https://docs.google.com/gview?embedded=true&url=http://arkledger.techregnum.com/assets/InvoiceFormats/";
  String pdfFile = "";
  String companyLogo = "";
  String companyLogoUrl =
      "http://arkledger.techregnum.com/assets/CompaniesLogo/";
  String? token = Global.services.getToken();

  //Integer
  int appClientId = Global.services.getAppClientId()!;
  int invoiceId = 0;
  int invoiceFormatId = 0;
  int companyId = 0;

  //Double
  double _progress = 0;

  //Map
  Map<String, dynamic> invoiceFormatDetails = {};

  //List
  List invoiceFormatList = [];
  List companyList = [];
  List invoiceFormatView = [];

  //File
  File? _image;

  //InAppWebViewController
  InAppWebViewController? _webViewController;

  //TextEditingController
  TextEditingController nameController = TextEditingController();
  TextEditingController companyTitleController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactDetailsController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController bankAccountNo1Controller = TextEditingController();
  TextEditingController bankName1Controller = TextEditingController();
  TextEditingController ifscCode1Controller = TextEditingController();
  TextEditingController branchName1Controller = TextEditingController();
  TextEditingController bankAccountNo2Controller = TextEditingController();
  TextEditingController bankName2Controller = TextEditingController();
  TextEditingController ifscCode2Controller = TextEditingController();
  TextEditingController branchName2Controller = TextEditingController();
  TextEditingController tnc1Controller = TextEditingController();
  TextEditingController tnc2Controller = TextEditingController();

  @override
  void initState() {
    setData();
    getInvoiceFormatList();
    getCompanyList();
    super.initState();
  }

  void setData() async {
    if (widget.invoiceFormatDetails.isNotEmpty) {
      setState(() {
        invoiceFormatDetails = widget.invoiceFormatDetails;
        title = "Update Invoice Format";
        companyLogo = invoiceFormatDetails['logo'];
        invoiceId = invoiceFormatDetails['id'];
        companyId = invoiceFormatDetails['clientCompanyId'];
        invoiceFormatId = invoiceFormatDetails['formatId'];
        nameController.text = invoiceFormatDetails['name'];
        companyTitleController.text = invoiceFormatDetails['companyTitle'];
        addressController.text = invoiceFormatDetails['address'];
        contactDetailsController.text = invoiceFormatDetails['mobile'];
        gstNoController.text = invoiceFormatDetails['gstin'];
        panNoController.text = invoiceFormatDetails['pan'];
        noteController.text = invoiceFormatDetails['note'];
        bankAccountNo1Controller.text = invoiceFormatDetails['bank1Acc'];
        bankName1Controller.text = invoiceFormatDetails['bank1Name'];
        ifscCode1Controller.text = invoiceFormatDetails['bank1Ifsc'];
        branchName1Controller.text = invoiceFormatDetails['bank1Branch'];
        bankAccountNo2Controller.text = invoiceFormatDetails['bank2Acc'];
        bankName2Controller.text = invoiceFormatDetails['bank2Name'];
        ifscCode2Controller.text = invoiceFormatDetails['bank2Ifsc'];
        branchName2Controller.text = invoiceFormatDetails['bank2Branch'];
        tnc1Controller.text = invoiceFormatDetails['tnc1'];
        tnc2Controller.text = invoiceFormatDetails['tnc2'];
      });
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var profile = jsonDecode(prefs.getString("getProfile")!);
    setState(() {
      appClientId = profile['appClientId'] as int;
    });
    print(appClientId);
  }

  //GET INVOICE FORMAT LIST
  void getInvoiceFormatList() async {
    Map<String, dynamic> bodyParam = {"status": true};
    print(bodyParam);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");

    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GETINVOICEFORMATLIST),
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
        if (invoiceFormatList.length > 0) {
          if (invoiceFormatId == 0) {
            invoiceFormatId = invoiceFormatList[0]['id'];
          }
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

  void getFormatView() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    print(bodyParam);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");

    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GETINVOICEFORMATLIST),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        List obj = responseBody['obj'];

        setState(() {
          invoiceFormatView = obj;
        });

        print(invoiceFormatView);
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

  //GET COMPANY LIST
  void getCompanyList() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> bodyParam = {};
    print(bodyParam);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");

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
          companyList = obj;
        });
        if (companyList.length > 0) {
          if (companyId == 0) {
            companyId = companyList[0]['id'];
          }
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

  void saveInvoiceFormat() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");
    bodyParam.addAll({
      "status": true,
      "appClientId": appClientId,
      "name": nameController.text.toString(),
      "clientCompanyId": companyId,
      "companyTitle": companyTitleController.text.toString(),
      "address": addressController.text.toString(),
      "contactDetails": contactDetailsController.text.toString(),
      "formatId": invoiceFormatId,
      "logo": companyLogo,
      "gstin": gstNoController.text.toString(),
      "pan": panNoController.text.toString(),
      "note": noteController.text.toString(),
      "bank1Acc": bankAccountNo1Controller.text.toString(),
      "bank1Name": bankName1Controller.text.toString(),
      "bank1Ifsc": ifscCode1Controller.text.toString(),
      "bank1Branch": branchName1Controller.text.toString(),
      "bank2Acc": bankAccountNo2Controller.text.toString(),
      "bank2Name": bankName2Controller.text.toString(),
      "bank2Ifsc": ifscCode2Controller.text.toString(),
      "bank2Branch": branchName2Controller.text.toString(),
      "tnc1": tnc1Controller.text.toString(),
      "tnc2": tnc2Controller.text.toString(),
    });
    if (invoiceId != 0) {
      bodyParam.addAll({"id": invoiceId});
    }
    print(bodyParam);
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.SAVEINVOICEFORMAT),
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
            context, MaterialPageRoute(builder: (context) => InvoiceFormat()));
      } else {
        var obj = responseBody['obj'];
        Fluttertoast.showToast(
            msg: obj.toString(),
            fontSize: 11.sp,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT,
            textColor: AppColors.yellowButton,
            backgroundColor: AppColors.darkGrey);
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
      companyLogo = "";
    });
  }

  //Upload Image
  void uploadImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    var imagePath = _image!.path;
    print(imagePath);
    final request = await http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.BASE_URL_UPLOAD_IMAGE +
            ApiEndPoint.UPLOAD_IMAGE_FOR_INVOICE_FORMAT));
    request.headers.addAll({"token": token!});
    request.files.add(await http.MultipartFile.fromPath("logo", imagePath));

    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        companyLogo = _image!.path.split('/').last.toString();
      });

      print("Uploaded Successfully");
      saveInvoiceFormat();
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      print("ERROR");
    }
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => InvoiceFormat()));
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
            title.toUpperCase(),
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => InvoiceFormat()));
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
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          height: 6.h,
          decoration: BoxDecoration(
              color: AppColors.yellowButton,
              border: Border.all(color: Colors.white, width: 0.15.h),
              borderRadius: BorderRadius.circular(1.h)),
          child: InkWell(
            onTap: () {
              if (companyLogo == "") {
                uploadImage();
              } else {
                saveInvoiceFormat();
              }
            },
            child: Center(
                child: Text(
              "SAVE INVOICE FORMAT",
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Colors.black),
            )),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                        height: 25.h,
                        width: 100.w,
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
                              : Image.network(companyLogoUrl + companyLogo,
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
                    Gap(2.h),
                  ],
                ),
                Column(
                  children: [
                    //Name TextField
                    TextFormField(
                      controller: nameController,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter name",
                          labelText: "Name",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Company Title TextField
                    TextFormField(
                      controller: companyTitleController,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter company title",
                          labelText: "Company Title",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    InkWell(
                      onTap: () {
                        getFormatView();
                        showMyDialog(context);
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "View Format",
                          style: GoogleFonts.quicksand(
                              fontSize: 11.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Gap(1.h),
                    //Select Invoice Format
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "Select Invoice Format",
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
                        'Select Invoice Format',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontSize: 11.sp, fontWeight: FontWeight.w500)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          invoiceFormatId = value as int;
                        });
                      },
                      value: invoiceFormatId,
                      items: invoiceFormatList.map((item) {
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
                    //Select company
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
                        'Select company',
                        style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                                fontSize: 11.sp, fontWeight: FontWeight.w500)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          companyId = value as int;
                        });
                      },
                      value: companyId,
                      items: companyList.map((item) {
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
                    //Address TextField
                    TextFormField(
                      controller: addressController,
                      maxLines: 2,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter address",
                          labelText: "Address",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Contact Details TextField
                    TextFormField(
                      controller: contactDetailsController,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter contact details",
                          labelText: "Contact Details",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //GST No TextField
                    TextFormField(
                      controller: gstNoController,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter GST no",
                          labelText: "GST No",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //PAN No TextField
                    TextFormField(
                      controller: panNoController,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter PAN no",
                          labelText: "PAN No",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Bank Account No 1 TextField
                    TextFormField(
                      controller: bankAccountNo1Controller,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter bank account no.",
                          labelText: "Bank(1) Account No",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Bank Name 1 TextField
                    TextFormField(
                      controller: bankName1Controller,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter bank name",
                          labelText: "Bank(1) Name",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Bank IFSC Code 1 TextField
                    TextFormField(
                      controller: ifscCode1Controller,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter bank IFSC Code",
                          labelText: "Bank(1) IFSC Code",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Bank Branch Name 1 TextField
                    TextFormField(
                      controller: branchName1Controller,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter bank Branch Name.",
                          labelText: "Bank(1) Branch Name",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Bank Account No 2 TextField
                    TextFormField(
                      controller: bankAccountNo2Controller,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter bank account no.",
                          labelText: "Bank(2) Account No",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Bank Name 2 TextField
                    TextFormField(
                      controller: bankName2Controller,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter bank name",
                          labelText: "Bank(2) Name",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Bank IFSC Code 2 TextField
                    TextFormField(
                      controller: ifscCode2Controller,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter bank IFSC Code",
                          labelText: "Bank(2) IFSC Code",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Bank Branch Name 2 TextField
                    TextFormField(
                      controller: branchName2Controller,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter bank Branch Name.",
                          labelText: "Bank(2) Branch Name",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Terms & Conditions 1 TextField
                    TextFormField(
                      controller: tnc1Controller,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter T&C 1",
                          labelText: "T&C(1)",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                    //Terms & Conditions 2 TextField
                    TextFormField(
                      controller: tnc2Controller,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter T&C 2",
                          labelText: "T&C(2)",
                          labelStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.h))),
                    ),
                    Gap(1.5.h),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 55.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: invoiceFormatView.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Center(
                    child: Wrap(
                      children: [
                        Column(
                          children: [
                            Text(
                              invoiceFormatView[index]['title'],
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold, fontSize: 11.sp),
                            ),
                            Gap(2.h),
                            Container(
                              height: 40.h,
                              width: 65.w,
                              child: InAppWebView(
                                initialUrlRequest: URLRequest(
                                    url: Uri.parse(webUrl +
                                        invoiceFormatView[index]['pdfFile'])),
                                onWebViewCreated:
                                    (InAppWebViewController controller) {
                                  _webViewController = controller;
                                },
                                onProgressChanged:
                                    (InAppWebViewController controller,
                                        int progress) {
                                  setState(() {
                                    _progress = progress / 100;
                                    print(_progress);
                                  });
                                },
                              ),
                            ),
                            Gap(1.h),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 1.h),
                              height: 6.h,
                              width: 50.w,
                              decoration: BoxDecoration(
                                  color: AppColors.yellowButton,
                                  border: Border.all(
                                      color: Colors.white, width: 0.15.h),
                                  borderRadius: BorderRadius.circular(1.h)),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    invoiceFormatId =
                                        invoiceFormatView[index]['id'];
                                  });
                                  print(invoiceFormatId);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(1.5.h),
                                  child: Center(
                                      child: Text(
                                    "Select",
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
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
