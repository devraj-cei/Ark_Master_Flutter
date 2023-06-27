import 'dart:convert';
import 'dart:io';

import 'package:ark_master/Screens/Dashboard/Offers.dart';
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

class OfferAdd extends StatefulWidget {
  OfferAdd({Key? key, required this.offerDetails}) : super(key: key);

  Map<String, dynamic> offerDetails = {};

  @override
  State<OfferAdd> createState() => _OfferAddState();
}

class _OfferAddState extends State<OfferAdd> {
  //String
  String title = "";
  String logo = "";
  String networkImage = "";
  String imageUrl = "http://arkledger.techregnum.com/assets/Offers/";
  String token = Global.services.getToken()!;

  //Integer
  int selectedDiscountTypeId = 0;
  int offerId = 0;
  int appClientId = Global.services.getAppClientId()!;

  //DatePicker
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  //Map
  Map<String, dynamic> offerDetails = {};

  //List
  List discountType = [
    {"id": 1, "discountType": "Percentage"},
    {"id": 2, "discountType": "Flat"}
  ];

  //File
  File? _image;

  //TEXT EDITING CONTROLLER
  TextEditingController titleController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController minOrderController = TextEditingController();
  TextEditingController maxDiscountController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController tncController = TextEditingController();

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() async {
    if (widget.offerDetails.isNotEmpty) {
      offerDetails = widget.offerDetails;
      offerId = offerDetails['id'];
      networkImage = offerDetails['imageFile'];
      selectedDiscountTypeId = offerDetails['discountType'];
      titleController.text = offerDetails['title'];
      discountController.text = offerDetails['discount'].toString();
      minOrderController.text = offerDetails['minOrderValue'].toString();
      maxDiscountController.text = offerDetails['maxDiscountValue'].toString();
      startDateController.text = offerDetails['startDate'];
      endDateController.text = offerDetails['endDate'];
      noteController.text = offerDetails['note'];
      tncController.text = offerDetails['tnc'];
      title = "Edit Offer";
    } else {
      title = "Add Offers";
    }
    setState(() {
      discountType.insertAll(0, [
        {"id": 0, "discountType": "Discount Type"}
      ]);
    });
  }

  //ImagePicker
  Future getImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      networkImage = "";
      _image = imageTemporary;
      logo = _image!.path.split('/').last.toString();
    });
  }

  //Upload Image
  void uploadImage() async {
    var imagePath = _image!.path;
    print(imagePath);
    final request = await http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.BASE_URL_UPLOAD_IMAGE +
            ApiEndPoint.UPLOAD_OFFER_IMAGE));
    request.headers.addAll({"token": token});
    request.files
        .add(await http.MultipartFile.fromPath("profilePic", imagePath));

    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        networkImage = _image!.path.split('/').last.toString();
      });
      saveOffer();
      print("Uploaded Successfully");
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      print("ERROR");
    }
  }

  void saveOffer() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    bodyParam.addAll({
      "appClientId": appClientId,
      "discountType": selectedDiscountTypeId,
      "discount": discountController.text.toString(),
      "minOrderValue": minOrderController.text.toString(),
      "maxDiscountValue": maxDiscountController.text.toString(),
      "startDate": startDateController.text.toString(),
      "endDate": endDateController.text.toString(),
      "note": noteController.text.toString(),
      "tnc": tncController.text.toString(),
      "title": titleController.text.toString(),
    });

    if (offerId > 0) {
      bodyParam.addAll({"id": offerId});
    }

    if (networkImage != "") {
      bodyParam.addAll({"imageFile": networkImage});
    }

    print(bodyParam);
    final response = await http.post(
        Uri.parse(ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.SAVE_OFFERS),
        headers: {"token": token, 'Content-Type': 'application/json'},
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
            context, MaterialPageRoute(builder: (context) => Offers()));
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

  //Date
  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        startDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
        endDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context, MaterialPageRoute(builder: (context) => Offers()));
    return false;
  }

  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        key: key,
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          height: 6.h,
          decoration: BoxDecoration(
              color: AppColors.yellowButton,
              border: Border.all(color: Colors.white, width: 0.15.h),
              borderRadius: BorderRadius.circular(1.h)),
          child: InkWell(
            onTap: () {
              if (networkImage == "") {
                uploadImage();
              } else {
                saveOffer();
              }
            },
            child: Padding(
              padding: EdgeInsets.all(1.5.h),
              child: Center(
                  child: Text(
                "Save Offer",
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: Colors.black),
              )),
            ),
          ),
        ),
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
                Navigator.pop(
                    context, MaterialPageRoute(builder: (context) => Offers()));
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 2.5.h,
              ),
            )
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
                      height: 24.h,
                      width: 100.w,
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
                            : Image.network(imageUrl + networkImage,
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
                          'Add Offer Image',
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
                    //Title TextField
                    TextFormField(
                      controller: titleController,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter title",
                          labelText: "Enter title",
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
                    Gap(2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 44.w,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "Discount Type",
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
                              'Discount Type',
                              style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500)),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedDiscountTypeId = value as int;
                                print(selectedDiscountTypeId);
                              });
                            },
                            value: selectedDiscountTypeId,
                            items: discountType.map((item) {
                              return DropdownMenuItem(
                                child: new Text(
                                  item['discountType'].toString(),
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500)),
                                ),
                                value: item['id'],
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          width: 44.w,
                          child: TextFormField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp),
                            decoration: InputDecoration(
                                hintText: "Enter discount",
                                labelText: "Enter discount",
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
                        ),
                      ],
                    ),
                    Gap(2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 44.w,
                          child: TextFormField(
                            controller: minOrderController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp),
                            decoration: InputDecoration(
                                hintText: "Min Order Value",
                                labelText: "Min Order Value",
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
                        ),
                        Container(
                          width: 44.w,
                          child: TextFormField(
                            controller: maxDiscountController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.quicksand(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp),
                            decoration: InputDecoration(
                                hintText: "Max Discount",
                                labelText: "Max Discount",
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
                        ),
                      ],
                    ),
                    Gap(2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 44.w,
                          child: //Date of Birth TextField
                              TextFormField(
                            controller: startDateController,
                            readOnly: true,
                            onTap: () {
                              if (Platform.isAndroid) {
                                selectStartDate(context);
                              }
                              if (Platform.isIOS) {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 30.h,
                                      child: CupertinoDatePicker(
                                        initialDateTime: startDate,
                                        backgroundColor: Colors.white,
                                        mode: CupertinoDatePickerMode.date,
                                        onDateTimeChanged: (DateTime newDate) {
                                          setState(
                                            () {
                                              startDateController.text = newDate
                                                  .toString()
                                                  .split(' ')[0];
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
                                hintText: "Start Date",
                                labelText: "Start Date",
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
                        ),
                        Container(
                          width: 44.w,
                          child: TextFormField(
                            controller: endDateController,
                            readOnly: true,
                            onTap: () {
                              if (Platform.isAndroid) {
                                selectEndDate(context);
                              }
                              if (Platform.isIOS) {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 30.h,
                                      child: CupertinoDatePicker(
                                        initialDateTime: endDate,
                                        backgroundColor: Colors.white,
                                        mode: CupertinoDatePickerMode.date,
                                        onDateTimeChanged: (DateTime newDate) {
                                          setState(
                                            () {
                                              endDateController.text = newDate
                                                  .toString()
                                                  .split(' ')[0];
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
                                hintText: "End Date",
                                labelText: "End Date",
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
                        ),
                      ],
                    ), //
                    Gap(2.h),
                    //Notes TextField
                    TextFormField(
                      controller: noteController,
                      maxLines: 2,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Enter note",
                          labelText: "Enter note",
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
                    Gap(2.h),
                    TextFormField(
                      controller: tncController,
                      maxLines: 2,
                      style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                          hintText: "Terms & Conditions",
                          labelText: "Terms & Conditions",
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
            ],
          ),
        ),
      ),
    );
  }
}
