import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../../Utils/AppColors/app_colors.dart' show AppColors;
import '../../../../../Utils/AppIcons/app_icons.dart' show AppIcons;
import '../../../../../core/App_Routes/app_routes.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/CustomBottomNavBar/ProviderNavBar.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart' show CustomButton;



class Newbookingrequest extends StatefulWidget {
  const Newbookingrequest({super.key});

  @override
  State<Newbookingrequest> createState() => _NewbookingrequestState();
}

class _NewbookingrequestState extends State<Newbookingrequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: SvgPicture.asset(AppIcons.chevronleft, height: 80.h, width: 80.w,)),
        title: GestureDetector(
          onTap: () {},
          child: Text("New Booking Request",
              style: TextStyle(color: Colors.black, fontSize: 18.sp)),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            Center(child: SvgPicture.asset(AppIcons.group)),
            SizedBox(
              height: 40.h,
            ),
            Text(
              "Booking Request",
              style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1F2937)),
            ),
            Text(
              "from Michelle Handyman Services",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xff4C545F),
              ),
            ),
            Container(
              width: 353.w,
              height: 107.h,
              decoration: BoxDecoration(
                  color: Color(0xffF7F7F7),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Color(0xff3A7DFF), width: 1.w)),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, top: 29.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.date,
                          height: 24.h,
                          width: 24.w,
                        ),
                        SizedBox(
                          width: 13.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date & Time",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff333333)),
                            ),
                            Text(
                              "Tuesday, 23 July at 10:00 AM",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.sp,
                                  color: Color(0xff4C545F)),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Text("Is this time available?",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                    color: Color(0xff4C545F)
                )
            ),
            SizedBox(height: 20.h,),

            CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Color(0xffFF5A36),
                ),
                child: Center(
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xffFFFFFF)),
                    )),
                onTap: () {
                  Get.toNamed(AppRoute.providerjobprogresspage);
                }),
            SizedBox(height: 20,),
            CustomButton(
                height: 56.h,
                width: 353.w,
                BoxDecoration: BoxDecoration(
                  border: Border.all(color: Color(0xffDA0808), width: 1.w),
                  borderRadius: BorderRadius.circular(12.r),
                  color: Color(0xffFFFFFF),
                ),
                child: Center(
                    child: Text(
                      "Decline Request",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xffDA0808)),
                    )),
                onTap: () {
                  Get.toNamed(AppRoute.cancelbooking);
                }),
          ],
        ),
      ),
     // bottomNavigationBar: CustomProvidernavbar(selectedIndex: 1),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
