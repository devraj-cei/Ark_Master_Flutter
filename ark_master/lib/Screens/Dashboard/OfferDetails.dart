import 'dart:convert';

import 'package:ark_master/Screens/Dashboard/OfferAdd.dart';
import 'package:ark_master/Utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../API/ApiEndPoint.dart';
import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Offers.dart';

class OfferDetails extends StatefulWidget {
  OfferDetails({Key? key, required this.offerDetails}) : super(key: key);

  Map<String, dynamic> offerDetails = {};

  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {
  //String
  String imageUrl = "http://arkledger.techregnum.com/assets/Offers/";
  String discount = "";
  String? token = Global.services.getToken();

  //Integer
  int offerId = 0;

  //Map
  Map<String, dynamic> offerDetails = {};

  @override
  void initState() {
    setData();
    getOfferDetails();
    super.initState();
  }

  void setData() {
    if (widget.offerDetails.isNotEmpty) {
      setState(() {
        offerDetails = widget.offerDetails;
        offerId = offerDetails['id'];
      });
    }
    if (offerDetails['discountType'] == 1) {
      setState(() {
        discount = offerDetails['discount'].toString() + "% off";
      });
    } else {
      setState(() {
        discount = "Flat " + "₹" + offerDetails['discount'].toString() + " off";
      });
    }
  }

  //GET APP CLIENT HSN SAC LIST
  void getOfferDetails() async {
    await EasyLoading.show(
        status: "Please Wait!!", maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> bodyParam = {};

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");
    bodyParam.addAll({"id": offerId});
    final response = await http.post(
        Uri.parse(
            ApiEndPoint.BASE_URL_CLIENTS + ApiEndPoint.GET_OFFERS_DETAILS),
        headers: {"token": token!, 'Content-Type': 'application/json'},
        body: jsonEncode(bodyParam));

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var response_code = responseBody['response_code'];

      if (response_code == "200") {
        var obj = responseBody['obj'];
        print(obj.toString());
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OfferAdd(offerDetails: widget.offerDetails)));
            },
            child: Padding(
              padding: EdgeInsets.all(1.5.h),
              child: Center(
                  child: Text(
                "EDIT",
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
            "Offer Details",
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, fontSize: 12.sp),
          ),
          backgroundColor: AppColors.darkGrey,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => Offers()));
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 2.5.h,
                ))
          ],
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                height: 30.h,
                width: 100.w,
                decoration: BoxDecoration(
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
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            imageUrl + offerDetails['imageFile']))),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offerDetails['title'],
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                    Gap(1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          discount,
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                        ),
                        Text(
                          "Valid Till: ${offerDetails['endDate']}",
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                        ),
                      ],
                    ),
                    Divider(
                      color: AppColors.darkGrey,
                      thickness: 0.1.h,
                    ),
                    Text(
                      "Notes: ${offerDetails['note']}",
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500, fontSize: 11.sp),
                    ),
                    Divider(
                      color: AppColors.darkGrey,
                      thickness: 0.1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Min Order: ${offerDetails['minOrderValue']}",
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                        ),
                        SizedBox(
                            height: 2.h,
                            child: VerticalDivider(
                              thickness: 0.1.h,
                              color: AppColors.darkGrey,
                            )),
                        Text(
                          "Max Discount: ${offerDetails['maxDiscountValue']}",
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500, fontSize: 11.sp),
                        ),
                      ],
                    ),
                    Gap(2.h),
                    Text(
                      "Terms & Conditions",
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold, fontSize: 11.sp),
                    ),
                    Text(
                      offerDetails['tnc'],
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500, fontSize: 11.sp),
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
