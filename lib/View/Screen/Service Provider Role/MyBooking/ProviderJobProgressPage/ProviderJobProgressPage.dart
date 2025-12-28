import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppIcons/app_icons.dart';
import 'package:txme_app/core/App_Routes/app_routes.dart';
import '../../../../../../Utils/AppColors/app_colors.dart';
import '../../../../../../Utils/StaticString/static_string.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/Custom_Button/custom_button.dart';
import '../../../../Widgegt/JobProgressTime/CountdownTimerWidget.dart';


class Providerjobprogresspage extends StatelessWidget {
  Providerjobprogresspage({super.key});


 // 2 hours
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.FFFFFF,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(
              AppIcons.chevronleft,
              height: 18.h,
              width: 18.w,
            )),
        title: Padding(
          padding: EdgeInsets.only(left: 70.w),
          child: Text(
            "Job Started",
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff1F2937)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 45.h, left: 20.w, right: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              JobTimerCard(),
              SizedBox(height: 36.h),
              Container(
                width: 353.w,
                height: 175.h,
                decoration: BoxDecoration(
                    color: Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Color(0xff3A7DFF), width: 1.w)),
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 23.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Lawn Mowing & Edging",
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1F2937)),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.location,
                            height: 18.h,
                            width: 16.w,
                            color: Color(0xff4C545F),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            "123 Maple Street",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 18.sp,
                                color: Color(0xff1F2937)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.date,
                            height: 18.h,
                            width: 16.w,
                            color: Color(0xff4C545F),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            "Tuesday, 28th May",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 18.sp,
                                color: Color(0xff1F2937)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.prof,
                            height: 18.h,
                            width: 16.w,
                            color: Color(0xff4C545F),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            "Michelle R.",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 18.sp,
                                color: Color(0xff1F2937)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              Container(
                width: 351.w,
                height: 93.h,
                decoration: BoxDecoration(
                  color: Color(0xffF7F7F7),
                  border: Border.all(color: Color(0xff3A7DFF), width: 1.w),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, left: 8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Job Notes",
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1F2937)),
                      ),
                      Text(
                        AppString.onlyPlease.tr,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff1F2937)),
                      ),
                    ],
                  ),
                ),
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
                        "Start",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xffFFFFFF)),
                      )),
                  onTap: () {
                    Get.toNamed(AppRoute.providertotalduration);
                  }),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: CustomProvidernavbar(selectedIndex: 1),

      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 1),
    );
  }
}
