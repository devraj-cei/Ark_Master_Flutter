import 'package:ark_master/Screens/Dashboard/EmployeeAdd.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../Utils/App_Colors.dart';
import '../Drawer/NavigationDrawer.dart';
import 'Employee.dart';

class EmployeeProfile extends StatefulWidget {
  EmployeeProfile({Key? key, required this.employeeDetails}) : super(key: key);

  Map<String, dynamic> employeeDetails = {};

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  Map<String, dynamic> employeeDetails = {};

  String firstName = "";
  String middleName = "";
  String lastName = "";
  String email = "";
  String mobile = "";
  String dateOfBirth = "";
  String gender = "";
  String bloodGroup = "";
  String country = "";
  String address = "";
  String panCardNo = "";
  String aadharCardNo = "";
  String companyName = "hey";
  String imageUrl = "http://arkledger.techregnum.com/assets/Employees/";
  String profilePic = "";

  @override
  void initState() {
    employeeDetails = widget.employeeDetails;
    setData();
    super.initState();
  }

  void setData() async {
    setState(() {
      firstName = widget.employeeDetails['firstName'];
      middleName = widget.employeeDetails['middleName'];
      lastName = widget.employeeDetails['lastName'];
      email = widget.employeeDetails['personalEmail'];
      mobile = widget.employeeDetails['mobile'];
      dateOfBirth = widget.employeeDetails['dob'];
      gender = widget.employeeDetails['gender'];
      bloodGroup = widget.employeeDetails['bloodGroup'];
      country = widget.employeeDetails['country'];
      address = widget.employeeDetails['street'] +
          " " +
          widget.employeeDetails['city'] +
          ", " +
          widget.employeeDetails['state'] +
          ", " +
          widget.employeeDetails['pincode'];
      panCardNo = widget.employeeDetails['panNo'];
      aadharCardNo = widget.employeeDetails['aadharNo'];
      profilePic = widget.employeeDetails['profilePic'];
    });
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context, MaterialPageRoute(builder: (context) => Employee()));
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
                        builder: (context) => EmployeeAdd(
                            employeeDetails: widget.employeeDetails)));
              },
              child: Padding(
                padding: EdgeInsets.all(1.5.h),
                child: Center(
                    child: Text(
                  "Edit",
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
              "Employee Details",
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold, fontSize: 12.sp),
            ),
            backgroundColor: AppColors.darkGrey,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => Employee()));
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
                  Gap(2.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1.h),
                    child: Image(
                      height: 15.h,
                      width: 33.w,
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
                      },
                      image: NetworkImage(imageUrl +
                          profilePic),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.h),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black45),
                        ],
                        color: Colors.white),
                    child: Column(
                      children: [
                        ExpansionTile(
                          iconColor: AppColors.darkGrey,
                          title: Text("Personal Information",
                              style: GoogleFonts.quicksand(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGrey)),
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 2.h),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person),
                                        Gap(4.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "First Name"
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(firstName,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        )
                                      ],
                                    ),
                                    Gap(0.5.h),
                                    Divider(
                                      color: AppColors.darkGrey,
                                    ),
                                    Gap(0.5.h),
                                    Row(
                                      children: [
                                        Icon(Icons.person),
                                        Gap(4.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Middle Name"
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(middleName,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ],
                                        )
                                      ],
                                    ),
                                    Gap(0.5.h),
                                    Divider(
                                      color: AppColors.darkGrey,
                                    ),
                                    Gap(0.5.h),
                                    Row(
                                      children: [
                                        Icon(Icons.person),
                                        Gap(4.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Last Name"
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(lastName,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ],
                                        )
                                      ],
                                    ),
                                    Gap(0.5.h),
                                    Divider(
                                      color: AppColors.darkGrey,
                                    ),
                                    Gap(0.5.h),
                                    Row(
                                      children: [
                                        Icon(Icons.mail),
                                        Gap(4.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Email"
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(email,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ],
                                        )
                                      ],
                                    ),
                                    Gap(0.5.h),
                                    Divider(
                                      color: AppColors.darkGrey,
                                    ),
                                    Gap(0.5.h),
                                    Row(
                                      children: [
                                        Icon(Icons.call),
                                        Gap(4.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Mobile"
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(mobile,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ],
                                        )
                                      ],
                                    ),
                                    Gap(0.5.h),
                                    Divider(
                                      color: AppColors.darkGrey,
                                    ),
                                    Gap(0.5.h),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.edit_calendar),
                                            Gap(4.w),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Date Of Birth"
                                                      .toString()
                                                      .toUpperCase(),
                                                  style:
                                                      GoogleFonts.quicksand(
                                                          fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                ),
                                                Text(dateOfBirth,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))
                                              ],
                                            )
                                          ],
                                        ),
                                        VerticalDivider(
                                          color: AppColors.darkGrey,
                                        ),
                                        Gap(2.w),
                                        Row(
                                          children: [
                                            Icon(Icons.person_rounded),
                                            Gap(4.w),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Gender"
                                                      .toString()
                                                      .toUpperCase(),
                                                  style:
                                                      GoogleFonts.quicksand(
                                                          fontSize: 11.sp,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                ),
                                                Text(gender,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Gap(0.5.h),
                                    Divider(
                                      color: AppColors.darkGrey,
                                    ),
                                    Gap(0.5.h),
                                    Row(
                                      children: [
                                        Icon(Icons.bloodtype_rounded),
                                        Gap(4.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Blood Group"
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(bloodGroup,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ),
                        ExpansionTile(
                          iconColor: AppColors.darkGrey,
                          title: Text("Address Information",
                              style: GoogleFonts.quicksand(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGrey)),
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 2.h),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(FontAwesomeIcons.building),
                                        Gap(4.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Country"
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(country,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        )
                                      ],
                                    ),
                                    Gap(0.5.h),
                                    Divider(
                                      color: AppColors.darkGrey,
                                    ),
                                    Gap(0.5.h),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on),
                                        Gap(4.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Address"
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: 65.w,
                                              child: Text(
                                                address,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 11.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Gap(0.5.h),
                                  ],
                                ))
                          ],
                        ),
                        ExpansionTile(
                          iconColor: AppColors.darkGrey,
                          title: Text("Other Information",
                              style: GoogleFonts.quicksand(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGrey)),
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 2.h),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.numbers),
                                        Gap(4.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Pancard Number"
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(panCardNo,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        )
                                      ],
                                    ),
                                    Gap(0.5.h),
                                    Divider(
                                      color: AppColors.darkGrey,
                                    ),
                                    Gap(0.5.h),
                                    Row(
                                      children: [
                                        Icon(Icons.numbers),
                                        Gap(4.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "AADHAR Number"
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(
                                              aadharCardNo,
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Gap(0.5.h),
                                    Divider(
                                      color: AppColors.darkGrey,
                                    ),
                                    Gap(0.5.h),
                                    Row(
                                      children: [
                                        Icon(FontAwesomeIcons.building),
                                        Gap(4.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Company"
                                                  .toString()
                                                  .toUpperCase(),
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(
                                              companyName,
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
